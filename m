Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <123kash@gmail.com>) id 1NZKpm-0007qt-Er
	for linux-dvb@linuxtv.org; Mon, 25 Jan 2010 10:02:11 +0100
Received: from mail-bw0-f214.google.com ([209.85.218.214])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NZKpl-0002Pr-Pb; Mon, 25 Jan 2010 10:02:10 +0100
Received: by bwz6 with SMTP id 6so2457774bwz.11
	for <linux-dvb@linuxtv.org>; Mon, 25 Jan 2010 01:02:08 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 25 Jan 2010 12:02:08 +0300
Message-ID: <d7fc510e1001250102j7bbc29ces674cd297c41403be@mail.gmail.com>
From: Sergey Ivanov <123kash@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Twinhan 1027 (once again)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0537407733=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0537407733==
Content-Type: multipart/alternative; boundary=00032555415a934489047df96c44

--00032555415a934489047df96c44
Content-Type: text/plain; charset=ISO-8859-1

When v4l-dvb starts to support this card? You already have well tested patch
for this purpose. But it still "experimental". I had one doubt, i'm not sure
if we need all of those chips, that patch contain, cos this card has only
cx88x & mb86a16, so i exclude em, and it looks work.


diff -r 2a50a0a1c951 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c    Sat Jan 23 00:14:32
2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c    Sun Jan 24 15:04:25
2010 +0300
@@ -2120,6 +2120,18 @@
         } },
         .mpeg           = CX88_MPEG_DVB,
     },
+    [CX88_BOARD_TWINHAN_VP1027_DVBS] = {
+            .name           = "Twinhan VP-1027 DVB-S",
+        .tuner_type     = TUNER_ABSENT,
+        .radio_type     = UNSET,
+        .tuner_addr     = ADDR_UNSET,
+        .radio_addr     = ADDR_UNSET,
+        .input          = {{
+               .type   = CX88_VMUX_DVB,
+               .vmux   = 0,
+            } },
+        .mpeg           = CX88_MPEG_DVB,
+    },
 };

 /* ------------------------------------------------------------------ */
@@ -2584,6 +2596,10 @@
         .subvendor = 0xb034,
         .subdevice = 0x3034,
         .card      = CX88_BOARD_PROF_7301,
+    }, {
+            .subvendor = 0x1822,
+                .subdevice = 0x0023,
+                .card      = CX88_BOARD_TWINHAN_VP1027_DVBS,
     },
 };

@@ -3075,6 +3091,13 @@
         cx_set(MO_GP1_IO, 0x10);
         mdelay(50);
         break;
+
+    case CX88_BOARD_TWINHAN_VP1027_DVBS:
+        cx_write(MO_GP0_IO, 0x00003230);
+        cx_write(MO_GP0_IO, 0x00003210);
+        msleep(1);
+        cx_write(MO_GP0_IO, 0x00001230);
+        break;
     }
 }

diff -r 2a50a0a1c951 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c    Sat Jan 23 00:14:32 2010
-0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c    Sun Jan 24 15:04:25 2010
+0300
@@ -57,6 +57,7 @@
 #include "stv0900.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
+#include "mb86a16.h"

 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -251,6 +252,10 @@
     .if2           = 45600,
 };

+static struct mb86a16_config twinhan_vp1027 = {
+    .demod_address  = 0x08,
+};
+
 #if defined(CONFIG_VIDEO_CX88_VP3054) ||
(defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 {
@@ -446,6 +451,30 @@
     return 0;
 }

+static int vp1027_set_voltage(struct dvb_frontend *fe,
+                    fe_sec_voltage_t voltage)
+{
+    struct cx8802_dev *dev = fe->dvb->priv;
+    struct cx88_core *core = dev->core;
+    switch (voltage) {
+          case SEC_VOLTAGE_OFF:
+            dprintk(1, "LNB Voltage OFF\n");
+            cx_write(MO_GP0_IO, 0x00001230);
+            break;
+          case SEC_VOLTAGE_13:
+            dprintk(1, "LNB SEC Voltage=13\n");
+            cx_write(MO_GP0_IO, 0x00001220);
+            break;
+          case SEC_VOLTAGE_18:
+            dprintk(1, "LNB SEC Voltage=18\n");
+            cx_write(MO_GP0_IO, 0x00001222);
+            break;
+    }
+    if (core->prev_set_voltage)
+          return core->prev_set_voltage(fe, voltage);
+    return 0;
+};
+
 static struct cx24123_config geniatech_dvbs_config = {
     .demod_address = 0x55,
     .set_ts_params = cx24123_set_ts_param,
@@ -1210,6 +1239,17 @@
         }
         break;
         }
+    case CX88_BOARD_TWINHAN_VP1027_DVBS:
+        dev->ts_gen_cntrl = 0x00;
+        fe0->dvb.frontend = dvb_attach(mb86a16_attach,
+                        &twinhan_vp1027,
+                        &core->i2c_adap);
+        if (fe0->dvb.frontend) {
+            core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
+            fe0->dvb.frontend->ops.set_voltage = vp1027_set_voltage;
+        }
+            break;
+
     default:
         printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't
supported yet\n",
                core->name);
diff -r 2a50a0a1c951 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h    Sat Jan 23 00:14:32 2010
-0200
+++ b/linux/drivers/media/video/cx88/cx88.h    Sun Jan 24 15:04:25 2010
+0300
@@ -240,6 +240,7 @@
 #define CX88_BOARD_WINFAST_DTV1800H        81
 #define CX88_BOARD_WINFAST_DTV2000H_J      82
 #define CX88_BOARD_PROF_7301               83
+#define CX88_BOARD_TWINHAN_VP1027_DVBS     84

 enum cx88_itype {
     CX88_VMUX_COMPOSITE1 = 1,

--00032555415a934489047df96c44
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

When v4l-dvb starts to support this card? You already have well tested patc=
h for this purpose. But it still &quot;experimental&quot;. I had one doubt,=
 i&#39;m not sure if we need all of those chips, that patch contain, cos th=
is card has only cx88x &amp; mb86a16, so i exclude em, and it looks work.<b=
r>
<br><br>diff -r 2a50a0a1c951 linux/drivers/media/video/cx88/cx88-cards.c<br=
>--- a/linux/drivers/media/video/cx88/cx88-cards.c=A0=A0=A0 Sat Jan 23 00:1=
4:32 2010 -0200<br>+++ b/linux/drivers/media/video/cx88/cx88-cards.c=A0=A0=
=A0 Sun Jan 24 15:04:25 2010 +0300<br>
@@ -2120,6 +2120,18 @@<br>=A0=A0=A0=A0 =A0=A0=A0 } },<br>=A0=A0=A0=A0 =A0=
=A0=A0 .mpeg=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D CX88_MPEG_DVB,<br>=A0=A0=A0=
=A0 },<br>+=A0=A0=A0 [CX88_BOARD_TWINHAN_VP1027_DVBS] =3D {<br>+=A0=A0=A0 =
=A0=A0=A0=A0=A0=A0=A0 .name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D &quot;Twinhan=
 VP-1027 DVB-S&quot;,<br>+=A0=A0=A0 =A0=A0=A0 .tuner_type=A0=A0=A0=A0 =3D T=
UNER_ABSENT,<br>
+=A0=A0=A0 =A0=A0=A0 .radio_type=A0=A0=A0=A0 =3D UNSET,<br>+=A0=A0=A0 =A0=
=A0=A0 .tuner_addr=A0=A0=A0=A0 =3D ADDR_UNSET,<br>+=A0=A0=A0 =A0=A0=A0 .rad=
io_addr=A0=A0=A0=A0 =3D ADDR_UNSET,<br>+=A0=A0=A0 =A0=A0=A0 .input=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =3D {{<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 .type=
=A0=A0 =3D CX88_VMUX_DVB,<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 .vmux=
=A0=A0 =3D 0,<br>
+=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 } },<br>+=A0=A0=A0 =A0=A0=A0 .mpeg=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D CX88_MPEG_DVB,<br>+=A0=A0=A0 },<br>=A0};<br>=
=A0<br>=A0/* --------------------------------------------------------------=
---- */<br>@@ -2584,6 +2596,10 @@<br>=A0=A0=A0=A0 =A0=A0=A0 .subvendor =3D =
0xb034,<br>
=A0=A0=A0=A0 =A0=A0=A0 .subdevice =3D 0x3034,<br>=A0=A0=A0=A0 =A0=A0=A0 .ca=
rd=A0=A0=A0=A0=A0 =3D CX88_BOARD_PROF_7301,<br>+=A0=A0=A0 }, {<br>+=A0=A0=
=A0 =A0=A0=A0=A0=A0=A0=A0 .subvendor =3D 0x1822,<br>+=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 .subdevice =3D 0x0023,<br>+=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 .card=A0=A0=A0=A0=A0 =3D CX88_BOARD_TWINHAN_VP1027=
_DVBS,<br>
=A0=A0=A0=A0 },<br>=A0};<br>=A0<br>@@ -3075,6 +3091,13 @@<br>=A0=A0=A0=A0 =
=A0=A0=A0 cx_set(MO_GP1_IO, 0x10);<br>=A0=A0=A0=A0 =A0=A0=A0 mdelay(50);<br=
>=A0=A0=A0=A0 =A0=A0=A0 break;<br>+<br>+=A0=A0=A0 case CX88_BOARD_TWINHAN_V=
P1027_DVBS:<br>+=A0=A0=A0 =A0=A0=A0 cx_write(MO_GP0_IO, 0x00003230);<br>
+=A0=A0=A0 =A0=A0=A0 cx_write(MO_GP0_IO, 0x00003210);<br>+=A0=A0=A0 =A0=A0=
=A0 msleep(1);<br>+=A0=A0=A0 =A0=A0=A0 cx_write(MO_GP0_IO, 0x00001230);<br>=
+=A0=A0=A0 =A0=A0=A0 break;<br>=A0=A0=A0=A0 }<br>=A0}<br>=A0<br>diff -r 2a5=
0a0a1c951 linux/drivers/media/video/cx88/cx88-dvb.c<br>--- a/linux/drivers/=
media/video/cx88/cx88-dvb.c=A0=A0=A0 Sat Jan 23 00:14:32 2010 -0200<br>
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c=A0=A0=A0 Sun Jan 24 15:04:2=
5 2010 +0300<br>@@ -57,6 +57,7 @@<br>=A0#include &quot;stv0900.h&quot;<br>=
=A0#include &quot;stb6100.h&quot;<br>=A0#include &quot;stb6100_proc.h&quot;=
<br>+#include &quot;mb86a16.h&quot;<br>
=A0<br>=A0MODULE_DESCRIPTION(&quot;driver for cx2388x based DVB cards&quot;=
);<br>=A0MODULE_AUTHOR(&quot;Chris Pascoe &lt;<a href=3D"mailto:c.pascoe@it=
ee.uq.edu.au">c.pascoe@itee.uq.edu.au</a>&gt;&quot;);<br>@@ -251,6 +252,10 =
@@<br>
=A0=A0=A0=A0 .if2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 45600,<br>=A0};<br>=A0<=
br>+static struct mb86a16_config twinhan_vp1027 =3D {<br>+=A0=A0=A0 .demod_=
address=A0 =3D 0x08,<br>+};<br>+<br>=A0#if defined(CONFIG_VIDEO_CX88_VP3054=
) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) &amp;&amp; defined(MODULE))<=
br>
=A0static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)<br>=A0=
{<br>@@ -446,6 +451,30 @@<br>=A0=A0=A0=A0 return 0;<br>=A0}<br>=A0<br>+stat=
ic int vp1027_set_voltage(struct dvb_frontend *fe,<br>+=A0=A0=A0 =A0=A0=A0 =
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 fe_sec_voltage_t voltage)<br>
+{<br>+=A0=A0=A0 struct cx8802_dev *dev =3D fe-&gt;dvb-&gt;priv;<br>+=A0=A0=
=A0 struct cx88_core *core =3D dev-&gt;core;<br>+=A0=A0=A0 switch (voltage)=
 {<br>+=A0=A0=A0 =A0=A0=A0=A0=A0 case SEC_VOLTAGE_OFF:<br>+=A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0 dprintk(1, &quot;LNB Voltage OFF\n&quot;);<br>
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 cx_write(MO_GP0_IO, 0x00001230);<br>+=A0=A0=
=A0 =A0=A0=A0 =A0=A0=A0 break;<br>+=A0=A0=A0 =A0=A0=A0=A0=A0 case SEC_VOLTA=
GE_13:<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dprintk(1, &quot;LNB SEC Voltage=
=3D13\n&quot;);<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 cx_write(MO_GP0_IO, 0x000=
01220);<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;<br>
+=A0=A0=A0 =A0=A0=A0=A0=A0 case SEC_VOLTAGE_18:<br>+=A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 dprintk(1, &quot;LNB SEC Voltage=3D18\n&quot;);<br>+=A0=A0=A0 =A0=A0=
=A0 =A0=A0=A0 cx_write(MO_GP0_IO, 0x00001222);<br>+=A0=A0=A0 =A0=A0=A0 =A0=
=A0=A0 break;<br>+=A0=A0=A0 }<br>+=A0=A0=A0 if (core-&gt;prev_set_voltage)<=
br>+=A0=A0=A0 =A0=A0=A0=A0=A0 return core-&gt;prev_set_voltage(fe, voltage)=
;<br>
+=A0=A0=A0 return 0;<br>+};<br>+<br>=A0static struct cx24123_config geniate=
ch_dvbs_config =3D {<br>=A0=A0=A0=A0 .demod_address =3D 0x55,<br>=A0=A0=A0=
=A0 .set_ts_params =3D cx24123_set_ts_param,<br>@@ -1210,6 +1239,17 @@<br>=
=A0=A0=A0=A0 =A0=A0=A0 }<br>=A0=A0=A0=A0 =A0=A0=A0 break;<br>
=A0=A0=A0=A0 =A0=A0=A0 }<br>+=A0=A0=A0 case CX88_BOARD_TWINHAN_VP1027_DVBS:=
<br>+=A0=A0=A0 =A0=A0=A0 dev-&gt;ts_gen_cntrl =3D 0x00;<br>+=A0=A0=A0 =A0=
=A0=A0 fe0-&gt;dvb.frontend =3D dvb_attach(mb86a16_attach,<br>+=A0=A0=A0 =
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 &amp;twinhan_vp1027,<br>+=
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 &amp;core-&gt;i=
2c_adap);<br>
+=A0=A0=A0 =A0=A0=A0 if (fe0-&gt;dvb.frontend) {<br>+=A0=A0=A0 =A0=A0=A0 =
=A0=A0=A0 core-&gt;prev_set_voltage =3D fe0-&gt;dvb.frontend-&gt;ops.set_vo=
ltage;<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 fe0-&gt;dvb.frontend-&gt;ops.set_v=
oltage =3D vp1027_set_voltage;<br>+=A0=A0=A0 =A0=A0=A0 }<br>+=A0=A0=A0 =A0=
=A0=A0=A0=A0=A0=A0 break;<br>
+<br>=A0=A0=A0=A0 default:<br>=A0=A0=A0=A0 =A0=A0=A0 printk(KERN_ERR &quot;=
%s/2: The frontend of your DVB/ATSC card isn&#39;t supported yet\n&quot;,<b=
r>=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 core-&gt;name);<br>diff -r 2a50=
a0a1c951 linux/drivers/media/video/cx88/cx88.h<br>
--- a/linux/drivers/media/video/cx88/cx88.h=A0=A0=A0 Sat Jan 23 00:14:32 20=
10 -0200<br>+++ b/linux/drivers/media/video/cx88/cx88.h=A0=A0=A0 Sun Jan 24=
 15:04:25 2010 +0300<br>@@ -240,6 +240,7 @@<br>=A0#define CX88_BOARD_WINFAS=
T_DTV1800H=A0=A0=A0=A0=A0=A0=A0 81<br>
=A0#define CX88_BOARD_WINFAST_DTV2000H_J=A0=A0=A0=A0=A0 82<br>=A0#define CX=
88_BOARD_PROF_7301=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 83<br>+#define=
 CX88_BOARD_TWINHAN_VP1027_DVBS=A0=A0=A0=A0 84<br>=A0<br>=A0enum cx88_itype=
 {<br>=A0=A0=A0=A0 CX88_VMUX_COMPOSITE1 =3D 1,<br><br>

--00032555415a934489047df96c44--


--===============0537407733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0537407733==--
