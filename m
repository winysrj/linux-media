Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbZASLCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 06:02:08 -0500
Date: Mon, 19 Jan 2009 09:01:24 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: CityK <cityk@rogers.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090119090124.24ac6020@pedra.chehab.org>
In-Reply-To: <4973BD03.4060702@rogers.com>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<200901182011.11960.hverkuil@xs4all.nl>
	<49739D1E.5050800@rogers.com>
	<200901182241.10047.hverkuil@xs4all.nl>
	<4973BD03.4060702@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 18 Jan 2009 18:36:35 -0500
CityK <cityk@rogers.com> wrote:

> Hans Verkuil wrote:
> > On Sunday 18 January 2009 22:20:30 CityK wrote:
> >   
> >> The output of dmesg is interesting (two times tuner simple initiating):
> > Shouldn't there be a tda9887 as well? It's what the card config says, but
> > I'm not sure whether that is correct.
> >  
> >   
> >> Would you like to see the results of after enabling 12c_scan to see what
> >> is going on, or is this the behaviour you expected?
> >>     
> >
> > It seems to be OK, although I find it a bit peculiar that the tuner type
> > is set twice. Or does that have to do with it being a hybrid tuner, perhaps?
> >   
> 
> The Philips TUV1236D NIM does indeed use a tda9887  (I know, because I
> was the one who discovered this some four years ago (pats self on
> head)).  But the module is not loading.  I can make it load, just as
> Hermann demonstrated to Mike in one of the recent messages for this thread.

>From what I got from the sources, nxt200x has an i2c gate. For accessing the
tuner, the gate needs to be opened. Maybe we need to close the gate in order to
access tda9887.

Unfortunately, I don't have nxt200x datasheet. Things would be clearer with the docs.

> >> Some Other Miscellanea:
> >> 1) Before this gets merged, can I ask you to also make one small change
> >> to tuner-simple; specifically, swap the contents of lines 301 and 304.  
> >> This will change the driver's default behaviour in regards to the
> >> selection of which RF input to use for digital cable and digital
> >> over-the-air.  Currently, the driver is set to use digital OTA on the
> >> top RF input and digital cable on the lower RF input spigot.  However,
> >> IMO, a more logical/convenient configuration is to have the digital
> >> cable input be handled by the top RF input spigot, as this is the same
> >> one that the analog cable is also drawn from by default. Mike had made
> >> this change, on my request, previously, but it appears that it got
> >> reverted after the tuner re-factoring. 

Could you provide a patch against the current tree?

> >>
> >> Note:  users have reported different default configurations in the past
> >> (e.g. http://www.mythtv.org/wiki/Kworld_ATSC_110), but I actually doubt
> >> that there has been any manufacturing difference with the TUV1236D. 
> >> Rather, I suspect that the user experiences being reported are just
> >> reflecting a combination of the different states of how our driver
> >> behaved in the past and differences in driver version that they may have
> >> been using (i.e. that version provided by/within their distro or by our
> >> Hg).  After all, this configuration setting has gone from being handled
> >> by saa7134-dvb.c to dvb-pll.c to tuner-simple.c, with changes in the
> >> behaviour implemented along the way.

The issue doesn't seem to be related to TUV1236D, but, instead with nxt200x.
The i2c command to enable the tuner is sent to nxt200x. If there are any
ATSC110 variant with a different demod (maybe a different version of nxt200x?),
then the users may experience different behaviors.

> > I'm not going to merge this, it's just a quick hack for this card. This
> > is something for Mike or Hermann to fix. 
> 
> Fair enough 

Please test the enclosed patch. It adds a proper gate_ctrl callback at saa7134
core, and initializes it for ATSC110. 

The gate_ctrl is close to what we currently have on cx88 driver, however with a
simpler implementation. We'll likely need to improve it, moving the i2c gate
control into nxt200x, adding the i2c close commands, and putting the gate_ctrl
initialization into saa7134-dvb.

You should notice that we don't know how to close the gate. So, the code is
still a workaroud.. However, to properly implement it, we need the help
of someone with the datasheets.

> > Someone with a better knowledge
> > of this driver and these tuners should review the saa7134_board_init2()
> > function and move the opening of tuner gate/muxes to a separate function.

This should be needed to do per board. The issue here is that we need to know
the i2c open and close cmds.

Cheers,
Mauro

---
saa7134: Fix tuner access on Kworld ATSC110

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r 0622096401ec linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jan 18 23:20:02 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Jan 19 08:43:36 2009 -0200
@@ -5994,6 +5994,32 @@
 }
 
 /* ----------------------------------------------------------- */
+
+static void nxt200x_gate_ctrl(struct saa7134_dev *dev, int open)
+{
+	/* enable tuner */
+	int i;
+	static const u8 buffer [][2] = { 
+		{ 0x10, 0x12 }, 
+		{ 0x13, 0x04 },
+		{ 0x16, 0x00 },
+		{ 0x14, 0x04 },
+		{ 0x17, 0x00 },
+	};
+
+	dev->i2c_client.addr = 0x0a;
+
+	/* FIXME: don't know how to close the i2c gate on NXT200x */
+	if (!open)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(buffer); i++)
+		if (2 != i2c_master_send(&dev->i2c_client,
+					 &buffer[i][0], ARRAY_SIZE(buffer[0])))
+			printk(KERN_WARNING
+			       "%s: Unable to enable tuner(%i).\n",
+			       dev->name, i);
+}
 
 int saa7134_board_init1(struct saa7134_dev *dev)
 {
@@ -6192,6 +6218,10 @@
 		       "are supported for now.\n",
 			dev->name, card(dev).name, dev->name);
 		break;
+	case SAA7134_BOARD_ADS_INSTANT_HDTV_PCI:
+	case SAA7134_BOARD_KWORLD_ATSC110:
+		dev->gate_ctrl = nxt200x_gate_ctrl;
+		break;
 	}
 	return 0;
 }
@@ -6453,22 +6483,6 @@
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
-	case SAA7134_BOARD_ADS_INSTANT_HDTV_PCI:
-	case SAA7134_BOARD_KWORLD_ATSC110:
-	{
-		/* enable tuner */
-		int i;
-		static const u8 buffer [] = { 0x10, 0x12, 0x13, 0x04, 0x16,
-					      0x00, 0x14, 0x04, 0x17, 0x00 };
-		dev->i2c_client.addr = 0x0a;
-		for (i = 0; i < 5; i++)
-			if (2 != i2c_master_send(&dev->i2c_client,
-						 &buffer[i*2], 2))
-				printk(KERN_WARNING
-				       "%s: Unable to enable tuner(%i).\n",
-				       dev->name, i);
-		break;
-	}
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
 		/* The T200 and the T200A share the same pci id.  Consequently,
diff -r 0622096401ec linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Jan 18 23:20:02 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Jan 19 08:43:36 2009 -0200
@@ -594,6 +594,7 @@
 	int (*original_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
 	int (*original_set_high_voltage)(struct dvb_frontend *fe, long arg);
 #endif
+	void (*gate_ctrl)(struct saa7134_dev *dev, int open);
 };
 
 /* ----------------------------------------------------------- */
@@ -623,10 +624,24 @@
 		V4L2_STD_PAL_60)
 
 #define GRP_EMPRESS (1)
-#define saa_call_all(dev, o, f, args...) \
-	v4l2_device_call_all(&(dev)->v4l2_dev, 0, o, f , ##args)
-#define saa_call_empress(dev, o, f, args...) \
-	v4l2_device_call_until_err(&(dev)->v4l2_dev, GRP_EMPRESS, o, f , ##args)
+#define saa_call_all(dev, o, f, args...) do {				\
+	if (dev->gate_ctrl)						\
+		dev->gate_ctrl(dev, 1);					\
+	v4l2_device_call_all(&(dev)->v4l2_dev, 0, o, f , ##args);	\
+	if (dev->gate_ctrl)						\
+		dev->gate_ctrl(dev, 0);					\
+} while (0)
+
+#define saa_call_empress(dev, o, f, args...) ({				\
+	long _rc;							\
+	if (dev->gate_ctrl)						\
+		dev->gate_ctrl(dev, 1);					\
+	_rc = v4l2_device_call_until_err(&(dev)->v4l2_dev,		\
+				         GRP_EMPRESS, o, f , ##args);	\
+	if (dev->gate_ctrl)						\
+		dev->gate_ctrl(dev, 0);					\
+	_rc;								\
+})
 
 /* ----------------------------------------------------------- */
 /* saa7134-core.c                                              */

