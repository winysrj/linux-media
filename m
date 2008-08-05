Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KQUBF-00053i-CF
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 23:35:00 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	118B8180502B
	for <linux-dvb@linuxtv.org>; Tue,  5 Aug 2008 21:33:50 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Mark Carbonaro" <mark@carbonaro.org>,
	"Jonathan Hummel" <jhhummel@bigpond.com>
Date: Wed, 6 Aug 2008 07:33:49 +1000
Message-Id: <20080805213349.C350B1CE835@ws1-6.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org, stev391@email.com
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1219137636=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1219137636==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121797202954682"

This is a multi-part message in MIME format.

--_----------=_121797202954682
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

 Mark, Jon,

The patches I made were not against the v4l-dvb tip that is referenced in
Mark's email below.  I did this on purpose because there is a small
amount of refactoring (recoding to make it better) being performed by
Steven Toth and others.

To get the version I used for the patch download (This is for the first
initial patch [you can tell it is this one as the patch file mentions
cx23885-sram in the path]):
http://linuxtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz

For the second patch that emailed less then 12 hours ago download this
version of drivers:
http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz
and then apply my patch (this patch mentions v4l-dvb). This version is a
cleanup of the previous and uses the generic callback function.

Other then that you are heading in the correct direction...

Do either of you have the same issue I have that when the computer is
first turned on the autodetect card feature doesn't work due to subvendor
sub product ids of 0000? Or is just a faulty card that I have?

Regards,

Stephen.

  ----- Original Message -----
  From: "Mark Carbonaro"
  To: "Jonathan Hummel"
  Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H -
  DVB Only support
  Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)


  Hi Mark,

  Forgive my ignorance/ newbie-ness, but what do I do with that patch
  code
  below? is there a tutorial or howto or something somewhere that will
  introduce me to this. I have done some programming, but nothing of
  this
  level.

  cheers

  Jon

  ----- Original Message -----
  From: "Jonathan Hummel"
  To: "Mark Carbonaro"
  Cc: stev391@email.com, linux-dvb@linuxtv.org
  Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000) Auto-Detected
  Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H
  - DVB Only support

  Hi Jon,

  Not a problem at all, I'm new to this myself, below is what went
  through and I may not be doing it the right way either. So if
  anyone would like to point out what I am doing wrong I would really
  appreciate it.

  The file that I downloaded was called v4l-dvb-2bade2ed7ac8.tar.bz2
  which I downloaded from
  http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I also
  saved the patch to the same location as the download.

  The patch didn't apply for me, so I manually patched applied the
  patches and created a new diff that should hopefully work for you
  also (attached and inline below). From what I could see the
  offsets in Stephens patch were a little off for this code snapshot
  but otherwise it is all good.

  I ran the following using the attached diff...

  tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2
  cd v4l-dvb-2bade2ed7ac8
  patch -p1 < ../Leadtek.Winfast.PxDVR.3200.H.2.diff

  Once the patch was applied I was then able to build and install the
  modules as per the instructions in the INSTALL file. I ran the
  following...

  make all
  sudo make install

  From there I could load the modules and start testing.

  I hope this helps you get started.

  Regards,
  Mark






  diff -Naur
  v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885
  v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885
  ---
  v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885
  2008-08-05 11:18:19.000000000
  +1000
  +++
  v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885 2008-08-05
  23:27:32.000000000 +1000
  @@ -10,3 +10,4 @@
  9 -> Hauppauge WinTV-HVR1400 [0070:8010]
  10 -> DViCO FusionHDTV7 Dual Express [18ac:d618]
  11 -> DViCO FusionHDTV DVB-T Dual Express [18ac:db78]
  + 12 -> Leadtek Winfast PxDVR3200 H [107d:6681]
  diff -Naur
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig
  v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig
  ---
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig
  2008-08-05
  11:18:19.000000000 +1000
  +++ v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig 2008-08-05
  23:37:51.000000000 +1000
  @@ -15,6 +15,7 @@
  select DVB_S5H1409 if !DVB_FE_CUSTOMISE
  select DVB_S5H1411 if !DVB_FE_CUSTOMISE
  select DVB_LGDT330X if !DVB_FE_CUSTOMISE
  + select DVB_ZL10353 if !DVB_FE_CUSTOMISE
  select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
  select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
  select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
  diff -Naur
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c
  v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c
  ---
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c
  2008-08-05 11:18:19.000000000
  +1000
  +++
  v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c 2008-08-05
  23:41:40.000000000 +1000
  @@ -155,6 +155,10 @@
  .portb =3D CX23885_MPEG_DVB,
  .portc =3D CX23885_MPEG_DVB,
  },
  + [CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] =3D {
  + .name =3D "Leadtek Winfast PxDVR3200 H",
  + .portc =3D CX23885_MPEG_DVB,
  + },
  };
  const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);

  @@ -230,6 +234,10 @@
  .subvendor =3D 0x18ac,
  .subdevice =3D 0xdb78,
  .card =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
  + },{
  + .subvendor =3D 0x107d,
  + .subdevice =3D 0x6681,
  + .card =3D CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
  },
  };
  const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);
  @@ -353,6 +361,10 @@
  if (command =3D=3D 0)
  bitmask =3D 0x04;
  break;
  + case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
  + /* Tuner Reset Command */
  + bitmask =3D 0x00070404;
  + break;
  case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
  case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  if (command =3D=3D 0) {
  @@ -492,6 +504,15 @@
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
  + break;
  }
  }

  @@ -579,6 +600,7 @@
  case CX23885_BOARD_HAUPPAUGE_HVR1200:
  case CX23885_BOARD_HAUPPAUGE_HVR1700:
  case CX23885_BOARD_HAUPPAUGE_HVR1400:
  + case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
  default:
  ts2->gen_ctrl_val =3D 0xc; /* Serial bus + punctured clock */
  ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
  @@ -592,6 +614,7 @@
  case CX23885_BOARD_HAUPPAUGE_HVR1800:
  case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
  case CX23885_BOARD_HAUPPAUGE_HVR1700:
  + case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
  request_module("cx25840");
  break;
  }
  diff -Naur
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c
  v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c
  ---
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c
  2008-08-05 11:18:19.000000000
  +1000
  +++
  v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c 2008-08-05
  23:37:03.000000000 +1000
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
  + struct dvb_frontend *fe;
  + struct xc2028_config cfg =3D {
  + .i2c_adap =3D &dev->i2c_bus[1].i2c_adap,
  + .i2c_addr =3D 0x61,
  + .video_dev =3D port,
  + .callback =3D cx23885_tuner_callback,
  + };
  + static struct xc2028_ctrl ctl =3D {
  + .fname =3D "xc3028-v27.fw",
  + .max_len =3D 64,
  + .demod =3D XC3028_FE_ZARLINK456,
  + };
  +
  + fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,
  + &cfg);
  + if (fe !=3D NULL && fe->ops.tuner_ops.set_config !=3D NULL)
  + fe->ops.tuner_ops.set_config(fe, &ctl);
  + }
  + break;
  default:
  printk("%s: The frontend of your DVB/ATSC card isn't supported
  yet\n",
  dev->name);
  diff -Naur
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h
  v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h
  ---
  v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h
  2008-08-05
  11:18:19.000000000 +1000
  +++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h 2008-08-05
  23:37:33.000000000 +1000
  @@ -66,6 +66,7 @@
  #define CX23885_BOARD_HAUPPAUGE_HVR1400 9
  #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
  #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
  +#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12

  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM
  B/G/H/LC */
  #define CX23885_NORMS (\
  << Leadtek.Winfast.PxDVR.3200.H.2.diff >>

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121797202954682
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"


<div>
Mark, Jon,<br><br>The patches I made were not against the v4l-dvb tip that =
is referenced in Mark's email below.&nbsp; I did this on purpose because th=
ere is a small amount of refactoring (recoding to make it better) being per=
formed by Steven Toth and others.<br><br>To get the version I used for the =
patch download (This is for the first initial patch [you can tell it is thi=
s one as the patch file mentions cx23885-sram in the path]):<br>http://linu=
xtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz<br><br>For the second pat=
ch that emailed less then 12 hours ago download this version of drivers:<br=
>http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz<br>and then apply =
my patch (this patch mentions v4l-dvb). This version is a cleanup of the pr=
evious and uses the generic callback function.<br><br>Other then that you a=
re heading in the correct direction...<br><br>Do either of you have the sam=
e issue I have that when the computer is first turned on the autodetect car=
d feature doesn't work due to subvendor sub product ids of 0000? Or is just=
 a faulty card that I have?<br>
<br>Regards,<br><br>Stephen.<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Mark Carbonaro" <mark@carbonaro.org><br>
To: "Jonathan Hummel" <jhhummel@bigpond.com><br>
Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB On=
ly support<br>
Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)<br>
<br>

<br>
Hi Mark,<br>
<br>
Forgive my ignorance/ newbie-ness, but what do I do with that patch code<br>
below? is there a tutorial or howto or something somewhere that will<br>
introduce me to this. I have done some programming, but nothing of this<br>
level.<br>
<br>
cheers<br>
<br>
Jon<br>
<br>
----- Original Message -----<br>
From: "Jonathan Hummel" <jhhummel@bigpond.com><br>
To: "Mark Carbonaro" <mark@carbonaro.org><br>
Cc: stev391@email.com, linux-dvb@linuxtv.org<br>
Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000) Auto-Detected<br>
Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H <br>
- DVB Only support<br>
<br>
Hi Jon,<br>
<br>
Not a problem at all, I'm new to this myself, below is what went <br>
through and I may not be doing it the right way either.  So if <br>
anyone would like to point out what I am doing wrong I would really <br>
appreciate it.<br>
<br>
The file that I downloaded was called v4l-dvb-2bade2ed7ac8.tar.bz2 <br>
which I downloaded from <br>
http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I also <br>
saved the patch to the same location as the download.<br>
<br>
The patch didn't apply for me, so I manually patched applied the <br>
patches and created a new diff that should hopefully work for you <br>
also (attached and inline below).  From what I could see the <br>
offsets in Stephens patch were a little off for this code snapshot <br>
but otherwise it is all good.<br>
<br>
I ran the following using the attached diff...<br>
<br>
tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2<br>
cd v4l-dvb-2bade2ed7ac8<br>
patch -p1 &lt; ../Leadtek.Winfast.PxDVR.3200.H.2.diff<br>
<br>
Once the patch was applied I was then able to build and install the <br>
modules as per the instructions in the INSTALL file.  I ran the <br>
following...<br>
<br>
make all<br>
sudo make install<br>
<br>
 From there I could load the modules and start testing.<br>
<br>
I hope this helps you get started.<br>
<br>
Regards,<br>
Mark<br>
<br>
<br>
<br>
<br>
<br>
<br>
diff -Naur <br>
v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885 <br>
v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885<br>
--- <br>
v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885	2008-=
08-05 11:18:19.000000000 <br>
+1000<br>
+++ <br>
v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-05 <br>
23:27:32.000000000 +1000<br>
@@ -10,3 +10,4 @@<br>
    9 -&gt; Hauppauge WinTV-HVR1400                             [0070:8010]=
<br>
   10 -&gt; DViCO FusionHDTV7 Dual Express                      [18ac:d618]=
<br>
   11 -&gt; DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]=
<br>
+ 12 -&gt; Leadtek Winfast PxDVR3200 H                         [107d:6681]<=
br>
diff -Naur <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig <br>
v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig<br>
--- <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 <=
br>
11:18:19.000000000 +1000<br>
+++ v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 <br>
23:37:51.000000000 +1000<br>
@@ -15,6 +15,7 @@<br>
  	select DVB_S5H1409 if !DVB_FE_CUSTOMISE<br>
  	select DVB_S5H1411 if !DVB_FE_CUSTOMISE<br>
  	select DVB_LGDT330X if !DVB_FE_CUSTOMISE<br>
+	select DVB_ZL10353 if !DVB_FE_CUSTOMISE<br>
  	select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE<br>
  	select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE<br>
  	select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE<br>
diff -Naur <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c <br>
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c<br>
--- <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c	2008=
-08-05 11:18:19.000000000 <br>
+1000<br>
+++ <br>
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-05 <br>
23:41:40.000000000 +1000<br>
@@ -155,6 +155,10 @@<br>
  		.portb		=3D CX23885_MPEG_DVB,<br>
  		.portc		=3D CX23885_MPEG_DVB,<br>
  	},<br>
+	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] =3D {<br>
+		.name        =3D "Leadtek Winfast PxDVR3200 H",<br>
+		.portc        =3D CX23885_MPEG_DVB,<br>
+	},<br>
  };<br>
  const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);<br>
<br>
@@ -230,6 +234,10 @@<br>
  		.subvendor =3D 0x18ac,<br>
  		.subdevice =3D 0xdb78,<br>
  		.card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,<br>
+	},{<br>
+		.subvendor =3D 0x107d,<br>
+		.subdevice =3D 0x6681,<br>
+		.card      =3D CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,<br>
  	},<br>
  };<br>
  const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);<br>
@@ -353,6 +361,10 @@<br>
  		if (command =3D=3D 0)<br>
  			bitmask =3D 0x04;<br>
  		break;<br>
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
+		/* Tuner Reset Command */<br>
+		bitmask =3D 0x00070404;<br>
+		break;<br>
  	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:<br>
  	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
  		if (command =3D=3D 0) {<br>
@@ -492,6 +504,15 @@<br>
  		mdelay(20);<br>
  		cx_set(GP0_IO, 0x000f000f);<br>
  		break;<br>
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
+		/* GPIO-2  xc3028 tuner reset */<br>
+		/* Put the parts into reset and back */<br>
+		cx_set(GP0_IO, 0x00040000);<br>
+		mdelay(20);<br>
+		cx_clear(GP0_IO, 0x00000004);<br>
+		mdelay(20);<br>
+		cx_set(GP0_IO, 0x00040004);<br>
+		break;<br>
  	}<br>
  }<br>
<br>
@@ -579,6 +600,7 @@<br>
  	case CX23885_BOARD_HAUPPAUGE_HVR1200:<br>
  	case CX23885_BOARD_HAUPPAUGE_HVR1700:<br>
  	case CX23885_BOARD_HAUPPAUGE_HVR1400:<br>
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
  	default:<br>
  		ts2-&gt;gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */<br>
  		ts2-&gt;ts_clk_en_val =3D 0x1; /* Enable TS_CLK */<br>
@@ -592,6 +614,7 @@<br>
  	case CX23885_BOARD_HAUPPAUGE_HVR1800:<br>
  	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:<br>
  	case CX23885_BOARD_HAUPPAUGE_HVR1700:<br>
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
  		request_module("cx25840");<br>
  		break;<br>
  	}<br>
diff -Naur <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c <br>
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
--- <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-0=
8-05 11:18:19.000000000 <br>
+1000<br>
+++ <br>
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-05 <br>
23:37:03.000000000 +1000<br>
@@ -37,6 +37,7 @@<br>
  #include "tda8290.h"<br>
  #include "tda18271.h"<br>
  #include "lgdt330x.h"<br>
+#include "zl10353.h"<br>
  #include "xc5000.h"<br>
  #include "tda10048.h"<br>
  #include "tuner-xc2028.h"<br>
@@ -502,6 +503,32 @@<br>
  		}<br>
  		break;<br>
  	}<br>
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
+		i2c_bus =3D &amp;dev-&gt;i2c_bus[0];<br>
+<br>
+		port-&gt;dvb.frontend =3D dvb_attach(zl10353_attach,<br>
+						&amp;dvico_fusionhdtv_xc3028,<br>
+						&amp;i2c_bus-&gt;i2c_adap);<br>
+		if (port-&gt;dvb.frontend !=3D NULL) {<br>
+			struct dvb_frontend      *fe;<br>
+			struct xc2028_config      cfg =3D {<br>
+				.i2c_adap  =3D &amp;dev-&gt;i2c_bus[1].i2c_adap,<br>
+				.i2c_addr  =3D 0x61,<br>
+				.video_dev =3D port,<br>
+				.callback  =3D cx23885_tuner_callback,<br>
+			};<br>
+			static struct xc2028_ctrl ctl =3D {<br>
+				.fname       =3D "xc3028-v27.fw",<br>
+				.max_len     =3D 64,<br>
+				.demod       =3D XC3028_FE_ZARLINK456,<br>
+			};<br>
+<br>
+			fe =3D dvb_attach(xc2028_attach, port-&gt;dvb.frontend,<br>
+					&amp;cfg);<br>
+			if (fe !=3D NULL &amp;&amp; fe-&gt;ops.tuner_ops.set_config !=3D NULL)<=
br>
+				fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>
+		}<br>
+		break;<br>
  	default:<br>
  		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",<=
br>
  		       dev-&gt;name);<br>
diff -Naur <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h <br>
v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h<br>
--- <br>
v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05=
 <br>
11:18:19.000000000 +1000<br>
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05 <br>
23:37:33.000000000 +1000<br>
@@ -66,6 +66,7 @@<br>
  #define CX23885_BOARD_HAUPPAUGE_HVR1400        9<br>
  #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10<br>
  #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11<br>
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12<br>
<br>
  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */=
<br>
  #define CX23885_NORMS (\<br>
&lt;&lt; Leadtek.Winfast.PxDVR.3200.H.2.diff &gt;&gt;<br>
</mark@carbonaro.org></jhhummel@bigpond.com></jhhummel@bigpond.com></mark@c=
arbonaro.org></blockquote>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121797202954682--



--===============1219137636==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1219137636==--
