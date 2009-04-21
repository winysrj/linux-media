Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3L7YDtG021743
	for <video4linux-list@redhat.com>; Tue, 21 Apr 2009 03:34:13 -0400
Received: from mail-fx0-f180.google.com (mail-fx0-f180.google.com
	[209.85.220.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3L7XwB3012395
	for <video4linux-list@redhat.com>; Tue, 21 Apr 2009 03:33:58 -0400
Received: by fxm28 with SMTP id 28so2462166fxm.3
	for <video4linux-list@redhat.com>; Tue, 21 Apr 2009 00:33:57 -0700 (PDT)
Date: Tue, 21 Apr 2009 17:35:42 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20090421173542.0f39b071@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/dHByNfY4InWMogRqmqrMhZ5"
Subject: [QUESTION] FM1216ME_MK3 control of GAIN
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/dHByNfY4InWMogRqmqrMhZ5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

We can control the sensitivity of the tuner FM1216ME_MK3. This is my test patch for discuss.

1. Add gain variable to tuner structure.
2. Add V4L2_CID_GAIN control to saa7134 and disable this control.
3. Add workaround to simple_post_tune function for write sensitivity level to the tuner.
4. Enable V4L2_CID_GAIN control when module load if card is right.

My expirience not so good, step 4 segfault the kernel. How to we can make it?

Our windows end-user programm control the sensitivity of each TV channel and change when
channel changed.

What you think about it??

diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Tue Apr 21 09:44:38 2009 +1000
@@ -116,6 +116,7 @@
 
 	u32 frequency;
 	u32 bandwidth;
+	signed int gain;
 };
 
 /* ---------------------------------------------------------------------- */
@@ -495,15 +507,57 @@
 				   "(should be 4)\n", rc);
 		break;
 	}
+	case TUNER_PHILIPS_FM1216ME_MK3:
+	{
+		buffer[2] = 0xDE; /* T2 = 0, T1 = 1 and T0 = 1 */
+		switch (priv->gain) {
+		case 0:
+			/* TOP = External AGC, ATC = OFF */
+			buffer[3] = 0x60;
+			break;
+		case 1:
+			/* TOP = 118 dB, ATC = OFF */
+			buffer[3] = 0x00;
+			break;
+		case 2:
+			/* TOP = 115 dB, ATC = OFF */
+			buffer[3] = 0x10;
+			break;
+		case 3:
+			/* TOP = 112 dB, ATC = OFF */
+			buffer[3] = 0x20;
+			break;
+		case 4:
+			/* TOP = 109 dB, ATC = OFF */
+			buffer[3] = 0x30;
+			break;
+		case 5:
+			/* TOP = 106 dB, ATC = OFF */
+			buffer[3] = 0x40;
+			break;
+		case 6:
+			/* TOP = 103 dB, ATC = OFF */
+			buffer[3] = 0x50;
+			break;
+		default:
+			/* TOP = 112 dB, ATC = OFF */
+			buffer[3] = 0x20;
+			break;
+		}
+
+		tuner_dbg("tv 0x%02x 0x%02x 0x%02x 0x%02x\n",
+			  buffer[0], buffer[1], buffer[2], buffer[3]);
+
+		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
+		if (4 != rc)
+			tuner_warn("i2c i/o error: rc == %d "
+				   "(should be 4)\n", rc);
+
+		break;
 	}
-
+	}
 	return 0;
 }
 
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 21 09:44:38 2009 +1000
@@ -6506,6 +6806,20 @@
 		saa_call_all(dev, tuner, s_config, &tea5767_cfg);
 		break;
 	}
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
+	{
+		struct v4l2_queryctrl *ctl;
+		struct saa7134_fh *fh;
+		struct file *fl;
+
+		ctl->id = V4L2_CID_GAIN;
+		if (saa7134_queryctrl(fl, fh, ctl) == 0) {
+			/* enable this control */
+			ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED);
+		}
+	}
 	} /* switch() */
 
 	saa7134_tuner_setup(dev);
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Apr 21 09:44:38 2009 +1000
@@ -417,6 +417,15 @@
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
+	}, {
+		.id 		= V4L2_CID_GAIN,
+		.name 		= "Gain",
+		.minimum 	= 0,
+		.maximum 	= 6,
+		.step 		= 1,
+		.default_value 	= 3,
+		.type 		= V4L2_CTRL_TYPE_INTEGER,
+		.flags 		= V4L2_CTRL_FLAG_DISABLED,
 	},{
 		.id            = V4L2_CID_HFLIP,
 		.name          = "Mirror",
@@ -1129,6 +1138,9 @@
 	case V4L2_CID_HUE:
 		c->value = dev->ctl_hue;
 		break;
+	case V4L2_CID_GAIN:
+		c->value = dev->ctl_gain;
+		break;
 	case V4L2_CID_CONTRAST:
 		c->value = dev->ctl_contrast;
 		break;
@@ -1214,6 +1226,10 @@
 	case V4L2_CID_HUE:
 		dev->ctl_hue = c->value;
 		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
+		break;
+	case V4L2_CID_GAIN:
+		dev->ctl_gain = c->value;
+
 		break;
 	case V4L2_CID_CONTRAST:
 		dev->ctl_contrast = c->value;
@@ -2502,6 +2518,7 @@
 	dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
 	dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
 	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
+	dev->ctl_gain       = ctrl_by_id(V4L2_CID_GAIN)->default_value;
 	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
 	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
 	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 21 09:44:38 2009 +1000
@@ -548,6 +558,7 @@
 	int                        ctl_bright;
 	int                        ctl_contrast;
 	int                        ctl_hue;
+	int                        ctl_gain;             /* gain */
 	int                        ctl_saturation;
 	int                        ctl_freq;
 	int                        ctl_mute;             /* audio */

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
--MP_/dHByNfY4InWMogRqmqrMhZ5
Content-Type: text/x-patch; name=behold_mk3_gain.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_mk3_gain.diff

diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Tue Apr 21 09:44:38 2009 +1000
@@ -116,6 +116,7 @@
 
 	u32 frequency;
 	u32 bandwidth;
+	signed int gain;
 };
 
 /* ---------------------------------------------------------------------- */
@@ -495,15 +507,57 @@
 				   "(should be 4)\n", rc);
 		break;
 	}
+	case TUNER_PHILIPS_FM1216ME_MK3:
+	{
+		buffer[2] = 0xDE; /* T2 = 0, T1 = 1 and T0 = 1 */
+		switch (priv->gain) {
+		case 0:
+			/* TOP = External AGC, ATC = OFF */
+			buffer[3] = 0x60;
+			break;
+		case 1:
+			/* TOP = 118 dB, ATC = OFF */
+			buffer[3] = 0x00;
+			break;
+		case 2:
+			/* TOP = 115 dB, ATC = OFF */
+			buffer[3] = 0x10;
+			break;
+		case 3:
+			/* TOP = 112 dB, ATC = OFF */
+			buffer[3] = 0x20;
+			break;
+		case 4:
+			/* TOP = 109 dB, ATC = OFF */
+			buffer[3] = 0x30;
+			break;
+		case 5:
+			/* TOP = 106 dB, ATC = OFF */
+			buffer[3] = 0x40;
+			break;
+		case 6:
+			/* TOP = 103 dB, ATC = OFF */
+			buffer[3] = 0x50;
+			break;
+		default:
+			/* TOP = 112 dB, ATC = OFF */
+			buffer[3] = 0x20;
+			break;
+		}
+
+		tuner_dbg("tv 0x%02x 0x%02x 0x%02x 0x%02x\n",
+			  buffer[0], buffer[1], buffer[2], buffer[3]);
+
+		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
+		if (4 != rc)
+			tuner_warn("i2c i/o error: rc == %d "
+				   "(should be 4)\n", rc);
+
+		break;
 	}
-
+	}
 	return 0;
 }
 
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 21 09:44:38 2009 +1000
@@ -6506,6 +6806,20 @@
 		saa_call_all(dev, tuner, s_config, &tea5767_cfg);
 		break;
 	}
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
+	{
+		struct v4l2_queryctrl *ctl;
+		struct saa7134_fh *fh;
+		struct file *fl;
+
+		ctl->id = V4L2_CID_GAIN;
+		if (saa7134_queryctrl(fl, fh, ctl) == 0) {
+			/* enable this control */
+			ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED);
+		}
+	}
 	} /* switch() */
 
 	saa7134_tuner_setup(dev);
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Apr 21 09:44:38 2009 +1000
@@ -417,6 +417,15 @@
 		.step          = 1,
 		.default_value = 0,
 		.type          = V4L2_CTRL_TYPE_INTEGER,
+	}, {
+		.id 		= V4L2_CID_GAIN,
+		.name 		= "Gain",
+		.minimum 	= 0,
+		.maximum 	= 6,
+		.step 		= 1,
+		.default_value 	= 3,
+		.type 		= V4L2_CTRL_TYPE_INTEGER,
+		.flags 		= V4L2_CTRL_FLAG_DISABLED,
 	},{
 		.id            = V4L2_CID_HFLIP,
 		.name          = "Mirror",
@@ -1129,6 +1138,9 @@
 	case V4L2_CID_HUE:
 		c->value = dev->ctl_hue;
 		break;
+	case V4L2_CID_GAIN:
+		c->value = dev->ctl_gain;
+		break;
 	case V4L2_CID_CONTRAST:
 		c->value = dev->ctl_contrast;
 		break;
@@ -1214,6 +1226,10 @@
 	case V4L2_CID_HUE:
 		dev->ctl_hue = c->value;
 		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
+		break;
+	case V4L2_CID_GAIN:
+		dev->ctl_gain = c->value;
+
 		break;
 	case V4L2_CID_CONTRAST:
 		dev->ctl_contrast = c->value;
@@ -2502,6 +2518,7 @@
 	dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
 	dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
 	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
+	dev->ctl_gain       = ctrl_by_id(V4L2_CID_GAIN)->default_value;
 	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
 	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
 	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 21 09:44:38 2009 +1000
@@ -548,6 +558,7 @@
 	int                        ctl_bright;
 	int                        ctl_contrast;
 	int                        ctl_hue;
+	int                        ctl_gain;             /* gain */
 	int                        ctl_saturation;
 	int                        ctl_freq;
 	int                        ctl_mute;             /* audio */

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
--MP_/dHByNfY4InWMogRqmqrMhZ5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/dHByNfY4InWMogRqmqrMhZ5--
