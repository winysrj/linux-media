Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Jw9xD-0002JB-0i
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 07:55:11 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	E4C691800201
	for <linux-dvb@linuxtv.org>; Wed, 14 May 2008 05:54:31 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1210744471264054"
MIME-Version: 1.0
From: stev391@email.com
To: "allan k" <sonofzev@iinet.net.au>
Date: Wed, 14 May 2008 15:54:31 +1000
Message-Id: <20080514055431.D014A104F0@ws1-3.us4.outblaze.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
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

--_----------=_1210744471264054
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1210744471264053"

This is a multi-part message in MIME format.

--_----------=_1210744471264053
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

I have updated my patch (from a week ago) and is included inline below as
well as an attachment. The issue that was noticed and mentioned in
previous posts regarding to tuners not resetting was possibly due to
several "__FUNCTION_" in the tuner reset code, these should be
"__func__", which is fixed in the attached patch.

This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is
intended to merge Chris Pascoe's work into the current head to enable
support for the DViCO Fusion HDTV DVB-T Dual Express (PCIe).  This
enables systems with different tuners to take advantage of other
experimental drivers, (for example my TV Walker Twin USB tuner).

Regards,

Stephen

diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-05-14 09:48:21.000000000 +1000
+++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-05-14 13:39:30.000000000 +1000
@@ -8,3 +8,4 @@
7 -> Hauppauge WinTV-HVR1200=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
[0070:71d1,0070:71d3]
;  8 -> Hauppauge WinTV-HVR1700                             [0070:8101]
9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
+ 10 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-05-14 09:48:22.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-05-14 13:39:30.000000000 +1000
@@ -144,6 +144,11 @@
.name    =3D "Hauppauge WinTV-HVR1400",
.portc    =3D CX23885_MPEG_DVB,
},
+    [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {
+    .name    =3D "DViCO FusionHDTV DVB-T Dual Express",
+    .portb    =3D CX23885_MPEG_DVB,
+    .portc    =3D CX23885_MPEG_DVB,
+    },
 };
 const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);

@@ -211,6 +216,10 @@
.subvendor =3D 0x0070,
.subdevice =3D 0x8010,
.card      =3D CX23885_BOARD_HAUPPAUGE_HVR1400,
+    },{
+    .subvendor =3D 0x18ac,
+    .subdevice =3D 0xdb78,
+    .card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
},
 };
 const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);
@@ -428,6 +437,13 @@
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

@@ -442,6 +458,9 @@
case CX23885_BOARD_HAUPPAUGE_HVR1400:
/* FIXME: Implement me */
break;
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+    request_module("ir-kbd-i2c");
+    break;
}

return 0;
@@ -478,6 +497,11 @@
}

switch (dev->board) {
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+    ts2->gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */
+    ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
+    ts2->src_sel_val   =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+    /* FALLTHROUGH */
case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
ts1->gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */
ts1->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c    2008-05-14
09:48:22.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c=20=20=20
2008-05-14 13:39:30.000000000 +1000
@@ -42,6 +42,9 @@
 #include "tuner-simple.h"
 #include "dib7000p.h"
 #include "dibx000_common.h"
+#include "zl10353.h"
+#include "tuner-xc2028.h"
+#include "tuner-xc2028-types.h"

 static unsigned int debug;

@@ -155,6 +158,44 @@
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
+    if (port->nr =3D=3D 1)
+    reset_mask =3D 0x0101;
+    else if (port->nr =3D=3D 2)
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
@@ -454,6 +495,39 @@
fe->ops.tuner_ops.set_config(fe, &ctl);
}
break;
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
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
+    .fname       =3D "xc3028-dvico-au-01.fw",
+    .max_len     =3D 64,
+    .scode_table =3D ZARLINK456,
+    };
+
+    fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,
+    &cfg);
+    if (fe !=3D NULL && fe->ops.tuner_ops.set_config !=3D NULL)
+    fe->ops.tuner_ops.set_config(fe, &ctl);
+    }
+    break;
+        }
default:
printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
dev->name);
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h    2008-05-14
09:48:22.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h    2008-05-14
13:39:30.000000000 +1000
@@ -66,6 +66,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1200        7
 #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
+#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 10

 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC
*/
 #define CX23885_NORMS (\
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig
v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
--- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig    2008-05-14
09:48:22.000000000 +1000
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig    2008-05-14
13:39:30.000000000 +1000
@@ -15,6 +15,7 @@
select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
select DVB_S5H1409 if !DVB_FE_CUSTOMISE
select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+ select DVB_ZL10353 if !DVB_FE_CUSTOMISE
select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1210744471264053
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>


<div><br>I have updated my patch (from a week ago) and is included inline b=
elow as well as an attachment. The issue that was noticed and mentioned in =
previous posts regarding to tuners not resetting was possibly due to severa=
l "__FUNCTION_" in the tuner reset code, these should be "__func__", which =
is fixed in the attached patch.<br><br>
This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is intended=
 to merge Chris Pascoe's work into the current head to enable support for t=
he DViCO Fusion HDTV DVB-T Dual Express (PCIe).&nbsp; This enables systems =
with different tuners to take advantage of other experimental drivers, (for=
 example my TV Walker Twin USB tuner).<br><br>Regards,<br><br>Stephen<br><b=
r>diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885 v4l-d=
vb_dev/linux/Documentation/video4linux/CARDLIST.cx23885<br>--- v4l-dvb/linu=
x/Documentation/video4linux/CARDLIST.cx23885&nbsp;&nbsp;&nbsp; 2008-05-14 0=
9:48:21.000000000 +1000<br>+++ v4l-dvb_dev/linux/Documentation/video4linux/=
CARDLIST.cx23885&nbsp;&nbsp;&nbsp; 2008-05-14 13:39:30.000000000 +1000<br>@=
@ -8,3 +8,4 @@<br>&nbsp;&nbsp; 7 -&gt; Hauppauge WinTV-HVR1200&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; [0070:71d1,0070:71d3]<br>&nbsp;
;&nbsp; 8 -&gt; Hauppauge WinTV-HVR1700&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [0070:8101]<br>&n=
bsp;&nbsp; 9 -&gt; Hauppauge WinTV-HVR1400&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [0070:8010]<br=
>+ 10 -&gt; DViCO FusionHDTV DVB-T Dual Express&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [18ac:=
db78]<br>diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards=
.c v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c<br>--- v4l=
-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c&nbsp;&nbsp;&nbsp; 20=
08-05-14 09:48:22.000000000 +1000<br>+++ v4l-dvb_dev/linux/drivers/media/vi=
deo/cx23885/cx23885-cards.c&nbsp;&nbsp;&nbsp; 2008-05-14 13:39:30.000000000=
 +1000<br>@@ -144,6 +144,11 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; .name&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D "Hauppauge WinTV-HVR1400"=
,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portc&nbsp;&nbsp;&nbsp; &=
nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>&nbsp;&nbsp;&nbsp;&nbsp; },<br>+=
&nbsp;&nbsp;&nbsp; [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {<br=
>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .name&nbsp;&nbsp;&nbsp; &nbsp;&nbsp=
;&nbsp; =3D "DViCO FusionHDTV DVB-T Dual Express",<br>+&nbsp;&nbsp;&nbsp; &=
nbsp;&nbsp;&nbsp; .portb&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX23885_M=
PEG_DVB,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portc&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>+&nbsp;&nbsp;&nbsp; },<br>&nbs=
p;};<br>&nbsp;const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boar=
ds);<br>&nbsp;<br>@@ -211,6 +216,10 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; .subvendor =3D 0x0070,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; .subdevice =3D 0x8010,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 .card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D CX23885_BOARD_HAUPPAUGE_HVR1400,<b=
r>+&nbsp;&nbsp;&nbsp; },{<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subven=
dor =3D 0x18ac,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subdevice =3D 0x=
db78,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .card&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,<br>&nbsp;&nbsp;=
&nbsp;&nbsp; },<br>&nbsp;};<br>&nbsp;const unsigned int cx23885_idcount =3D=
 ARRAY_SIZE(cx23885_subids);<br>@@ -428,6 +437,13 @@<br>&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; mdelay(20);<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; cx_set(GP0_IO, 0x00050005);<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_DVICO_FUSIONHDTV_=
DVB_T_DUAL_EXP:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GPIO-0 portb x=
c3028 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GPIO-1 portb zl=
10353 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GPIO-2 portc xc=
3028 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GPIO-3 portc zl1=
0353 reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_write(GP0_IO, 0x=
002f1000);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>&nbsp;&nbsp;=
&nbsp;&nbsp; }<br>&nbsp;}<br>&nbsp;<br>@@ -442,6 +458,9 @@<br>&nbsp;&nbsp;&=
nbsp;&nbsp; case CX23885_BOARD_HAUPPAUGE_HVR1400:<br>&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; /* FIXME: Implement me */<br>&nbsp;&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_DVICO_=
FUSIONHDTV_DVB_T_DUAL_EXP:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; reques=
t_module("ir-kbd-i2c");<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br=
>&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp; return 0;=
<br>@@ -478,6 +497,11 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;<br>&nbsp;&=
nbsp;&nbsp;&nbsp; switch (dev-&gt;board) {<br>+&nbsp;&nbsp;&nbsp; case CX23=
885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; ts2-&gt;gen_ctrl_val&nbsp; =3D 0xc; /* Serial bus + punctured clo=
ck */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ts2-&gt;ts_clk_en_val =3D 0=
x1; /* Enable TS_CLK */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ts2-&gt;s=
rc_sel_val&nbsp;&nbsp; =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;<br>+&nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* FALLTHROUGH */<br>&nbsp;&nbsp;&nbsp;&nbsp=
; case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:<br>&nbsp;&nbsp;&nbsp;&nbsp; &n=
bsp;&nbsp;&nbsp; ts1-&gt;gen_ctrl_val&nbsp; =3D 0xc; /* Serial bus + punctu=
red clock */<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ts1-&gt;ts_clk_=
en_val =3D 0x1; /* Enable TS_CLK */<br>diff -Naur v4l-dvb/linux/drivers/med=
ia/video/cx23885/cx23885-dvb.c v4l-dvb_dev/linux/drivers/media/video/cx2388=
5/cx23885-dvb.c<br>--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dv=
b.c&nbsp;&nbsp;&nbsp; 2008-05-14 09:48:22.000000000 +1000<br>+++ v4l-dvb_de=
v/linux/drivers/media/video/cx23885/cx23885-dvb.c&nbsp;&nbsp;&nbsp; 2008-05=
-14 13:39:30.000000000 +1000<br>@@ -42,6 +42,9 @@<br>&nbsp;#include "tuner-=
simple.h"<br>&nbsp;#include "dib7000p.h"<br>&nbsp;#include "dibx000_common.=
h"<br>+#include "zl10353.h"<br>+#include "tuner-xc2028.h"<br>+#include "tun=
er-xc2028-types.h"<br>&nbsp;<br>&nbsp;static unsigned int debug;<br>&nbsp;<=
br>@@ -155,6 +158,44 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; .serial_mpeg =3D 0x40,<=
br>&nbsp;};<br>&nbsp;<br>+static int cx23885_dvico_xc2028_callback(void *pt=
r, int command, int arg)<br>+{<br>+&nbsp;&nbsp;&nbsp; struct cx23885_tsport=
 *port =3D ptr;<br>+&nbsp;&nbsp;&nbsp; struct cx23885_dev *dev =3D port-&gt=
;dev;<br>+&nbsp;&nbsp;&nbsp; u32 reset_mask =3D 0;<br>+<br>+&nbsp;&nbsp;&nb=
sp; switch (command) {<br>+&nbsp;&nbsp;&nbsp; case XC2028_TUNER_RESET:<br>+=
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dprintk(1, "%s: XC2028_TUNER_RESET %d=
, port %d\n", __func__,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; arg, port-&gt;nr);<br>+<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 if (port-&gt;nr =3D=3D 1)<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; reset_mask =3D 0x0101;<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; else if (port-&gt;nr =3D=3D 2)<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; reset_mask =3D 0x0404;<br>+<br>+&nbsp;&nbsp;&nbsp; &nbs=
p;&nbsp;&nbsp; cx_clear(GP0_IO, reset_mask);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp; mdelay(5);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(GP0=
_IO, reset_mask);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbs=
p;&nbsp;&nbsp; case XC2028_RESET_CLK:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);<br>+&nbsp;&nbs=
p;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; default:<br>+&nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; dprintk(1, "%s: unknown command %d, arg %=
d\n", __func__,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; command, arg);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; return -EINVAL;<br>+&nbsp;&nbsp;&nbsp; }<br>+<br>+&nbsp;&nbsp;&nbsp; retu=
rn 0;<br>+}<br>+<br>+static struct zl10353_config dvico_fusionhdtv_xc3028 =
=3D {<br>+&nbsp;&nbsp;&nbsp; .demod_address =3D 0x0f,<br>+&nbsp;&nbsp;&nbsp=
; .if2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D 4560=
0,<br>+&nbsp;&nbsp;&nbsp; .no_tuner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D 1,<br=
>+};<br>+<br>&nbsp;static struct s5h1409_config hauppauge_hvr1500q_config =
=3D {<br>&nbsp;&nbsp;&nbsp;&nbsp; .demod_address =3D 0x32 &gt;&gt; 1,<br>&n=
bsp;&nbsp;&nbsp;&nbsp; .output_mode&nbsp;&nbsp; =3D S5H1409_SERIAL_OUTPUT,<=
br>@@ -454,6 +495,39 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fe-&gt;ops.tuner_ops.set_config(fe, &amp;=
ctl);<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD=
_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; i2c_bus =3D &amp;dev-&gt;i2c_bus[port-&gt;nr - 1];<br>+<br>+&nbsp;&nbsp;=
&nbsp; &nbsp;&nbsp;&nbsp; /* Take demod and tuner out of reset */<br>+&nbsp=
;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (port-&gt;nr =3D=3D 1)<br>+&nbsp;&nbsp;=
&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x0303);<br>+&n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; else if (port-&gt;nr =3D=3D 2)<br>+&nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x0c0c)=
;<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(5);<br>+&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; port-&gt;dvb.frontend =3D dvb_attach(zl10353_attach,<=
br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;dvico_fus=
ionhdtv_xc3028,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; &amp;i2c_bus-&gt;i2c_adap);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if =
(port-&gt;dvb.frontend !=3D NULL) {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; struct dvb_frontend&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *fe=
;<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; struct xc202=
8_config&nbsp;&nbsp;&nbsp; &nbsp; cfg =3D {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .i2c_adap&nbsp; =3D &amp;i=
2c_bus-&gt;i2c_adap,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;=
&nbsp; &nbsp;&nbsp;&nbsp; .i2c_addr&nbsp; =3D 0x61,<br>+&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .video_dev =3D por=
t,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp=
;&nbsp; .callback&nbsp; =3D cx23885_dvico_xc2028_callback,<br>+&nbsp;&nbsp;=
&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>+&nbsp;&nbsp;&nbsp; &nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; static struct xc2028_ctrl ctl =3D {<br>+&=
nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
.fname&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D "xc3028-dvico-au-01.fw",<br>=
+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp=
; .max_len&nbsp;&nbsp;&nbsp;&nbsp; =3D 64,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .scode_table =3D ZARLINK456=
,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>+<br>+=
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fe =3D dvb_attach(=
xc2028_attach, port-&gt;dvb.frontend,<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &amp;cfg);<br=
>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (fe !=3D NULL=
 &amp;&amp; fe-&gt;ops.tuner_ops.set_config !=3D NULL)<br>+&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; fe-&gt;ops.tune=
r_ops.set_config(fe, &amp;ctl);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }=
<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nbsp=
;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; printk("%s: The frontend of your DVB/ATSC =
card isn't supported yet\n",<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev-&gt;name);<br>diff -Naur v4l-dvb/=
linux/drivers/media/video/cx23885/cx23885.h v4l-dvb_dev/linux/drivers/media=
/video/cx23885/cx23885.h<br>--- v4l-dvb/linux/drivers/media/video/cx23885/c=
x23885.h&nbsp;&nbsp;&nbsp; 2008-05-14 09:48:22.000000000 +1000<br>+++ v4l-d=
vb_dev/linux/drivers/media/video/cx23885/cx23885.h&nbsp;&nbsp;&nbsp; 2008-0=
5-14 13:39:30.000000000 +1000<br>@@ -66,6 +66,7 @@<br>&nbsp;#define CX23885=
_BOARD_HAUPPAUGE_HVR1200&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7<br>&nb=
sp;#define CX23885_BOARD_HAUPPAUGE_HVR1700&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; 8<br>&nbsp;#define CX23885_BOARD_HAUPPAUGE_HVR1400&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br>+#define CX23885_BOARD_DVICO_FUSIONHDTV_DV=
B_T_DUAL_EXP 10<br>&nbsp;<br>&nbsp;/* Currently unsupported by the driver: =
PAL/H, NTSC/Kr, SECAM B/G/H/LC */<br>&nbsp;#define CX23885_NORMS (\<br>diff=
 -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig v4l-dvb_dev/linux/=
drivers/media/video/cx23885/Kconfig<br>--- v4l-dvb/linux/drivers/media/vide=
o/cx23885/Kconfig&nbsp;&nbsp;&nbsp; 2008-05-14 09:48:22.000000000 +1000<br>=
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig&nbsp;&nbsp;&nbsp;=
 2008-05-14 13:39:30.000000000 +1000<br>@@ -15,6 +15,7 @@<br>&nbsp;&nbsp;&n=
bsp;&nbsp; select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&n=
bsp;&nbsp; select DVB_S5H1409 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nb=
sp; select DVB_LGDT330X if !DVB_FE_CUSTOMISE<br>+ &nbsp;&nbsp;&nbsp; select=
 DVB_ZL10353 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_=
TUNER_XC2028 if !DVB_FE_CUSTOMIZE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_=
TUNER_TDA8290 if !DVB_FE_CUSTOMIZE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA=
_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE<br><br></div>


</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_1210744471264053--


--_----------=_1210744471264054
Content-Disposition: attachment; filename="DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch"

ZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80
bGludXgvQ0FSRExJU1QuY3gyMzg4NSB2NGwtZHZiX2Rldi9saW51eC9Eb2N1
bWVudGF0aW9uL3ZpZGVvNGxpbnV4L0NBUkRMSVNULmN4MjM4ODUKLS0tIHY0
bC1kdmIvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElT
VC5jeDIzODg1CTIwMDgtMDUtMTQgMDk6NDg6MjEuMDAwMDAwMDAwICsxMDAw
CisrKyB2NGwtZHZiX2Rldi9saW51eC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxp
bnV4L0NBUkRMSVNULmN4MjM4ODUJMjAwOC0wNS0xNCAxMzozOTozMC4wMDAw
MDAwMDAgKzEwMDAKQEAgLTgsMyArOCw0IEBACiAgIDcgLT4gSGF1cHBhdWdl
IFdpblRWLUhWUjEyMDAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFsw
MDcwOjcxZDEsMDA3MDo3MWQzXQogICA4IC0+IEhhdXBwYXVnZSBXaW5UVi1I
VlIxNzAwICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbMDA3MDo4MTAx
XQogICA5IC0+IEhhdXBwYXVnZSBXaW5UVi1IVlIxNDAwICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBbMDA3MDo4MDEwXQorIDEwIC0+IERWaUNPIEZ1
c2lvbkhEVFYgRFZCLVQgRHVhbCBFeHByZXNzICAgICAgICAgICAgICAgICBb
MThhYzpkYjc4XQpkaWZmIC1OYXVyIHY0bC1kdmIvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2FyZHMuYyB2NGwtZHZiX2Rl
di9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1j
YXJkcy5jCi0tLSB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
Y3gyMzg4NS9jeDIzODg1LWNhcmRzLmMJMjAwOC0wNS0xNCAwOTo0ODoyMi4w
MDAwMDAwMDAgKzEwMDAKKysrIHY0bC1kdmJfZGV2L2xpbnV4L2RyaXZlcnMv
bWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRzLmMJMjAwOC0wNS0x
NCAxMzozOTozMC4wMDAwMDAwMDAgKzEwMDAKQEAgLTE0NCw2ICsxNDQsMTEg
QEAKIAkJLm5hbWUJCT0gIkhhdXBwYXVnZSBXaW5UVi1IVlIxNDAwIiwKIAkJ
LnBvcnRjCQk9IENYMjM4ODVfTVBFR19EVkIsCiAJfSwKKwlbQ1gyMzg4NV9C
T0FSRF9EVklDT19GVVNJT05IRFRWX0RWQl9UX0RVQUxfRVhQXSA9IHsKKwkJ
Lm5hbWUJCT0gIkRWaUNPIEZ1c2lvbkhEVFYgRFZCLVQgRHVhbCBFeHByZXNz
IiwKKwkJLnBvcnRiCQk9IENYMjM4ODVfTVBFR19EVkIsCisJCS5wb3J0YwkJ
PSBDWDIzODg1X01QRUdfRFZCLAorCX0sCiB9OwogY29uc3QgdW5zaWduZWQg
aW50IGN4MjM4ODVfYmNvdW50ID0gQVJSQVlfU0laRShjeDIzODg1X2JvYXJk
cyk7CiAKQEAgLTIxMSw2ICsyMTYsMTAgQEAKIAkJLnN1YnZlbmRvciA9IDB4
MDA3MCwKIAkJLnN1YmRldmljZSA9IDB4ODAxMCwKIAkJLmNhcmQgICAgICA9
IENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hWUjE0MDAsCisJfSx7CisJCS5z
dWJ2ZW5kb3IgPSAweDE4YWMsCisJCS5zdWJkZXZpY2UgPSAweGRiNzgsCisJ
CS5jYXJkICAgICAgPSBDWDIzODg1X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZf
RFZCX1RfRFVBTF9FWFAsCiAJfSwKIH07CiBjb25zdCB1bnNpZ25lZCBpbnQg
Y3gyMzg4NV9pZGNvdW50ID0gQVJSQVlfU0laRShjeDIzODg1X3N1Ymlkcyk7
CkBAIC00MjgsNiArNDM3LDEzIEBACiAJCW1kZWxheSgyMCk7CiAJCWN4X3Nl
dChHUDBfSU8sIDB4MDAwNTAwMDUpOwogCQlicmVhazsKKwljYXNlIENYMjM4
ODVfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl9EVkJfVF9EVUFMX0VYUDoKKwkJ
LyogR1BJTy0wIHBvcnRiIHhjMzAyOCByZXNldCAqLworCQkvKiBHUElPLTEg
cG9ydGIgemwxMDM1MyByZXNldCAqLworCQkvKiBHUElPLTIgcG9ydGMgeGMz
MDI4IHJlc2V0ICovCisJCS8qIEdQSU8tMyBwb3J0YyB6bDEwMzUzIHJlc2V0
ICovCisJCWN4X3dyaXRlKEdQMF9JTywgMHgwMDJmMTAwMCk7CisJCWJyZWFr
OwogCX0KIH0KIApAQCAtNDQyLDYgKzQ1OCw5IEBACiAJY2FzZSBDWDIzODg1
X0JPQVJEX0hBVVBQQVVHRV9IVlIxNDAwOgogCQkvKiBGSVhNRTogSW1wbGVt
ZW50IG1lICovCiAJCWJyZWFrOworCWNhc2UgQ1gyMzg4NV9CT0FSRF9EVklD
T19GVVNJT05IRFRWX0RWQl9UX0RVQUxfRVhQOgorCQlyZXF1ZXN0X21vZHVs
ZSgiaXIta2JkLWkyYyIpOworCQlicmVhazsKIAl9CiAKIAlyZXR1cm4gMDsK
QEAgLTQ3OCw2ICs0OTcsMTEgQEAKIAl9CiAKIAlzd2l0Y2ggKGRldi0+Ym9h
cmQpIHsKKwljYXNlIENYMjM4ODVfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl9E
VkJfVF9EVUFMX0VYUDoKKwkJdHMyLT5nZW5fY3RybF92YWwgID0gMHhjOyAv
KiBTZXJpYWwgYnVzICsgcHVuY3R1cmVkIGNsb2NrICovCisJCXRzMi0+dHNf
Y2xrX2VuX3ZhbCA9IDB4MTsgLyogRW5hYmxlIFRTX0NMSyAqLworCQl0czIt
PnNyY19zZWxfdmFsICAgPSBDWDIzODg1X1NSQ19TRUxfUEFSQUxMRUxfTVBF
R19WSURFTzsKKwkJLyogRkFMTFRIUk9VR0ggKi8KIAljYXNlIENYMjM4ODVf
Qk9BUkRfRFZJQ09fRlVTSU9OSERUVl81X0VYUDoKIAkJdHMxLT5nZW5fY3Ry
bF92YWwgID0gMHhjOyAvKiBTZXJpYWwgYnVzICsgcHVuY3R1cmVkIGNsb2Nr
ICovCiAJCXRzMS0+dHNfY2xrX2VuX3ZhbCA9IDB4MTsgLyogRW5hYmxlIFRT
X0NMSyAqLwpkaWZmIC1OYXVyIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRp
YS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMgdjRsLWR2Yl9kZXYvbGlu
dXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMK
LS0tIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1
L2N4MjM4ODUtZHZiLmMJMjAwOC0wNS0xNCAwOTo0ODoyMi4wMDAwMDAwMDAg
KzEwMDAKKysrIHY0bC1kdmJfZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlk
ZW8vY3gyMzg4NS9jeDIzODg1LWR2Yi5jCTIwMDgtMDUtMTQgMTM6Mzk6MzAu
MDAwMDAwMDAwICsxMDAwCkBAIC00Miw2ICs0Miw5IEBACiAjaW5jbHVkZSAi
dHVuZXItc2ltcGxlLmgiCiAjaW5jbHVkZSAiZGliNzAwMHAuaCIKICNpbmNs
dWRlICJkaWJ4MDAwX2NvbW1vbi5oIgorI2luY2x1ZGUgInpsMTAzNTMuaCIK
KyNpbmNsdWRlICJ0dW5lci14YzIwMjguaCIKKyNpbmNsdWRlICJ0dW5lci14
YzIwMjgtdHlwZXMuaCIKIAogc3RhdGljIHVuc2lnbmVkIGludCBkZWJ1ZzsK
IApAQCAtMTU1LDYgKzE1OCw0NCBAQAogCS5zZXJpYWxfbXBlZyA9IDB4NDAs
CiB9OwogCitzdGF0aWMgaW50IGN4MjM4ODVfZHZpY29feGMyMDI4X2NhbGxi
YWNrKHZvaWQgKnB0ciwgaW50IGNvbW1hbmQsIGludCBhcmcpCit7CisJc3Ry
dWN0IGN4MjM4ODVfdHNwb3J0ICpwb3J0ID0gcHRyOworCXN0cnVjdCBjeDIz
ODg1X2RldiAqZGV2ID0gcG9ydC0+ZGV2OworCXUzMiByZXNldF9tYXNrID0g
MDsKKworCXN3aXRjaCAoY29tbWFuZCkgeworCWNhc2UgWEMyMDI4X1RVTkVS
X1JFU0VUOgorCQlkcHJpbnRrKDEsICIlczogWEMyMDI4X1RVTkVSX1JFU0VU
ICVkLCBwb3J0ICVkXG4iLCBfX2Z1bmNfXywKKwkJCWFyZywgcG9ydC0+bnIp
OworCisJCWlmIChwb3J0LT5uciA9PSAxKQorCQkJcmVzZXRfbWFzayA9IDB4
MDEwMTsKKwkJZWxzZSBpZiAocG9ydC0+bnIgPT0gMikKKwkJCXJlc2V0X21h
c2sgPSAweDA0MDQ7CisKKwkJY3hfY2xlYXIoR1AwX0lPLCByZXNldF9tYXNr
KTsKKwkJbWRlbGF5KDUpOworCQljeF9zZXQoR1AwX0lPLCByZXNldF9tYXNr
KTsKKwkJYnJlYWs7CisJY2FzZSBYQzIwMjhfUkVTRVRfQ0xLOgorCQlkcHJp
bnRrKDEsICIlczogWEMyMDI4X1JFU0VUX0NMSyAlZFxuIiwgX19mdW5jX18s
IGFyZyk7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCWRwcmludGsoMSwgIiVz
OiB1bmtub3duIGNvbW1hbmQgJWQsIGFyZyAlZFxuIiwgX19mdW5jX18sCisJ
CSAgICAgICBjb21tYW5kLCBhcmcpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9
CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHN0cnVjdCB6bDEwMzUzX2Nv
bmZpZyBkdmljb19mdXNpb25oZHR2X3hjMzAyOCA9IHsKKwkuZGVtb2RfYWRk
cmVzcyA9IDB4MGYsCisJLmlmMiAgICAgICAgICAgPSA0NTYwMCwKKwkubm9f
dHVuZXIgICAgICA9IDEsCit9OworCiBzdGF0aWMgc3RydWN0IHM1aDE0MDlf
Y29uZmlnIGhhdXBwYXVnZV9odnIxNTAwcV9jb25maWcgPSB7CiAJLmRlbW9k
X2FkZHJlc3MgPSAweDMyID4+IDEsCiAJLm91dHB1dF9tb2RlICAgPSBTNUgx
NDA5X1NFUklBTF9PVVRQVVQsCkBAIC00NTQsNiArNDk1LDM5IEBACiAJCQkJ
ZmUtPm9wcy50dW5lcl9vcHMuc2V0X2NvbmZpZyhmZSwgJmN0bCk7CiAJCX0K
IAkJYnJlYWs7CisJY2FzZSBDWDIzODg1X0JPQVJEX0RWSUNPX0ZVU0lPTkhE
VFZfRFZCX1RfRFVBTF9FWFA6IHsKKwkJaTJjX2J1cyA9ICZkZXYtPmkyY19i
dXNbcG9ydC0+bnIgLSAxXTsKKworCQkvKiBUYWtlIGRlbW9kIGFuZCB0dW5l
ciBvdXQgb2YgcmVzZXQgKi8KKwkJaWYgKHBvcnQtPm5yID09IDEpCisJCQlj
eF9zZXQoR1AwX0lPLCAweDAzMDMpOworCQllbHNlIGlmIChwb3J0LT5uciA9
PSAyKQorCQkJY3hfc2V0KEdQMF9JTywgMHgwYzBjKTsKKwkJbWRlbGF5KDUp
OworCQlwb3J0LT5kdmIuZnJvbnRlbmQgPSBkdmJfYXR0YWNoKHpsMTAzNTNf
YXR0YWNoLAorCQkJCQkgICAgICAgJmR2aWNvX2Z1c2lvbmhkdHZfeGMzMDI4
LAorCQkJCQkgICAgICAgJmkyY19idXMtPmkyY19hZGFwKTsKKwkJaWYgKHBv
cnQtPmR2Yi5mcm9udGVuZCAhPSBOVUxMKSB7CisJCQlzdHJ1Y3QgZHZiX2Zy
b250ZW5kICAgICAgKmZlOworCQkJc3RydWN0IHhjMjAyOF9jb25maWcJICBj
ZmcgPSB7CisJCQkJLmkyY19hZGFwICA9ICZpMmNfYnVzLT5pMmNfYWRhcCwK
KwkJCQkuaTJjX2FkZHIgID0gMHg2MSwKKwkJCQkudmlkZW9fZGV2ID0gcG9y
dCwKKwkJCQkuY2FsbGJhY2sgID0gY3gyMzg4NV9kdmljb194YzIwMjhfY2Fs
bGJhY2ssCisJCQl9OworCQkJc3RhdGljIHN0cnVjdCB4YzIwMjhfY3RybCBj
dGwgPSB7CisJCQkJLmZuYW1lICAgICAgID0gInhjMzAyOC1kdmljby1hdS0w
MS5mdyIsCisJCQkJLm1heF9sZW4gICAgID0gNjQsCisJCQkJLnNjb2RlX3Rh
YmxlID0gWkFSTElOSzQ1NiwKKwkJCX07CisKKwkJCWZlID0gZHZiX2F0dGFj
aCh4YzIwMjhfYXR0YWNoLCBwb3J0LT5kdmIuZnJvbnRlbmQsCisJCQkJCSZj
ZmcpOworCQkJaWYgKGZlICE9IE5VTEwgJiYgZmUtPm9wcy50dW5lcl9vcHMu
c2V0X2NvbmZpZyAhPSBOVUxMKQorCQkJCWZlLT5vcHMudHVuZXJfb3BzLnNl
dF9jb25maWcoZmUsICZjdGwpOworCQl9CisJCWJyZWFrOworICAgICAgICB9
CiAJZGVmYXVsdDoKIAkJcHJpbnRrKCIlczogVGhlIGZyb250ZW5kIG9mIHlv
dXIgRFZCL0FUU0MgY2FyZCBpc24ndCBzdXBwb3J0ZWQgeWV0XG4iLAogCQkg
ICAgICAgZGV2LT5uYW1lKTsKZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L2Ry
aXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LmggdjRsLWR2Yl9k
ZXYvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUu
aAotLS0gdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvY3gyMzg4NS5oCTIwMDgtMDUtMTQgMDk6NDg6MjIuMDAwMDAwMDAwICsx
MDAwCisrKyB2NGwtZHZiX2Rldi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4MjM4ODUvY3gyMzg4NS5oCTIwMDgtMDUtMTQgMTM6Mzk6MzAuMDAwMDAw
MDAwICsxMDAwCkBAIC02Niw2ICs2Niw3IEBACiAjZGVmaW5lIENYMjM4ODVf
Qk9BUkRfSEFVUFBBVUdFX0hWUjEyMDAgICAgICAgIDcKICNkZWZpbmUgQ1gy
Mzg4NV9CT0FSRF9IQVVQUEFVR0VfSFZSMTcwMCAgICAgICAgOAogI2RlZmlu
ZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNDAwICAgICAgICA5Cisj
ZGVmaW5lIENYMjM4ODVfQk9BUkRfRFZJQ09fRlVTSU9OSERUVl9EVkJfVF9E
VUFMX0VYUCAxMAogCiAvKiBDdXJyZW50bHkgdW5zdXBwb3J0ZWQgYnkgdGhl
IGRyaXZlcjogUEFML0gsIE5UU0MvS3IsIFNFQ0FNIEIvRy9IL0xDICovCiAj
ZGVmaW5lIENYMjM4ODVfTk9STVMgKFwKZGlmZiAtTmF1ciB2NGwtZHZiL2xp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9LY29uZmlnIHY0bC1k
dmJfZGV2L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9LY29u
ZmlnCi0tLSB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gy
Mzg4NS9LY29uZmlnCTIwMDgtMDUtMTQgMDk6NDg6MjIuMDAwMDAwMDAwICsx
MDAwCisrKyB2NGwtZHZiX2Rldi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4MjM4ODUvS2NvbmZpZwkyMDA4LTA1LTE0IDEzOjM5OjMwLjAwMDAwMDAw
MCArMTAwMApAQCAtMTUsNiArMTUsNyBAQAogCXNlbGVjdCBNRURJQV9UVU5F
Ul9NVDIxMzEgaWYgIURWQl9GRV9DVVNUT01JU0UKIAlzZWxlY3QgRFZCX1M1
SDE0MDkgaWYgIURWQl9GRV9DVVNUT01JU0UKIAlzZWxlY3QgRFZCX0xHRFQz
MzBYIGlmICFEVkJfRkVfQ1VTVE9NSVNFCisgCXNlbGVjdCBEVkJfWkwxMDM1
MyBpZiAhRFZCX0ZFX0NVU1RPTUlTRQogCXNlbGVjdCBNRURJQV9UVU5FUl9Y
QzIwMjggaWYgIURWQl9GRV9DVVNUT01JWkUKIAlzZWxlY3QgTUVESUFfVFVO
RVJfVERBODI5MCBpZiAhRFZCX0ZFX0NVU1RPTUlaRQogCXNlbGVjdCBNRURJ
QV9UVU5FUl9UREExODI3MSBpZiAhRFZCX0ZFX0NVU1RPTUlaRQo=

--_----------=_1210744471264054
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1210744471264054--
