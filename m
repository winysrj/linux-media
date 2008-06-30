Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KDTFb-0002Zj-7e
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 01:57:40 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	3502618007FF
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 23:56:55 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "linux dvb" <linux-dvb@linuxtv.org>
Date: Tue, 1 Jul 2008 09:56:54 +1000
Message-Id: <20080630235654.CCD891CE833@ws1-6.us4.outblaze.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Subject: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV DVB-T
	Dual Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0877105710=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0877105710==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1214870214286391"

This is a multi-part message in MIME format.

--_----------=_1214870214286391
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Add initial support for DViCO FusionHDTV DVB-T Dual Express

From: Stephen Backway <stev391@email.com>

Add initial support (Note: Only one tuner is activated, due to issues
with the
SRAM definitions. Once fixed this will be enabled).  The analog portion
of the
card is not configured.  Original work to support this card was completed
by
Chris Pascoe, however this was never merged into the main tree.  Minor
changes
were required to ensure that the card worked correctly, namely the
callback
function, kernel config and various debugging messages.

Signed-off-by: Stephen Backway <stev391@email.com>

diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-06-09 14:13:20.000000000 +1000
+++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-06-30 21:06:19.000000000 +1000
@@ -9,3 +9,4 @@
8 -> Hauppauge WinTV-HVR1700                             [0070:8101]
9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
+ 11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-06-09 14:13:21.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-06-30 21:08:18.000000000 +1000
@@ -151,6 +151,13 @@
 #endif
.portc    =3D CX23885_MPEG_DVB,
},
+    [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {
+    .name    =3D "DViCO FusionHDTV DVB-T Dual Express",
+#if 0
+    .portb    =3D CX23885_MPEG_DVB,
+#endif
+    .portc    =3D CX23885_MPEG_DVB,
+    },
 };
 const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);

@@ -222,7 +229,11 @@
.subvendor =3D 0x18ac,
.subdevice =3D 0xd618,
.card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
-    },
+    }, {
+    .subvendor =3D 0x18ac,
+    .subdevice =3D 0xdb78,
+    .card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
+ },
 };
 const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);

@@ -439,6 +450,13 @@
mdelay(20);
cx_set(GP0_IO, 0x00050005);
break;
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+    /* GPIO-0 portb xc3028 reset */
+    /* GPIO-1 portb zl10353 reset */
+    /* GPIO-2 portc xc3028 reset */
+    /* GPIO-3 portc zl10353 reset */
+    cx_write(GP0_IO, 0x002f1000);
+    break;
}
 }

@@ -453,7 +471,10 @@
case CX23885_BOARD_HAUPPAUGE_HVR1400:
/* FIXME: Implement me */
break;
-    }
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+    request_module("ir-kbd-i2c");
+    break;
+ }

return 0;
 }
@@ -490,6 +511,7 @@

switch (dev->board) {
case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
ts2->gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */
ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
ts2->src_sel_val   =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c    2008-06-09
14:13:21.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c=20=20=20
2008-06-30 21:06:19.000000000 +1000
@@ -36,9 +36,11 @@
 #include "tda8290.h"
 #include "tda18271.h"
 #include "lgdt330x.h"
+#include "zl10353.h"
 #include "xc5000.h"
 #include "tda10048.h"
 #include "tuner-xc2028.h"
+#include "tuner-xc2028-types.h"
 #include "tuner-simple.h"
 #include "dib7000p.h"
 #include "dibx000_common.h"
@@ -155,6 +157,44 @@
.serial_mpeg =3D 0x40,
 };

+static int cx23885_dvico_xc2028_callback(void *ptr, int command, int
arg)
+{
+    struct cx23885_tsport *port =3D ptr;
+    struct cx23885_dev *dev =3D port->dev;
+    u32 reset_mask =3D 0;
+
+    switch (command) {
+    case XC2028_TUNER_RESET:
+    dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __func__,
+    arg, port->nr);
+
+    if (port->nr =3D=3D 0)
+    reset_mask =3D 0x0101;
+    else if (port->nr =3D=3D 1)
+    reset_mask =3D 0x0404;
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
@@ -481,7 +521,39 @@
&i2c_bus->i2c_adap,
&dvico_xc5000_tunerconfig, i2c_bus);
break;
-    default:
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+    i2c_bus =3D &dev->i2c_bus[port->nr - 1];
+
+    /* Take demod and tuner out of reset */
+    if (port->nr =3D=3D 1)
+    cx_set(GP0_IO, 0x0303);
+    else if (port->nr =3D=3D 2)
+    cx_set(GP0_IO, 0x0c0c);
+    mdelay(5);
+    port->dvb.frontend =3D dvb_attach(zl10353_attach,
+    &dvico_fusionhdtv_xc3028,
+    &i2c_bus->i2c_adap);
+    if (port->dvb.frontend !=3D NULL) {
+    struct dvb_frontend      *fe;
+    struct xc2028_config    cfg =3D {
+    .i2c_adap  =3D &i2c_bus->i2c_adap,
+    .i2c_addr  =3D 0x61,
+    .video_dev =3D port,
+    .callback  =3D cx23885_dvico_xc2028_callback,
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
+ default:
printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
dev->name);
break;
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h    2008-06-09
14:13:21.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h    2008-06-30
21:06:19.000000000 +1000
@@ -67,6 +67,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
+#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11

 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC
*/
 #define CX23885_NORMS (\
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig
v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
--- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig    2008-05-15
19:47:08.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig    2008-06-30
21:06:19.000000000 +1000
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


--_----------=_1214870214286391
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

Add initial support for DViCO FusionHDTV DVB-T Dual Express<br><br>From: St=
ephen Backway &lt;stev391@email.com&gt;<br><br>Add initial support (Note: O=
nly one tuner is activated, due to issues with the<br>SRAM definitions. Onc=
e fixed this will be enabled).&nbsp; The analog portion of the<br>card is n=
ot configured.&nbsp; Original work to support this card was completed by<br=
>Chris Pascoe, however this was never merged into the main tree.&nbsp; Mino=
r changes<br>were required to ensure that the card worked correctly, namely=
 the callback <br>function, kernel config and various debugging messages.<b=
r><br>Signed-off-by: Stephen Backway &lt;stev391@email.com&gt;<br><br>diff =
-Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885 v4l-dvb_dev/=
linux/Documentation/video4linux/CARDLIST.cx23885<br>--- v4l-dvb/linux/Docum=
entation/video4linux/CARDLIST.cx23885&nbsp;&nbsp;&nbsp; 2008-06-09 14:13:20=
.000000000 +1000<br>+++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIS=
T.cx23885&nbsp;&nbsp;&nbsp; 2008-06-30 21:06:19.000000000 +1000<br>@@ -9,3 =
+9,4 @@<br>&nbsp;&nbsp; 8 -&gt; Hauppauge WinTV-HVR1700&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [=
0070:8101]<br>&nbsp;&nbsp; 9 -&gt; Hauppauge WinTV-HVR1400&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; [0070:8010]<br>&nbsp; 10 -&gt; DViCO FusionHDTV7 Dual Express&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [18ac:d618]<br>+ 11 -&gt; DViCO Fus=
ionHDTV DVB-T Dual Express&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [18ac:db78]<br>diff -Naur v=
4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb_dev/linux/=
drivers/media/video/cx23885/cx23885-cards.c<br>--- v4l-dvb/linux/drivers/me=
dia/video/cx23885/cx23885-cards.c&nbsp;&nbsp;&nbsp; 2008-06-09 14:13:21.000=
000000 +1000<br>+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-c=
ards.c&nbsp;&nbsp;&nbsp; 2008-06-30 21:08:18.000000000 +1000<br>@@ -151,6 +=
151,13 @@<br>&nbsp;#endif<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .p=
ortc&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>&nbsp;&n=
bsp;&nbsp;&nbsp; },<br>+&nbsp;&nbsp;&nbsp; [CX23885_BOARD_DVICO_FUSIONHDTV_=
DVB_T_DUAL_EXP] =3D {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .name&nbsp;=
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D "DViCO FusionHDTV DVB-T Dual Express",<=
br>+#if 0<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portb&nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>+#endif<br>+&nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; .portc&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX2388=
5_MPEG_DVB,<br>+&nbsp;&nbsp;&nbsp; },<br>&nbsp;};<br>&nbsp;const unsigned i=
nt cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);<br>&nbsp;<br>@@ -222,7 +2=
29,11 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subvendor =3D 0x18=
ac,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subdevice =3D 0xd618,<b=
r>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .card&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; =3D CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,<br>-&nbsp;&nbsp;&nbsp=
; },<br>+&nbsp;&nbsp;&nbsp; }, {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
.subvendor =3D 0x18ac,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subdevice=
 =3D 0xdb78,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .card&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,<br>+ &nb=
sp;&nbsp;&nbsp; },<br>&nbsp;};<br>&nbsp;const unsigned int cx23885_idcount =
=3D ARRAY_SIZE(cx23885_subids);<br>&nbsp;<br>@@ -439,6 +450,13 @@<br>&nbsp;=
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(20);<br>&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x00050005);<br>&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_DVIC=
O_FUSIONHDTV_DVB_T_DUAL_EXP:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* G=
PIO-0 portb xc3028 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GP=
IO-1 portb zl10353 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GP=
IO-2 portc xc3028 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GPI=
O-3 portc zl10353 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_wri=
te(GP0_IO, 0x002f1000);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br=
>&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;}<br>&nbsp;<br>@@ -453,7 +471,10 @@<br=
>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BOARD_HAUPPAUGE_HVR1400:<br>&nbsp;&n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* FIXME: Implement me */<br>&nbsp;&nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>-&nbsp;&nbsp;&nbsp; }<br>+&nbsp=
;&nbsp;&nbsp; case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>+&nbsp=
;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; request_module("ir-kbd-i2c");<br>+&nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+ &nbsp;&nbsp;&nbsp; }<br>&nbsp;<br=
>&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>&nbsp;}<br>@@ -490,6 +511,7 @@<br>&n=
bsp;<br>&nbsp;&nbsp;&nbsp;&nbsp; switch (dev-&gt;board) {<br>&nbsp;&nbsp;&n=
bsp;&nbsp; case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:<br>+&nbsp;&nbsp;=
&nbsp; case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>&nbsp;&nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ts2-&gt;gen_ctrl_val&nbsp; =3D 0xc; /* Seria=
l bus + punctured clock */<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; t=
s2-&gt;ts_clk_en_val =3D 0x1; /* Enable TS_CLK */<br>&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; ts2-&gt;src_sel_val&nbsp;&nbsp; =3D CX23885_SRC_SEL_P=
ARALLEL_MPEG_VIDEO;<br>diff -Naur v4l-dvb/linux/drivers/media/video/cx23885=
/cx23885-dvb.c v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c<=
br>--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c&nbsp;&nbsp;&=
nbsp; 2008-06-09 14:13:21.000000000 +1000<br>+++ v4l-dvb_dev/linux/drivers/=
media/video/cx23885/cx23885-dvb.c&nbsp;&nbsp;&nbsp; 2008-06-30 21:06:19.000=
000000 +1000<br>@@ -36,9 +36,11 @@<br>&nbsp;#include "tda8290.h"<br>&nbsp;#=
include "tda18271.h"<br>&nbsp;#include "lgdt330x.h"<br>+#include "zl10353.h=
"<br>&nbsp;#include "xc5000.h"<br>&nbsp;#include "tda10048.h"<br>&nbsp;#inc=
lude "tuner-xc2028.h"<br>+#include "tuner-xc2028-types.h"<br>&nbsp;#include=
 "tuner-simple.h"<br>&nbsp;#include "dib7000p.h"<br>&nbsp;#include "dibx000=
_common.h"<br>@@ -155,6 +157,44 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; .serial_mpeg=
 =3D 0x40,<br>&nbsp;};<br>&nbsp;<br>+static int cx23885_dvico_xc2028_callba=
ck(void *ptr, int command, int arg)<br>+{<br>+&nbsp;&nbsp;&nbsp; struct cx2=
3885_tsport *port =3D ptr;<br>+&nbsp;&nbsp;&nbsp; struct cx23885_dev *dev =
=3D port-&gt;dev;<br>+&nbsp;&nbsp;&nbsp; u32 reset_mask =3D 0;<br>+<br>+&nb=
sp;&nbsp;&nbsp; switch (command) {<br>+&nbsp;&nbsp;&nbsp; case XC2028_TUNER=
_RESET:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dprintk(1, "%s: XC2028_TU=
NER_RESET %d, port %d\n", __func__,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; arg, port-&gt;nr);<br>+<br>+&nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; if (port-&gt;nr =3D=3D 0)<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; reset_mask =3D 0x0101;<br>+&nbsp;&nbsp;&nbsp; &nbs=
p;&nbsp;&nbsp; else if (port-&gt;nr =3D=3D 1)<br>+&nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; reset_mask =3D 0x0404;<br>+<br>+&nbsp;&nbsp=
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
L_OUTPUT,<br>@@ -481,7 +521,39 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &amp;i2c_bus-&gt;i2c_adap,<br>&=
nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &amp;dvico_xc5000_tunerconfig, i2c_bus);<br>&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; break;<br>-&nbsp;&nbsp;&nbsp; default:<br>+&nbsp;&nbsp;&=
nbsp; case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>+&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; i2c_bus =3D &amp;dev-&gt;i2c_bus[port-&gt;nr - 1];=
<br>+<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* Take demod and tuner out=
 of reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (port-&gt;nr =3D=
=3D 1)<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(=
GP0_IO, 0x0303);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; else if (port-&g=
t;nr =3D=3D 2)<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 cx_set(GP0_IO, 0x0c0c);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(5=
);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; port-&gt;dvb.frontend =3D dvb_=
attach(zl10353_attach,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; &amp;dvico_fusionhdtv_xc3028,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; &amp;i2c_bus-&gt;i2c_adap);<br>+&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; if (port-&gt;dvb.frontend !=3D NULL) {<br>+&nbsp;&nbsp;=
&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; struct dvb_frontend&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; *fe;<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; struct xc2028_config&nbsp;&nbsp;&nbsp; &nbsp; cfg =3D {<br>+&nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .i2=
c_adap&nbsp; =3D &amp;i2c_bus-&gt;i2c_adap,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .i2c_addr&nbsp; =3D 0x61,<=
br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; .video_dev =3D port,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .callback&nbsp; =3D cx23885_dvico_xc2028_cal=
lback,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>+=
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; static struct xc20=
28_ctrl ctl =3D {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nb=
sp; &nbsp;&nbsp;&nbsp; .fname&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D "xc30=
28-v27.fw",<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &n=
bsp;&nbsp;&nbsp; .max_len&nbsp;&nbsp;&nbsp;&nbsp; =3D 64,<br>+&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .demod&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D XC3028_FE_ZARLINK456,<br>+&nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>+<br>+&nbsp;&nbsp;&nbsp; &=
nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fe =3D dvb_attach(xc2028_attach, port-=
&gt;dvb.frontend,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nb=
sp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &amp;cfg);<br>+&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe !=3D NULL &amp;&amp; fe-&gt;o=
ps.tuner_ops.set_config !=3D NULL)<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fe-&gt;ops.tuner_ops.set_config(fe,=
 &amp;ctl);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>+&nbsp;&nbsp;&nb=
sp; &nbsp;&nbsp;&nbsp; break;<br>+ &nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; printk("%s: The frontend of your DVB/ATS=
C card isn't supported yet\n",<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev-&gt;name);<br>&nbsp;&nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>diff -Naur v4l-dvb/linux/drivers/media=
/video/cx23885/cx23885.h v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23=
885.h<br>--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h&nbsp;&nbsp=
;&nbsp; 2008-06-09 14:13:21.000000000 +1000<br>+++ v4l-dvb_dev/linux/driver=
s/media/video/cx23885/cx23885.h&nbsp;&nbsp;&nbsp; 2008-06-30 21:06:19.00000=
0000 +1000<br>@@ -67,6 +67,7 @@<br>&nbsp;#define CX23885_BOARD_HAUPPAUGE_HV=
R1700&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8<br>&nbsp;#define CX23885_=
BOARD_HAUPPAUGE_HVR1400&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br>&nbs=
p;#define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10<br>+#define CX23885_=
BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11<br>&nbsp;<br>&nbsp;/* Currently un=
supported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */<br>&nbsp;#define=
 CX23885_NORMS (\<br>diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/K=
config v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig<br>--- v4l-dvb=
/linux/drivers/media/video/cx23885/Kconfig&nbsp;&nbsp;&nbsp; 2008-05-15 19:=
47:08.000000000 +1000<br>+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/=
Kconfig&nbsp;&nbsp;&nbsp; 2008-06-30 21:06:19.000000000 +1000<br>@@ -15,6 +=
15,7 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_MT2131 if !DVB_FE_CU=
STOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select DVB_S5H1409 if !DVB_FE_CUSTOMISE=
<br>&nbsp;&nbsp;&nbsp;&nbsp; select DVB_LGDT330X if !DVB_FE_CUSTOMISE<br>+ =
&nbsp;&nbsp;&nbsp; select DVB_ZL10353 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&=
nbsp;&nbsp; select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE<br>&nbsp;&nbsp;&=
nbsp;&nbsp; select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE<br>&nbsp;&nbsp;=
&nbsp;&nbsp; select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE<br><br><BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1214870214286391--



--===============0877105710==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0877105710==--
