Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1JwPEL-0008Qp-F7
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 00:14:03 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	97056180013B
	for <linux-dvb@linuxtv.org>; Wed, 14 May 2008 22:13:08 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "scuba sam" <scubasam@operamail.com>
Date: Thu, 15 May 2008 08:12:52 +1000
Message-Id: <20080514221252.48BF0478088@ws1-5.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1026725007=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1026725007==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121080317249323"

This is a multi-part message in MIME format.

--_----------=_121080317249323
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Thom,

Disclaimer: This not guranteed to work and will break any webcams you
have running on ubuntu, this is reversable by reinstalling the "linux-*"
packages that you have already installed.

I can't seem to find any information about that version of Mythbuntu, is
it supposed to be version 8.04? Anyway the following will work for
previous versions as well.
All commands to be run in a terminal.

Step 1, Install the required packages to retrieve and compile the source
(you also need to install the linux-headers that match your kernel, which
is done by the following command as well)
sudo apt-get install mercurial build-essential patch linux-headers-`uname
-r`

Step 2, Retrieve the v4l-dvb sources
hg clone http://linuxtv.org/hg/v4l-dvb

Step 3, Apply patch (which was an attachment on the previous email)
cd v4l-dvb
patch -p1 < ../DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch

Step 4, Compile which will take awhile... (maybe time to make a cup of
coffee)
make all

Step 5 Remove the old modules as this causes issues when loading the
modules later(this depends on version of ubuntu)
8.04:  cd /lib/modules/`uname -r`/ubuntu/media
cd /lib/modules/`uname -r`/kernel/drivers/media
sudo rm -r common
sudo rm -r dvb
sudo rm -r radio
sudo rm -r video

Step 6: return to v4l-dvb directory and run:
sudo make install

Step 7: Update the initramfs:
sudo dpkg-reconfigure linux-ubuntu-modules-`uname -r`

Step 8: Reboot and see if it worked
sudo shutdown -r now

If this didn't work with my patch please send me the output of dmesg and
any relevant logs of the application that you used to identify the
problem with (eg mythbackend log). Then try replacing step 2 & 3 with
(This uses the older branch by Chris Pascoe, whose code I'm trying to
update to bring into the main v4l-dvb):
hg clone http://linuxtv.org/hg/~pascoe/xc-test/
cd xc-test

If this still doesn't work and your dvb system is broken just reinstall
your linux-* packages.

Regards,
Stephen

  ----- Original Message -----
  From: "scuba sam"
  To: stev391@email.com
  Subject: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
  Date: Wed, 14 May 2008 21:32:51 +0100


  Hi

  I have one of these cards and have been wanting to get it working
  under Mythbuntu 8.01 and this looks promising.

  I'm fairly new to Linux and have no idea as to how to apply this
  patch to my existing Mythbuntu installation and would be very
  grateful for some pointers as to how to go about it. I'm sure there
  are many people in the same situation and I would be happy to write
  it up as a howto and post to relevant interest groups.

  Thank you for your work on this.

  Regards
  Thom



  ----------------------------------------
  I have updated my patch (from a week ago) and is included inline
  below as well as an attachment. The issue that was noticed and
  mentioned in previous posts regarding to tuners not resetting was
  possibly due to several "__FUNCTION_" in the tuner reset code,
  these should be "__func__", which is fixed in the attached patch.

  This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is
  intended to merge Chris Pascoe's work into the current head to
  enable support for the DViCO Fusion HDTV DVB-T Dual Express (PCIe).
  This enables systems with different tuners to take advantage of
  other experimental drivers, (for example my TV Walker Twin USB
  tuner).

  Regards,

  Stephen

  diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
  v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
  --- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
  2008-05-14 09:48:21.000000000 +1000
  +++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
  2008-05-14 13:39:30.000000000 +1000
  @@ -8,3 +8,4 @@
  7 -> Hauppauge WinTV-HVR1200
  [0070:71d1,0070:71d3]
  ; 8 -> Hauppauge WinTV-HVR1700 [0070:8101]
  9 -> Hauppauge WinTV-HVR1400 [0070:8010]
  + 10 -> DViCO FusionHDTV DVB-T Dual Express [18ac:db78]
  diff -Naur
  v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
  v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
  --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
  2008-05-14 09:48:22.000000000 +1000
  +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
  2008-05-14 13:39:30.000000000 +1000
  @@ -144,6 +144,11 @@
  .name =3D "Hauppauge WinTV-HVR1400",
  .portc =3D CX23885_MPEG_DVB,
  },
  + [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {
  + .name =3D "DViCO FusionHDTV DVB-T Dual Express",
  + .portb =3D CX23885_MPEG_DVB,
  + .portc =3D CX23885_MPEG_DVB,
  + },
  };
  const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);

  @@ -211,6 +216,10 @@
  .subvendor =3D 0x0070,
  .subdevice =3D 0x8010,
  .card =3D CX23885_BOARD_HAUPPAUGE_HVR1400,
  + },{
  + .subvendor =3D 0x18ac,
  + .subdevice =3D 0xdb78,
  + .card =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
  },
  };
  const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);
  @@ -428,6 +437,13 @@
  mdelay(20);
  cx_set(GP0_IO, 0x00050005);
  break;
  + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  + /* GPIO-0 portb xc3028 reset */
  + /* GPIO-1 portb zl10353 reset */
  + /* GPIO-2 portc xc3028 reset */
  + /* GPIO-3 portc zl10353 reset */
  + cx_write(GP0_IO, 0x002f1000);
  + break;
  }
  }

  @@ -442,6 +458,9 @@
  case CX23885_BOARD_HAUPPAUGE_HVR1400:
  /* FIXME: Implement me */
  break;
  + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  + request_module("ir-kbd-i2c");
  + break;
  }

  return 0;
  @@ -478,6 +497,11 @@
  }

  switch (dev->board) {
  + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  + ts2->gen_ctrl_val =3D 0xc; /* Serial bus + punctured clock */
  + ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
  + ts2->src_sel_val =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
  + /* FALLTHROUGH */
  case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
  ts1->gen_ctrl_val =3D 0xc; /* Serial bus + punctured clock */
  ts1->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
  diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
  v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
  --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
  2008-05-14 09:48:22.000000000 +1000
  +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
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
  + struct cx23885_tsport *port =3D ptr;
  + struct cx23885_dev *dev =3D port->dev;
  + u32 reset_mask =3D 0;
  +
  + switch (command) {
  + case XC2028_TUNER_RESET:
  + dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __func__,
  + arg, port->nr);
  +
  + if (port->nr =3D=3D 1)
  + reset_mask =3D 0x0101;
  + else if (port->nr =3D=3D 2)
  + reset_mask =3D 0x0404;
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
  +static struct zl10353_config dvico_fusionhdtv_xc3028 =3D {
  + .demod_address =3D 0x0f,
  + .if2 =3D 45600,
  + .no_tuner =3D 1,
  +};
  +
  static struct s5h1409_config hauppauge_hvr1500q_config =3D {
  .demod_address =3D 0x32 >> 1,
  .output_mode =3D S5H1409_SERIAL_OUTPUT,
  @@ -454,6 +495,39 @@
  fe->ops.tuner_ops.set_config(fe, &ctl);
  }
  break;
  + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
  + i2c_bus =3D &dev->i2c_bus[port->nr - 1];
  +
  + /* Take demod and tuner out of reset */
  + if (port->nr =3D=3D 1)
  + cx_set(GP0_IO, 0x0303);
  + else if (port->nr =3D=3D 2)
  + cx_set(GP0_IO, 0x0c0c);
  + mdelay(5);
  + port->dvb.frontend =3D dvb_attach(zl10353_attach,
  + &dvico_fusionhdtv_xc3028,
  + &i2c_bus->i2c_adap);
  + if (port->dvb.frontend !=3D NULL) {
  + struct dvb_frontend *fe;
  + struct xc2028_config cfg =3D {
  + .i2c_adap =3D &i2c_bus->i2c_adap,
  + .i2c_addr =3D 0x61,
  + .video_dev =3D port,
  + .callback =3D cx23885_dvico_xc2028_callback,
  + };
  + static struct xc2028_ctrl ctl =3D {
  + .fname =3D "xc3028-dvico-au-01.fw",
  + .max_len =3D 64,
  + .scode_table =3D ZARLINK456,
  + };
  +
  + fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,
  + &cfg);
  + if (fe !=3D NULL && fe->ops.tuner_ops.set_config !=3D NULL)
  + fe->ops.tuner_ops.set_config(fe, &ctl);
  + }
  + break;
  + }
  default:
  printk("%s: The frontend of your DVB/ATSC card isn't
  supported yet\n",
  dev->name);
  diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
  v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
  --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
  2008-05-14 09:48:22.000000000 +1000
  +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
  2008-05-14 13:39:30.000000000 +1000
  @@ -66,6 +66,7 @@
  #define CX23885_BOARD_HAUPPAUGE_HVR1200 7
  #define CX23885_BOARD_HAUPPAUGE_HVR1700 8
  #define CX23885_BOARD_HAUPPAUGE_HVR1400 9
  +#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 10

  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM
  B/G/H/LC */
  #define CX23885_NORMS (\
  diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig
  v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
  --- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig 2008-05-14
  09:48:22.000000000 +1000
  +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
  2008-05-14 13:39:30.000000000 +1000
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


--_----------=_121080317249323
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Thom,<br><br>Disclaimer: This not guranteed to work and will break any webc=
ams you have running on ubuntu, this is reversable by reinstalling the "lin=
ux-*" packages that you have already installed.<br><br>I can't seem to find=
 any information about that version of Mythbuntu, is it supposed to be vers=
ion 8.04? Anyway the following will work for previous versions as well.<br>=
All commands to be run in a terminal.<br><br>Step 1, Install the required p=
ackages to retrieve and compile the source (you also need to install the li=
nux-headers that match your kernel, which is done by the following command =
as well)<br>sudo apt-get install mercurial build-essential patch linux-head=
ers-`uname -r`<br><br>Step 2, Retrieve the v4l-dvb sources<br>hg clone http=
://linuxtv.org/hg/v4l-dvb<br><br>Step 3, Apply patch (which was an attachme=
nt on the previous email)<br>cd v4l-dvb<br>patch -p1 &lt; ../DViCO_FUSIONHD=
TV_DVB_T_DUAL_EXP_v2.patch<br><br>Step 4, Compile which will take awhile...=
 (maybe time to make a cup of coffee)<br>make all<br><br>Step 5 Remove the =
old modules as this causes issues when loading the modules later(this depen=
ds on version of ubuntu)<br>8.04:&nbsp; cd /lib/modules/`uname -r`/ubuntu/m=
edia<br>cd /lib/modules/`uname -r`/kernel/drivers/media<br>sudo rm -r commo=
n<br>sudo rm -r dvb<br>sudo rm -r radio<br>sudo rm -r video<br><br>Step 6: =
return to v4l-dvb directory and run:<br>sudo make install<br><br>Step 7: Up=
date the initramfs:<br>sudo dpkg-reconfigure linux-ubuntu-modules-`uname -r=
`<br><br>Step 8: Reboot and see if it worked<br>sudo shutdown -r now<br><br=
>If this didn't work with my patch please send me the output of dmesg and a=
ny relevant logs of the application that you used to identify the problem w=
ith (eg mythbackend log). Then try replacing step 2 &amp; 3 with (This uses=
 the older branch by Chris Pascoe, whose code I'm trying to update to bring=
 into the main v4l-dvb):<br>hg clone http://linuxtv.org/hg/~pascoe/xc-test/=
<br>cd xc-test<br>
<br>If this still doesn't work and your dvb system is broken just reinstall=
 your linux-* packages.<br><br>Regards,<br>Stephen<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "scuba sam" <scubasam@operamail.com><br>
To: stev391@email.com<br>
Subject:  [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]<br>
Date: Wed, 14 May 2008 21:32:51 +0100<br>
<br>
<br>
Hi<br>
<br>
I have one of these cards and have been wanting to get it working <br>
under Mythbuntu 8.01 and this looks promising.<br>
<br>
I'm fairly new to Linux and have no idea as to how to apply this <br>
patch to my existing Mythbuntu installation and would be very <br>
grateful for some pointers as to how to go about it. I'm sure there <br>
are many people in the same situation and I would be happy to write <br>
it up as a howto and post to relevant interest groups.<br>
<br>
Thank you for your work on this.<br>
<br>
Regards<br>
Thom<br>
<br>
<br>
<br>
----------------------------------------<br>
I have updated my patch (from a week ago) and is included inline <br>
below as well as an attachment. The issue that was noticed and <br>
mentioned in previous posts regarding to tuners not resetting was <br>
possibly due to several "__FUNCTION_" in the tuner reset code, <br>
these should be "__func__", which is fixed in the attached patch.<br>
<br>
This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is <br>
intended to merge Chris Pascoe's work into the current head to <br>
enable support for the DViCO Fusion HDTV DVB-T Dual Express (PCIe). <br>
  This enables systems with different tuners to take advantage of <br>
other experimental drivers, (for example my TV Walker Twin USB <br>
tuner).<br>
<br>
Regards,<br>
<br>
Stephen<br>
<br>
diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885 <br>
v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885<br>
--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885    <br>
2008-05-14 09:48:21.000000000 +1000<br>
+++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885    <br>
2008-05-14 13:39:30.000000000 +1000<br>
@@ -8,3 +8,4 @@<br>
    7 -&gt; Hauppauge WinTV-HVR1200                             <br>
[0070:71d1,0070:71d3]<br>
   ;  8 -&gt; Hauppauge WinTV-HVR1700                             [0070:810=
1]<br>
    9 -&gt; Hauppauge WinTV-HVR1400                             [0070:8010]=
<br>
+ 10 -&gt; DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]<=
br>
diff -Naur <br>
v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c <br>
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c<br>
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c    <br>
2008-05-14 09:48:22.000000000 +1000<br>
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c   <br>
  2008-05-14 13:39:30.000000000 +1000<br>
@@ -144,6 +144,11 @@<br>
          .name        =3D "Hauppauge WinTV-HVR1400",<br>
          .portc        =3D CX23885_MPEG_DVB,<br>
      },<br>
+    [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {<br>
+        .name        =3D "DViCO FusionHDTV DVB-T Dual Express",<br>
+        .portb        =3D CX23885_MPEG_DVB,<br>
+        .portc        =3D CX23885_MPEG_DVB,<br>
+    },<br>
  };<br>
  const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);<br>
<br>
@@ -211,6 +216,10 @@<br>
          .subvendor =3D 0x0070,<br>
          .subdevice =3D 0x8010,<br>
          .card      =3D CX23885_BOARD_HAUPPAUGE_HVR1400,<br>
+    },{<br>
+        .subvendor =3D 0x18ac,<br>
+        .subdevice =3D 0xdb78,<br>
+        .card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,<br>
      },<br>
  };<br>
  const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);<br>
@@ -428,6 +437,13 @@<br>
          mdelay(20);<br>
          cx_set(GP0_IO, 0x00050005);<br>
          break;<br>
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
+        /* GPIO-0 portb xc3028 reset */<br>
+        /* GPIO-1 portb zl10353 reset */<br>
+        /* GPIO-2 portc xc3028 reset */<br>
+        /* GPIO-3 portc zl10353 reset */<br>
+        cx_write(GP0_IO, 0x002f1000);<br>
+        break;<br>
      }<br>
  }<br>
<br>
@@ -442,6 +458,9 @@<br>
      case CX23885_BOARD_HAUPPAUGE_HVR1400:<br>
          /* FIXME: Implement me */<br>
          break;<br>
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
+        request_module("ir-kbd-i2c");<br>
+        break;<br>
      }<br>
<br>
      return 0;<br>
@@ -478,6 +497,11 @@<br>
      }<br>
<br>
      switch (dev-&gt;board) {<br>
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
+        ts2-&gt;gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */<=
br>
+        ts2-&gt;ts_clk_en_val =3D 0x1; /* Enable TS_CLK */<br>
+        ts2-&gt;src_sel_val   =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;<br>
+        /* FALLTHROUGH */<br>
      case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:<br>
          ts1-&gt;gen_ctrl_val  =3D 0xc; /* Serial bus + punctured clock */=
<br>
          ts1-&gt;ts_clk_en_val =3D 0x1; /* Enable TS_CLK */<br>
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c <br>
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c    <br>
2008-05-14 09:48:22.000000000 +1000<br>
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c    <br>
2008-05-14 13:39:30.000000000 +1000<br>
@@ -42,6 +42,9 @@<br>
  #include "tuner-simple.h"<br>
  #include "dib7000p.h"<br>
  #include "dibx000_common.h"<br>
+#include "zl10353.h"<br>
+#include "tuner-xc2028.h"<br>
+#include "tuner-xc2028-types.h"<br>
<br>
  static unsigned int debug;<br>
<br>
@@ -155,6 +158,44 @@<br>
      .serial_mpeg =3D 0x40,<br>
  };<br>
<br>
+static int cx23885_dvico_xc2028_callback(void *ptr, int command, int arg)<=
br>
+{<br>
+    struct cx23885_tsport *port =3D ptr;<br>
+    struct cx23885_dev *dev =3D port-&gt;dev;<br>
+    u32 reset_mask =3D 0;<br>
+<br>
+    switch (command) {<br>
+    case XC2028_TUNER_RESET:<br>
+        dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __func__,<br>
+            arg, port-&gt;nr);<br>
+<br>
+        if (port-&gt;nr =3D=3D 1)<br>
+            reset_mask =3D 0x0101;<br>
+        else if (port-&gt;nr =3D=3D 2)<br>
+            reset_mask =3D 0x0404;<br>
+<br>
+        cx_clear(GP0_IO, reset_mask);<br>
+        mdelay(5);<br>
+        cx_set(GP0_IO, reset_mask);<br>
+        break;<br>
+    case XC2028_RESET_CLK:<br>
+        dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);<br>
+        break;<br>
+    default:<br>
+        dprintk(1, "%s: unknown command %d, arg %d\n", __func__,<br>
+               command, arg);<br>
+        return -EINVAL;<br>
+    }<br>
+<br>
+    return 0;<br>
+}<br>
+<br>
+static struct zl10353_config dvico_fusionhdtv_xc3028 =3D {<br>
+    .demod_address =3D 0x0f,<br>
+    .if2           =3D 45600,<br>
+    .no_tuner      =3D 1,<br>
+};<br>
+<br>
  static struct s5h1409_config hauppauge_hvr1500q_config =3D {<br>
      .demod_address =3D 0x32 &gt;&gt; 1,<br>
      .output_mode   =3D S5H1409_SERIAL_OUTPUT,<br>
@@ -454,6 +495,39 @@<br>
                  fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>
          }<br>
          break;<br>
+    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {<br>
+        i2c_bus =3D &amp;dev-&gt;i2c_bus[port-&gt;nr - 1];<br>
+<br>
+        /* Take demod and tuner out of reset */<br>
+        if (port-&gt;nr =3D=3D 1)<br>
+            cx_set(GP0_IO, 0x0303);<br>
+        else if (port-&gt;nr =3D=3D 2)<br>
+            cx_set(GP0_IO, 0x0c0c);<br>
+        mdelay(5);<br>
+        port-&gt;dvb.frontend =3D dvb_attach(zl10353_attach,<br>
+                           &amp;dvico_fusionhdtv_xc3028,<br>
+                           &amp;i2c_bus-&gt;i2c_adap);<br>
+        if (port-&gt;dvb.frontend !=3D NULL) {<br>
+            struct dvb_frontend      *fe;<br>
+            struct xc2028_config      cfg =3D {<br>
+                .i2c_adap  =3D &amp;i2c_bus-&gt;i2c_adap,<br>
+                .i2c_addr  =3D 0x61,<br>
+                .video_dev =3D port,<br>
+                .callback  =3D cx23885_dvico_xc2028_callback,<br>
+            };<br>
+            static struct xc2028_ctrl ctl =3D {<br>
+                .fname       =3D "xc3028-dvico-au-01.fw",<br>
+                .max_len     =3D 64,<br>
+                .scode_table =3D ZARLINK456,<br>
+            };<br>
+<br>
+            fe =3D dvb_attach(xc2028_attach, port-&gt;dvb.frontend,<br>
+                    &amp;cfg);<br>
+            if (fe !=3D NULL &amp;&amp; fe-&gt;ops.tuner_ops.set_config !=
=3D NULL)<br>
+                fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>
+        }<br>
+        break;<br>
+        }<br>
      default:<br>
          printk("%s: The frontend of your DVB/ATSC card isn't <br>
supported yet\n",<br>
                 dev-&gt;name);<br>
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h <br>
v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h<br>
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h    <br>
2008-05-14 09:48:22.000000000 +1000<br>
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h    <br>
2008-05-14 13:39:30.000000000 +1000<br>
@@ -66,6 +66,7 @@<br>
  #define CX23885_BOARD_HAUPPAUGE_HVR1200        7<br>
  #define CX23885_BOARD_HAUPPAUGE_HVR1700        8<br>
  #define CX23885_BOARD_HAUPPAUGE_HVR1400        9<br>
+#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 10<br>
<br>
  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */=
<br>
  #define CX23885_NORMS (\<br>
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig <br>
v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig<br>
--- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig    2008-05-14 <br>
09:48:22.000000000 +1000<br>
+++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig    <br>
2008-05-14 13:39:30.000000000 +1000<br>
@@ -15,6 +15,7 @@<br>
      select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE<br>
      select DVB_S5H1409 if !DVB_FE_CUSTOMISE<br>
      select DVB_LGDT330X if !DVB_FE_CUSTOMISE<br>
+     select DVB_ZL10353 if !DVB_FE_CUSTOMISE<br>
      select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE<br>
      select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE<br>
      select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE<br>
<br>
</scubasam@operamail.com></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_121080317249323--



--===============1026725007==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1026725007==--
