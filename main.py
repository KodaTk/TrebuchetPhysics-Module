from time import sleep
from math import cos, sin, radians, degrees
import matplotlib.pyplot as plt
plt.style.use('dark_background')

############################################
# STARTER CONSTANTS
############################################

g = 9.81
dt = 0.01

# Meters
Len_BarCW = 4
Len_BarPW = 6
Len_PenCW = 1.5

# Kilogram
Mass_Bar_PerMeter = 0.2
Mass_Bar =  Mass_Bar_PerMeter * (Len_BarCW + Len_BarPW)
Mass_CW = 150
Mass_PW = 1

# Radians
Th = radians(-60) # 360 - 55
Ph = radians(0) # To left
Pause_Level = radians(100) # 360 + 60


############################################
# VARIABLES
############################################

t=0

Th_d = 0
Th_dd = 0
Ph_d = 0
Ph_dd = 0

############################################
# FORMULAS
############################################

def CONST_V():
    V = Mass_CW * g * Len_BarCW - Mass_PW * g * Len_BarPW - 0.5 * Mass_Bar * g * (Len_BarPW - Len_BarCW)
    return V

def EOM_I(Ph_dd, Ph_d, Th, Ph):
    ITh_dd = Mass_CW * Len_BarCW * Len_PenCW * Ph_dd * sin(Th + Ph) + Mass_CW * Len_BarCW * Len_PenCW * Ph_d**2 * cos(Th + Ph) + CONST_V() * cos(Th)
    return ITh_dd

def EOM_h(Th_dd, Th_d, Th, Ph):
    hPh_dd = Len_BarCW * Th_dd * sin(Th+Ph) + Len_BarCW * Th_d**2 * cos(Th + Ph) - g * sin(Ph)
    return hPh_dd

def I():
    Ib = 1/3 * Mass_Bar * ((Len_BarPW**3 + Len_BarCW**3)/(Len_BarPW + Len_BarCW))
    I = Mass_CW * Len_BarCW**2 + Mass_PW * Len_BarPW**2 + Ib
    return I

def Wait():
    while True:
        sleep(5)

############################################
# GRAPHING SETUP
############################################

fig1, ax1 = plt.subplots()

# Lists
times = []
Th_G = []
Th_dG = []
Th_ddG = []

# Lines
line_Th, = ax1.plot([], [], label="Theta", color="#4CC9F0")
line_Th_d, = ax1.plot([], [], label="Theta d", color="#F72585")
line_Th_dd, = ax1.plot([], [], label="Theta dd", color="#FCA311")

# Setup
ax1.set_xlabel("Time (s)")
ax1.set_ylabel("Angle / angular velocity / angular acceleration")
ax1.set_title("Trebuchet motion over time")
ax1.legend()
ax1.grid()

############################################
# SIMULATION LOOP
############################################

while True:


    if Th > Pause_Level:
        vel = Th_d * Len_BarPW
        print(f"{vel:.1f}")
        Wait()
        


    Th_dd = EOM_I(Ph_dd, Ph_d, Th, Ph) / I()
    Th_d = Th_d + dt * Th_dd
    Th = Th + dt * Th_d    

    Ph_dd = EOM_h(Th_dd, Ph_d, Th, Ph) / Len_PenCW
    Ph_d = Ph_d + dt * Ph_dd
    Ph = Ph + dt * Ph_d


    t += dt


    ############################################
    # APPEND VALUES
    ############################################

    times.append(t)
    Th_G.append(degrees(Th))
    Th_dG.append(degrees(Th_d))
    Th_ddG.append(degrees(Th_dd))

    ############################################
    # UPDATE GRAPH 1
    ############################################

    line_Th.set_data(times, Th_G)
    line_Th_d.set_data(times, Th_dG)
    line_Th_dd.set_data(times, Th_ddG)

    ax1.set_aspect('auto')
    ax1.relim()
    ax1.autoscale_view()

    ### DRAW
    fig1.canvas.draw()
    fig1.canvas.flush_events()

    plt.pause(dt)