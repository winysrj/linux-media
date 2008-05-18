Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1JxfT8-0003FX-GC
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 11:46:22 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	78EEF1800121
	for <linux-dvb@linuxtv.org>; Sun, 18 May 2008 09:45:42 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "allan k" <sonofzev@iinet.net.au>
Date: Sun, 18 May 2008 19:45:42 +1000
Message-Id: <20080518094542.588821CE7C0@ws1-6.us4.outblaze.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0121973945=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0121973945==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1211103942292755"

This is a multi-part message in MIME format.

--_----------=_1211103942292755
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Allan,

My patch has not been merged into the branch,

For the moment don't worry about it and use Chris Pascoe's xc-test
branch.=20

I have worked out what my issue is on the one PC that didn't work.  I'm
actually surprised it worked on the other systems, it was only due to a
weird coincidence in identifying my other tuner cards first.
I have been slowly going through the source to attempt to solve this, I
will post when it is working reliably on all machines.

Thanks for at least trying it.

Regards,
Stephen


  ----- Original Message -----
  From: "allan k"
  To: stev391@email.com
  Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
  Date: Sat, 17 May 2008 21:27:19 +1000


  Hi Steve

  I'm getting a large amount of noise again, although after previous
  restarts this didn't happen.

  I'm wondering if your patch is already merged into the v4l sources or
  if
  I need to use this one you sent.

  cheers

  Allan
  On Wed, 2008-05-14 at 15:54 +1000, stev391@email.com wrote:
  >
  > I have updated my patch (from a week ago) and is included inline
  below
  > as well as an attachment. The issue that was noticed and mentioned
  in
  > previous posts regarding to tuners not resetting was possibly due
  to
  > several "__FUNCTION_" in the tuner reset code, these should be
  > "__func__", which is fixed in the attached patch.
  >
  > This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is
  > intended to merge Chris Pascoe's work into the current head to
  enable
  > support for the DViCO Fusion HDTV DVB-T Dual Express (PCIe). This
  > enables systems with different tuners to take advantage of other
  > experimental drivers, (for example my TV Walker Twin USB tuner).
  >
  > Regards,
  >
  > Stephen
  >
  > diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
  > v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
  > --- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
  > 2008-05-14 09:48:21.000000000 +1000
  > +++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
  > 2008-05-14 13:39:30.000000000 +1000
  > @@ -8,3 +8,4 @@
  > 7 -> Hauppauge WinTV-HVR1200
  > [0070:71d1,0070:71d3]
  > ; 8 -> Hauppauge WinTV-HVR1700
  > [0070:8101]
  > 9 -> Hauppauge WinTV-HVR1400
  > [0070:8010]
  > + 10 -> DViCO FusionHDTV DVB-T Dual Express
  > [18ac:db78]
  > diff -Naur
  v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
  > v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
  > --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
  > 2008-05-14 09:48:22.000000000 +1000
  > +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
  > 2008-05-14 13:39:30.000000000 +1000
  > @@ -144,6 +144,11 @@
  > .name =3D "Hauppauge WinTV-HVR1400",
  > .portc =3D CX23885_MPEG_DVB,
  > },
  > + [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {
  > + .name =3D "DViCO FusionHDTV DVB-T Dual Express",
  > + .portb =3D CX23885_MPEG_DVB,
  > + .portc =3D CX23885_MPEG_DVB,
  > + },
  > };
  > const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);
  >
  > @@ -211,6 +216,10 @@
  > .subvendor =3D 0x0070,
  > .subdevice =3D 0x8010,
  > .card =3D CX23885_BOARD_HAUPPAUGE_HVR1400,
  > + },{
  > + .subvendor =3D 0x18ac,
  > + .subdevice =3D 0xdb78,
  > + .card =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
  > },
  > };
  > const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);
  > @@ -428,6 +437,13 @@
  > mdelay(20);
  > cx_set(GP0_IO, 0x00050005);
  > break;
  > + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  > + /* GPIO-0 portb xc3028 reset */
  > + /* GPIO-1 portb zl10353 reset */
  > + /* GPIO-2 portc xc3028 reset */
  > + /* GPIO-3 portc zl10353 reset */
  > + cx_write(GP0_IO, 0x002f1000);
  > + break;
  > }
  > }
  >
  > @@ -442,6 +458,9 @@
  > case CX23885_BOARD_HAUPPAUGE_HVR1400:
  > /* FIXME: Implement me */
  > break;
  > + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  > + request_module("ir-kbd-i2c");
  > + break;
  > }
  >
  > return 0;
  > @@ -478,6 +497,11 @@
  > }
  >
  > switch (dev->board) {
  > + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
  > + ts2->gen_ctrl_val =3D 0xc; /* Serial bus + punctured clock */
  > + ts2->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
  > + ts2->src_sel_val =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
  > + /* FALLTHROUGH */
  > case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
  > ts1->gen_ctrl_val =3D 0xc; /* Serial bus + punctured clock */
  > ts1->ts_clk_en_val =3D 0x1; /* Enable TS_CLK */
  > diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
  > v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
  > --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
  > 2008-05-14 09:48:22.000000000 +1000
  > +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
  > 2008-05-14 13:39:30.000000000 +1000
  > @@ -42,6 +42,9 @@
  > #include "tuner-simple.h"
  > #include "dib7000p.h"
  > #include "dibx000_common.h"
  > +#include "zl10353.h"
  > +#include "tuner-xc2028.h"
  > +#include "tuner-xc2028-types.h"
  >
  > static unsigned int debug;
  >
  > @@ -155,6 +158,44 @@
  > .serial_mpeg =3D 0x40,
  > };
  >
  > +static int cx23885_dvico_xc2028_callback(void *ptr, int command,
  int
  > arg)
  > +{
  > + struct cx23885_tsport *port =3D ptr;
  > + struct cx23885_dev *dev =3D port->dev;
  > + u32 reset_mask =3D 0;
  > +
  > + switch (command) {
  > + case XC2028_TUNER_RESET:
  > + dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __func__,
  > + arg, port->nr);
  > +
  > + if (port->nr =3D=3D 1)
  > + reset_mask =3D 0x0101;
  > + else if (port->nr =3D=3D 2)
  > + reset_mask =3D 0x0404;
  > +
  > + cx_clear(GP0_IO, reset_mask);
  > + mdelay(5);
  > + cx_set(GP0_IO, reset_mask);
  > + break;
  > + case XC2028_RESET_CLK:
  > + dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
  > + break;
  > + default:
  > + dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
  > + command, arg);
  > + return -EINVAL;
  > + }
  > +
  > + return 0;
  > +}
  > +
  > +static struct zl10353_config dvico_fusionhdtv_xc3028 =3D {
  > + .demod_address =3D 0x0f,
  > + .if2 =3D 45600,
  > + .no_tuner =3D 1,
  > +};
  > +
  > static struct s5h1409_config hauppauge_hvr1500q_config =3D {
  > .demod_address =3D 0x32 >> 1,
  > .output_mode =3D S5H1409_SERIAL_OUTPUT,
  > @@ -454,6 +495,39 @@
  > fe->ops.tuner_ops.set_config(fe, &ctl);
  > }
  > break;
  > + case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
  > + i2c_bus =3D &dev->i2c_bus[port->nr - 1];
  > +
  > + /* Take demod and tuner out of reset */
  > + if (port->nr =3D=3D 1)
  > + cx_set(GP0_IO, 0x0303);
  > + else if (port->nr =3D=3D 2)
  > + cx_set(GP0_IO, 0x0c0c);
  > + mdelay(5);
  > + port->dvb.frontend =3D dvb_attach(zl10353_attach,
  > + &dvico_fusionhdtv_xc3028,
  > + &i2c_bus->i2c_adap);
  > + if (port->dvb.frontend !=3D NULL) {
  > + struct dvb_frontend *fe;
  > + struct xc2028_config cfg =3D {
  > + .i2c_adap =3D &i2c_bus->i2c_adap,
  > + .i2c_addr =3D 0x61,
  > + .video_dev =3D port,
  > + .callback =3D cx23885_dvico_xc2028_callback,
  > + };
  > + static struct xc2028_ctrl ctl =3D {
  > + .fname =3D "xc3028-dvico-au-01.fw",
  > + .max_len =3D 64,
  > + .scode_table =3D ZARLINK456,
  > + };
  > +
  > + fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,
  > + &cfg);
  > + if (fe !=3D NULL && fe->ops.tuner_ops.set_config !=3D NULL)
  > + fe->ops.tuner_ops.set_config(fe, &ctl);
  > + }
  > + break;
  > + }
  > default:
  > printk("%s: The frontend of your DVB/ATSC card isn't
  > supported yet\n",
  > dev->name);
  > diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
  > v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
  > --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h 2008-05-14
  > 09:48:22.000000000 +1000
  > +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
  > 2008-05-14 13:39:30.000000000 +1000
  > @@ -66,6 +66,7 @@
  > #define CX23885_BOARD_HAUPPAUGE_HVR1200 7
  > #define CX23885_BOARD_HAUPPAUGE_HVR1700 8
  > #define CX23885_BOARD_HAUPPAUGE_HVR1400 9
  > +#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 10
  >
  > /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM
  > B/G/H/LC */
  > #define CX23885_NORMS (\
  > diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig
  > v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
  > --- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig 2008-05-14
  > 09:48:22.000000000 +1000
  > +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
  > 2008-05-14 13:39:30.000000000 +1000
  > @@ -15,6 +15,7 @@
  > select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
  > select DVB_S5H1409 if !DVB_FE_CUSTOMISE
  > select DVB_LGDT330X if !DVB_FE_CUSTOMISE
  > + select DVB_ZL10353 if !DVB_FE_CUSTOMISE
  > select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
  > select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
  > select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
  >
  >
  >
  > -- See Exclusive Video: 10th Annual Young Hollywood Awards
  >

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1211103942292755
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Allan,<br><br>My patch has not been merged into the branch,<br><br>For the =
moment don't worry about it and use Chris Pascoe's xc-test branch.&nbsp; <b=
r><br>I have worked out what my issue is on the one PC that didn't work.&nb=
sp; I'm actually surprised it worked on the other systems, it was only due =
to a weird coincidence in identifying my other tuner cards first.<br>I have=
 been slowly going through the source to attempt to solve this, I will post=
 when it is working reliably on all machines.<br><br>Thanks for at least tr=
ying it.<br><br>Regards,<br>Stephen<br><br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "allan k" <sonofzev@iinet.net.au><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]<br>
Date: Sat, 17 May 2008 21:27:19 +1000<br>
<br>

<br>
Hi Steve<br>
<br>
I'm getting a large amount of noise again, although after previous<br>
restarts this didn't happen.<br>
<br>
I'm wondering if your patch is already merged into the v4l sources or if<br>
I need to use this one you sent.<br>
<br>
cheers<br>
<br>
Allan<br>
On Wed, 2008-05-14 at 15:54 +1000, stev391@email.com wrote:<br>
&gt;<br>
&gt; I have updated my patch (from a week ago) and is included inline below=
<br>
&gt; as well as an attachment. The issue that was noticed and mentioned in<=
br>
&gt; previous posts regarding to tuners not resetting was possibly due to<b=
r>
&gt; several "__FUNCTION_" in the tuner reset code, these should be<br>
&gt; "__func__", which is fixed in the attached patch.<br>
&gt;<br>
&gt; This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is<br>
&gt; intended to merge Chris Pascoe's work into the current head to enable<=
br>
&gt; support for the DViCO Fusion HDTV DVB-T Dual Express (PCIe).  This<br>
&gt; enables systems with different tuners to take advantage of other<br>
&gt; experimental drivers, (for example my TV Walker Twin USB tuner).<br>
&gt;<br>
&gt; Regards,<br>
&gt;<br>
&gt; Stephen<br>
&gt;<br>
&gt; diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885<br>
&gt; v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885<br>
&gt; --- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885<br>
&gt; 2008-05-14 09:48:21.000000000 +1000<br>
&gt; +++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885<br>
&gt; 2008-05-14 13:39:30.000000000 +1000<br>
&gt; @@ -8,3 +8,4 @@<br>
&gt;    7 -&gt; Hauppauge WinTV-HVR1200<br>
&gt; [0070:71d1,0070:71d3]<br>
&gt;   ;  8 -&gt; Hauppauge WinTV-HVR1700<br>
&gt; [0070:8101]<br>
&gt;    9 -&gt; Hauppauge WinTV-HVR1400<br>
&gt; [0070:8010]<br>
&gt; + 10 -&gt; DViCO FusionHDTV DVB-T Dual Express<br>
&gt; [18ac:db78]<br>
&gt; diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c<b=
r>
&gt; v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c<br>
&gt; --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c<br>
&gt; 2008-05-14 09:48:22.000000000 +1000<br>
&gt; +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c<br>
&gt; 2008-05-14 13:39:30.000000000 +1000<br>
&gt; @@ -144,6 +144,11 @@<br>
&gt;          .name        =3D "Hauppauge WinTV-HVR1400",<br>
&gt;          .portc        =3D CX23885_MPEG_DVB,<br>
&gt;      },<br>
&gt; +    [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] =3D {<br>
&gt; +        .name        =3D "DViCO FusionHDTV DVB-T Dual Express",<br>
&gt; +        .portb        =3D CX23885_MPEG_DVB,<br>
&gt; +        .portc        =3D CX23885_MPEG_DVB,<br>
&gt; +    },<br>
&gt;  };<br>
&gt;  const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);<br>
&gt;<br>
&gt; @@ -211,6 +216,10 @@<br>
&gt;          .subvendor =3D 0x0070,<br>
&gt;          .subdevice =3D 0x8010,<br>
&gt;          .card      =3D CX23885_BOARD_HAUPPAUGE_HVR1400,<br>
&gt; +    },{<br>
&gt; +        .subvendor =3D 0x18ac,<br>
&gt; +        .subdevice =3D 0xdb78,<br>
&gt; +        .card      =3D CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,=
<br>
&gt;      },<br>
&gt;  };<br>
&gt;  const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);<br>
&gt; @@ -428,6 +437,13 @@<br>
&gt;          mdelay(20);<br>
&gt;          cx_set(GP0_IO, 0x00050005);<br>
&gt;          break;<br>
&gt; +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
&gt; +        /* GPIO-0 portb xc3028 reset */<br>
&gt; +        /* GPIO-1 portb zl10353 reset */<br>
&gt; +        /* GPIO-2 portc xc3028 reset */<br>
&gt; +        /* GPIO-3 portc zl10353 reset */<br>
&gt; +        cx_write(GP0_IO, 0x002f1000);<br>
&gt; +        break;<br>
&gt;      }<br>
&gt;  }<br>
&gt;<br>
&gt; @@ -442,6 +458,9 @@<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1400:<br>
&gt;          /* FIXME: Implement me */<br>
&gt;          break;<br>
&gt; +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
&gt; +        request_module("ir-kbd-i2c");<br>
&gt; +        break;<br>
&gt;      }<br>
&gt;<br>
&gt;      return 0;<br>
&gt; @@ -478,6 +497,11 @@<br>
&gt;      }<br>
&gt;<br>
&gt;      switch (dev-&gt;board) {<br>
&gt; +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:<br>
&gt; +        ts2-&gt;gen_ctrl_val  =3D 0xc; /* Serial bus + punctured cloc=
k */<br>
&gt; +        ts2-&gt;ts_clk_en_val =3D 0x1; /* Enable TS_CLK */<br>
&gt; +        ts2-&gt;src_sel_val   =3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO=
;<br>
&gt; +        /* FALLTHROUGH */<br>
&gt;      case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:<br>
&gt;          ts1-&gt;gen_ctrl_val  =3D 0xc; /* Serial bus + punctured cloc=
k */<br>
&gt;          ts1-&gt;ts_clk_en_val =3D 0x1; /* Enable TS_CLK */<br>
&gt; diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
&gt; v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
&gt; --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
&gt; 2008-05-14 09:48:22.000000000 +1000<br>
&gt; +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
&gt; 2008-05-14 13:39:30.000000000 +1000<br>
&gt; @@ -42,6 +42,9 @@<br>
&gt;  #include "tuner-simple.h"<br>
&gt;  #include "dib7000p.h"<br>
&gt;  #include "dibx000_common.h"<br>
&gt; +#include "zl10353.h"<br>
&gt; +#include "tuner-xc2028.h"<br>
&gt; +#include "tuner-xc2028-types.h"<br>
&gt;<br>
&gt;  static unsigned int debug;<br>
&gt;<br>
&gt; @@ -155,6 +158,44 @@<br>
&gt;      .serial_mpeg =3D 0x40,<br>
&gt;  };<br>
&gt;<br>
&gt; +static int cx23885_dvico_xc2028_callback(void *ptr, int command, int<=
br>
&gt; arg)<br>
&gt; +{<br>
&gt; +    struct cx23885_tsport *port =3D ptr;<br>
&gt; +    struct cx23885_dev *dev =3D port-&gt;dev;<br>
&gt; +    u32 reset_mask =3D 0;<br>
&gt; +<br>
&gt; +    switch (command) {<br>
&gt; +    case XC2028_TUNER_RESET:<br>
&gt; +        dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __func__,<=
br>
&gt; +            arg, port-&gt;nr);<br>
&gt; +<br>
&gt; +        if (port-&gt;nr =3D=3D 1)<br>
&gt; +            reset_mask =3D 0x0101;<br>
&gt; +        else if (port-&gt;nr =3D=3D 2)<br>
&gt; +            reset_mask =3D 0x0404;<br>
&gt; +<br>
&gt; +        cx_clear(GP0_IO, reset_mask);<br>
&gt; +        mdelay(5);<br>
&gt; +        cx_set(GP0_IO, reset_mask);<br>
&gt; +        break;<br>
&gt; +    case XC2028_RESET_CLK:<br>
&gt; +        dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);<br>
&gt; +        break;<br>
&gt; +    default:<br>
&gt; +        dprintk(1, "%s: unknown command %d, arg %d\n", __func__,<br>
&gt; +               command, arg);<br>
&gt; +        return -EINVAL;<br>
&gt; +    }<br>
&gt; +<br>
&gt; +    return 0;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static struct zl10353_config dvico_fusionhdtv_xc3028 =3D {<br>
&gt; +    .demod_address =3D 0x0f,<br>
&gt; +    .if2           =3D 45600,<br>
&gt; +    .no_tuner      =3D 1,<br>
&gt; +};<br>
&gt; +<br>
&gt;  static struct s5h1409_config hauppauge_hvr1500q_config =3D {<br>
&gt;      .demod_address =3D 0x32 &gt;&gt; 1,<br>
&gt;      .output_mode   =3D S5H1409_SERIAL_OUTPUT,<br>
&gt; @@ -454,6 +495,39 @@<br>
&gt;                  fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>
&gt;          }<br>
&gt;          break;<br>
&gt; +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {<br>
&gt; +        i2c_bus =3D &amp;dev-&gt;i2c_bus[port-&gt;nr - 1];<br>
&gt; +<br>
&gt; +        /* Take demod and tuner out of reset */<br>
&gt; +        if (port-&gt;nr =3D=3D 1)<br>
&gt; +            cx_set(GP0_IO, 0x0303);<br>
&gt; +        else if (port-&gt;nr =3D=3D 2)<br>
&gt; +            cx_set(GP0_IO, 0x0c0c);<br>
&gt; +        mdelay(5);<br>
&gt; +        port-&gt;dvb.frontend =3D dvb_attach(zl10353_attach,<br>
&gt; +                           &amp;dvico_fusionhdtv_xc3028,<br>
&gt; +                           &amp;i2c_bus-&gt;i2c_adap);<br>
&gt; +        if (port-&gt;dvb.frontend !=3D NULL) {<br>
&gt; +            struct dvb_frontend      *fe;<br>
&gt; +            struct xc2028_config      cfg =3D {<br>
&gt; +                .i2c_adap  =3D &amp;i2c_bus-&gt;i2c_adap,<br>
&gt; +                .i2c_addr  =3D 0x61,<br>
&gt; +                .video_dev =3D port,<br>
&gt; +                .callback  =3D cx23885_dvico_xc2028_callback,<br>
&gt; +            };<br>
&gt; +            static struct xc2028_ctrl ctl =3D {<br>
&gt; +                .fname       =3D "xc3028-dvico-au-01.fw",<br>
&gt; +                .max_len     =3D 64,<br>
&gt; +                .scode_table =3D ZARLINK456,<br>
&gt; +            };<br>
&gt; +<br>
&gt; +            fe =3D dvb_attach(xc2028_attach, port-&gt;dvb.frontend,<b=
r>
&gt; +                    &amp;cfg);<br>
&gt; +            if (fe !=3D NULL &amp;&amp; fe-&gt;ops.tuner_ops.set_conf=
ig !=3D NULL)<br>
&gt; +                fe-&gt;ops.tuner_ops.set_config(fe, &amp;ctl);<br>
&gt; +        }<br>
&gt; +        break;<br>
&gt; +        }<br>
&gt;      default:<br>
&gt;          printk("%s: The frontend of your DVB/ATSC card isn't<br>
&gt; supported yet\n",<br>
&gt;                 dev-&gt;name);<br>
&gt; diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h<br>
&gt; v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h<br>
&gt; --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h    2008-05-14<=
br>
&gt; 09:48:22.000000000 +1000<br>
&gt; +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h<br>
&gt; 2008-05-14 13:39:30.000000000 +1000<br>
&gt; @@ -66,6 +66,7 @@<br>
&gt;  #define CX23885_BOARD_HAUPPAUGE_HVR1200        7<br>
&gt;  #define CX23885_BOARD_HAUPPAUGE_HVR1700        8<br>
&gt;  #define CX23885_BOARD_HAUPPAUGE_HVR1400        9<br>
&gt; +#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 10<br>
&gt;<br>
&gt;  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM<br>
&gt; B/G/H/LC */<br>
&gt;  #define CX23885_NORMS (\<br>
&gt; diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig<br>
&gt; v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig<br>
&gt; --- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig    2008-05-14<br>
&gt; 09:48:22.000000000 +1000<br>
&gt; +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig<br>
&gt; 2008-05-14 13:39:30.000000000 +1000<br>
&gt; @@ -15,6 +15,7 @@<br>
&gt;      select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE<br>
&gt;      select DVB_S5H1409 if !DVB_FE_CUSTOMISE<br>
&gt;      select DVB_LGDT330X if !DVB_FE_CUSTOMISE<br>
&gt; +     select DVB_ZL10353 if !DVB_FE_CUSTOMISE<br>
&gt;      select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE<br>
&gt;      select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE<br>
&gt;      select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; -- See Exclusive Video: 10th Annual Young Hollywood Awards<br>
&gt;<br>
</sonofzev@iinet.net.au></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_1211103942292755--



--===============0121973945==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0121973945==--
