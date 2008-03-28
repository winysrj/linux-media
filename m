Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out.neti.ee ([194.126.126.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kasjas@hot.ee>) id 1JfL5z-0006Xd-Vx
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 21:22:41 +0100
Message-ID: <47ED538C.4090302@hot.ee>
Date: Fri, 28 Mar 2008 22:22:36 +0200
From: Arthur Konovalov <kasjas@hot.ee>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200803212024.17198.christophpfister@gmail.com>	<200803281535.57209.christophpfister@gmail.com>	<47ED0962.20701@hot.ee>
	<200803281816.10525.christophpfister@gmail.com>
In-Reply-To: <200803281816.10525.christophpfister@gmail.com>
Content-Type: multipart/mixed; boundary="------------040902060908050003070805"
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040902060908050003070805
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Christoph Pfister wrote:
> Am Freitag 28 M=E4rz 2008 schrieb Arthur Konovalov:
> Try removing the following three lines from=20
> linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c and see whether it wo=
rks:
>=20
> 989 				/* clear down an old CI slot if necessary */
> 990 				if (ca->slot_info[slot].slot_state !=3D DVB_CA_SLOTSTATE_NONE)
> 991 					dvb_ca_en50221_slot_shutdown(ca, slot);

Done.

> If it doesn't work load budget-core with module param debug=3D255 and d=
vb-core=20
> with module param cam_debug=3D1 (likely you need to unload them first);=
 please=20
> paste dmesg in any case.

I haven't xine GUI at moment, but regarding to logs I suspect that it=20
doesn't works...

Attached files are:
dmesg_load_modules - dmesg after modules load.
dmesg_start_vdr - dmesg after vdr start.
syslog - syslog after vdr start.

I noticed some suspicious rows in logs:

budget_av: saa7113_init(): saa7113 not found on KNC card

DVB: TDA10021(0): _tda10021_writereg, writereg error (reg =3D=3D 0x01, va=
l=20
=3D=3D 0x6a, ret =3D=3D -121)


I hope it helps and wish quick solution :) .

Regards,
Arthur


--------------040902060908050003070805
Content-Type: application/octet-stream;
 name="syslog.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="syslog.zip"

UEsDBBQAAgAIAKawfDhqdxC8OSsAAPlUAwAGAAAAc3lzbG9n7Zxtjxs3loW/DzD/gbvAYhzA
7tZrvwFewImdGWOSOLCd7CwWjUZZqm4LlqUeqaTE82F++1aVum2X6hzyssR6YYdYTNZOziVZ
h7zkpaR6nv77Kfo/9fPm7dv/VfPljRr0emdHveHR4EwN+hfjs4vRQMGYfz/985+SaDZXT67V
8TZaHafRx+tP6/T//flPP0YrlbUwuOj1LnoDtZ2usv9dqP8b9M5HJ5dq8nb2Mf5xfaE269ni
Rn1cLpbJcjGbqMl8OfmgHq3i9XK+SWbLhZqt1ajX6w3GPbVYfyNo+9fnr9U2Xq2z4P7RyVFP
rZNolcRTybiW03gdJ1mnf/nl7fdPzv6inqgPi+VvC0Hw9XKzmKrBMDVyEs3jtZot1PFmnVmT
/v14vZocp/on+Zh2/y4WtDpfRtPMo9v55ma2uPi6xVR3/PMPv/z15U9vjuezd9n/sg5+ny3i
o/XyKO/IooevWo6TfKzHqReb26PJcnF9YDvLzWoSrx20NJ2t439OHDQ0eR8tFvHcxZiSdDGv
XDQ0WX78GC2mLppaxZPJRyctrdN/3L5frhM3w/q4TGIHDX2IP32MJqulbFCnl2o7m8ZLNZ2l
xiTL1Se1nmTzv1LJ+1UcTe/3CPXodjZ9mnf/WCV3fzw1bjtnB7V/JtnWslYyL178/Fc1jZJI
Xa+WH5Ez8e3NUSY43JN4Ma3REd66yI/b1fJdvjam8fZ4un13HE2j2yRe9Y5TYxZJ2jrZ+z7E
qzTvL1QaczWJruLFuDcY9K9my6vlbUz2eRKze5Kr36IP8ebWtrfpMv3nJJlbxeX98dl13Ft6
midX6/ebZEpPwPvId5vpTZxcRdsLNZnNFsl1MfjRN/jf6xt9k0pVen6LxNXnhox9lZUC+wPP
/6VheY57l+q7l+puQaq0DknX6GwSp49i3g3GPbL6+dzeLueGeX3+67cX6u3zZ/20kOo/6qXP
dJVMo/xvV7+tZuko45vH6v5PKl6tlqusCrtRT5+q3u+9/mO1jea7v5xEj9PNKMn+8qQ/6Ncw
WtvVWzT+2Y+qf5GWlNPNPE53iXS+FmTCqoxxHq0T9TFer6ObOLXhNo6yeRyqrAZYN5KUPg/v
PubtLz//8EIln27ji97v/amax4ub5P3FSB+lsqXYu8j/qY4E2n6mnb4zad2sUXNMPqZBPv4z
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
siXzW5SunenyJk+sVbaCTqRrb9y/VC9ev371Wj1K02A3wqPJ42H/NJ2eV7fxKsorumydrze3
t8tswOZsul4tF0m8mO4y9kJ9/+LN22dvX1y9fvH2l59eXKjr+HY12z757+xTrvhp6bMjbXpq
U9pqxzF1w3ac6sOrtuMEI+rdp4Kv7noSxdR6bn1ub3nrtLkHNzy8lEfVlnKVheLz8g/7QDAi
GPGgRufec3dL4o9kxLiSEdooMjhTDDOiel/BiGBEMCIYEYzYxWmBUMVIR5Qp2Oj9Jwnpnczu
gwRta/afSxSbMyCwtMZqEViHT//BCKxic89//fZCvX3+rN/rZT+CTqZR/qd8Aa/imwt19wcV
r1bLlXq0ihP19Kl60h/0S5+TNjjB3VouTaTx1ppZ5nofHFbYBxvcpjszvPsYKW+rGKUnPQEt
5W0BLeVm1bGezTF6bpbOTc7NcuGm2SE9N6szh3yFdarhZlFrATeLWiubBsrNYgsIsVGAlvKv
WkwAyr8CWsq/AlrKvwJayr8CWsq/OilrKf/qpIJ3phiWIof3pedfAS19lxdo6bu8QEvf5T0p
FgnZd9Qfo9+P0rMyiReTT/nZqPrsq2nQE6VnlbWcngW0lE5Vx4qQzSynYAEtpWABLaVgAS2l
YAEtpWABLaVg+ZeBnIIFtJSCBbSUglXUSilYIJsoBQtoKWWqvQzhGCWgpTQrjZs6mhW1E7z+
zuxENCv/EqDCNACiEtBSmhXQUpoV0FL0ANBSmhXQUlpUiylCqVSsLBIe+ZRKxcoOhAVgZYfs
0OZUKg9ziCJOWGEjmydOpaIFhygvOJWKFRxmbVN5IaZLsS0e0aXoFg/oUnQLBUQetoUiuhTb
QhFBwsMUoXQptsUjuhTb4hFdim3xwi2S0qXY1is8vii9qcVjpqWb5WFbKKJE0bshoLv4l0Oc
EsW2ePRpF9vihfcaSolid0pZqcYpUezOZl6Djd73Ke2J3Q2Fa53SnoCW0p6AltKegJbSnjzM
IUp7Kms57QloKe0JaCntCWgp7QlohXncTqnGqU3FKBtqUzGyRmqT1gwTtakYfAC1qdiQHbXJ
j1S1+rWMthsKUtJG6Vk/FqES1o+2Ofprn2JUHSClYg9WICVPzOU8mWKYe5BSsX2XICXYcuXf
tmhbs/9tC5oNZ5Sndk432+1wa0l56spTQVpT49klozU5f37hLvwgjtPTSkZoo8jgTDHMiOp9
bb9+Q/r+feb0gJwvU4Pmy8mH7I3uLy/qP1bJbXq6lXbvOh7WOsbzqWh8TdYBOurOBCHQUSeW
aS2LpwuOm2MOLpf0m9Yqvolmi3RBt7tx+Ty77jahYEQwIhgRjAhGNG/EWSUjtFHanqyMMHXD
jKg+vGBEMCIY0bIRvo7OvefulkQwIhgRjPjDG3FeyQhtFBmcKYYZUb2vYMQf0Agt2qIY6YiX
ARut/CWxtjX7Tz2LzRl4GVpjtbyMw6f/YF6GR9PQRHpsrTkUrvcXAnroyvbXmeHdx0g5FMUo
PTkBaCmHoo41ao7R8y6AlnIodG5yDoULN80j72plUJ4FW2c1HApqLeBQUGtl00A5FGwBobeT
W0wAyrsAWsqhAFrKoQBayqEAWsqhAFrKofAwRSgnA2gphwJo6dtCQEvfFgJa+rYQ0FKSRFnL
SRLt5RAnVgAtJUkALSVJAC0lSQAtJUkALSVJ+JdDnHQBtJQkAbSUJAG0lCShOeo0JAl60gGS
RIunDCVW0JJMtntRkoSucNCQJKid4BU5/xKAky6cTAOgLbCCw+ynniTBCg70eiIrOMwbdqMp
QokVrLABh/aoRwoHcGgjLSNJIC0jSSAtI0nsaUXeGWNIDjnoS0u6QFr2GjTQUpIE0jKSBNIy
kgTSMpIE0jKSRC1zao6RkiTQNDGSBNIykgTSMpIE0jKShI8pwkgXSMtIEkjLSBJIy0gSSMve
QEdaRpKgWy84vlpKES2xgm7xwmOG3Q35Fio7Zqy3UECS8DCHKOmCbvHgMxG6xYPPq+gWD0pA
pGUkCaRlpRrSMpJEizlEiRVIy0gSSMtIEkjLSBJIy0gSSMtIEj7mECNdIC0jSQAtJUkgLSNJ
7GkP/NYQ9cy4FEjLuBRIK9wV2in8KJdiL8qCS7EXWR+XQm+GgUuxF1ydS7HXkBWXwpNNwuZX
KfpuGJdCH6VFJ9iECtAJ+ubYr2r2omrgUuz1YMOl8MVc+ub8XphzLgU+W1xwKWo9tQ79rQuc
DVdcipZON9vtcGvHpXAwwlpm7VCTEOai+WQVYS7cP79wU3/4p3MwIhjRQL0jgkx0aIIAZMKT
082ur34lx7VR2p6slqmpG2ZE9eEFI4IRwYhgRDAiGBGMCEZ02YiBvRGDikaY4vjwbI2o3lMw
wvPRuffc3ZIIRgQjghHBiGBEMOIhGaFDJ+xFuuEx4EYrfzmqbc3+a7Zic3oeg95YHY9BZqyY
rVBpNQ2dToO2NftpGB78QPL02MVtbXkMB4zRBnhw4GM9wOHdxwh5DHtRWoIA0jIeQy1r1Byj
5TEgLeMxaN2kPAYnbppH3kTGu5kFW2c5j4FbW+YxcGtl08B4DHQBgXd820wAxmNAWsZjQFrG
Y0BaxmNAWsZjQFrGY/AxRRiPAWkZjwFp6Ts3QEvfuQFa+s4N0DIeA9BSHkOLOUR5DEjLeAxI
y3gMSMt4DEjLeAxIy3gMHuYQ5TEgLeMxIC3jMSAt4zHojjrOY+AnXZnH0OYpw3gMvCST7V6M
x6AtHDiPgdsJXjTzLwEoj8HNNJRZArTgMPup5THQggO95McKDvOG3WiKMB4DLWyEhzblMbDC
QXhoUx4DKxyaOrRrziHKY2CFjcwjzmNgBQfiMdCCQ5QXnMfACg6ztqkcEvMY2BaPeAx0CwU8
BrqFgnff2RaKeAwepgjlMbAtXlbjch4D2+IRj4HeKWVbJOUxsK3XfHzVnSKfP5AdnVyqSbS5
eZ+o9exmEc1V6U0uepuUreLO3CZtNl1EcPAv6zjBgR0Ksk9ROMGBHQrCmxAlOIzILRQVd0BL
CQ6jCj4fHqMnOAAtJTgALSU4AC0lOAAtJTgALSU41OE3yyFH80QJDqPyTpp9t3c7W9yo2/nm
Zra4UL/PFqVPC0AflPxQ1nLyA9BS8kNRe+j3k3tOjE8vVbKKFuvsFerdN7UqXmQvMT+6nU2f
5l49Vsnuj+PTbwQPQkESmge5+0v+PNdxPJU/iePmCkvk/s3yJErWF+p0PFCPev/1jdqs49JH
b/u2Di/VD3G0zdbX5B/pwnodf8xeBL1zWBD9VdBkuUhWy7l5eoaS6aHsDqCl50E7e7GU3VGM
smF3FCNrZHdozTCxO/aXS7pU//7tc7WyXC4nZLkUt8koe7ExHdHmViVLdbxZr47ny0k0P46T
yXEqPc7/21E2Xv1DHsAYKTZkxxjx4xiz+qWVthvKGNFG6TEYFqESDIa2OfpLsWJUHYyRYg9W
jBFPzOXYgmKYe8YIPK2dMEbqqI9Ia/a/30Kz4Ywx0s4pbLsdbi0ZI9VH+KWn80v19s191qYL
dRpvZ5NY9c2H4rmhhnK0Ir4M9Wy/zuyfncnrzDR6tdsJLZ/zzPCcblYGBKs0vkPJwCrOn194
kjVyEcrWaasXK9fD+5ICg7RIvZvt9+nuOZdcZAc2WV79oXFVN5JUdW7Psa6WvV9msX+pks3C
dhfrO9zFiufUy8+n9JcB9cwD6knuVNN4Hid2Hz3ZbS2F3j5Gvx+lKzGJF5NP+cpLjU0TZrmY
kiVYiI5/n2VDfZz/Id1Zp3H5K0OT56v0eaN1+oT/D1BLAQIUABQAAgAIAKawfDhqdxC8OSsA
APlUAwAGAAAAAAAAAAAAIAAAAAAAAABzeXNsb2dQSwUGAAAAAAEAAQA0AAAAXSsAAAAA
--------------040902060908050003070805
Content-Type: application/octet-stream;
 name="dmesg_load_modules.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg_load_modules.zip"

UEsDBBQAAgAIAJesfDj1XkzTSwUAALsOAAASAAAAZG1lc2dfbG9hZF9tb2R1bGVzvVddb9s2
FH034P9wsT00BhxH1Ic/BHSoa7utsTbJmjR7GAqDJimbqCx5Eu2k+/W7pGhblJut68OCItHh
x9G95x5St0Weq1d7XsRXu7K4SnNG06uyYFebXarktshV/jNsco5PSwF8v7xkeSGA0c2Ci+Vu
9TKYknar+C8kyx1fCVXxHDj8KPoxFrr/vn18I8pVu/VeZrsn2Esucsxhq3YYg8yUKBLKRAx7
v+d57VZJ6YCE/RgKsZIlzoJ4UiIrZZ7Bi+rFC7p/0Wu3xpPbeQy3kznMNUux2yrw8Cf2/Ngj
Pe+P8We4/AXe3s3B9+EiFXuRdiHNHzt6eP7xNxyuvS/JdxkHC+EVbMQGhCciipRwUYi9NDGQ
LsjiT9zagQvviUTBsot/SNTvYEjH+GI4Pi6oUpStLzoxKo4TnPsi6utU7RJdjBiU2jK5sEMy
k+psQ9dy6mEyosPvozgkdOF1dFBJgoqqr1sBL6GU2SoVXXiUXK0Rk+GwC2shV2ulkeeHR3mq
7XxDDxSl/EsAGfkRQQ2nD69P9UJSyMQjUI41xpUX91gbqgSDicxEsfoKxEdFcc/lpNNuHZYl
VKaCw4fxBLlXGTX2YGvBvrRbImM5t5NJkW9gNrv9ePMBHmkJSRL/6L+GfBYc8rjoxM8Lrits
pCGBqzQJIMuVNRPa5dfrCZq94O0WPpFLLzZJUM4LlFh7lcaUxYTE+Ozjab6fjonn+SQG6bPL
w7onj6HtuHkcsG8IjqrgGcBXolVv1zKV2xIOVFbqXg8NipfIgtGFyCLP94kJ/ZDTpc6JydOR
BD0raSpLwc+3qnUhKHc30w3uKUWhsFZjRysmkTZZlGmuBS6FEexsENP/dPt+ZvwZ46nikIps
pdYxGhG0Ciif/g09i4nGfHnEvpkfHnGgcZJo7DKzA3PwT8w1Jv85pujA5A8cqqhB5blUUQj3
9SD7EQiLQ4MDYBZHBg9hbXHfYAGZxQODRyAtHhr+AO4sHpl5AtRiqvEgBGXxshEf0zgMYWox
N3x9eLBYmHkfXlucaOx7FSIm+zCAicUm+5BoPxjsO6tN7iGebIur3BPILa5yD4FbbHIfRLCz
uModq2nx0NWSjNzcCH2mjL73basFbhUDPIKO1TzXahV2DUKPBiEONWkYJGm4uEntH3HY2G9E
Yqf1RiRPHPHALUFlkBrfqFFw2ij4slFwY5AogUXdIKeSW4OMYF43yGl9ZZETf2WRgABxLHKM
vzJJ4IFXN0mFXamXx1PtnEWWNKQOG1KPXKmDAQzqUkcRfKpLffJrJXXE4XNdary3enWpa1Ia
qbEb+akuda10y0Y8P3QWm1KHQ3jnnMYEbupSn+6KSurT3VRJXTs/ldWO1iMNq1Xn8RQvaeRf
ncdTvNV5rMW7bNwezLUS4Y31onF/JG5+vufG4xO3nr7JP2Tw3uLqPopgZnEtf9dq4cFqaMLZ
9RRu3sDk3Xh+Dc4y3WM84BeU628wTMYfsJPATkiZXuZ6Po0DjlfMdPaAjx5Mbq7fzN++Ht/N
zI10GLi5vZ/fXGu2s49waZqXLJGrfKuwO2237oSC+oi+7rqgP9Vnw6aNMEHtdYhUR1XuGBNl
mezS9OvZ21KZfbEtQ2PmkUrsOPFTrrBvK/9lunqJ0A2dkhuR75QWsbFFR7zAmPCj9VEwIfe4
ejKGLWVfhG6vsAPFtgHbHcwqQ0V1TigzFgtSWqpFUtBVTEybqsVstybrvBQZ6BycHjZPgPT/
h4QeC6mEzeh3/H+R+GY63e/O55nmSpX4RrpMRbPBOk7EMDwEd+zR8ZicGZRiN1nrABvW+BtQ
SwECFAAUAAIACACXrHw49V5M00sFAAC7DgAAEgAAAAAAAAAAACAAAAAAAAAAZG1lc2dfbG9h
ZF9tb2R1bGVzUEsFBgAAAAABAAEAQAAAAHsFAAAAAA==
--------------040902060908050003070805
Content-Type: application/octet-stream;
 name="dmesg_start_vdr.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg_start_vdr.zip"

UEsDBBQAAgAIAIGufDgB5dW7WAcAAK6kAAAPAAAAZG1lc2dfc3RhcnRfdmRy7Z1dT9tIFIbv
I+U/HO3etBJF/iQfEtKmQLdIBaotZbUXq8ixx2A1jSPbgXYv+tt3PHbijyQebJx4HI4qIY4d
x+9555yZDDy4p79ON/2Dz4vb239g6t6DIkn9Y0k9VvqgyENVHmoSbLzm12m347lu8Mej5Q1/
/Q7Wd+LfdzvW42RsGmMy0yVFkceOO3bnZLZ2PHjwiGGNn4xvZDHfdJXl0q9mMF07x66zjMAo
dZU/dYOx/7AILPeJqpksrHsSjI3HIZiOMwvs7AvevN18vNv5QkOQIDlQNq+5O50u7/+O3d/4
Ds7MJ15ALBhtleYRnwR5Xexgt3N+934It+cjWZIU+Y1EXzQOLINF4yfPCYhH7o9g+R0Qz3M9
eBN+e3oK0g9JPoJHYxoFJ8YReCQIg3eyIr/dnkMJ9wuuqeu42Pe+/fr50wUEP+dkKP2QLZiS
2X3wMNS6HQgHQBqyr3Acx3IYW5NVrLDz/TAuq5Zdr4bX23Z4fVaJuVSiFimJ7pwoid5pd/7o
S1VKLyNLz8mSsrJ0DW7TCZ/oQOJYY7EKZkUDdXZ9Hx7i+ITFBGZx3GPxAJw47jM9KnyJ4wE7
L4MRx0YY9zQI6rWRvfck540ZxpoG53FsMW0ncBfHhJ1X4H0c22GsSABRLDPvNRXO4ph5r8nh
XFXFS1nJvT8bK82CqziOxsoGN44j7zWw4ph539NhEceR97SS6/dS7mfrSB5kvZWNLY1F09vY
4mq2glULTitWpJIbZTWJs81krJpJzkiRc81Ue08XyFRWsZbTwgbbTF7PBlsiq7iXFF/SaNH7
VbJxkGsOI9cck1xzsGbSbRinmylpjriZBnC5Ay/t7L2jxky0Ro2pyiBnGm3lXdRoqgRSutGi
uKx32RKbrFaRzHxt2rkS03IL2iBbFmoPeumy0HX4ugMb9ex8E5WYbsG/6RKja/RxusRSJcFK
RlHgt3TJpEp2kuRWqSQrzdf5stD68DEzX9tws4P5Ucmuc1GJJetwVGKp+TJq71W7y7n2juby
JHc55X2ltWaQ9Sqar1NeTXJrm5m0L4ut3OtJUju1e2kn4xTGipT1QpGTnmAx814z4VMcR+uo
DhdxnPL+Ze2tLdubThQX1+dw8wHOPo4uryHzMtvudu6MqWMB3Y7A2egKLBIQM9zVXI2uL8+H
qkWXv/OLO/qtBGc31x8u/3w/+nLBVsvlgZvPt5c31+G7re/g6KbIdGe2c+/OA8cN92J0m5I+
Ei7F4ebFsNYOsz0SE/UYSjRCVf7CNInv24vp9KdQO42pM/s2dmbO+ofDJ8MJxg7d/AVGsPA5
p6MEiUVTDZzvxF0Ew/WZPrWb/ouYxHmkrz4bwdwwv1F3bbpP9KMdL3V0Rkcz9JMOMS0smBp+
MLY9434og+/8xz72dDtnD65PZhDmAJOFbROPnQTXBvlkDwmxXW6c0d+eG5CN6Rw9O58t2/HA
p3c0JlOS35KvTgyhvxQHhmXM6d4baEuvNYcxsyAcbIcWpv+CstxHuTJza7Nc3mS5/mw9hT8I
aqx5UVUlVeUmn42VM6gn6/CiRvquklpUhapecE1KcbzQma5Hly4/cOfhUmbSdWvhsUUuOj+k
C5c8MPpShU1j8zkKpLjarzFQMSpGxW1QvLdPXKgYFaNiVNxixQcNZwg2cqJW1N51tQHJKMoL
cY3t5pbANbgWI8qxVV8ZlIPnM2IeGyugAPMoyhYRkOdbXAIB4U4WiIdsWB9K4SFcixEd2a6v
xPrA9Rmxku36SmAl3HUPkZMNU4aoyEmR04eKoxTdA1GVFyS0R1RlG6GyQliW4g4GVTlY7KUo
NzExD1QsjGLEbOofW1RcTpWQPzJGxagYFaNiVPyaFL/2X7yjYlSMilHxc+6OkM7+Rk7Uitq7
ruqQTtmM8lDP8yEdHohTlHdLIZ1K5qagnrKQDg/E4VrcUkinis9pqKcspMMDcXg+I6STh3RK
gDjcIkZIp5bntHB9RkiHB+nwQByuxQjp1PJ8F+58jJBOLc9+4fqMkI5AkM6OQRwhd2CtBnG2
5fiKAJ1mniXTdCkLBdbU/iuHnTc9Kt6r4vbCM3txtlYUBRWjYlSMilExKkbFrVPcakgaFaNi
VFyr4lbv+3as+JWBNY2ufqKuyjvRtR2eKXo3HliTB2XKZlIfWCMoPMM1V6Cn3/DAGpHhGa7P
Aj39hgfWiATPFN2jlWCNyPAMt4hbBNaIDM/wfG4JWCMyPMMt5RaBNSLDM9xSbhFYIzI8w/MZ
wRoQ9wk3te3AEKxBsKa+J9/sq5TbA9Y07RQqbl5xe8GavTgr5jNeUDEqRsWo+DAV4xNTUHFT
ilv9WQ4Vo2JUjIr3pPiVwTPthVEOSZc4/3VUkfqDA2uahmeK0j0ksKZpeIbnc1vBGnHgmedP
G60Fa5qGZ7iTxYGANQ3CM1yLDwSsaRqe4fp8IGBN0/AMd907ELDmdcIzRU63CKypbQeGYA2C
Nc2CNduOCwXPFOUm5t/6tU9xq/86sb3wzAH9vTsq3oHizv9QSwECFAAUAAIACACBrnw4AeXV
u1gHAACupAAADwAAAAAAAAAAACAAAAAAAAAAZG1lc2dfc3RhcnRfdmRyUEsFBgAAAAABAAEA
PQAAAIUHAAAAAA==
--------------040902060908050003070805
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040902060908050003070805--
