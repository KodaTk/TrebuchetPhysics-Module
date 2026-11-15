import math
import time
import matplotlib.pyplot as plt


dt = 0.01
t = 0

### Degrees #we copying the teach
Th_dd = 0
Th_d = 0
Ph_dd = 0
Ph_d = 0

### Lengths (meter)
Len_BarPW = 3
Len_BarCW = 1
Len_PenCW = 0.5

### Simples
g = 9.81 # on earth, constant or variable
Mass_CW = 20000 #Counterweight 2000 Kg
Mass_PW = 0.2 #Projectileweight 200 Grams
Mass_Bar = 50 #Bar weight 200 Kg
Ph = math.radians(270)
Th = math.radians(0)
V = 0

def CONST_V():
    V = Mass_CW * g * Len_BarCW - Mass_PW * g * Len_BarPW - 0.5 * Mass_Bar * g * (Len_BarPW - Len_BarCW)
    return V

def EOM_I(Ph_dd, Ph_d, Th, Ph):
    ITh_dd = Mass_CW * Len_BarCW * Len_PenCW * Ph_dd * math.sin(Th + Ph) + Mass_CW * Len_BarCW * Len_PenCW * Ph_d**2 * math.cos(Th + Ph) + CONST_V() * math.cos(Th)
    return ITh_dd

def EOM_h(Th_dd, Th_d, Th, Ph):
    hPh_dd = Len_BarCW * Th_dd * math.sin(Th+Ph) + Len_BarCW * Th_d**2 * math.cos(Th + Ph) - g * math.sin(Ph)
    return hPh_dd

def I():
    Ib = 1/3 * Mass_Bar * ((Len_BarPW**3 + Len_BarCW**3)/(Len_BarPW + Len_BarCW))
    I = Mass_CW * Len_BarCW**2 + Mass_PW * Len_BarPW**2 + Ib
    return I



# -------------------------
# Graph setup
# -------------------------

times = []
Th_G = []
Th_dG = []
Th_ddG = []
Pw_posx = []
Pw_posy = []
Cw_posx = []
Cw_posy = []
CW_posx = []
CW_posy = []

plt.ion()

fig, ax = plt.subplots()

line_Th, = ax.plot([], [], label="Theta")
line_Th_d, = ax.plot([], [], label="Theta d")
line_Th_dd, = ax.plot([], [], label="Theta dd")

line_Pw_pos, = ax.plot([],[], label="Pw_pos")
line_Cw_pos, = ax.plot([],[], label="Cw_pos")
line_bar, = ax.plot([], [], label="Bar")
line_pen, = ax.plot([], [], label="pen")
line_CW_pos, = ax.plot([], [], label="CW")
ax.plot(0, 0, 'o', label="Pivot")

ax.set_xlabel("Pos X (m)")
ax.set_ylabel("Pos y (m)")
ax.set_title("Trebuchet motion over time")
ax.legend()
ax.grid()


# larpaholic

def pauze(vel):
    time.sleep(10)

# -------------------------
# Simulation
# -------------------------

while True:


    if Th > math.radians(60):
        vel = Th_d * Len_BarPW
        print(vel)
        pauze(vel)
        dt = 0
        


    Ph_dd = EOM_h(Th_dd, Th_d, Th, Ph) / Len_PenCW
    Th_dd = EOM_I(Ph_dd, Ph_d, Th, Ph) / I()

    Ph_d = Ph_d + dt * Ph_dd
    Th_d = Th_d + dt * Th_dd

    Ph = Ph + dt * Ph_d
    Th = Th + dt * Th_d

    t += dt



    # Store values
    times.append(t)
    Th_G.append(math.degrees(Th))
    Th_dG.append(math.degrees(Th_d))
    #Th_ddG.append(math.degrees(Th_dd))

    Pw_posx.append(-1*Len_BarPW*math.cos(Th))
    Pw_posy.append(Len_BarPW*math.sin(Th))

    Cw_posx.append(Len_BarCW*math.cos(Th))
    Cw_posy.append(-1*Len_BarCW*math.sin(Th))

    CW_posx.append(
        Len_BarCW * math.cos(Th)
        - Len_PenCW * math.sin(Th + Ph)
    )

    CW_posy.append(
        -Len_BarCW * math.sin(Th)
        -Len_PenCW * math.cos(Th + Ph)
    )

    # Update graph
    #line_Th.set_data(times, Th_G)
    #line_Th_d.set_data(times, Th_dG)
    #line_Th_dd.set_data(times, Th_ddG)


    line_bar.set_data(
        [Cw_posx[-1], Pw_posx[-1]],
        [Cw_posy[-1], Pw_posy[-1]]
    )

    line_pen.set_data(
        [Cw_posx[-1], CW_posx[-1]],
        [Cw_posy[-1], CW_posy[-1]]
    )


    line_Pw_pos.set_data(Pw_posx, Pw_posy)
    line_Cw_pos.set_data(Cw_posx, Cw_posy)
    line_CW_pos.set_data(CW_posx, CW_posy)

    ax.relim()
    ax.autoscale_view()

    plt.draw()
    plt.pause(0.01)

    print("t =", t)
    print("Th =", math.degrees(Th))
    print("Th_d =", Th_d)
    print("Th_dd =", Th_dd)



    # ISSUES
    # IF PHI IS NEUTRAL, GRAVITY IS OPISITE