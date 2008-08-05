Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 216.14.233.220.exetel.com.au ([220.233.14.216]
	helo=mail.carbonaro.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@carbonaro.org>) id 1KQL93-0001gA-MX
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 13:56:08 +0200
Date: Tue, 5 Aug 2008 21:34:32 +1000 (EST)
From: Mark Carbonaro <mark@carbonaro.org>
To: stev391@email.com
Message-ID: <4895080.81217937323843.JavaMail.mark@trogdor.carbonaro.org>
In-Reply-To: <1292178.61217937203262.JavaMail.mark@trogdor.carbonaro.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0662701667=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0662701667==
Content-Type: multipart/alternative;
	boundary="----=_Part_4_33079566.1217937323840"

------=_Part_4_33079566.1217937323840
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Fantastic, I will start testing it tonight and I will let you know how I get on. 

----- Original Message ----- 
From: stev391@email.com 
To: "Mark Carbonaro" <mark@carbonaro.org>, "Jonathan Hummel" <jhhummel@bigpond.com> 
Cc: linux-dvb@linuxtv.org 
Sent: Monday, 4 August, 2008 9:34:06 PM (GMT+1000) Auto-Detected 
Subject: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only support 


Mark, Jon, 

Inline (and attached) below is a patch against Steven Toths cx2388s-sram branch, that enables DVB support on the Leadtek Winfast PxDVR 3200 H. 

The code is not exactly elegant at the moment, I'm waiting for Steven to refactor his callback code before I tidy this up, but at least you can take the dust off the card and use part of it. 

Let me know what issues you run into. (For example occasional on boot up, the card gets a subvendor id of 0000 and subproduct of 0000, this I have no idea why, but a soft restart makes it work). 

If anyone knows where to start with the Analog support please let me know... 

Regards, 

Stephen. 

----------Patch----------- 

diff -Naur cx23885-sram/linux/Documentation/video4linux/CARDLIST.cx23885 cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx23885 
--- cx23885-sram/linux/Documentation/video4linux/CARDLIST.cx23885 2008-08-04 20:29:16.000000000 +1000 
+++ cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx23885 2008-08-04 20:50:15.000000000 +1000 
@@ -9,3 +9,4 @@ 
8 -> Hauppauge WinTV-HVR1700 & nbsp; [0070:8101] 
9 -> Hauppauge WinTV-HVR1400 [0070:8010] 
10 -> DViCO FusionHDTV7 Dual Express [18ac:d618] 
+ 11 -> Leadtek Winfast PxDVR3200 H [107d:6681] 
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885-cards.c cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c 
--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885-cards.c 2008-08-04 20:29:17.000000000 +1000 
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c 2008-08-04 21:14:55.000000000 +1000 
@@ -149,6 +149,11 @@ 
.portb = CX23885_MPEG_DVB, 
.portc = CX23885_MPEG_DVB, 
}, 
+ [CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = { 
+ .name = "Leadtek Winfast PxDVR3200 H", 
+// .portb = CX23885_MPEG_ENCODER, 
+ .portc = CX23885_MPEG_DVB, 
+ }, 
}; 
const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards); 

@@ -220,6 +225,10 @@ 
.subvendor = 0x18ac, 
.subdevice = 0xd618, 
.card = CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP, 
+ },{ 
+ .subvendor = 0x107d, 
+ .subdevice = 0x6681, 
+ .card = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H, 
}, 
}; 
const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids); 
@@ -466,6 +475,17 @@ 
mdelay(20); 
cx_set(GP0_IO, 0x000f000f); 
break; 
+ case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H: 
+ /* GPIO-2 xc3028 tuner reset */ 
+ /* Put the parts into reset and back */ 
+ cx_set(GP0_IO, 0x00040000); 
+ mdelay(20); 
+ cx_clear(GP0_IO, 0x00000004); 
+ mdelay(20); 
+ cx_set(GP0_IO, 0x00040004); 
+// mdelay(20); 
+// cx_write(GP0_IO, 0x00070404); 
+ break; 
} 
} 

@@ -549,6 +569,7 @@ 
case CX23885_BOARD_HAUPPAUGE_HVR1200: 
case CX23885_BOARD_HAUPPAUGE_HVR1700: 
case CX23885_BOARD_HAUPPAUGE_HVR1400: 
+ case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H: 
default: 
ts2->gen_ctrl_val = 0xc; /* Serial bus + punctured clock */ 
ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */ 
@@ -562,6 +583,7 @@ 
case CX23885_BOARD_HAUPPAUGE_HVR1800: 
case CX23885_BOARD_HAUPPAUGE_HVR1800lp: 
case CX23885_BOARD_HAUPPAUGE_HVR1700: 
+ case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H: 
request_module("cx25840"); 
break; 
} 
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885-dvb.c cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c 
--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885-dvb.c 2008-08-04 20:29:17.000000000 +1000 
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c 2008-08-04 20:48:07.000000000 +1000 
@@ -36,6 +36,7 @@ 
#include "tda8290.h" 
#include "tda18271.h" 
#include "lgdt330x.h" 
+#include "zl10353.h" 
#include "xc5000.h" 
#include "tda10048.h" 
#include "tuner-xc2028.h" 
@@ -155,6 +156,40 @@ 
.serial_mpeg = 0x40, 
}; 

+static int cx23885_leadtek_xc2028_callback(void *ptr, int command, int arg) 
+{ 
+ struct cx23885_tsport *port = ptr; 
+ struct cx23885_dev *dev = port->dev; 
+ u32 reset_mask = 0; 
+ 
+ switch (command) { 
+ case XC2028_TUNER_RESET: 
+ dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__, 
+ arg); 
+ reset_mask = 0x00070404; 
+ 
+ cx_clear(GP0_IO, reset_mask); 
+ mdelay(5); 
+ cx_set(GP0_IO, reset_mask); 
+ break; 
+ case XC2028_RESET_CLK: 
+ dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg); 
+ break; 
+ default: 
+ dprintk(1, "%s: unknown command %d, arg %d\n", __func__, 
+ command, arg); 
+ return -EINVAL; 
+ } 
+ 
+ return 0; 
+} 
+ 
+static struct zl10353_config dvico_fusionhdtv_xc3028 = { 
+ .demod_address = 0x0f, 
+ .if2 = 45600, 
+ .no_tuner = 1, 
+}; 
+ 
static struct s5h1409_config hauppauge_hvr1500q_config = { 
.demod_address = 0x32 >> 1, 
.output_mode = S5H1409_SERIAL_OUTPUT, 
@@ -481,6 +516,32 @@ 
&i2c_bus->i2c_adap, 
&dvico_xc5000_tunerconfig, i2c_bus); 
break; 
+ case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H: 
+ i2c_bus = &dev->i2c_bus[0]; 
+ 
+ port->dvb.frontend = dvb_attach(zl10353_attach, 
+ &dvico_fusionhdtv_xc3028, 
+ &i2c_bus->i2c_adap); 
+ if (port->dvb.frontend != NULL) { 
+ struct dvb_frontend *fe; 
+ struct xc2028_config cfg = { 
+ .i2c_adap = &dev->i2c_bus[1].i2c_adap, 
+ .i2c_addr = 0x61, 
+ .video_dev = port, 
+ .callback = cx23885_leadtek_xc2028_callback, 
+ }; 
+ static struct xc2028_ctrl ctl = { 
+ .fname = "xc3028-v27.fw", 
+ .max_len = 64, 
+ .demod = XC3028_FE_ZARLINK456, 
+ }; 
+ 
+ fe = dvb_attach(xc2028_attach, port->dvb.frontend, 
+ &cfg); 
+ if (fe != NULL && fe->ops.tuner_ops.set_config != NULL) 
+ fe->ops.tuner_ops.set_config(fe, &ctl); 
+ } 
+ break; 
default: 
printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n", 
dev->name); 
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885.h 
--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h 2008-08-04 20:29:17.000000000 +1000 
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885.h 2008-08-04 20:48:39.000000000 +1000 
@@ -67,6 +67,7 @@ 
#define CX23885_BOARD_HAUPPAUGE_HVR1700 8 
#define CX23885_BOARD_HAUPPAUGE_HVR1400 9 
#define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10 
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 11 

/* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */ 
#define CX23885_NORMS (\ 
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/Kconfig cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig 
--- cx23885-sram/linux/drivers/media/video/cx23885/Kconfig 2008-08-04 20:29:17.000000000 +1000 
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig 2008-08-04 20:49:05.000000000 +1000 
@@ -15,6 +15,7 @@ 
select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE 
select DVB_S5H1409 if !DVB_FE_CUSTOMISE 
select DVB_LGDT330X if !DVB_FE_CUSTOMISE 
+ select DVB_ZL10353 if !DVB_FE_CUSTOMISE 
select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE 
select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE 
select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE 

-- 
Be Yourself @ mail.com! 
Choose From 200+ Email Addresses 
Get a Free Account at www.mail.com ! 
------=_Part_4_33079566.1217937323840
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D'text/css'>p { margin: 0; }</style></head><body><=
div style=3D'font-family: Times New Roman; font-size: 12pt; color: #000000'=
>Fantastic, I will start testing it tonight and I will let you know how I g=
et on.<br><br>----- Original Message -----<br>From: stev391@email.com<br>To=
: "Mark Carbonaro" &lt;mark@carbonaro.org&gt;, "Jonathan Hummel" &lt;jhhumm=
el@bigpond.com&gt;<br>Cc: linux-dvb@linuxtv.org<br>Sent: Monday, 4 August, =
2008 9:34:06 PM (GMT+1000) Auto-Detected<br>Subject: [PATCH-TESTERS-REQUIRE=
D] Leadtek Winfast PxDVR 3200 H - DVB Only support<br><br>
<div>

Mark, Jon,<br><br>Inline (and attached) below is a patch against Steven Tot=
hs cx2388s-sram branch, that enables DVB support on the Leadtek Winfast PxD=
VR 3200 H.<br><br>The code is not exactly elegant at the moment, I'm waitin=
g for Steven to refactor his callback code before I tidy this up, but at le=
ast you can take the dust off the card and use part of it.<br><br>Let me kn=
ow what issues you run into. (For example occasional on boot up, the card g=
ets a subvendor id of 0000 and subproduct of 0000, this I have no idea why,=
 but a soft restart makes it work).<br><br>If anyone knows where to start w=
ith the Analog support please let me know...<br><br>Regards,<br><br>Stephen=
.<br><br>----------Patch-----------<br><br>diff -Naur cx23885-sram/linux/Do=
cumentation/video4linux/CARDLIST.cx23885 cx23885-sram_dev/linux/Documentati=
on/video4linux/CARDLIST.cx23885<br>--- cx23885-sram/linux/Documentation/vid=
eo4linux/CARDLIST.cx23885&nbsp;&nbsp;&nbsp; 2008-08-04 20:29:16.000000000 +=
1000<br>+++ cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx238=
85&nbsp;&nbsp;&nbsp; 2008-08-04 20:50:15.000000000 +1000<br>@@ -9,3 +9,4 @@=
<br>&nbsp;&nbsp; 8 -&gt; Hauppauge WinTV-HVR1700&nbsp;&nbsp;&nbsp;&amp;
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
[0070:8101]<br>&nbsp;&nbsp; 9 -&gt; Hauppauge WinTV-HVR1400&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; [0070:8010]<br>&nbsp; 10 -&gt; DViCO FusionHDTV7 Dual Express&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [18ac:d618]<br>+ 11 -&gt; Leadtek =
Winfast PxDVR3200 H&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp; [107d:6681]<br>diff -Naur cx23885-sram/linux/drivers/media/vi=
deo/cx23885/cx23885-cards.c cx23885-sram_dev/linux/drivers/media/video/cx23=
885/cx23885-cards.c<br>--- cx23885-sram/linux/drivers/media/video/cx23885/c=
x23885-cards.c&nbsp;&nbsp;&nbsp; 2008-08-04 20:29:17.000000000 +1000<br>+++=
 cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c&nbsp;&n=
bsp;&nbsp; 2008-08-04 21:14:55.000000000 +1000<br>@@ -149,6 +149,11 @@<br>&=
nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portb&nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; .portc&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>=
&nbsp;&nbsp;&nbsp;&nbsp; },<br>+&nbsp;&nbsp;&nbsp; [CX23885_BOARD_LEADTEK_W=
INFAST_PXDVR3200_H] =3D {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .name&n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D "Leadtek Winfast PxDVR3200 H",<br>+=
//&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portb&nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; =3D CX23885_MPEG_ENCODER,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; .portc&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>+&nb=
sp;&nbsp;&nbsp; },<br>&nbsp;};<br>&nbsp;const unsigned int cx23885_bcount =
=3D ARRAY_SIZE(cx23885_boards);<br>&nbsp;<br>@@ -220,6 +225,10 @@<br>&nbsp;=
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subvendor =3D 0x18ac,<br>&nbsp;&nbsp=
;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subdevice =3D 0xd618,<br>&nbsp;&nbsp;&nbs=
p;&nbsp; &nbsp;&nbsp;&nbsp; .card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D CX23885=
_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,<br>+&nbsp;&nbsp;&nbsp; },{<br>+&nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; .subvendor =3D 0x107d,<br>+&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; .subdevice =3D 0x6681,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; .card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D CX23885_BOARD_LEADTEK_WIN=
FAST_PXDVR3200_H,<br>&nbsp;&nbsp;&nbsp;&nbsp; },<br>&nbsp;};<br>&nbsp;const=
 unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);<br>@@ -466,6 =
+475,17 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(20);<br>&n=
bsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x000f000f);<br>&n=
bsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; cas=
e CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp; /* GPIO-2&nbsp; xc3028 tuner reset */<br>+&nbsp;&nbsp;&nbsp; &n=
bsp;&nbsp;&nbsp; /* Put the parts into reset and back */<br>+&nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x00040000);<br>+&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; mdelay(20);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx=
_clear(GP0_IO, 0x00000004);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdela=
y(20);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x00040004)=
;<br>+//&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(20);<br>+//&nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; cx_write(GP0_IO, 0x00070404);<br>+&nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; break;<br>&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;}<br>=
&nbsp;<br>@@ -549,6 +569,7 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BOAR=
D_HAUPPAUGE_HVR1200:<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BOARD_HAUPPAU=
GE_HVR1700:<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BOARD_HAUPPAUGE_HVR140=
0:<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<b=
r>&nbsp;&nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp=
;&nbsp; ts2-&gt;gen_ctrl_val&nbsp; =3D 0xc; /* Serial bus + punctured clock=
 */<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ts2-&gt;ts_clk_en_val =
=3D 0x1; /* Enable TS_CLK */<br>@@ -562,6 +583,7 @@<br>&nbsp;&nbsp;&nbsp;&n=
bsp; case CX23885_BOARD_HAUPPAUGE_HVR1800:<br>&nbsp;&nbsp;&nbsp;&nbsp; case=
 CX23885_BOARD_HAUPPAUGE_HVR1800lp:<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX2388=
5_BOARD_HAUPPAUGE_HVR1700:<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LEADTE=
K_WINFAST_PXDVR3200_H:<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; reque=
st_module("cx25840");<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;=
<br>&nbsp;&nbsp;&nbsp;&nbsp; }<br>diff -Naur cx23885-sram/linux/drivers/med=
ia/video/cx23885/cx23885-dvb.c cx23885-sram_dev/linux/drivers/media/video/c=
x23885/cx23885-dvb.c<br>--- cx23885-sram/linux/drivers/media/video/cx23885/=
cx23885-dvb.c&nbsp;&nbsp;&nbsp; 2008-08-04 20:29:17.000000000 +1000<br>+++ =
cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c&nbsp;&nbsp=
;&nbsp; 2008-08-04 20:48:07.000000000 +1000<br>@@ -36,6 +36,7 @@<br>&nbsp;#=
include "tda8290.h"<br>&nbsp;#include "tda18271.h"<br>&nbsp;#include "lgdt3=
30x.h"<br>+#include "zl10353.h"<br>&nbsp;#include "xc5000.h"<br>&nbsp;#incl=
ude "tda10048.h"<br>&nbsp;#include "tuner-xc2028.h"<br>@@ -155,6 +156,40 @@=
<br>&nbsp;&nbsp;&nbsp;&nbsp; .serial_mpeg =3D 0x40,<br>&nbsp;};<br>&nbsp;<b=
r>+static int cx23885_leadtek_xc2028_callback(void *ptr, int command, int a=
rg)<br>+{<br>+&nbsp;&nbsp;&nbsp; struct cx23885_tsport *port =3D ptr;<br>+&=
nbsp;&nbsp;&nbsp; struct cx23885_dev *dev =3D port-&gt;dev;<br>+&nbsp;&nbsp=
;&nbsp; u32 reset_mask =3D 0;<br>+<br>+&nbsp;&nbsp;&nbsp; switch (command) =
{<br>+&nbsp;&nbsp;&nbsp; case XC2028_TUNER_RESET:<br>+&nbsp;&nbsp;&nbsp; &n=
bsp;&nbsp;&nbsp; dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__,<br>+&n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; arg);<br>+&nbsp;&nbs=
p;&nbsp; &nbsp;&nbsp;&nbsp; reset_mask =3D 0x00070404;<br>+<br>+&nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; cx_clear(GP0_IO, reset_mask);<br>+&nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; mdelay(5);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; cx_set(GP0_IO, reset_mask);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; bre=
ak;<br>+&nbsp;&nbsp;&nbsp; case XC2028_RESET_CLK:<br>+&nbsp;&nbsp;&nbsp; &n=
bsp;&nbsp;&nbsp; dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);<br=
>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; defau=
lt:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dprintk(1, "%s: unknown comma=
nd %d, arg %d\n", __func__,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; command, arg);<br>+&nbsp;&nbsp;&nbsp; &nbsp=
;&nbsp;&nbsp; return -EINVAL;<br>+&nbsp;&nbsp;&nbsp; }<br>+<br>+&nbsp;&nbsp=
;&nbsp; return 0;<br>+}<br>+<br>+static struct zl10353_config dvico_fusionh=
dtv_xc3028 =3D {<br>+&nbsp;&nbsp;&nbsp; .demod_address =3D 0x0f,<br>+&nbsp;=
&nbsp;&nbsp; .if2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; =3D 45600,<br>+&nbsp;&nbsp;&nbsp; .no_tuner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; =3D 1,<br>+};<br>+<br>&nbsp;static struct s5h1409_config hauppauge_hvr150=
0q_config =3D {<br>&nbsp;&nbsp;&nbsp;&nbsp; .demod_address =3D 0x32 &gt;&gt=
; 1,<br>&nbsp;&nbsp;&nbsp;&nbsp; .output_mode&nbsp;&nbsp; =3D S5H1409_SERIA=
L_OUTPUT,<br>@@ -481,6 +516,32 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &amp;i2c_bus-&gt;i2c_adap,<br>&=
nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &amp;dvico_xc5000_tunerconfig, i2c_bus);<br>&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LEADTEK=
_WINFAST_PXDVR3200_H:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; i2c_bus =3D=
 &amp;dev-&gt;i2c_bus[0];<br>+<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; po=
rt-&gt;dvb.frontend =3D dvb_attach(zl10353_attach,<br>+&nbsp;&nbsp;&nbsp; &=
nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;dvico_fusionhdtv_xc3028,<br>+&nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;i2c_bus-&gt;i2c_a=
dap);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (port-&gt;dvb.frontend !=
=3D NULL) {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; st=
ruct dvb_frontend&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *fe;<br>+&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; struct xc2028_config&nbsp;&nbsp;&nbs=
p; &nbsp; cfg =3D {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; .i2c_adap&nbsp; =3D &amp;dev-&gt;i2c_bus[1].i2c_ad=
ap,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; .i2c_addr&nbsp; =3D 0x61,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .video_dev =3D port,<br>+&nbsp;&nbs=
p;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .callback=
&nbsp; =3D cx23885_leadtek_xc2028_callback,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; static struct xc2028_ctrl ctl =3D {<br>+&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .fname&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; =3D "xc3028-v27.fw",<br>+&nbsp;&nbsp;&nbsp; &nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .max_len&nbsp;&nbsp;&=
nbsp;&nbsp; =3D 64,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; .demod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D XC3=
028_FE_ZARLINK456,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; };<br>+<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; f=
e =3D dvb_attach(xc2028_attach, port-&gt;dvb.frontend,<br>+&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nb=
sp; &amp;cfg);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 if (fe !=3D NULL &amp;&amp; fe-&gt;ops.tuner_ops.set_config !=3D NULL)<br>=
+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>+&nbsp;&nbsp;&nbsp; &nb=
sp;&nbsp;&nbsp; }<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>&nbsp=
;&nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",<br>=
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; dev-&gt;name);<br>diff -Naur cx23885-sram/linux/drivers/media/video/c=
x23885/cx23885.h cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885=
.h<br>--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h&nbsp;&nb=
sp;&nbsp; 2008-08-04 20:29:17.000000000 +1000<br>+++ cx23885-sram_dev/linux=
/drivers/media/video/cx23885/cx23885.h&nbsp;&nbsp;&nbsp; 2008-08-04 20:48:3=
9.000000000 +1000<br>@@ -67,6 +67,7 @@<br>&nbsp;#define CX23885_BOARD_HAUPP=
AUGE_HVR1700&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8<br>&nbsp;#define C=
X23885_BOARD_HAUPPAUGE_HVR1400&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<=
br>&nbsp;#define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10<br>+#define C=
X23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 11<br>&nbsp;<br>&nbsp;/* Currently=
 unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */<br>&nbsp;#def=
ine CX23885_NORMS (\<br>diff -Naur cx23885-sram/linux/drivers/media/video/c=
x23885/Kconfig cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig<b=
r>--- cx23885-sram/linux/drivers/media/video/cx23885/Kconfig&nbsp;&nbsp;&nb=
sp; 2008-08-04 20:29:17.000000000 +1000<br>+++ cx23885-sram_dev/linux/drive=
rs/media/video/cx23885/Kconfig&nbsp;&nbsp;&nbsp; 2008-08-04 20:49:05.000000=
000 +1000<br>@@ -15,6 +15,7 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUN=
ER_MT2131 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select DVB_S5H14=
09 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select DVB_LGDT330X if =
!DVB_FE_CUSTOMISE<br>+ &nbsp;&nbsp;&nbsp; select DVB_ZL10353 if !DVB_FE_CUS=
TOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_XC2028 if !DVB_FE_CUS=
TOMIZE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_TDA8290 if !DVB_FE_CU=
STOMIZE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_TDA18271 if !DVB_FE_=
CUSTOMIZE<br>

</div>
<br>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>
</div></body></html>
------=_Part_4_33079566.1217937323840--


--===============0662701667==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0662701667==--
