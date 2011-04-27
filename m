Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <silvercordiagsr@hotmail.com>) id 1QEtJR-000499-OI
	for linux-dvb@linuxtv.org; Wed, 27 Apr 2011 03:13:06 +0200
Received: from snt0-omc3-s4.snt0.hotmail.com ([65.55.90.143])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1QEtJQ-0007nT-He; Wed, 27 Apr 2011 03:13:05 +0200
Message-ID: <SNT124-W617C89EDE0DBE313ACDFCCAC980@phx.gbl>
From: Nicholas Leahy <silvercordiagsr@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 27 Apr 2011 11:13:00 +1000
MIME-Version: 1.0
Subject: [linux-dvb] DViCO FusionHDTV DVB-T Dual Express2
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0226272454=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0226272454==
Content-Type: multipart/alternative;
	boundary="_8a1e789f-b682-4ced-a62e-3367a56d75a0_"

--_8a1e789f-b682-4ced-a62e-3367a56d75a0_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


I=92m trying to get the DViCO FusionHDTV DVB-T
Dual Express2 http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual=
_Express2 to work with v4l

I found what looks like most of the relevant
information in dib0700_devices.c at line /*DIB7070 generic*/ however im not
sure about the "dib7070p_tuner_attach" and
"dib7070_set_param_override" configs as they refer to a usb adaptor
dib0700

=20

I have modified the following
modules to load the card cx23885.h=2C cx23885-dvb.c & cx23885-cards.c

=20

nicholas@Trial-Backend:~$
dmesg | grep -i dib

[   30.930887] DiB0070: successfully
identified

[   30.930903] DVB: registering adapter 0
frontend 0 (DiBcom 7000PC)...

[   31.420874] DiB0070: successfully
identified

[   31.420890] DVB: registering adapter 1
frontend 0 (DiBcom 7000PC)...

nicholas@Trial-Backend:~$ dmesg | grep -i cx

[   29.869405] cx23885 driver version
0.0.2 loaded

[   29.881296] cx23885 0000:03:00.0: PCI
INT A -> Link[AE2A] -> GSI 16 (level=2C low) -> IRQ 16

[   29.881552] CORE cx23885[0]:
subsystem: 18ac:db98=2C board: DViCO FusionHDTV DVB-T Dual Express Rev2
[card=3D29=2Cautodetected]

[   30.460772] ir-kbd-i2c: i2c IR
(FusionHDTV) detected at i2c-3/3-006b/ir0 [cx23885[0]]

[   30.462879] cx23885_dvb_register()
allocating 1 frontend(s)

[   30.462886] cx23885[0]: cx23885 based
dvb card

[   30.930896] DVB: registering new
adapter (cx23885[0])

[   30.932021] cx23885_dvb_register()
allocating 1 frontend(s)

[   30.932028] cx23885[0]: cx23885 based
dvb card

[   31.420885] DVB: registering new
adapter (cx23885[0])

[   31.421369]
cx23885_dev_checkrevision() Hardware revision =3D 0xa5

[   31.421379] cx23885[0]/0: found at
0000:03:00.0=2C rev: 4=2C irq: 16=2C latency: 0=2C mmio: 0xfc000000

[   31.421386] cx23885 0000:03:00.0:
setting latency timer to 64



nicholas@Trial-Backend:~$ lspci



3:00.0 Multimedia video controller [0400]: Conexant Systems=2C Inc. CX23885=
 PCI
Video and Audio Decoder [14f1:8852] (rev 04)

                Subsystem: DViCO
Corporation Device [18ac:db98]

                Flags: bus master=2C fast
devsel=2C latency 0=2C IRQ 16

                Memory at fc000000
(64-bit=2C non-prefetchable) [size=3D2M]

                Capabilities: <access
denied>

                Kernel driver in use:
cx23885

                Kernel modules: cx23885



nicholas@Trial-Backend:~$ scan -c -a 0 -f 0 -d 0 -l 45000000=2C800000000

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

WARNING: filter timeout pid 0x0011

WARNING: filter timeout pid 0x0000

dumping lists (0 services)

Done.

=20

=20

=20

--- cx23885.h          2011-04-06 00:21:42.000000000 +1000

+++ newcx23885.h 2011-04-06 09:38:48.000000000 +1000

@@ -85=2C6 +85=2C7 @@

 #define CX23885_BOARD_HAUPPAUGE_HVR1290        26

 #define CX23885_BOARD_MYGICA_X8558PRO          27

 #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200
28

+#define
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2 29

=20

 #define GPIO_0 0x00000001

 #define GPIO_1 0x00000002

=20

=20

--- cx23885-cards.c               2011-04-06 00:21:42.000000000
+1000

+++ newcx23885-cards.c      2011-04-06 09:43:44.000000000 +1000

@@ -300=2C6 +300=2C11 @@

                                                                  CX25840_C=
OMPONENT_ON=2C

                                }
}=2C

                }=2C

+              [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2]
=3D {

+                              .name                      =3D "DViCO Fusion=
HDTV
DVB-T Dual Express Rev2"=2C

+                              .portb                      =3D CX23885_MPEG=
_DVB=2C

+                              .portc                      =3D CX23885_MPEG=
_DVB=2C

+              }=2C

 }=3B

 const unsigned int cx23885_bcount =3D
ARRAY_SIZE(cx23885_boards)=3B

=20

@@ -447=2C6 +452=2C10 @@

                                .subvendor
=3D 0x107d=2C

                                .subdevice
=3D 0x6f22=2C

                                .card      =3D CX23885_BOARD_LEADTEK_WINFAS=
T_PXTV1200=2C

+              }=2C
{

+                              .subvendor
=3D 0x18ac=2C

+                              .subdevice
=3D 0xdb98=2C

+                              .card
     =3D
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2=2C

                }=2C

 }=3B

 const unsigned int cx23885_idcount =3D
ARRAY_SIZE(cx23885_subids)=3B

@@ -653=2C6 +662=2C7 @@

                                break=3B

                case
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:

                case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:

+              case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:

                                /*
Two identical tuners on two different i2c buses=2C

                                 * we need to reset the correct gpio. */

                                if
(port->nr =3D=3D 1)

@@ -784=2C6 +794=2C7 @@

                                mdelay(20)=3B

                                cx_set(GP0_IO=2C
0x000f000f)=3B

                                break=3B

+              case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:

                case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:

                                /*
GPIO-0 portb xc3028 reset */

                                /*
GPIO-1 portb zl10353 reset */

@@ -942=2C6 +953=2C7 @@

                                dev->sd_ir
=3D cx23885_find_hw(dev=2C CX23885_HW_888_IR)=3B

                                dev->pci_irqmask
|=3D PCI_MSK_IR=3B

                                break=3B

+              case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:

                case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:

                                request_module("ir-kbd-i2c")=3B

                                break=3B

@@ -1011=2C6 +1023=2C7 @@

                }

=20

                switch
(dev->board) {

+              case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:

                case
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:

                case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:

                                ts2->gen_ctrl_val  =3D 0xc=3B /* Serial bus=
 + punctured clock */

=20

--- cx23885-dvb.c  2011-04-06 00:21:42.000000000 +1000

+++ newcx23885-dvb.c         2011-04-20 22:35:32.000000000 +1000

@@ -45=2C6 +45=2C7 @@

 #include "tuner-simple.h"

 #include "dib7000p.h"

 #include "dibx000_common.h"

+#include "dib0070.h"

 #include "zl10353.h"

 #include "stv0900.h"

 #include "stv0900_reg.h"

@@ -77=2C6 +78=2C94 @@

=20

 /*
------------------------------------------------------------------ */

=20

+static struct dibx000_agc_config
dib7070_agc_config =3D {

+              BAND_UHF
| BAND_VHF | BAND_LBAND | BAND_SBAND=2C

+              /*
P_agc_use_sd_mod1=3D0=2C P_agc_use_sd_mod2=3D0=2C P_agc_freq_pwm_div=3D5=2C=
 P_agc_inv_pwm1=3D0=2C
P_agc_inv_pwm2=3D0=2C

+             =20
* P_agc_inh_dc_rv_est=3D0=2C P_agc_time_est=3D3=2C P_agc_freeze=3D0=2C P_ag=
c_nb_est=3D5=2C
P_agc_write=3D0 */

+              (0
<< 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0
<< 9) | (0 << 8)

+              |
(3 << 5) | (0 << 4) | (5 << 1) | (0 << 0)=2C

+

+              600=2C

+              10=2C

+

+              0=2C

+              118=2C

+

+              0=2C

+              3530=2C

+              1=2C

+              5=2C

+

+              65535=2C

+              0=2C

+

+              65535=2C

+              0=2C

+

+              0=2C

+              40=2C

+              183=2C

+              206=2C

+              255=2C

+              72=2C

+              152=2C

+              88=2C

+              90=2C

+

+              17=2C

+              27=2C

+              23=2C

+              51=2C

+

+              0=2C

+}=3B

+

+static int
dib7070_tuner_reset(struct dvb_frontend *fe=2C int onoff)

+{

+              return
dib7000p_set_gpio(fe=2C 8=2C 0=2C !onoff)=3B

+}

+

+static int
dib7070_tuner_sleep(struct dvb_frontend *fe=2C int onoff)

+{

+              return
0=3B

+}

+

+static struct dib0070_config
dib7070p_dib0070_config =3D{

+             =20

+                              .i2c_address
=3D DEFAULT_DIB0070_I2C_ADDRESS=2C

+                              .reset
=3D dib7070_tuner_reset=2C

+                              .sleep
=3D dib7070_tuner_sleep=2C

+                              .clock_khz
=3D 12000=2C

+             =20

+}=3B

+

+static struct
dibx000_bandwidth_config dib7070_bw_config_12_mhz =3D {

+              60000=2C
15000=2C

+              1=2C
20=2C 3=2C 1=2C 0=2C

+              0=2C
0=2C 1=2C 1=2C 2=2C

+              (3
<< 14) | (1 << 12) | (524 << 0)=2C

+              (0
<< 25) | 0=2C

+              20452225=2C

+              12000000=2C

+}=3B

+

+static struct dib7000p_config
dib7070p_dib7000p_config =3D {

+              .output_mpeg2_in_188_bytes
=3D 1=2C

+

+              .agc_config_count
=3D 1=2C

+              .agc
=3D &dib7070_agc_config=2C

+              .bw  =3D &dib7070_bw_config_12_mhz=2C

+              .tuner_is_baseband
=3D 1=2C

+              .spur_protect
=3D 1=2C

+

+              .gpio_dir
=3D 0xfcef=2C

+              .gpio_val
=3D 0x0110=2C

+              .gpio_pwm_pos
=3D DIB7000P_GPIO_DEFAULT_PWM_POS=2C

+

+              .hostbus_diversity
=3D 1=2C

+              .output_mode
=3D OUTMODE_MPEG2_PAR_GATED_CLK=2C

+}=3B

+

 static int dvb_buf_setup(struct videobuf_queue
*q=2C

                                                 unsigned int *count=2C uns=
igned int *size)

 {

@@ -760=2C6 +849=2C17 @@

                                                                fe->ops.tun=
er_ops.set_config(fe=2C
&ctl)=3B

                                }

                                break=3B

+              case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:

+                              i2c_bus
=3D &dev->i2c_bus[port->nr - 1]=3B

+                              fe0->dvb.frontend
=3D dvb_attach(dib7000p_attach=2C

+                                              &i2c_bus->i2c_adap=2C

+                                              0x12=2C
&dib7070p_dib7000p_config)=3B

+

+                              if
(fe0->dvb.frontend !=3D NULL)             =20

+                                              dvb_attach(dib0070_attach=2C
fe0->dvb.frontend=2C

+                                              &i2c_bus->i2c_adap=2C

+                                              &dib7070p_dib0070_config)=3B

+                              break=3B

                case
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:

                                i2c_bus
=3D &dev->i2c_bus[port->nr - 1]=3B

  		 	   		  =

--_8a1e789f-b682-4ced-a62e-3367a56d75a0_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Tahoma
}
--></style>
</head>
<body class=3D'hmmessage'>
<p class=3D"MsoNormal"><span class=3D"apple-style-span"><span style=3D"font=
-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A">I=92m trying to get the DViCO FusionHDTV=
 DVB-T
Dual Express2&nbsp=3B</span></span><span class=3D"ecxapple-style-span"><spa=
n style=3D"font-size:8.0pt=3Bfont-family:Arial=3Bcolor:#2A2A2A"><a href=3D"=
http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express2" tar=
get=3D"_blank" style=3D"font-weight:inherit=3Bcursor:pointer"><span style=
=3D"color:#0068CF">http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T=
_Dual_Express2</span></a></span></span><span class=3D"apple-style-span"><sp=
an style=3D"font-size:8.0pt=3Bfont-family:Arial=3B
color:#2A2A2A">&nbsp=3B</span></span><span class=3D"ecxapple-style-span"><s=
pan style=3D"font-size:8.0pt=3Bfont-family:Arial=3Bcolor:#2A2A2A">to work w=
ith v4l</span><o:p></o:p></span></p>

<p class=3D"MsoNormal"><span class=3D"apple-style-span"><span style=3D"font=
-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A">I found what looks like most of the rele=
vant
information in dib0700_devices.c at line /*DIB7070 generic*/ however im not
sure about the "dib7070p_tuner_attach" and
"dib7070_set_param_override" configs as they refer to a usb adaptor
dib0700</span><o:p></o:p></span></p>

<p class=3D"MsoNormal"><span class=3D"apple-style-span"><span style=3D"font=
-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A"><o:p>&nbsp=3B</o:p></span></span></p>

<p class=3D"MsoNormal"><span class=3D"apple-style-span"><span style=3D"font=
-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A">I have&nbsp=3Bmodified&nbsp=3Bthe follow=
ing
modules to load the card cx23885.h=2C cx23885-dvb.c &amp=3B cx23885-cards.c=
</span><o:p></o:p></span></p>

<p class=3D"MsoNormal"><span class=3D"apple-style-span"><span style=3D"font=
-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A"><o:p>&nbsp=3B</o:p></span></span></p>

<p class=3D"MsoPlainText"><span style=3D"font-size:8.0pt=3Bfont-family:Aria=
l">nicholas@Trial-Backend:~$
dmesg | grep -i dib<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.930887] DiB007=
0: successfully
identified<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.930903] DVB: r=
egistering adapter 0
frontend 0 (DiBcom 7000PC)...<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>31.420874] DiB007=
0: successfully
identified<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>31.420890] DVB: r=
egistering adapter 1
frontend 0 (DiBcom 7000PC)...<br>
nicholas@Trial-Backend:~$ dmesg | grep -i cx<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>29.869405] cx2388=
5 driver version
0.0.2 loaded<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>29.881296] cx2388=
5 0000:03:00.0: PCI
INT A -&gt=3B Link[AE2A] -&gt=3B GSI 16 (level=2C low) -&gt=3B IRQ 16<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>29.881552] CORE c=
x23885[0]:
subsystem: 18ac:db98=2C board: DViCO FusionHDTV DVB-T Dual Express Rev2
[card=3D29=2Cautodetected]<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.460772] ir-kbd=
-i2c: i2c IR
(FusionHDTV) detected at i2c-3/3-006b/ir0 [cx23885[0]]<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.462879] cx2388=
5_dvb_register()
allocating 1 frontend(s)<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.462886] cx2388=
5[0]: cx23885 based
dvb card<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.930896] DVB: r=
egistering new
adapter (cx23885[0])<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.932021] cx2388=
5_dvb_register()
allocating 1 frontend(s)<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>30.932028] cx2388=
5[0]: cx23885 based
dvb card<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>31.420885] DVB: r=
egistering new
adapter (cx23885[0])<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>31.421369]
cx23885_dev_checkrevision() Hardware revision =3D 0xa5<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>31.421379] cx2388=
5[0]/0: found at
0000:03:00.0=2C rev: 4=2C irq: 16=2C latency: 0=2C mmio: 0xfc000000<br>
[<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B </span>31.421386] cx2388=
5 0000:03:00.0:
setting latency timer to 64<br>
<br>
nicholas@Trial-Backend:~$ lspci<br>
<br>
3:00.0 Multimedia video controller [0400]: Conexant Systems=2C Inc. CX23885=
 PCI
Video and Audio Decoder [14f1:8852] (rev 04)<br>
<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>Subsystem: DViCO
Corporation Device [18ac:db98]<br>
<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>Flags: bus master=2C fast
devsel=2C latency 0=2C IRQ 16<br>
<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>Memory at fc000000
(64-bit=2C non-prefetchable) [size=3D2M]<br>
<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>Capabilities: &lt=3Baccess
denied&gt=3B<br>
<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>Kernel driver in use:
cx23885<br>
<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>Kernel modules: cx23885<br>
<br>
nicholas@Trial-Backend:~$ scan -c -a 0 -f 0 -d 0 -l 45000000=2C800000000<br=
>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<br>
WARNING: filter timeout pid 0x0011<br>
WARNING: filter timeout pid 0x0000<br>
dumping lists (0 services)<br>
Done.<br>
<o:p>&nbsp=3B</o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><o:p>&nbsp=3B</o=
:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><o:p>&nbsp=3B</o=
:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">--- cx23885.h<sp=
an style=3D"mso-tab-count:
1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
 </span>2011-04-06 00:21:42.000000000 +1000<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+++ newcx23885.h=
<span style=3D"mso-tab-count:1"> </span>2011-04-06 09:38:48.000000000 +1000=
<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -85=2C6 +85=
=2C7 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#define CX23885_BOARD_HAUPPAUGE_HVR1290<spa=
n style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B </span>26<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#define CX23885_BOARD_MYGICA_X8558PRO<span =
style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>27<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#define CX23885_BOARD_LEADTEK_WINFAST_PXTV1=
200
28<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+#define
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2 29<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#define GPIO_0 0x00000001<o:p></o:p></span>=
</p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#define GPIO_1 0x00000002<o:p></o:p></span>=
</p>

<p class=3D"MsoNormal"><span class=3D"ecxapple-style-span"><span style=3D"f=
ont-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A"><o:p>&nbsp=3B</o:p></span></span></p>

<p class=3D"MsoNormal"><span class=3D"ecxapple-style-span"><span style=3D"f=
ont-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A"><o:p>&nbsp=3B</o:p></span></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">--- cx23885-card=
s.c<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </=
span>2011-04-06 00:21:42.000000000
+1000<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+++ newcx23885-c=
ards.c<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>2011-04-06 09:43:44.000000000 +1000<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -300=2C6 +300=
=2C11 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:4">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span><span style=3D"mso-spacerun:ye=
s">&nbsp=3B </span>CX25840_COMPONENT_ON=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>}
}=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>}=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>[CX23885_BOARD_DVICO_=
FUSIONHDTV_DVB_T_DUAL_EXP2]
=3D {<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.name<span style=3D"mso-tab-count:2">&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B </span>=3D "DViCO FusionHDTV
DVB-T Dual Express Rev2"=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.portb<span style=3D"mso-tab-count:2">&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B </span>=3D CX23885_MPEG_DVB=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.portc<span style=3D"mso-tab-count:2">&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B </span>=3D CX23885_MPEG_DVB=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>}=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>}=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>const unsigned int cx23885_bcount =3D
ARRAY_SIZE(cx23885_boards)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -447=2C6 +452=
=2C10 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>.subvendor
=3D 0x107d=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>.subdevice
=3D 0x6f22=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>.card<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B </span>=3D CX23885_BOARD_LEADTEK_WINFAST_PXTV1200=2C<o:p><=
/o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>}=2C
{<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.subvendor
=3D 0x18ac=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.subdevice
=3D 0xdb98=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.card
<span style=3D"mso-spacerun:yes">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B</=
span>=3D
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>}=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>}=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>const unsigned int cx23885_idcount =3D
ARRAY_SIZE(cx23885_subids)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -653=2C6 +662=
=2C7 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>break=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>/*
Two identical tuners on two different i2c buses=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span><span style=3D"mso-spacerun:yes">&nbsp=3B</span>* we need to r=
eset the correct gpio. */<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>if
(port-&gt=3Bnr =3D=3D 1)<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -784=2C6 +794=
=2C7 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>mdelay(20)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>cx_set(GP0_IO=2C
0x000f000f)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>break=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>/*
GPIO-0 portb xc3028 reset */<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>/*
GPIO-1 portb zl10353 reset */<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -942=2C6 +953=
=2C7 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>dev-&gt=3Bsd_ir
=3D cx23885_find_hw(dev=2C CX23885_HW_888_IR)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>dev-&gt=3Bpci_irqmask
|=3D PCI_MSK_IR=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>break=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>request_module("ir-kbd-i2c")=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>break=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -1011=2C6 +10=
23=2C7 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>}<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>switch
(dev-&gt=3Bboard) {<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>ts2-&gt=3Bgen_ctrl_val<span style=3D"mso-spacerun:yes">&nbsp=
=3B </span>=3D 0xc=3B /* Serial bus + punctured clock */<o:p></o:p></span><=
/p>

<p class=3D"MsoNormal"><span class=3D"ecxapple-style-span"><span style=3D"f=
ont-size:8.0pt=3B
font-family:Arial=3Bcolor:#2A2A2A"><o:p>&nbsp=3B</o:p></span></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">--- cx23885-dvb.=
c<span style=3D"mso-tab-count:1">&nbsp=3B </span>2011-04-06 00:21:42.000000=
000 +1000<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+++ newcx23885-d=
vb.c<span style=3D"mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>2011-04-20 22:35:32.000000000 +1000<o:p>=
</o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -45=2C6 +45=
=2C7 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#include "tuner-simple.h"<o:p></o:p></span>=
</p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#include "dib7000p.h"<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#include "dibx000_common.h"<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+#include "dib00=
70.h"<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#include "zl10353.h"<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#include "stv0900.h"<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>#include "stv0900_reg.h"<o:p></o:p></span><=
/p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -77=2C6 +78=
=2C94 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>/*
------------------------------------------------------------------ */<o:p><=
/o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+static struct d=
ibx000_agc_config
dib7070_agc_config =3D {<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>BAND_UHF
| BAND_VHF | BAND_LBAND | BAND_SBAND=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>/*
P_agc_use_sd_mod1=3D0=2C P_agc_use_sd_mod2=3D0=2C P_agc_freq_pwm_div=3D5=2C=
 P_agc_inv_pwm1=3D0=2C
P_agc_inv_pwm2=3D0=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>
* P_agc_inh_dc_rv_est=3D0=2C P_agc_time_est=3D3=2C P_agc_freeze=3D0=2C P_ag=
c_nb_est=3D5=2C
P_agc_write=3D0 */<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>(0
&lt=3B&lt=3B 15) | (0 &lt=3B&lt=3B 14) | (5 &lt=3B&lt=3B 11) | (0 &lt=3B&lt=
=3B 10) | (0
&lt=3B&lt=3B 9) | (0 &lt=3B&lt=3B 8)<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>|
(3 &lt=3B&lt=3B 5) | (0 &lt=3B&lt=3B 4) | (5 &lt=3B&lt=3B 1) | (0 &lt=3B&lt=
=3B 0)=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>600=2C<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>10=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>118=2C<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>3530=2C<o:p></o:p></s=
pan></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>1=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>5=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>65535=2C<o:p></o:p></=
span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>65535=2C<o:p></o:p></=
span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>40=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>183=2C<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>206=2C<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>255=2C<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>72=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>152=2C<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>88=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>90=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>17=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>27=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>23=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>51=2C<o:p></o:p></spa=
n></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C<o:p></o:p></span=
></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+}=3B<o:p></o:p>=
</span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+static int
dib7070_tuner_reset(struct dvb_frontend *fe=2C int onoff)<o:p></o:p></span>=
</p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+{<o:p></o:p></s=
pan></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>return
dib7000p_set_gpio(fe=2C 8=2C 0=2C !onoff)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+}<o:p></o:p></s=
pan></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+static int
dib7070_tuner_sleep(struct dvb_frontend *fe=2C int onoff)<o:p></o:p></span>=
</p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+{<o:p></o:p></s=
pan></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>return
0=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+}<o:p></o:p></s=
pan></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+static struct d=
ib0070_config
dib7070p_dib0070_config =3D{<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span><o:p></o:p></span></p=
>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.i2c_address
=3D DEFAULT_DIB0070_I2C_ADDRESS=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.reset
=3D dib7070_tuner_reset=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.sleep
=3D dib7070_tuner_sleep=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>.clock_khz
=3D 12000=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span><o:p></o:p></span></p=
>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+}=3B<o:p></o:p>=
</span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+static struct
dibx000_bandwidth_config dib7070_bw_config_12_mhz =3D {<o:p></o:p></span></=
p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>60000=2C
15000=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>1=2C
20=2C 3=2C 1=2C 0=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>0=2C
0=2C 1=2C 1=2C 2=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>(3
&lt=3B&lt=3B 14) | (1 &lt=3B&lt=3B 12) | (524 &lt=3B&lt=3B 0)=2C<o:p></o:p>=
</span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>(0
&lt=3B&lt=3B 25) | 0=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>20452225=2C<o:p></o:p=
></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>12000000=2C<o:p></o:p=
></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+}=3B<o:p></o:p>=
</span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+static struct d=
ib7000p_config
dib7070p_dib7000p_config =3D {<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.output_mpeg2_in_188_=
bytes
=3D 1=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.agc_config_count
=3D 1=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.agc
=3D &amp=3Bdib7070_agc_config=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.bw<span style=3D"mso=
-spacerun:yes">&nbsp=3B </span>=3D &amp=3Bdib7070_bw_config_12_mhz=2C<o:p><=
/o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.tuner_is_baseband
=3D 1=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.spur_protect
=3D 1=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.gpio_dir
=3D 0xfcef=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.gpio_val
=3D 0x0110=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.gpio_pwm_pos
=3D DIB7000P_GPIO_DEFAULT_PWM_POS=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.hostbus_diversity
=3D 1=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>.output_mode
=3D OUTMODE_MPEG2_PAR_GATED_CLK=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+}=3B<o:p></o:p>=
</span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>static int dvb_buf_setup(struct videobuf_qu=
eue
*q=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:3">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span><span st=
yle=3D"mso-spacerun:yes">&nbsp=3B</span>unsigned int *count=2C unsigned int=
 *size)<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span>{<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">@@ -760=2C6 +849=
=2C17 @@<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:4">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>fe-&gt=3Bops.tuner_ops.set_con=
fig(fe=2C
&amp=3Bctl)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>}<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>break=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:1">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>i2c_bus
=3D &amp=3Bdev-&gt=3Bi2c_bus[port-&gt=3Bnr - 1]=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>fe0-&gt=3Bdvb.frontend
=3D dvb_attach(dib7000p_attach=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:3">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>&amp=3Bi2c_bus-&gt=3Bi2c_adap=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:3">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>0x12=2C
&amp=3Bdib7070p_dib7000p_config)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<o:p></o:p></sp=
an></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>if
(fe0-&gt=3Bdvb.frontend !=3D NULL)<span style=3D"mso-tab-count:1">&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B </span><o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:3">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>dvb_attach(dib0070_attach=2C
fe0-&gt=3Bdvb.frontend=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:3">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>&amp=3Bi2c_bus-&gt=3Bi2c_adap=2C<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:3">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B </span>&amp=3Bdib7070p_dib0070_config)=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">+<span style=3D"=
mso-tab-count:2">&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B </span>break=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:1">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B </span>case
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:<o:p></o:p></span></p>

<p class=3D"MsoNormal" style=3D"mso-layout-grid-align:none=3Btext-autospace=
:none"><span style=3D"font-size:8.0pt=3Bfont-family:Arial"><span style=3D"m=
so-spacerun:yes">&nbsp=3B</span><span style=3D"mso-tab-count:2">&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B </span>i2c_bus
=3D &amp=3Bdev-&gt=3Bi2c_bus[port-&gt=3Bnr - 1]=3B<o:p></o:p></span></p>

<p class=3D"MsoNormal"><span style=3D"font-size:8.0pt=3Bfont-family:Arial">=
<o:p>&nbsp=3B</o:p></span></p> 		 	   		  </body>
</html>=

--_8a1e789f-b682-4ced-a62e-3367a56d75a0_--


--===============0226272454==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0226272454==--
