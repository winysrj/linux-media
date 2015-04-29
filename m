Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbD2XGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 22/27] bttv: fix audio hooks
Date: Wed, 29 Apr 2015 20:06:07 -0300
Message-Id: <df1c9e21d389e42b6d450a5b855831f6783d9d08.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

as reported by smatch:
	drivers/media/pci/bt8xx/bttv-audio-hook.c:201 lt9415_audio() warn: bitwise AND condition is false here
	drivers/media/pci/bt8xx/bttv-audio-hook.c:241 winfast2000_audio() warn: bitwise AND condition is false here
	drivers/media/pci/bt8xx/bttv-audio-hook.c:276 pvbt878p9b_audio() warn: bitwise AND condition is false here
	drivers/media/pci/bt8xx/bttv-audio-hook.c:307 fv2000s_audio() warn: bitwise AND condition is false here
	drivers/media/pci/bt8xx/bttv-audio-hook.c:334 windvr_audio() warn: bitwise AND condition is false here
	drivers/media/pci/bt8xx/bttv-audio-hook.c:371 adtvk503_audio() warn: bitwise AND condition is false here

there are some serious issues at the audio hook implementation.

They're not following what's specified at the DocBook:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-tuner.html#tuner-audmode

Basically, it was assuming that the audmode (V4L2_TUNER_MODE_foo)
is a variable with a bit maskk. However, it isn't.

The bitmask only applies to rxsubchans field (V4L2_TUNER_SUB_foo).

As the code is also too complex, and not all hooks were returning
both audmode and rxsubchans to a VIDIOC_G_TUNER, rewrite the
functions, in order to fix both for get and set tuner ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/bt8xx/bttv-audio-hook.c b/drivers/media/pci/bt8xx/bttv-audio-hook.c
index 2364d16586b3..2b91a24b8183 100644
--- a/drivers/media/pci/bt8xx/bttv-audio-hook.c
+++ b/drivers/media/pci/bt8xx/bttv-audio-hook.c
@@ -54,23 +54,33 @@ void winview_volume(struct bttv *btv, __u16 volume)
 
 void gvbctv3pci_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 {
-	unsigned int con = 0;
+	unsigned int con;
 
-	if (set) {
-		gpio_inout(0x300, 0x300);
-		if (t->audmode & V4L2_TUNER_MODE_LANG1)
-			con = 0x000;
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)
-			con = 0x300;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)
-			con = 0x200;
-/*		if (t->audmode & V4L2_TUNER_MODE_MONO)
- *			con = 0x100; */
-		gpio_bits(0x300, con);
-	} else {
-		t->audmode = V4L2_TUNER_MODE_STEREO |
-			  V4L2_TUNER_MODE_LANG1  | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
+	}
+
+	gpio_inout(0x300, 0x300);
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_LANG1:
+	default:
+		con = 0x000;
+		break;
+	case V4L2_TUNER_MODE_LANG2:
+		con = 0x300;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		con = 0x200;
+		break;
 	}
+	gpio_bits(0x300, con);
 }
 
 void gvbctv5pci_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
@@ -82,16 +92,16 @@ void gvbctv5pci_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 
 	val = gpio_read();
 	if (set) {
-		con = 0x000;
-		if (t->audmode & V4L2_TUNER_MODE_LANG2) {
-			if (t->audmode & V4L2_TUNER_MODE_LANG1) {
-				/* LANG1 + LANG2 */
-				con = 0x100;
-			}
-			else {
-				/* LANG2 */
-				con = 0x300;
-			}
+		switch (t->audmode) {
+		case V4L2_TUNER_MODE_LANG2:
+			con = 0x300;
+			break;
+		case V4L2_TUNER_MODE_LANG1_LANG2:
+			con = 0x100;
+			break;
+		default:
+			con = 0x000;
+			break;
 		}
 		if (con != (val & 0x300)) {
 			gpio_bits(0x300, con);
@@ -102,27 +112,31 @@ void gvbctv5pci_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 		switch (val & 0x70) {
 		  case 0x10:
 			t->rxsubchans = V4L2_TUNER_SUB_LANG1 |  V4L2_TUNER_SUB_LANG2;
+			t->audmode = V4L2_TUNER_MODE_LANG1_LANG2;
 			break;
 		  case 0x30:
 			t->rxsubchans = V4L2_TUNER_SUB_LANG2;
+			t->audmode = V4L2_TUNER_MODE_LANG1_LANG2;
 			break;
 		  case 0x50:
 			t->rxsubchans = V4L2_TUNER_SUB_LANG1;
+			t->audmode = V4L2_TUNER_MODE_LANG1_LANG2;
 			break;
 		  case 0x60:
 			t->rxsubchans = V4L2_TUNER_SUB_STEREO;
+			t->audmode = V4L2_TUNER_MODE_STEREO;
 			break;
 		  case 0x70:
 			t->rxsubchans = V4L2_TUNER_SUB_MONO;
+			t->audmode = V4L2_TUNER_MODE_MONO;
 			break;
 		  default:
 			t->rxsubchans = V4L2_TUNER_SUB_MONO |
 					 V4L2_TUNER_SUB_STEREO |
 					 V4L2_TUNER_SUB_LANG1 |
 					 V4L2_TUNER_SUB_LANG2;
+			t->audmode = V4L2_TUNER_MODE_LANG1;
 		}
-		t->audmode = V4L2_TUNER_MODE_STEREO |
-			  V4L2_TUNER_MODE_LANG1  | V4L2_TUNER_MODE_LANG2;
 	}
 }
 
@@ -142,23 +156,32 @@ void gvbctv5pci_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 
 void avermedia_tvphone_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 {
-	int val = 0;
+	int val;
 
-	if (set) {
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)   /* SAP */
-			val = 0x02;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)
-			val = 0x01;
-		if (val) {
-			gpio_bits(0x03,val);
-			if (bttv_gpio)
-				bttv_gpio_tracking(btv,"avermedia");
-		}
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			V4L2_TUNER_MODE_LANG1;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
+	}
+
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_LANG2:   /* SAP */
+		val = 0x02;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		val = 0x01;
+		break;
+	default:
 		return;
 	}
+	gpio_bits(0x03,val);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"avermedia");
 }
 
 
@@ -166,19 +189,31 @@ void avermedia_tv_stereo_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 {
 	int val = 0;
 
-	if (set) {
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)   /* SAP */
-			val = 0x01;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)  /* STEREO */
-			val = 0x02;
-		btaor(val, ~0x03, BT848_GPIO_DATA);
-		if (bttv_gpio)
-			bttv_gpio_tracking(btv,"avermedia");
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
 		return;
 	}
+
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_LANG2:   /* SAP */
+		val = 0x01;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		val = 0x02;
+		break;
+	default:
+		val = 0;
+		break;
+	}
+	btaor(val, ~0x03, BT848_GPIO_DATA);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"avermedia");
 }
 
 /* Lifetec 9415 handling */
@@ -192,23 +227,32 @@ void lt9415_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 		return;
 	}
 
-	if (set) {
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)  /* A2 SAP */
-			val = 0x0080;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO) /* A2 stereo */
-			val = 0x0880;
-		if ((t->audmode & V4L2_TUNER_MODE_LANG1) ||
-		    (t->audmode & V4L2_TUNER_MODE_MONO))
-			val = 0;
-		gpio_bits(0x0880, val);
-		if (bttv_gpio)
-			bttv_gpio_tracking(btv,"lt9415");
-	} else {
-		/* autodetect doesn't work with this card :-( */
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
 		return;
 	}
+
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_LANG2:	/* A2 SAP */
+		val = 0x0080;
+		break;
+	case V4L2_TUNER_MODE_STEREO:	/* A2 stereo */
+		val = 0x0880;
+		break;
+	default:
+		val = 0;
+		break;
+	}
+
+	gpio_bits(0x0880, val);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"lt9415");
 }
 
 /* TDA9821 on TerraTV+ Bt848, Bt878 */
@@ -216,45 +260,69 @@ void terratv_audio(struct bttv *btv,  struct v4l2_tuner *t, int set)
 {
 	unsigned int con = 0;
 
-	if (set) {
-		gpio_inout(0x180000,0x180000);
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)
-			con = 0x080000;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)
-			con = 0x180000;
-		gpio_bits(0x180000, con);
-		if (bttv_gpio)
-			bttv_gpio_tracking(btv,"terratv");
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
 	}
+
+	gpio_inout(0x180000,0x180000);
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_LANG2:
+		con = 0x080000;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		con = 0x180000;
+		break;
+	default:
+		con = 0;
+		break;
+	}
+	gpio_bits(0x180000, con);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"terratv");
 }
 
 
 void winfast2000_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 {
-	unsigned long val = 0;
+	unsigned long val;
 
-	if (set) {
-		/*btor (0xc32000, BT848_GPIO_OUT_EN);*/
-		if (t->audmode & V4L2_TUNER_MODE_MONO)		/* Mono */
-			val = 0x420000;
-		if (t->audmode & V4L2_TUNER_MODE_LANG1)	/* Mono */
-			val = 0x420000;
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)	/* SAP */
-			val = 0x410000;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)	/* Stereo */
-			val = 0x020000;
-		if (val) {
-			gpio_bits(0x430000, val);
-			if (bttv_gpio)
-				bttv_gpio_tracking(btv,"winfast2000");
-		}
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			  V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
+	}
+
+	/*btor (0xc32000, BT848_GPIO_OUT_EN);*/
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_MONO:
+	case V4L2_TUNER_MODE_LANG1:
+		val = 0x420000;
+		break;
+	case V4L2_TUNER_MODE_LANG2: /* SAP */
+		val = 0x410000;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		val = 0x020000;
+		break;
+	default:
+		return;
 	}
+
+	gpio_bits(0x430000, val);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"winfast2000");
 }
 
 /*
@@ -272,23 +340,33 @@ void pvbt878p9b_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 	if (btv->radio_user)
 		return;
 
-	if (set) {
-		if (t->audmode & V4L2_TUNER_MODE_MONO)	{
-			val = 0x01;
-		}
-		if ((t->audmode & (V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2))
-		    || (t->audmode & V4L2_TUNER_MODE_STEREO)) {
-			val = 0x02;
-		}
-		if (val) {
-			gpio_bits(0x03,val);
-			if (bttv_gpio)
-				bttv_gpio_tracking(btv,"pvbt878p9b");
-		}
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
 	}
+
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_MONO:
+		val = 0x01;
+		break;
+	case V4L2_TUNER_MODE_LANG1:
+	case V4L2_TUNER_MODE_LANG2:
+	case V4L2_TUNER_MODE_STEREO:
+		val = 0x02;
+		break;
+	default:
+		return;
+	}
+
+	gpio_bits(0x03,val);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"pvbt878p9b");
 }
 
 /*
@@ -298,28 +376,37 @@ void pvbt878p9b_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
  */
 void fv2000s_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 {
-	unsigned int val = 0xffff;
+	unsigned int val;
 
 	if (btv->radio_user)
 		return;
 
-	if (set) {
-		if (t->audmode & V4L2_TUNER_MODE_MONO)	{
-			val = 0x0000;
-		}
-		if ((t->audmode & (V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2))
-		    || (t->audmode & V4L2_TUNER_MODE_STEREO)) {
-			val = 0x1080; /*-dk-???: 0x0880, 0x0080, 0x1800 ... */
-		}
-		if (val != 0xffff) {
-			gpio_bits(0x1800, val);
-			if (bttv_gpio)
-				bttv_gpio_tracking(btv,"fv2000s");
-		}
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
 	}
+
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_MONO:
+		val = 0x0000;
+		break;
+	case V4L2_TUNER_MODE_LANG1:
+	case V4L2_TUNER_MODE_LANG2:
+	case V4L2_TUNER_MODE_STEREO:
+		val = 0x1080; /*-dk-???: 0x0880, 0x0080, 0x1800 ... */
+		break;
+	default:
+		return;
+	}
+	gpio_bits(0x1800, val);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"fv2000s");
 }
 
 /*
@@ -328,26 +415,33 @@ void fv2000s_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
  */
 void windvr_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 {
-	unsigned long val = 0;
+	unsigned long val;
 
-	if (set) {
-		if (t->audmode & V4L2_TUNER_MODE_MONO)
-			val = 0x040000;
-		if (t->audmode & V4L2_TUNER_MODE_LANG1)
-			val = 0;
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)
-			val = 0x100000;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)
-			val = 0;
-		if (val) {
-			gpio_bits(0x140000, val);
-			if (bttv_gpio)
-				bttv_gpio_tracking(btv,"windvr");
-		}
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			  V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
+	}
+
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_MONO:
+		val = 0x040000;
+		break;
+	case V4L2_TUNER_MODE_LANG2:
+		val = 0x100000;
+		break;
+	default:
+		return;
 	}
+
+	gpio_bits(0x140000, val);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv,"windvr");
 }
 
 /*
@@ -360,23 +454,36 @@ void adtvk503_audio(struct bttv *btv, struct v4l2_tuner *t, int set)
 
 	/* btaor(0x1e0000, ~0x1e0000, BT848_GPIO_OUT_EN); */
 
-	if (set) {
-		/* btor(***, BT848_GPIO_OUT_EN); */
-		if (t->audmode & V4L2_TUNER_MODE_LANG1)
-			con = 0x00000000;
-		if (t->audmode & V4L2_TUNER_MODE_LANG2)
-			con = 0x00180000;
-		if (t->audmode & V4L2_TUNER_MODE_STEREO)
-			con = 0x00000000;
-		if (t->audmode & V4L2_TUNER_MODE_MONO)
-			con = 0x00060000;
-		if (con != 0xffffff) {
-			gpio_bits(0x1e0000,con);
-			if (bttv_gpio)
-				bttv_gpio_tracking(btv, "adtvk503");
-		}
-	} else {
-		t->audmode = V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO |
-			  V4L2_TUNER_MODE_LANG1  | V4L2_TUNER_MODE_LANG2;
+	if (!set) {
+		/* Not much to do here */
+		t->audmode = V4L2_TUNER_MODE_LANG1;
+		t->rxsubchans = V4L2_TUNER_SUB_MONO |
+                                V4L2_TUNER_SUB_STEREO |
+                                V4L2_TUNER_SUB_LANG1 |
+                                V4L2_TUNER_SUB_LANG2;
+
+		return;
 	}
+
+	/* btor(***, BT848_GPIO_OUT_EN); */
+	switch (t->audmode) {
+	case V4L2_TUNER_MODE_LANG1:
+		con = 0x00000000;
+		break;
+	case V4L2_TUNER_MODE_LANG2:
+		con = 0x00180000;
+		break;
+	case V4L2_TUNER_MODE_STEREO:
+		con = 0x00000000;
+		break;
+	case V4L2_TUNER_MODE_MONO:
+		con = 0x00060000;
+		break;
+	default:
+		return;
+	}
+
+	gpio_bits(0x1e0000,con);
+	if (bttv_gpio)
+		bttv_gpio_tracking(btv, "adtvk503");
 }
-- 
2.1.0

