Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52031 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab0AaNqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 08:46:15 -0500
Received: by bwz27 with SMTP id 27so2430176bwz.21
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 05:46:14 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: paul10@planar.id.au, "linux-media" <linux-media@vger.kernel.org>,
	Christian =?iso-8859-1?q?H=FCppe?= <christian.hueppe@web.de>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Sun, 31 Jan 2010 15:45:09 +0200
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au> <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au> <52aaba8d0f6ba9e6928ea68d96565bf4@mail.velocitynet.com.au>
In-Reply-To: <52aaba8d0f6ba9e6928ea68d96565bf4@mail.velocitynet.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_llYZLd2RTRM1+KK"
Message-Id: <201001311545.09620.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_llYZLd2RTRM1+KK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 20 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2010 23:20:20 paul10@planar.id.a=
u wrote:
> Igor wrote:
> > Oh, that is wrong. It is registers addresses, Never touch this.
> >
> > Let's look on that part of code:
> >
> > /* GPIO's for LNB power control */
> > #define DM1105_LNB_MASK                         0x00000000 // later in
>
> code write it to
>
> > DM1105_GPIOCTR, all GPIO's as OUT
> > #define DM1105_LNB_OFF                          0x00020000 // later in
>
> code write it to
>
> > DM1105_GPIOVAL, set GPIO17 to HIGH
> >
> > But you have not to change this.
> > Right way is to write another entry in cards structure and so on.
> > Better leave it to me.
> >
> > Regards
> > Igor
>
> Thanks for all your help, I understand better now.  I have moved to code
> like that at the bottom.  It still doesn't work, but feels a lot closer.
>
> Before I keep playing with values, I want to check I'm on the right track.
> Does it look right?  Specific questions:
> 1. I see there is a hw_init function.  Should I be using that?  I put the
> logic into fe_attach because there was already card-specific logic in
> there.  But this feels like hw initialisation.
>
> 2. Should I set the control to input or output?  I'm assuming input =3D 1.
>
> 3. Would pin 15 be numbered from the left or right - is it 0x4, or 0x2000?
>
> Thanks,
>
> Paul
>
> *** dm1105.c.old        2010-01-13 16:15:00.000000000 +1100
> --- dm1105.c    2010-01-21 08:13:14.000000000 +1100
> ***************
> *** 51,56 ****
> --- 51,57 ----
>   #define DM1105_BOARD_DVBWORLD_2002    1
>   #define DM1105_BOARD_DVBWORLD_2004    2
>   #define DM1105_BOARD_AXESS_DM05               3
> + #define DM1105_BOARD_UNBRANDED                4
>
>   /* ----------------------------------------------- */
>   /*
> ***************
> *** 171,176 ****
> --- 172,181 ----
>   #define DM05_LNB_13V                          0x00020000
>   #define DM05_LNB_18V                          0x00030000
>
> + /* GPIO's for demod reset for unbranded 195d:1105 */
> + #define UNBRANDED_DEMOD_MASK                  0x00008000
> + #define UNBRANDED_DEMOD_RESET                 0x00008000
> +
>   static unsigned int card[]  =3D {[0 ... 3] =3D UNSET };
>   module_param_array(card,  int, NULL, 0444);
>   MODULE_PARM_DESC(card, "card type");
> ***************
> *** 206,211 ****
> --- 211,219 ----
>         [DM1105_BOARD_AXESS_DM05] =3D {
>                 .name           =3D "Axess/EasyTv DM05",
>         },
> +       [DM1105_BOARD_UNBRANDED] =3D {
> +               .name           =3D "Unbranded 195d:1105",
> +         },
>   };
>
>   static const struct dm1105_subid dm1105_subids[] =3D {
> ***************
> *** 229,234 ****
> --- 237,246 ----
>                 .subvendor =3D 0x195d,
>                 .subdevice =3D 0x1105,
>                 .card      =3D DM1105_BOARD_AXESS_DM05,
> +       }, {
> +               .subvendor =3D 0x195d,
> +               .subdevice =3D 0x1105,
> +               .card      =3D DM1105_BOARD_UNBRANDED,
>         },
>   };
>
> ***************
> *** 698,703 ****
> --- 710,727 ----
>                         dm1105dvb->fe->ops.set_voltage =3D
> dm1105dvb_set_voltage;
>
>                 break;
> +       case DM1105_BOARD_UNBRANDED:
> +                 printk(KERN_ERR "Attaching as board_unbranded\n");
> +               outl(UNBRANDED_DEMOD_MASK, dm_io_mem(DM1105_GPIOCTR));
> +               outl(UNBRANDED_DEMOD_RESET , dm_io_mem(DM1105_GPIOVAL));
> +               dm1105dvb->fe =3D dvb_attach(
> +                       si21xx_attach, &serit_config,
> +                       &dm1105dvb->i2c_adap);
> +                       if (dm1105dvb->fe)
> +                               dm1105dvb->fe->ops.set_voltage =3D
> +                                       dm1105dvb_set_voltage;
> +
> +               break;
>         case DM1105_BOARD_DVBWORLD_2002:
>         case DM1105_BOARD_AXESS_DM05:
>         default:
Some things are missed, like keep GPIO15 high in set_voltage function.
Try attached patch against current v4l-dvb tree with modprobe option card=
=3D4
	modprobe dm1105 card=3D4
=2D-=20
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks



--Boundary-00=_llYZLd2RTRM1+KK
Content-Type: text/x-patch;
  charset="utf-8";
  name="dm1105_gpio15.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dm1105_gpio15.diff"

diff -r d6520e486ee6 linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Sat Jan 30 01:27:34 2010 -0200
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Sun Jan 31 15:35:30 2010 +0200
@@ -52,6 +52,7 @@
 #define DM1105_BOARD_DVBWORLD_2002	1
 #define DM1105_BOARD_DVBWORLD_2004	2
 #define DM1105_BOARD_AXESS_DM05		3
+#define DM1105_BOARD_UNBRANDED_GPIO15	4
 
 /* ----------------------------------------------- */
 /*
@@ -207,6 +208,9 @@
 	[DM1105_BOARD_AXESS_DM05] = {
 		.name		= "Axess/EasyTv DM05",
 	},
+	[DM1105_BOARD_UNBRANDED_GPIO15] = {
+		.name		= "Unbranded Board GPIO15",
+	},
 };
 
 static const struct dm1105_subid dm1105_subids[] = {
@@ -327,6 +331,8 @@
 #define dm_setl(reg, bit)	dm_andorl((reg), (bit), (bit))
 #define dm_clearl(reg, bit)	dm_andorl((reg), (bit), 0)
 
+#define DM1105_GPIO(x)		(1 << x)
+
 static int dm1105_i2c_xfer(struct i2c_adapter *i2c_adap,
 			    struct i2c_msg *msgs, int num)
 {
@@ -441,6 +447,12 @@
 	u32 lnb_mask, lnb_13v, lnb_18v, lnb_off;
 
 	switch (dev->boardnr) {
+	case DM1105_BOARD_UNBRANDED_GPIO15:
+		lnb_mask = DM05_LNB_MASK;
+		lnb_off = DM05_LNB_OFF | DM1105_GPIO(15);/* keep GPIO15 high */
+		lnb_13v = DM05_LNB_13V | DM1105_GPIO(15);
+		lnb_18v = DM05_LNB_18V | DM1105_GPIO(15);
+		break;
 	case DM1105_BOARD_AXESS_DM05:
 		lnb_mask = DM05_LNB_MASK;
 		lnb_off = DM05_LNB_OFF;
@@ -758,6 +770,14 @@
 			dev->fe->ops.set_voltage = dm1105_set_voltage;
 
 		break;
+	case DM1105_BOARD_UNBRANDED_GPIO15:
+		/* reset frontend */
+		dm_clearl(DM1105_GPIOCTR, DM1105_GPIO(15));
+		dm_clearl(DM1105_GPIOVAL, DM1105_GPIO(15));
+		msleep(10);
+		dm_setl(DM1105_GPIOVAL, DM1105_GPIO(15));
+		msleep(100);
+	/* break omitted intentionally */
 	case DM1105_BOARD_DVBWORLD_2002:
 	case DM1105_BOARD_AXESS_DM05:
 	default:

--Boundary-00=_llYZLd2RTRM1+KK--
