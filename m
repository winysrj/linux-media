Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KQL3M-0000aJ-68
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 13:50:13 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	D37E61804071
	for <linux-dvb@linuxtv.org>; Tue,  5 Aug 2008 11:49:37 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Tue, 5 Aug 2008 21:47:57 +1000
Message-Id: <20080805114757.5502411581F@ws1-7.us4.outblaze.com>
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
Content-Type: multipart/mixed; boundary="===============1134412618=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1134412618==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1217936877175500"

This is a multi-part message in MIME format.

--_----------=_1217936877175500
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Steve,

I have reworked the tuner callback now against your branch at:
http://linuxtv.org/hg/~stoth/v4l-dvb

The new Patch (to add support for this card) is attached inline below for
testing (this is a hint Mark & Jon), I have not provided a signed-off
note on purpose as I want to solve the issue mentioned in the next
paragraph first.

Regarding the cx25840 module; the card doesn't seem to initialise
properly (no DVB output and DMA errors in log) unless I have this
requested.  Once the card is up and running I can unload all drivers,
recompile without the cx25840 and load and it will work again until I
power off the computer and back on again (This has been tedious trying to
work out which setting I had missed).  Is there some initialisation work
being performed in the cx25840 module that I can incorporate into my
patch to remove this dependency? Or should I leave it as is?

Anyway nearly bedtime here.

Regards,
Stephen.


--------Patch------
diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885
--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-08-05 16:48:13.000000000 +1000
+++ v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885=20=20=20
2008-08-05 20:07:16.000000000 +1000
@@ -10,3 +10,4 @@
9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
+ 12 -> Leadtek Winfast PxDVR3200 H                         [107d:6681]
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-08-05 16:48:14.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c=20=20=20
2008-08-05 21:29:59.000000000 +1000
@@ -155,6 +155,10 @@
.portb    =3D CX23885_MPEG_DVB,
.portc    =3D CX23885_MPEG_DVB,
},
+    [CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] =3D {
+    .name    =3D "Leadtek Winfast PxDVR3200 H",
+    .portc    =3D CX23885_MPEG_DVB,
+    },
 };
 const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);

@@ -230,7 +234,11 @@
.subvendor =3D 0x18ac,
.subdevice =3D 0xdb78,
.card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
-    },
+    },{
+ .subvendor =3D 0x107d,
+ .subdevice =3D 0x6681,
+ .card      =3D CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
+  },
 };
 const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);

@@ -353,6 +361,10 @@
if (command =3D=3D 0)
bitmask =3D 0x04;
break;
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+    /* Tuner Reset Command */
+    bitmask =3D 0x00070404;
+    break;
case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
if (command =3D=3D 0) {
@@ -492,6 +504,15 @@
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
+    break;
}
 }

@@ -579,6 +600,7 @@
case CX23885_BOARD_HAUPPAUGE_HVR1200:
case CX23885_BOARD_HAUPPAUGE_HVR1700:
case CX23885_BOARD_HAUPPAUGE_HVR1400:
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
default:
ts2->gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */
ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
@@ -592,6 +614,7 @@
case CX23885_BOARD_HAUPPAUGE_HVR1800:
case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
case CX23885_BOARD_HAUPPAUGE_HVR1700:
+    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
request_module("cx25840");
break;
}
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c    2008-08-05
16:48:14.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c=20=20=20
2008-08-05 21:29:00.000000000 +1000
@@ -37,6 +37,7 @@
 #include "tda8290.h"
 #include "tda18271.h"
 #include "lgdt330x.h"
+#include "zl10353.h"
 #include "xc5000.h"
 #include "tda10048.h"
 #include "tuner-xc2028.h"
@@ -502,6 +503,32 @@
}
break;
}
+ case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+ i2c_bus =3D &dev->i2c_bus[0];
+
+ port->dvb.frontend =3D dvb_attach(zl10353_attach,
+ &dvico_fusionhdtv_xc3028,
+ &i2c_bus->i2c_adap);
+ if (port->dvb.frontend !=3D NULL) {
+ struct dvb_frontend      *fe;
+ struct xc2028_config    cfg =3D {
+ .i2c_adap  =3D &dev->i2c_bus[1].i2c_adap,
+ .i2c_addr  =3D 0x61,
+ .video_dev =3D port,
+ .callback  =3D cx23885_tuner_callback,
+ };
+ static struct xc2028_ctrl ctl =3D {
+ .fname       =3D "xc3028-v27.fw",
+ .max_len     =3D 64,
+ .demod       =3D XC3028_FE_ZARLINK456,
+ };
+
+ fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,
+ &cfg);
+ if (fe !=3D NULL && fe->ops.tuner_ops.set_config !=3D NULL)
+ fe->ops.tuner_ops.set_config(fe, &ctl);
+ }
+ break;
default:
printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
dev->name);
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h    2008-08-05
16:48:14.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h    2008-08-05
20:10:57.000000000 +1000
@@ -66,6 +66,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12

 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC
*/
 #define CX23885_NORMS (\
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig
v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig
--- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig    2008-08-05
16:48:14.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig    2008-08-05
20:06:06.000000000 +1000
@@ -15,6 +15,7 @@
select DVB_S5H1409 if !DVB_FE_CUSTOMISE
select DVB_S5H1411 if !DVB_FE_CUSTOMISE
select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+ select DVB_ZL10353 if !DVB_FE_CUSTOMISE
select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE



-------End Patch-------

  ----- Original Message -----
  From: "Steven Toth"
  To: stev391@email.com
  Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast
  PxDVR 3200 H - DVB Only support
  Date: Mon, 04 Aug 2008 10:35:20 -0400


  > case CX23885_BOARD_HAUPPAUGE_HVR1800:
  > case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
  > case CX23885_BOARD_HAUPPAUGE_HVR1700:
  > + case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
  > request_module("cx25840");
  > break;
  > }

  Steve, thanks for look at this.

  I took a quick look at your patch. Obviously the callback stuff
  you're planning to re-work will be based Antons patch, which I plan
  to push tonight after more testing.... So I'm ignoring this.

  Minor nitpick... Don't request module cx25840 above unless you plan
  to use it. If you are planning to add analog support, make this a
  second patch after the digital stuff gets merged.

  Other than that, it will be great to have another product supported
  in the tree.

  Regards,

  - Steve

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1217936877175500
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>


<div>
Steve,<br><br>I have reworked the tuner callback now against your branch at=
:<span id=3D"obmessage"><br>http://linuxtv.org/hg/~stoth/v4l-dvb<br><br>The=
 new Patch (to add support for this card) is attached inline below for test=
ing (this is a hint Mark &amp; Jon), I have not provided a signed-off note =
on purpose as I want to solve the issue mentioned in the next paragraph fir=
st.<br><br>Regarding the cx25840 module; the card doesn't seem to initialis=
e properly (no DVB output and DMA errors in log) unless I have this request=
ed.&nbsp; Once the card is up and running I can unload all drivers, recompi=
le without the cx25840 and load and it will work again until I power off th=
e computer and back on again (This has been tedious trying to work out whic=
h setting I had missed).&nbsp; Is there some initialisation work being perf=
ormed in the cx25840 module that I can incorporate into my patch to remove =
this dependency? Or should I leave it as is?<br><br>Anyway nearly bedtime h=
ere.<br><br>Regards,<br>Stephen.<br></span>
<br><br>--------Patch------<br>diff -Naur v4l-dvb/linux/Documentation/video=
4linux/CARDLIST.cx23885 v4l-dvb2/linux/Documentation/video4linux/CARDLIST.c=
x23885<br>--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885&nbsp=
;&nbsp;&nbsp; 2008-08-05 16:48:13.000000000 +1000<br>+++ v4l-dvb2/linux/Doc=
umentation/video4linux/CARDLIST.cx23885&nbsp;&nbsp;&nbsp; 2008-08-05 20:07:=
16.000000000 +1000<br>@@ -10,3 +10,4 @@<br>&nbsp;&nbsp; 9 -&gt; Hauppauge W=
inTV-HVR1400&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [0070:8010]<br>&nbsp; 10 -&gt; DViCO FusionH=
DTV7 Dual Express&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [18ac:=
d618]<br>&nbsp; 11 -&gt; DViCO FusionHDTV DVB-T Dual Express&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; [18ac:db78]<br>+ 12 -&gt; Leadtek Winfast PxDVR3200 H&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [107d:6681]<br>diff =
-Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb2/li=
nux/drivers/media/video/cx23885/cx23885-cards.c<br>--- v4l-dvb/linux/driver=
s/media/video/cx23885/cx23885-cards.c&nbsp;&nbsp;&nbsp; 2008-08-05 16:48:14=
.000000000 +1000<br>+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-=
cards.c&nbsp;&nbsp;&nbsp; 2008-08-05 21:29:59.000000000 +1000<br>@@ -155,6 =
+155,10 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portb&nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>&nbsp;&nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; .portc&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D CX2388=
5_MPEG_DVB,<br>&nbsp;&nbsp;&nbsp;&nbsp; },<br>+&nbsp;&nbsp;&nbsp; [CX23885_=
BOARD_LEADTEK_WINFAST_PXDVR3200_H] =3D {<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp=
;&nbsp; .name&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =3D "Leadtek Winfast PxD=
VR3200 H",<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .portc&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; =3D CX23885_MPEG_DVB,<br>+&nbsp;&nbsp;&nbsp; },<br>&n=
bsp;};<br>&nbsp;const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_bo=
ards);<br>&nbsp;<br>@@ -230,7 +234,11 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; .subvendor =3D 0x18ac,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp=
;&nbsp; .subdevice =3D 0xdb78,<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; .card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D CX23885_BOARD_DVICO_FUSIONHDTV_D=
VB_T_DUAL_EXP,<br>-&nbsp;&nbsp;&nbsp; },<br>+&nbsp;&nbsp;&nbsp; },{<br>+ &n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .subvendor =3D 0x107d,<br>+ &nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; .subdevice =3D 0x6681,<br>+ &nbsp;&nbsp;&nbsp; &=
nbsp;&nbsp;&nbsp; .card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D CX23885_BOARD_LEA=
DTEK_WINFAST_PXDVR3200_H,<br>+&nbsp; &nbsp;&nbsp;&nbsp; },<br>&nbsp;};<br>&=
nbsp;const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);<br>=
&nbsp;<br>@@ -353,6 +361,10 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; if (command =3D=3D 0)<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nb=
sp;&nbsp;&nbsp; bitmask =3D 0x04;<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LEADTEK_WINFAST_PXDV=
R3200_H:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* Tuner Reset Command *=
/<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; bitmask =3D 0x00070404;<br>+&nb=
sp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;<br>&nbsp;&nbsp;&nbsp;&nbsp; case =
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:<br>&nbsp;&nbsp;&nbsp;&nbsp; case=
 CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>&nbsp;&nbsp;&nbsp;&nbsp;=
 &nbsp;&nbsp;&nbsp; if (command =3D=3D 0) {<br>@@ -492,6 +504,15 @@<br>&nbs=
p;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(20);<br>&nbsp;&nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x000f000f);<br>&nbsp;&nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; break;<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LE=
ADTEK_WINFAST_PXDVR3200_H:<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* GPI=
O-2&nbsp; xc3028 tuner reset */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /=
* Put the parts into reset and back */<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&=
nbsp; cx_set(GP0_IO, 0x00040000);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=
 mdelay(20);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_clear(GP0_IO, 0x0=
0000004);<br>+&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; mdelay(20);<br>+&nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; cx_set(GP0_IO, 0x00040004);<br>+&nbsp;&nbsp;=
&nbsp; &nbsp;&nbsp;&nbsp; break;<br>&nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;}<b=
r>&nbsp;<br>@@ -579,6 +600,7 @@<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BO=
ARD_HAUPPAUGE_HVR1200:<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BOARD_HAUPP=
AUGE_HVR1700:<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX23885_BOARD_HAUPPAUGE_HVR1=
400:<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:=
<br>&nbsp;&nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; ts2-&gt;gen_ctrl_val&nbsp; =3D 0xc; /* Serial bus + punctured clo=
ck */<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ts2-&gt;ts_clk_en_val =
=3D 0x1; /* Enable TS_CLK */<br>@@ -592,6 +614,7 @@<br>&nbsp;&nbsp;&nbsp;&n=
bsp; case CX23885_BOARD_HAUPPAUGE_HVR1800:<br>&nbsp;&nbsp;&nbsp;&nbsp; case=
 CX23885_BOARD_HAUPPAUGE_HVR1800lp:<br>&nbsp;&nbsp;&nbsp;&nbsp; case CX2388=
5_BOARD_HAUPPAUGE_HVR1700:<br>+&nbsp;&nbsp;&nbsp; case CX23885_BOARD_LEADTE=
K_WINFAST_PXDVR3200_H:<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; reque=
st_module("cx25840");<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; break;=
<br>&nbsp;&nbsp;&nbsp;&nbsp; }<br>diff -Naur v4l-dvb/linux/drivers/media/vi=
deo/cx23885/cx23885-dvb.c v4l-dvb2/linux/drivers/media/video/cx23885/cx2388=
5-dvb.c<br>--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c&nbsp=
;&nbsp;&nbsp; 2008-08-05 16:48:14.000000000 +1000<br>+++ v4l-dvb2/linux/dri=
vers/media/video/cx23885/cx23885-dvb.c&nbsp;&nbsp;&nbsp; 2008-08-05 21:29:0=
0.000000000 +1000<br>@@ -37,6 +37,7 @@<br>&nbsp;#include "tda8290.h"<br>&nb=
sp;#include "tda18271.h"<br>&nbsp;#include "lgdt330x.h"<br>+#include "zl103=
53.h"<br>&nbsp;#include "xc5000.h"<br>&nbsp;#include "tda10048.h"<br>&nbsp;=
#include "tuner-xc2028.h"<br>@@ -502,6 +503,32 @@<br>&nbsp;&nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; brea=
k;<br>&nbsp;&nbsp;&nbsp;&nbsp; }<br>+ &nbsp;&nbsp;&nbsp; case CX23885_BOARD=
_LEADTEK_WINFAST_PXDVR3200_H:<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; i2=
c_bus =3D &amp;dev-&gt;i2c_bus[0];<br>+ <br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; port-&gt;dvb.frontend =3D dvb_attach(zl10353_attach,<br>+ &nbsp;&n=
bsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;dvico_fusionhdtv_xc30=
28,<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nb=
sp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;i2c_=
bus-&gt;i2c_adap);<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; if (port-&gt;=
dvb.frontend !=3D NULL) {<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; struct dvb_frontend&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *fe;<br>+ &n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; struct xc2028_config=
&nbsp;&nbsp;&nbsp; &nbsp; cfg =3D {<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nb=
sp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .i2c_adap&nbsp; =3D &amp;dev-&gt;=
i2c_bus[1].i2c_adap,<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp=
;&nbsp; &nbsp;&nbsp;&nbsp; .i2c_addr&nbsp; =3D 0x61,<br>+ &nbsp;&nbsp;&nbsp=
; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .video_dev =3D p=
ort,<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp; .callback&nbsp; =3D cx23885_tuner_callback,<br>+ &nbsp;&nbsp;&nb=
sp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; };<br>+ &nbsp;&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; static struct xc2028_ctrl ctl =3D {<br>+ &n=
bsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .=
fname&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D "xc3028-v27.fw",<br>+ &nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .max_l=
en&nbsp;&nbsp;&nbsp;&nbsp; =3D 64,<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; .demod&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; =3D XC3028_FE_ZARLINK456,<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; };<br>+ <br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &=
nbsp;&nbsp;&nbsp; fe =3D dvb_attach(xc2028_attach, port-&gt;dvb.frontend,<b=
r>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; &amp;cfg);<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbs=
p; &nbsp;&nbsp;&nbsp; if (fe !=3D NULL &amp;&amp; fe-&gt;ops.tuner_ops.set_=
config !=3D NULL)<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp; &nbsp;&nbsp;&nbsp; fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>+=
 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; }<br>+ &nbsp;&nbsp;&nbsp; &nbsp;&nbs=
p;&nbsp; break;<br>&nbsp;&nbsp;&nbsp;&nbsp; default:<br>&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; printk("%s: The frontend of your DVB/ATSC card isn=
't supported yet\n",<br>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev-&gt;name);<br>diff -Naur v4l-dvb/linux/dr=
ivers/media/video/cx23885/cx23885.h v4l-dvb2/linux/drivers/media/video/cx23=
885/cx23885.h<br>--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h&nb=
sp;&nbsp;&nbsp; 2008-08-05 16:48:14.000000000 +1000<br>+++ v4l-dvb2/linux/d=
rivers/media/video/cx23885/cx23885.h&nbsp;&nbsp;&nbsp; 2008-08-05 20:10:57.=
000000000 +1000<br>@@ -66,6 +66,7 @@<br>&nbsp;#define CX23885_BOARD_HAUPPAU=
GE_HVR1400&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9<br>&nbsp;#define CX2=
3885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10<br>&nbsp;#define CX23885_BOARD_DV=
ICO_FUSIONHDTV_DVB_T_DUAL_EXP 11<br>+#define CX23885_BOARD_LEADTEK_WINFAST_=
PXDVR3200_H 12<br>&nbsp;<br>&nbsp;/* Currently unsupported by the driver: P=
AL/H, NTSC/Kr, SECAM B/G/H/LC */<br>&nbsp;#define CX23885_NORMS (\<br>diff =
-Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig v4l-dvb2/linux/driv=
ers/media/video/cx23885/Kconfig<br>--- v4l-dvb/linux/drivers/media/video/cx=
23885/Kconfig&nbsp;&nbsp;&nbsp; 2008-08-05 16:48:14.000000000 +1000<br>+++ =
v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig&nbsp;&nbsp;&nbsp; 2008-0=
8-05 20:06:06.000000000 +1000<br>@@ -15,6 +15,7 @@<br>&nbsp;&nbsp;&nbsp;&nb=
sp; select DVB_S5H1409 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; sel=
ect DVB_S5H1411 if !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select DVB=
_LGDT330X if !DVB_FE_CUSTOMISE<br>+ &nbsp;&nbsp;&nbsp; select DVB_ZL10353 i=
f !DVB_FE_CUSTOMISE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_XC2028 i=
f !DVB_FE_CUSTOMIZE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_TDA8290 =
if !DVB_FE_CUSTOMIZE<br>&nbsp;&nbsp;&nbsp;&nbsp; select MEDIA_TUNER_TDA1827=
1 if !DVB_FE_CUSTOMIZE<br><br><br><br>-------End Patch-------<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Steven Toth" <stoth@linuxtv.org><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 320=
0 H - DVB Only support<br>
Date: Mon, 04 Aug 2008 10:35:20 -0400<br>
<br>

<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1800:<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1800lp:<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1700:<br>
&gt; +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
&gt;          request_module("cx25840");<br>
&gt;          break;<br>
&gt;      }<br>
<br>
Steve, thanks for look at this.<br>
<br>
I took a quick look at your patch. Obviously the callback stuff <br>
you're planning to re-work will be based Antons patch, which I plan <br>
to push tonight after more testing.... So I'm ignoring this.<br>
<br>
Minor nitpick... Don't request module cx25840 above unless you plan <br>
to use it. If you are planning to add analog support, make this a <br>
second patch after the digital stuff gets merged.<br>
<br>
Other than that, it will be great to have another product supported <br>
in the tree.<br>
<br>
Regards,<br>
<br>
- Steve<br>
</stoth@linuxtv.org></blockquote>
</div>


</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1217936877175500--



--===============1134412618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1134412618==--
