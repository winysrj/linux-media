Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KPyL5-0000VJ-G7
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 13:35:02 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	851DB1803316
	for <linux-dvb@linuxtv.org>; Mon,  4 Aug 2008 11:34:06 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_121784964640493"
MIME-Version: 1.0
From: stev391@email.com
To: "Mark Carbonaro" <mark@carbonaro.org>,
	"Jonathan Hummel" <jhhummel@bigpond.com>
Date: Mon, 4 Aug 2008 21:34:06 +1000
Message-Id: <20080804113406.44F511BF28D@ws1-1.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H -
 DVB Only support
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

--_----------=_121784964640493
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121784964640492"

This is a multi-part message in MIME format.

--_----------=_121784964640492
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Mark, Jon,

Inline (and attached) below is a patch against Steven Toths cx2388s-sram
branch, that enables DVB support on the Leadtek Winfast PxDVR 3200 H.

The code is not exactly elegant at the moment, I'm waiting for Steven to
refactor his callback code before I tidy this up, but at least you can
take the dust off the card and use part of it.

Let me know what issues you run into. (For example occasional on boot up,
the card gets a subvendor id of 0000 and subproduct of 0000, this I have
no idea why, but a soft restart makes it work).

If anyone knows where to start with the Analog support please let me
know...

Regards,

Stephen.

----------Patch-----------

diff -Naur cx23885-sram/linux/Documentation/video4linux/CARDLIST.cx23885
cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx23885
--- cx23885-sram/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-08-04 20:29:16.000000000 +1000
+++ cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=
=20
2008-08-04 20:50:15.000000000 +1000
@@ -9,3 +9,4 @@
8 -> Hauppauge WinTV-HVR1700   & nbsp;=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
[0070:8101]
9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
+ 11 -> Leadtek Winfast PxDVR3200 H    [107d:6681]
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885-cards.c
cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-08-04 20:29:17.000000000 +1000
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c=20=
=20=20
2008-08-04 21:14:55.000000000 +1000
@@ -149,6 +149,11 @@
.portb    =3D CX23885_MPEG_DVB,
.portc    =3D CX23885_MPEG_DVB,
},
+    [CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] =3D {
+    .name    =3D "Leadtek Winfast PxDVR3200 H",
+//    .portb    =3D CX23885_MPEG_ENCODER,
+    .portc    =3D CX23885_MPEG_DVB,
+    },
 };
 const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);

@@ -220,6 +225,10 @@
.subvendor =3D 0x18ac,
.subdevice =3D 0xd618,
.card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
+    },{
+    .subvendor =3D 0x107d,
+    .subdevice =3D 0x6681,
+    .card      =3D CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
},
 };
 const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);
@@ -466,6 +475,17 @@
mdelay(20);
cx_set(GP0_IO, 0x000f000f);
break;
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+    /* GPIO-2  xc3028 tuner reset */
+    /* Put the parts into reset and back */
+    cx_set(GP0_IO, 0x00040000);
+    mdelay(20);
+    cx_clear(GP0_IO, 0x00000004);
+    mdelay(20);
+    cx_set(GP0_IO, 0x00040004);
+//    mdelay(20);
+//    cx_write(GP0_IO, 0x00070404);
+    break;
}
 }

@@ -549,6 +569,7 @@
case CX23885_BOARD_HAUPPAUGE_HVR1200:
case CX23885_BOARD_HAUPPAUGE_HVR1700:
case CX23885_BOARD_HAUPPAUGE_HVR1400:
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
default:
ts2->gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */
ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
@@ -562,6 +583,7 @@
case CX23885_BOARD_HAUPPAUGE_HVR1800:
case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
case CX23885_BOARD_HAUPPAUGE_HVR1700:
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
request_module("cx25840");
break;
}
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885-dvb.c
cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885-dvb.c=20=20=20
2008-08-04 20:29:17.000000000 +1000
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c=20=20=
=20
2008-08-04 20:48:07.000000000 +1000
@@ -36,6 +36,7 @@
 #include "tda8290.h"
 #include "tda18271.h"
 #include "lgdt330x.h"
+#include "zl10353.h"
 #include "xc5000.h"
 #include "tda10048.h"
 #include "tuner-xc2028.h"
@@ -155,6 +156,40 @@
.serial_mpeg =3D 0x40,
 };

+static int cx23885_leadtek_xc2028_callback(void *ptr, int command, int
arg)
+{
+    struct cx23885_tsport *port =3D ptr;
+    struct cx23885_dev *dev =3D port->dev;
+    u32 reset_mask =3D 0;
+
+    switch (command) {
+    case XC2028_TUNER_RESET:
+    dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__,
+    arg);
+    reset_mask =3D 0x00070404;
+
+    cx_clear(GP0_IO, reset_mask);
+    mdelay(5);
+    cx_set(GP0_IO, reset_mask);
+    break;
+    case XC2028_RESET_CLK:
+    dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
+    break;
+    default:
+    dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
+    command, arg);
+    return -EINVAL;
+    }
+
+    return 0;
+}
+
+static struct zl10353_config dvico_fusionhdtv_xc3028 =3D {
+    .demod_address =3D 0x0f,
+    .if2           =3D 45600,
+    .no_tuner      =3D 1,
+};
+
 static struct s5h1409_config hauppauge_hvr1500q_config =3D {
.demod_address =3D 0x32 >> 1,
.output_mode   =3D S5H1409_SERIAL_OUTPUT,
@@ -481,6 +516,32 @@
&i2c_bus->i2c_adap,
&dvico_xc5000_tunerconfig, i2c_bus);
break;
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+    i2c_bus =3D &dev->i2c_bus[0];
+
+    port->dvb.frontend =3D dvb_attach(zl10353_attach,
+    &dvico_fusionhdtv_xc3028,
+    &i2c_bus->i2c_adap);
+    if (port->dvb.frontend !=3D NULL) {
+    struct dvb_frontend      *fe;
+    struct xc2028_config    cfg =3D {
+    .i2c_adap  =3D &dev->i2c_bus[1].i2c_adap,
+    .i2c_addr  =3D 0x61,
+    .video_dev =3D port,
+    .callback  =3D cx23885_leadtek_xc2028_callback,
+    };
+    static struct xc2028_ctrl ctl =3D {
+    .fname       =3D "xc3028-v27.fw",
+    .max_len     =3D 64,
+    .demod       =3D XC3028_FE_ZARLINK456,
+    };
+
+    fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,
+    &cfg);
+    if (fe !=3D NULL && fe->ops.tuner_ops.set_config !=3D NULL)
+    fe->ops.tuner_ops.set_config(fe, &ctl);
+    }
+    break;
default:
printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
dev->name);
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h
cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885.h
--- cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h=20=20=20
2008-08-04 20:29:17.000000000 +1000
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885.h=20=20=20
2008-08-04 20:48:39.000000000 +1000
@@ -67,6 +67,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 11

 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC
*/
 #define CX23885_NORMS (\
diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/Kconfig
cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig
--- cx23885-sram/linux/drivers/media/video/cx23885/Kconfig    2008-08-04
20:29:17.000000000 +1000
+++ cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig=20=20=20
2008-08-04 20:49:05.000000000 +1000
@@ -15,6 +15,7 @@
select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
select DVB_S5H1409 if !DVB_FE_CUSTOMISE
select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+ select DVB_ZL10353 if !DVB_FE_CUSTOMISE
select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121784964640492
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


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
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121784964640492--


--_----------=_121784964640493
Content-Disposition: attachment; filename="Leadtek.Winfast.PxDVR.3200.H.diff"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="Leadtek.Winfast.PxDVR.3200.H.diff"

ZGlmZiAtTmF1ciBjeDIzODg1LXNyYW0vbGludXgvRG9jdW1lbnRhdGlvbi92
aWRlbzRsaW51eC9DQVJETElTVC5jeDIzODg1IGN4MjM4ODUtc3JhbV9kZXYv
bGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5jeDIz
ODg1Ci0tLSBjeDIzODg1LXNyYW0vbGludXgvRG9jdW1lbnRhdGlvbi92aWRl
bzRsaW51eC9DQVJETElTVC5jeDIzODg1CTIwMDgtMDgtMDQgMjA6Mjk6MTYu
MDAwMDAwMDAwICsxMDAwCisrKyBjeDIzODg1LXNyYW1fZGV2L2xpbnV4L0Rv
Y3VtZW50YXRpb24vdmlkZW80bGludXgvQ0FSRExJU1QuY3gyMzg4NQkyMDA4
LTA4LTA0IDIwOjUwOjE1LjAwMDAwMDAwMCArMTAwMApAQCAtOSwzICs5LDQg
QEAKICAgOCAtPiBIYXVwcGF1Z2UgV2luVFYtSFZSMTcwMCAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgWzAwNzA6ODEwMV0KICAgOSAtPiBIYXVwcGF1
Z2UgV2luVFYtSFZSMTQwMCAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
WzAwNzA6ODAxMF0KICAxMCAtPiBEVmlDTyBGdXNpb25IRFRWNyBEdWFsIEV4
cHJlc3MgICAgICAgICAgICAgICAgICAgICAgWzE4YWM6ZDYxOF0KKyAxMSAt
PiBMZWFkdGVrIFdpbmZhc3QgUHhEVlIzMjAwIEgJCQkgICBbMTA3ZDo2Njgx
XQpkaWZmIC1OYXVyIGN4MjM4ODUtc3JhbS9saW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1jYXJkcy5jIGN4MjM4ODUtc3JhbV9k
ZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUt
Y2FyZHMuYwotLS0gY3gyMzg4NS1zcmFtL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRzLmMJMjAwOC0wOC0wNCAyMDoy
OToxNy4wMDAwMDAwMDAgKzEwMDAKKysrIGN4MjM4ODUtc3JhbV9kZXYvbGlu
dXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2FyZHMu
YwkyMDA4LTA4LTA0IDIxOjE0OjU1LjAwMDAwMDAwMCArMTAwMApAQCAtMTQ5
LDYgKzE0OSwxMSBAQAogCQkucG9ydGIJCT0gQ1gyMzg4NV9NUEVHX0RWQiwK
IAkJLnBvcnRjCQk9IENYMjM4ODVfTVBFR19EVkIsCiAJfSwKKwlbQ1gyMzg4
NV9CT0FSRF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAwX0hdID0geworCQku
bmFtZQkJPSAiTGVhZHRlayBXaW5mYXN0IFB4RFZSMzIwMCBIIiwKKy8vCQku
cG9ydGIJCT0gQ1gyMzg4NV9NUEVHX0VOQ09ERVIsCisJCS5wb3J0YwkJPSBD
WDIzODg1X01QRUdfRFZCLAorCX0sCiB9OwogY29uc3QgdW5zaWduZWQgaW50
IGN4MjM4ODVfYmNvdW50ID0gQVJSQVlfU0laRShjeDIzODg1X2JvYXJkcyk7
CiAKQEAgLTIyMCw2ICsyMjUsMTAgQEAKIAkJLnN1YnZlbmRvciA9IDB4MThh
YywKIAkJLnN1YmRldmljZSA9IDB4ZDYxOCwKIAkJLmNhcmQgICAgICA9IENY
MjM4ODVfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl83X0RVQUxfRVhQLAorCX0s
eworCQkuc3VidmVuZG9yID0gMHgxMDdkLAorCQkuc3ViZGV2aWNlID0gMHg2
NjgxLAorCQkuY2FyZCAgICAgID0gQ1gyMzg4NV9CT0FSRF9MRUFEVEVLX1dJ
TkZBU1RfUFhEVlIzMjAwX0gsCiAJfSwKIH07CiBjb25zdCB1bnNpZ25lZCBp
bnQgY3gyMzg4NV9pZGNvdW50ID0gQVJSQVlfU0laRShjeDIzODg1X3N1Ymlk
cyk7CkBAIC00NjYsNiArNDc1LDE3IEBACiAJCW1kZWxheSgyMCk7CiAJCWN4
X3NldChHUDBfSU8sIDB4MDAwZjAwMGYpOwogCQlicmVhazsKKwljYXNlIENY
MjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IOgorCQkv
KiBHUElPLTIgIHhjMzAyOCB0dW5lciByZXNldCAqLworCQkvKiBQdXQgdGhl
IHBhcnRzIGludG8gcmVzZXQgYW5kIGJhY2sgKi8KKwkJY3hfc2V0KEdQMF9J
TywgMHgwMDA0MDAwMCk7CisJCW1kZWxheSgyMCk7CisJCWN4X2NsZWFyKEdQ
MF9JTywgMHgwMDAwMDAwNCk7CisJCW1kZWxheSgyMCk7CisJCWN4X3NldChH
UDBfSU8sIDB4MDAwNDAwMDQpOworLy8JCW1kZWxheSgyMCk7CisvLwkJY3hf
d3JpdGUoR1AwX0lPLCAweDAwMDcwNDA0KTsKKwkJYnJlYWs7CiAJfQogfQog
CkBAIC01NDksNiArNTY5LDcgQEAKIAljYXNlIENYMjM4ODVfQk9BUkRfSEFV
UFBBVUdFX0hWUjEyMDA6CiAJY2FzZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVH
RV9IVlIxNzAwOgogCWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQUEFVR0VfSFZS
MTQwMDoKKwljYXNlIENYMjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BY
RFZSMzIwMF9IOgogCWRlZmF1bHQ6CiAJCXRzMi0+Z2VuX2N0cmxfdmFsICA9
IDB4YzsgLyogU2VyaWFsIGJ1cyArIHB1bmN0dXJlZCBjbG9jayAqLwogCQl0
czItPnRzX2Nsa19lbl92YWwgPSAweDE7IC8qIEVuYWJsZSBUU19DTEsgKi8K
QEAgLTU2Miw2ICs1ODMsNyBAQAogCWNhc2UgQ1gyMzg4NV9CT0FSRF9IQVVQ
UEFVR0VfSFZSMTgwMDoKIAljYXNlIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdF
X0hWUjE4MDBscDoKIAljYXNlIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hW
UjE3MDA6CisJY2FzZSBDWDIzODg1X0JPQVJEX0xFQURURUtfV0lORkFTVF9Q
WERWUjMyMDBfSDoKIAkJcmVxdWVzdF9tb2R1bGUoImN4MjU4NDAiKTsKIAkJ
YnJlYWs7CiAJfQpkaWZmIC1OYXVyIGN4MjM4ODUtc3JhbS9saW51eC9kcml2
ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYyBjeDIzODg1
LXNyYW1fZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9j
eDIzODg1LWR2Yi5jCi0tLSBjeDIzODg1LXNyYW0vbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMJMjAwOC0wOC0wNCAy
MDoyOToxNy4wMDAwMDAwMDAgKzEwMDAKKysrIGN4MjM4ODUtc3JhbV9kZXYv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZi
LmMJMjAwOC0wOC0wNCAyMDo0ODowNy4wMDAwMDAwMDAgKzEwMDAKQEAgLTM2
LDYgKzM2LDcgQEAKICNpbmNsdWRlICJ0ZGE4MjkwLmgiCiAjaW5jbHVkZSAi
dGRhMTgyNzEuaCIKICNpbmNsdWRlICJsZ2R0MzMweC5oIgorI2luY2x1ZGUg
InpsMTAzNTMuaCIKICNpbmNsdWRlICJ4YzUwMDAuaCIKICNpbmNsdWRlICJ0
ZGExMDA0OC5oIgogI2luY2x1ZGUgInR1bmVyLXhjMjAyOC5oIgpAQCAtMTU1
LDYgKzE1Niw0MCBAQAogCS5zZXJpYWxfbXBlZyA9IDB4NDAsCiB9OwogCitz
dGF0aWMgaW50IGN4MjM4ODVfbGVhZHRla194YzIwMjhfY2FsbGJhY2sodm9p
ZCAqcHRyLCBpbnQgY29tbWFuZCwgaW50IGFyZykKK3sKKwlzdHJ1Y3QgY3gy
Mzg4NV90c3BvcnQgKnBvcnQgPSBwdHI7CisJc3RydWN0IGN4MjM4ODVfZGV2
ICpkZXYgPSBwb3J0LT5kZXY7CisJdTMyIHJlc2V0X21hc2sgPSAwOworCisJ
c3dpdGNoIChjb21tYW5kKSB7CisJY2FzZSBYQzIwMjhfVFVORVJfUkVTRVQ6
CisJCWRwcmludGsoMSwgIiVzOiBYQzIwMjhfVFVORVJfUkVTRVQgJWRcbiIs
IF9fZnVuY19fLAorCQkJYXJnKTsKKwkJcmVzZXRfbWFzayA9IDB4MDAwNzA0
MDQ7CisKKwkJY3hfY2xlYXIoR1AwX0lPLCByZXNldF9tYXNrKTsKKwkJbWRl
bGF5KDUpOworCQljeF9zZXQoR1AwX0lPLCByZXNldF9tYXNrKTsKKwkJYnJl
YWs7CisJY2FzZSBYQzIwMjhfUkVTRVRfQ0xLOgorCQlkcHJpbnRrKDEsICIl
czogWEMyMDI4X1JFU0VUX0NMSyAlZFxuIiwgX19mdW5jX18sIGFyZyk7CisJ
CWJyZWFrOworCWRlZmF1bHQ6CisJCWRwcmludGsoMSwgIiVzOiB1bmtub3du
IGNvbW1hbmQgJWQsIGFyZyAlZFxuIiwgX19mdW5jX18sCisJCSAgICAgICBj
b21tYW5kLCBhcmcpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisKKwlyZXR1
cm4gMDsKK30KKworc3RhdGljIHN0cnVjdCB6bDEwMzUzX2NvbmZpZyBkdmlj
b19mdXNpb25oZHR2X3hjMzAyOCA9IHsKKwkuZGVtb2RfYWRkcmVzcyA9IDB4
MGYsCisJLmlmMiAgICAgICAgICAgPSA0NTYwMCwKKwkubm9fdHVuZXIgICAg
ICA9IDEsCit9OworCiBzdGF0aWMgc3RydWN0IHM1aDE0MDlfY29uZmlnIGhh
dXBwYXVnZV9odnIxNTAwcV9jb25maWcgPSB7CiAJLmRlbW9kX2FkZHJlc3Mg
PSAweDMyID4+IDEsCiAJLm91dHB1dF9tb2RlICAgPSBTNUgxNDA5X1NFUklB
TF9PVVRQVVQsCkBAIC00ODEsNiArNTE2LDMyIEBACiAJCQkJJmkyY19idXMt
PmkyY19hZGFwLAogCQkJCSZkdmljb194YzUwMDBfdHVuZXJjb25maWcsIGky
Y19idXMpOwogCQlicmVhazsKKwljYXNlIENYMjM4ODVfQk9BUkRfTEVBRFRF
S19XSU5GQVNUX1BYRFZSMzIwMF9IOgorCQlpMmNfYnVzID0gJmRldi0+aTJj
X2J1c1swXTsKKworCQlwb3J0LT5kdmIuZnJvbnRlbmQgPSBkdmJfYXR0YWNo
KHpsMTAzNTNfYXR0YWNoLAorCQkJCQkgICAgICAgJmR2aWNvX2Z1c2lvbmhk
dHZfeGMzMDI4LAorCQkJCQkgICAgICAgJmkyY19idXMtPmkyY19hZGFwKTsK
KwkJaWYgKHBvcnQtPmR2Yi5mcm9udGVuZCAhPSBOVUxMKSB7CisJCQlzdHJ1
Y3QgZHZiX2Zyb250ZW5kICAgICAgKmZlOworCQkJc3RydWN0IHhjMjAyOF9j
b25maWcJICBjZmcgPSB7CisJCQkJLmkyY19hZGFwICA9ICZkZXYtPmkyY19i
dXNbMV0uaTJjX2FkYXAsCisJCQkJLmkyY19hZGRyICA9IDB4NjEsCisJCQkJ
LnZpZGVvX2RldiA9IHBvcnQsCisJCQkJLmNhbGxiYWNrICA9IGN4MjM4ODVf
bGVhZHRla194YzIwMjhfY2FsbGJhY2ssCisJCQl9OworCQkJc3RhdGljIHN0
cnVjdCB4YzIwMjhfY3RybCBjdGwgPSB7CisJCQkJLmZuYW1lICAgICAgID0g
InhjMzAyOC12MjcuZnciLAorCQkJCS5tYXhfbGVuICAgICA9IDY0LAorCQkJ
CS5kZW1vZCAgICAgICA9IFhDMzAyOF9GRV9aQVJMSU5LNDU2LAorCQkJfTsK
KworCQkJZmUgPSBkdmJfYXR0YWNoKHhjMjAyOF9hdHRhY2gsIHBvcnQtPmR2
Yi5mcm9udGVuZCwKKwkJCQkJJmNmZyk7CisJCQlpZiAoZmUgIT0gTlVMTCAm
JiBmZS0+b3BzLnR1bmVyX29wcy5zZXRfY29uZmlnICE9IE5VTEwpCisJCQkJ
ZmUtPm9wcy50dW5lcl9vcHMuc2V0X2NvbmZpZyhmZSwgJmN0bCk7CisJCX0K
KwkJYnJlYWs7CiAJZGVmYXVsdDoKIAkJcHJpbnRrKCIlczogVGhlIGZyb250
ZW5kIG9mIHlvdXIgRFZCL0FUU0MgY2FyZCBpc24ndCBzdXBwb3J0ZWQgeWV0
XG4iLAogCQkgICAgICAgZGV2LT5uYW1lKTsKZGlmZiAtTmF1ciBjeDIzODg1
LXNyYW0vbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4
ODUuaCBjeDIzODg1LXNyYW1fZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlk
ZW8vY3gyMzg4NS9jeDIzODg1LmgKLS0tIGN4MjM4ODUtc3JhbS9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5oCTIwMDgtMDgt
MDQgMjA6Mjk6MTcuMDAwMDAwMDAwICsxMDAwCisrKyBjeDIzODg1LXNyYW1f
ZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1
LmgJMjAwOC0wOC0wNCAyMDo0ODozOS4wMDAwMDAwMDAgKzEwMDAKQEAgLTY3
LDYgKzY3LDcgQEAKICNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9IQVVQUEFVR0Vf
SFZSMTcwMCAgICAgICAgOAogI2RlZmluZSBDWDIzODg1X0JPQVJEX0hBVVBQ
QVVHRV9IVlIxNDAwICAgICAgICA5CiAjZGVmaW5lIENYMjM4ODVfQk9BUkRf
RFZJQ09fRlVTSU9OSERUVl83X0RVQUxfRVhQIDEwCisjZGVmaW5lIENYMjM4
ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYRFZSMzIwMF9IIDExCiAKIC8q
IEN1cnJlbnRseSB1bnN1cHBvcnRlZCBieSB0aGUgZHJpdmVyOiBQQUwvSCwg
TlRTQy9LciwgU0VDQU0gQi9HL0gvTEMgKi8KICNkZWZpbmUgQ1gyMzg4NV9O
T1JNUyAoXApkaWZmIC1OYXVyIGN4MjM4ODUtc3JhbS9saW51eC9kcml2ZXJz
L21lZGlhL3ZpZGVvL2N4MjM4ODUvS2NvbmZpZyBjeDIzODg1LXNyYW1fZGV2
L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9LY29uZmlnCi0t
LSBjeDIzODg1LXNyYW0vbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIz
ODg1L0tjb25maWcJMjAwOC0wOC0wNCAyMDoyOToxNy4wMDAwMDAwMDAgKzEw
MDAKKysrIGN4MjM4ODUtc3JhbV9kZXYvbGludXgvZHJpdmVycy9tZWRpYS92
aWRlby9jeDIzODg1L0tjb25maWcJMjAwOC0wOC0wNCAyMDo0OTowNS4wMDAw
MDAwMDAgKzEwMDAKQEAgLTE1LDYgKzE1LDcgQEAKIAlzZWxlY3QgTUVESUFf
VFVORVJfTVQyMTMxIGlmICFEVkJfRkVfQ1VTVE9NSVNFCiAJc2VsZWN0IERW
Ql9TNUgxNDA5IGlmICFEVkJfRkVfQ1VTVE9NSVNFCiAJc2VsZWN0IERWQl9M
R0RUMzMwWCBpZiAhRFZCX0ZFX0NVU1RPTUlTRQorIAlzZWxlY3QgRFZCX1pM
MTAzNTMgaWYgIURWQl9GRV9DVVNUT01JU0UKIAlzZWxlY3QgTUVESUFfVFVO
RVJfWEMyMDI4IGlmICFEVkJfRkVfQ1VTVE9NSVpFCiAJc2VsZWN0IE1FRElB
X1RVTkVSX1REQTgyOTAgaWYgIURWQl9GRV9DVVNUT01JWkUKIAlzZWxlY3Qg
TUVESUFfVFVORVJfVERBMTgyNzEgaWYgIURWQl9GRV9DVVNUT01JWkUK

--_----------=_121784964640493
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_121784964640493--
