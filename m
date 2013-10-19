Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.seznam.cz ([77.75.72.43]:44597 "EHLO smtp1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3JSQMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Oct 2013 12:12:19 -0400
Message-ID: <5262AC1E.5030303@email.cz>
Date: Sat, 19 Oct 2013 17:58:22 +0200
From: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.m@email.cz>
MIME-Version: 1.0
To: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
CC: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: cx23885: Add basic analog radio support
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com> <524F0F57.5020605@netscape.net>
In-Reply-To: <524F0F57.5020605@netscape.net>
Content-Type: multipart/mixed;
 boundary="------------050009070306070902050608"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050009070306070902050608
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, i am not using those devices anymore for analog, we do change our 
devices to SDR and SW demodulation, but i am sending my latest patches 
all for kernel 3.2.XX

Feel free to resubmit any kind of my code by your name ;)

Miroslav Slugeň
+420 724 825 885

Alfredo Jesús Delaiti napsal(a):
> Hi all
>
>
> El 14/01/12 15:25, Miroslav Slugeň escribió:
>> New version of patch, fixed video modes for DVR3200 tuners and working
>> audio mux.
>
> I tested this patch (https://linuxtv.org/patch/9498/) with the latest
> versions of git (September 28, 2013) with my TV card (Mygica X8507) and
> it works.
> I found some issue, although it may be through a bad implementation of
> mine.
>
> Details of them:
>
> 1) Some warning when compiling
>
> ...
> CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.o
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8:
> : initialization from incompatible pointer type [enabled by default]
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8:
> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_tuner')
> [enabled by default]
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8:
> warning: initialization from incompatible pointer type [enabled by default]
> /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8:
> warning: (near initialization for 'radio_ioctl_ops.vidioc_s_audio')
> [enabled by default]
> CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-vbi.o
> ...
>
> --------------------------------------------------------
> static const struct v4l2_ioctl_ops radio_ioctl_ops = {
>
> .vidioc_s_tuner = radio_s_tuner, /* line 1910 */
> .vidioc_s_audio = radio_s_audio, /* line 1911 */
>
> --------------------------------------------------------
>
> 2)
> No reports signal strength or stereo signal with KRadio. XC5000 neither
> reported (modprobe xc5000 debug=1). Maybe a feature XC5000.
> To listen in stereo, sometimes, you have to turn on the Digital TV then
> Analog TV and then radio.
>
> 3)
> To listen Analog TV I need changed to NTSC standard and then PAL-Nc (the
> norm in my country is PAL-Nc). If I leave the tune in NTSC no problem
> with sound.
> The patch (https://linuxtv.org/patch/9505/) corrects the latter, if used
> tvtime with xawtv not always.
> If I see-Digital TV (ISDB-T), then so as to listen the radio I have
> first put the TV-Analog, because I hear very low and a strong white noise.
> The latter is likely to be corrected by resetting the tuner, I have to
> study it more.
>
> I put below attached the patch applied to the plate: X8507.
>
> Have you done any update of this patch?
>
> Thanks

--------------050009070306070902050608
Content-Type: text/x-diff;
 name="cx25840_audio_fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx25840_audio_fixes.patch"

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
From: Miroslav Slugen <thunder.mmm@gmail.com>
Date: Mon, 12 Dec 2011 00:19:34 +0100
Subject: [PATCH] This patch should fix many analog audio issues for cx23885 based cards.

1. Rewrite part of set_input to cx25840_audio_set_path, this part should be
 set only when soft reset is asserted and microcontroler is stopped.
 
2. While using AUDIO6 and AUDIO7 inputs we should always stop microcontroler,
 because they are not tuner inputs, this should fix no-audio for composite
 s-video and componnet input on many types of tuners.

3. Add radio_deemphasis support, in Europe we use 50us, with 75us sound is not so cool.

4. Add audio_standard_force support. On many types of cards autodetection of
 audio standard just doesn't work, my research in this shows that it could be
 just in wrong registers settings or in detection algorithm, so if we want to
 have audio on such broken tuners we have to force audio standard, this is done
 in input_change and should not introduce any regression, i tested this behavior
 on card with working autodetection Leadtek DVR3200H_xc4000 and with not working
 DVR3200H_xc3028, first card has audio even with previouse code, but xc3028
 (older model) has no audio, to get audio support it require to set AUD_STANDARD
 register, of course forced mode is available in driver level (pvr150_workaround)
 or as option to module.
 
5. Improve format detection as writen in cx25840 datasheet, this is done in
 cx23885_initialize and in input_change functions.
 In init it is necesary to reset tuner autodetection and tuner.
 In input change i just add others formats from datasheet, previouse code was
 just for NTSC detection, and it is also necesary to reset microcontroler, but
 only if it is running.

---
diff -Naurp a/drivers/media/video/cx25840/cx25840-audio.c b/drivers/media/video/cx25840/cx25840-audio.c
--- a/drivers/media/video/cx25840/cx25840-audio.c	2012-01-05 00:55:44.000000000 +0100
+++ b/drivers/media/video/cx25840/cx25840-audio.c	2012-01-14 16:05:38.616366747 +0100
@@ -446,14 +446,45 @@ void cx25840_audio_set_path(struct i2c_c
 
 		/* Mute everything to prevent the PFFT! */
 		cx25840_write(client, 0x8d3, 0x1f);
+		cx25840_write(client, 0x8e3, 0x03);
 
-		if (state->aud_input == CX25840_AUDIO_SERIAL) {
+		if (is_cx231xx(state) || is_cx2388x(state)) {
+			/* Path1 require different GPIO0 pin mux */
+			if ((state->aud_input == CX25840_AUDIO6) ||
+			    (state->aud_input == CX25840_AUDIO7)) {
+				cx25840_write(client, 0x124, 0x00);
+			} else {
+				/* Audio channel 1 src : Parallel 1 */
+				cx25840_write(client, 0x124, 0x03);
+			}
+
+			/* Select AFE clock pad output source */
+			if (is_cx2388x(state))
+				cx25840_write(client, 0x144, 0x05);
+
+			/* I2S_IN_CTL: I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1 */
+			cx25840_write(client, 0x914, 0xa0);
+
+			/* I2S_OUT_CTL:
+			 * I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1
+			 * I2S_OUT_MASTER_MODE = Master
+			 */
+			cx25840_write(client, 0x918, 0xa0);
+			cx25840_write(client, 0x919, 0x01);
+
+			if ((state->aud_input == CX25840_AUDIO6) ||
+			    (state->aud_input == CX25840_AUDIO7)) {
+				cx25840_write4(client, 0x910, 0);
+				cx25840_write4(client, 0x8d0, 0x00063073);
+				/* Reset path1 volume control */
+				cx25840_write4(client, 0x8d4, 0x7fff0024);
+			} else { /* default for all sources, not only AUDIO8 */
+				cx25840_write4(client, 0x910, 0x12b000c9);
+				cx25840_write4(client, 0x8d0, 0x1f063870);
+			}
+		} else if (state->aud_input == CX25840_AUDIO_SERIAL) {
 			/* Set Path1 to Serial Audio Input */
 			cx25840_write4(client, 0x8d0, 0x01011012);
-
-			/* The microcontroller should not be started for the
-			 * non-tuner inputs: autodetection is specific for
-			 * TV audio. */
 		} else {
 			/* Set Path1 to Analog Demod Main Channel */
 			cx25840_write4(client, 0x8d0, 0x1f063870);
@@ -463,7 +494,12 @@ void cx25840_audio_set_path(struct i2c_c
 	set_audclk_freq(client, state->audclk_freq);
 
 	if (!is_cx2583x(state)) {
-		if (state->aud_input != CX25840_AUDIO_SERIAL) {
+		/* The microcontroller should not be started for the
+		 * non-tuner inputs: autodetection is specific for
+		 * TV audio. */
+		if ((state->aud_input != CX25840_AUDIO_SERIAL) &&
+		    (state->aud_input != CX25840_AUDIO6) &&
+		    (state->aud_input != CX25840_AUDIO7)) {
 			/* When the microcontroller detects the
 			 * audio format, it will unmute the lines */
 			cx25840_and_or(client, 0x803, ~0x10, 0x10);
@@ -471,10 +507,6 @@ void cx25840_audio_set_path(struct i2c_c
 
 		/* deassert soft reset */
 		cx25840_and_or(client, 0x810, ~0x1, 0x00);
-
-		/* Ensure the controller is running when we exit */
-		if (is_cx2388x(state) || is_cx231xx(state))
-			cx25840_and_or(client, 0x803, ~0x10, 0x10);
 	}
 }
 
diff -Naurp a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
--- a/drivers/media/video/cx25840/cx25840-core.c	2012-01-14 18:02:41.968366747 +0100
+++ b/drivers/media/video/cx25840/cx25840-core.c	2012-01-14 18:03:33.024366746 +0100
@@ -73,11 +73,18 @@ MODULE_LICENSE("GPL");
 #define CX25840_IR_IRQEN_REG	0x214
 
 static int cx25840_debug;
-
-module_param_named(debug,cx25840_debug, int, 0644);
-
+module_param_named(debug, cx25840_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debugging messages [0=Off (default) 1=On]");
 
+static unsigned int radio_deemphasis = 0;
+module_param(radio_deemphasis, int, 0644);
+MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant "
+				   "[0=75us (USA) 1=50us (elsewhere)]");
+
+static unsigned int audio_standard_force = 0;
+module_param(audio_standard_force, int, 0644);
+MODULE_PARM_DESC(audio_standard_force, "Force audio standard for tuners with broken"
+				       "microcontroler autodetection [0=Off (default) 1=TV 2=TV+FM]");
 
 /* ----------------------------------------------------------------------- */
 
@@ -474,7 +481,7 @@ static void cx23885_initialize(struct i2
 	cx25840_and_or(client, 0x102, ~0x01, 0x01);
 	cx25840_and_or(client, 0x102, ~0x01, 0x00);
 
-	/* Stop microcontroller */
+	/* 2. Stop microcontroller */
 	cx25840_and_or(client, 0x803, ~0x10, 0x00);
 
 	/* DIF in reset? */
@@ -536,12 +543,6 @@ static void cx23885_initialize(struct i2
 	cx25840_write4(client, 0x10c, 0x002be2c9);
 	cx25840_write4(client, 0x108, 0x0000040f);
 
-	/* Luma */
-	cx25840_write4(client, 0x414, 0x00107d12);
-
-	/* Chroma */
-	cx25840_write4(client, 0x420, 0x3d008282);
-
 	/*
 	 * Aux PLL
 	 * Initial setup for audio sample clock:
@@ -586,12 +587,6 @@ static void cx23885_initialize(struct i2
 	/* VIN1 & VIN5 */
 	cx25840_write(client, 0x103, 0x11);
 
-	/* Enable format auto detect */
-	cx25840_write(client, 0x400, 0);
-	/* Fast subchroma lock */
-	/* White crush, Chroma AGC & Chroma Killer enabled */
-	cx25840_write(client, 0x401, 0xe8);
-
 	/* Select AFE clock pad output source */
 	cx25840_write(client, 0x144, 0x05);
 
@@ -604,7 +599,14 @@ static void cx23885_initialize(struct i2
 	cx25840_write(client, 0x160, 0x1d);
 	cx25840_write(client, 0x164, 0x00);
 
-	/* Do the firmware load in a work handler to prevent.
+	/* Enable format auto detect */
+	cx25840_write(client, 0x400, 0);
+
+	/* 4. Reset tuner autodetection */
+	cx25840_and_or(client, 0x13c, ~0x01, 0x01);
+	cx25840_and_or(client, 0x13c, ~0x01, 0x00);
+
+	/* 5. Do the firmware load in a work handler to prevent.
 	   Otherwise the kernel is blocked waiting for the
 	   bit-banging i2c interface to finish uploading the
 	   firmware. */
@@ -617,13 +619,32 @@ static void cx23885_initialize(struct i2
 	finish_wait(&state->fw_wait, &wait);
 	destroy_workqueue(q);
 
+	/* 7. Reset and initialize video decoder */
+	cx25840_write4(client, 0x4a4, 0x8000);
+	cx25840_write4(client, 0x4a4, 0);
+	cx25840_write(client, 0x402, 0x00);
+
+	/* 8. White crush, Chroma AGC & Chroma Killer enabled.
+	 * From datasheet and spoted from Leadtek drivers we
+	 * should not set Fast Lock and Auto Chroma Lock Speed.
+	 */
+	cx25840_write(client, 0x401, 0xe0);
+
+	/* Luma */
+	cx25840_write4(client, 0x414, 0x00107d12);
+
+	/* Chroma */
+	cx25840_write4(client, 0x420, 0x3d008282);
+
 	cx25840_std_setup(client);
 
 	/* (re)set input */
 	set_input(client, state->vid_input, state->aud_input);
 
-	/* start microcontroller */
-	cx25840_and_or(client, 0x803, ~0x10, 0x10);
+	/* start microcontroller only for tuner inputs */
+	if ((state->aud_input != CX25840_AUDIO6) &&
+	    (state->aud_input != CX25840_AUDIO7))
+		cx25840_and_or(client, 0x803, ~0x10, 0x10);
 
 	/* Disable and clear video interrupts - we don't use them */
 	cx25840_write4(client, CX25840_VID_INT_STAT_REG, 0xffffffff);
@@ -678,6 +699,7 @@ static void cx231xx_initialize(struct i2
 
 	/* Enable format auto detect */
 	cx25840_write(client, 0x400, 0);
+
 	/* Fast subchroma lock */
 	/* White crush, Chroma AGC & Chroma Killer enabled */
 	cx25840_write(client, 0x401, 0xe8);
@@ -866,72 +888,112 @@ static void input_change(struct i2c_clie
 {
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	v4l2_std_id std = state->std;
+	u8 fmt = cx25840_read(client, 0x40D);
+	int hw_fix = (audio_standard_force > state->pvr150_workaround) ?
+			audio_standard_force : state->pvr150_workaround;
 
 	/* Follow step 8c and 8d of section 3.16 in the cx25840 datasheet */
 	if (std & V4L2_STD_SECAM) {
 		cx25840_write(client, 0x402, 0);
-	}
-	else {
+	} else {
 		cx25840_write(client, 0x402, 0x04);
 		cx25840_write(client, 0x49f, (std & V4L2_STD_NTSC) ? 0x14 : 0x11);
 	}
-	cx25840_and_or(client, 0x401, ~0x60, 0);
-	cx25840_and_or(client, 0x401, ~0x60, 0x60);
+
+	/* Step 9. Improve format detection */
+	if (((fmt & 0x0f) > 0x3) ||
+	    ((fmt & 0x0f) < 0x9)) {
+		/* Switch to NTSC and back */
+		u8 val = cx25840_read(client, 0x400);
+		cx25840_and_or(client, 0x400, ~0x0f, 0x01);
+		/* Disable LCOMB_3LN_EN and LCOMB_2LN_EN */
+		cx25840_and_or(client, 0x47b, ~0x06, 0);
+		cx25840_and_or(client, 0x400, ~0x0f, (val & 0x0f));
+
+		/* Toggle CAGCEN and CKILLEN */
+		cx25840_and_or(client, 0x401, ~0x60, 0);
+		cx25840_and_or(client, 0x401, ~0x60, 0x60);
+	} else if ((fmt & 0x0f) == 0x9) {
+		/* Toggle CKILLEN */
+		cx25840_and_or(client, 0x401, ~0x20, 0);
+		cx25840_and_or(client, 0x401, ~0x20, 0x20);
+		/* Standard autodetection */
+		cx25840_and_or(client, 0x400, ~0x0f, 0x00);
+	} else {
+		/* Toggle CAGCEN and CKILLEN */
+		cx25840_and_or(client, 0x401, ~0x60, 0);
+		cx25840_and_or(client, 0x401, ~0x60, 0x60);
+	}
 
 	/* Don't write into audio registers on cx2583x chips */
 	if (is_cx2583x(state))
 		return;
 
+	/* Toggle microcontroller only when running */
+	if (cx25840_read(client, 0x803) & 0x10) {
+		cx25840_and_or(client, 0x803, ~0x10, 0x00);
+		msleep(1);
+		cx25840_and_or(client, 0x803, ~0x10, 0x10);
+	}
+
 	cx25840_and_or(client, 0x810, ~0x01, 1);
 
+	/* Use default audio format control */
+	cx25840_write(client, 0x80b, 0);
+
 	if (state->radio) {
-		cx25840_write(client, 0x808, 0xf9);
-		cx25840_write(client, 0x80b, 0x00);
-	}
-	else if (std & V4L2_STD_525_60) {
-		/* Certain Hauppauge PVR150 models have a hardware bug
-		   that causes audio to drop out. For these models the
-		   audio standard must be set explicitly.
-		   To be precise: it affects cards with tuner models
-		   85, 99 and 112 (model numbers from tveeprom). */
-		int hw_fix = state->pvr150_workaround;
-
-		if (std == V4L2_STD_NTSC_M_JP) {
-			/* Japan uses EIAJ audio standard */
-			cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
-		} else if (std == V4L2_STD_NTSC_M_KR) {
-			/* South Korea uses A2 audio standard */
-			cx25840_write(client, 0x808, hw_fix ? 0x3f : 0xf8);
-		} else {
-			/* Others use the BTSC audio standard */
-			cx25840_write(client, 0x808, hw_fix ? 0x1f : 0xf6);
-		}
-		cx25840_write(client, 0x80b, 0x00);
-	} else if (std & V4L2_STD_PAL) {
-		/* Autodetect audio standard and audio system */
+		/* Disable fm_deviation, set deemphasis, don't mute and prefer stereo */
+		cx25840_write(client, 0x809, radio_deemphasis ? 0x24 : 0x04);
+		/* For FM mode hw_fix is not necessary */
+		cx25840_write(client, 0x808, (hw_fix > 1) ? 0xef : 0xf9);
+	} else if (std == V4L2_STD_NTSC_M_JP) {
+		/* Japan uses EIAJ audio standard */
+		cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
+	} else if (std == V4L2_STD_NTSC_M_KR) {
+		/* South Korea uses A2 audio standard */
+		cx25840_write(client, 0x808, hw_fix ? 0x3f : 0xf8);
+	} else if (std & (V4L2_STD_525_60 | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
+		/* NTSC, PAL-60, PAL-M and PAL-N uses BTSC audio standard */
+		cx25840_write(client, 0x808, hw_fix ? 0x1f : 0xf6);
+	} else if ((std & (V4L2_STD_PAL_BG | V4L2_STD_PAL_H)) &&
+		   !(std & V4L2_STD_PAL_DK) &&
+		   !(std & V4L2_STD_PAL_I)) {
+		/* A2-BG */
+		cx25840_write(client, 0x808, hw_fix ? 0x4f : 0xf0);
+	} else if (!(std & (V4L2_STD_PAL_BG | V4L2_STD_PAL_H)) &&
+		    (std & V4L2_STD_PAL_DK) &&
+		   !(std & V4L2_STD_PAL_I)) {
+		/* A2-DK1 */
+		cx25840_write(client, 0x808, hw_fix ? 0x5f : 0xf1);
+	} else if (!(std & (V4L2_STD_PAL_BG | V4L2_STD_PAL_H)) &&
+		   !(std & V4L2_STD_PAL_DK) &&
+		    (std & V4L2_STD_PAL_I)) {
+		/* A1 */
+		cx25840_write(client, 0x808, hw_fix ? 0x8f : 0xf4);
+	} else if ((std & (V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H)) &&
+		   !(std & V4L2_STD_SECAM_DK) &&
+		   !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
+		/* NICAM-BG */
+		cx25840_write(client, 0x808, hw_fix ? 0xaf : 0xf0);
+	} else if (!(std & (V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H)) &&
+		    (std & V4L2_STD_SECAM_DK) &&
+		   !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
+		/* NICAM-DK */
+		cx25840_write(client, 0x808, hw_fix ? 0xbf : 0xf1);
+	} else if (!(std & (V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H)) &&
+		   !(std & V4L2_STD_SECAM_DK) &&
+		    (std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
+		/* 6.5 MHz carrier to be interpreted as System L */
+		cx25840_write(client, 0x80b, 0x08);
+		/* NICAM-L */
+		cx25840_write(client, 0x808, hw_fix ? 0xdf : 0xf5);
+        } else if (std & V4L2_STD_SECAM) {
+		/* 6.5 MHz carrier to be autodetected */
+		cx25840_write(client, 0x80b, 0x10);
 		cx25840_write(client, 0x808, 0xff);
-		/* Since system PAL-L is pretty much non-existent and
-		   not used by any public broadcast network, force
-		   6.5 MHz carrier to be interpreted as System DK,
-		   this avoids DK audio detection instability */
-	       cx25840_write(client, 0x80b, 0x00);
-	} else if (std & V4L2_STD_SECAM) {
-		/* Autodetect audio standard and audio system */
+	} else {
+		/* Audio standard autodetection - not working on some cards */
 		cx25840_write(client, 0x808, 0xff);
-		/* If only one of SECAM-DK / SECAM-L is required, then force
-		  6.5MHz carrier, else autodetect it */
-		if ((std & V4L2_STD_SECAM_DK) &&
-		    !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
-			/* 6.5 MHz carrier to be interpreted as System DK */
-			cx25840_write(client, 0x80b, 0x00);
-	       } else if (!(std & V4L2_STD_SECAM_DK) &&
-			  (std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
-			/* 6.5 MHz carrier to be interpreted as System L */
-			cx25840_write(client, 0x80b, 0x08);
-	       } else {
-			/* 6.5 MHz carrier to be autodetected */
-			cx25840_write(client, 0x80b, 0x10);
-	       }
 	}
 
 	cx25840_and_or(client, 0x810, ~0x01, 0);
@@ -950,7 +1012,7 @@ static int set_input(struct i2c_client *
 	u8 reg;
 
 	v4l_dbg(1, cx25840_debug, client,
-		"decoder set video input %d, audio input %d\n",
+		"decoder set video input 0x%x, audio input 0x%x\n",
 		vid_input, aud_input);
 
 	if (vid_input >= CX25840_VIN1_CH1) {
@@ -1043,49 +1105,6 @@ static int set_input(struct i2c_client *
 	cx25840_audio_set_path(client);
 	input_change(client);
 
-	if (is_cx2388x(state)) {
-		/* Audio channel 1 src : Parallel 1 */
-		cx25840_write(client, 0x124, 0x03);
-
-		/* Select AFE clock pad output source */
-		cx25840_write(client, 0x144, 0x05);
-
-		/* I2S_IN_CTL: I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1 */
-		cx25840_write(client, 0x914, 0xa0);
-
-		/* I2S_OUT_CTL:
-		 * I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1
-		 * I2S_OUT_MASTER_MODE = Master
-		 */
-		cx25840_write(client, 0x918, 0xa0);
-		cx25840_write(client, 0x919, 0x01);
-	} else if (is_cx231xx(state)) {
-		/* Audio channel 1 src : Parallel 1 */
-		cx25840_write(client, 0x124, 0x03);
-
-		/* I2S_IN_CTL: I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1 */
-		cx25840_write(client, 0x914, 0xa0);
-
-		/* I2S_OUT_CTL:
-		 * I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1
-		 * I2S_OUT_MASTER_MODE = Master
-		 */
-		cx25840_write(client, 0x918, 0xa0);
-		cx25840_write(client, 0x919, 0x01);
-	}
-
-	if (is_cx2388x(state) && ((aud_input == CX25840_AUDIO7) ||
-		(aud_input == CX25840_AUDIO6))) {
-		/* Configure audio from LR1 or LR2 input */
-		cx25840_write4(client, 0x910, 0);
-		cx25840_write4(client, 0x8d0, 0x63073);
-	} else
-	if (is_cx2388x(state) && (aud_input == CX25840_AUDIO8)) {
-		/* Configure audio from tuner/sif input */
-		cx25840_write4(client, 0x910, 0x12b000c9);
-		cx25840_write4(client, 0x8d0, 0x1f063870);
-	}
-
 	return 0;
 }
 

--------------050009070306070902050608
Content-Type: text/x-diff;
 name="cx25840_g_tuner_rewrite.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx25840_g_tuner_rewrite.patch"

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
From: Miroslav Slugen <thunder.mmm@gmail.com>
Date: Mon, 12 Dec 2011 00:19:34 +0100
Subject: [PATCH] cx25840_g_tuner should support also radio mode for detecting
 current audio mode, and we can use cx25840 register 0x805 for FM radio lock,
 also reworked mode detection.

---
diff -Naurp a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
--- a/drivers/media/video/cx25840/cx25840-core.c	2012-01-16 16:18:06.181583026 +0100
+++ b/drivers/media/video/cx25840/cx25840-core.c	2012-01-16 16:23:38.665583026 +0100
@@ -1589,37 +1589,68 @@ static int cx25840_g_tuner(struct v4l2_s
 {
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	u8 vpres = cx25840_read(client, 0x40e) & 0x20;
+	u8 vpres = 0;
 	u8 mode;
-	int val = 0;
+	int val = V4L2_TUNER_SUB_MONO;
 
-	if (state->radio)
-		return 0;
+	if (!state->radio) {
+		vpres = cx25840_read(client, 0x40e) & 0x20;
+		vt->signal = vpres ? 0xffff : 0x0;
+	}
 
-	vt->signal = vpres ? 0xffff : 0x0;
 	if (is_cx2583x(state))
 		return 0;
 
-	vt->capability |=
-		V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LANG1 |
-		V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
+	/* stereo for all modes, even radio */
+	vt->capability |= V4L2_TUNER_CAP_STEREO;
+
+	if (!state->radio) {
+		vt->capability |= V4L2_TUNER_CAP_LANG1 |
+			V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
+	} else {
+		/* Works only for 0xf9 AUD_MODE */
+		mode = cx25840_read(client, 0x805);
+		/* usable modes from datasheet 0x01 - 0x11 */
+		vt->signal = ((mode >= 1) && (mode <= 0x11)) ? 0xffff : 0;
+	}
 
 	mode = cx25840_read(client, 0x804);
 
 	/* get rxsubchans and audmode */
-	if ((mode & 0xf) == 1)
+	switch (mode & 0xf) {
+	case 0:
+		vt->audmode = V4L2_TUNER_MODE_MONO;
+		break;
+	case 1:
 		val |= V4L2_TUNER_SUB_STEREO;
-	else
-		val |= V4L2_TUNER_SUB_MONO;
-
-	if (mode == 2 || mode == 4)
+		vt->audmode = V4L2_TUNER_MODE_STEREO;
+		break;
+	case 2:
+	case 4:
 		val = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+		/* can't detect exact audio mode */
+		vt->audmode = state->audmode;
+		break;
+	default:
+		/* audio mode is forced or unknown */
+		switch (state->audmode) {
+		case V4L2_TUNER_MODE_STEREO:
+			val |= V4L2_TUNER_SUB_STEREO;
+			break;
+		case V4L2_TUNER_MODE_LANG1:
+		case V4L2_TUNER_MODE_LANG2:
+		case V4L2_TUNER_MODE_LANG1_LANG2:
+			val = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+			break;
+		}
+		vt->audmode = state->audmode;
+		break;
+	}
 
 	if (mode & 0x10)
 		val |= V4L2_TUNER_SUB_SAP;
 
 	vt->rxsubchans = val;
-	vt->audmode = state->audmode;
 	return 0;
 }
 
-- 
1.7.2.3


--------------050009070306070902050608
Content-Type: text/x-diff;
 name="cx25840_s_tuner_radio_support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx25840_s_tuner_radio_support.patch"

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
From: Miroslav Slugen <thunder.mmm@gmail.com>
Date: Mon, 12 Dec 2011 00:19:34 +0100
Subject: [PATCH] cx25840_s_tuner should support also radio mode for setting
 stereo and mono.

---
diff -Naurp a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
--- a/drivers/media/video/cx25840/cx25840-core.c	2012-01-12 20:42:45.000000000 +0100
+++ b/drivers/media/video/cx25840/cx25840-core.c	2012-01-16 16:18:06.181583026 +0100
@@ -1628,9 +1628,14 @@ static int cx25840_s_tuner(struct v4l2_s
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (state->radio || is_cx2583x(state))
+	if (is_cx2583x(state))
 		return 0;
 
+	/* FM radio supports only mono and stereo modes */
+	if ((state->radio) &&
+	    (vt->audmode != V4L2_TUNER_MODE_MONO) &&
+	    (vt->audmode != V4L2_TUNER_MODE_STEREO)) return -EINVAL;
+
 	switch (vt->audmode) {
 		case V4L2_TUNER_MODE_MONO:
 			/* mono      -> mono
-- 
1.7.2.3


--------------050009070306070902050608
Content-Type: text/x-diff;
 name="cx23885-add-basic-fm-radio-support_v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-add-basic-fm-radio-support_v3.patch"

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
From: Miroslav Slugen <thunder.mmm@gmail.com>
Date: Sat, 17 Dec 2011 01:23:22 +0100
Subject: [PATCH] Add support for radio tuners to cx23885 driver, and add example of radio support
 for Leadtek DVR3200 H tuners.

 Version 3

diff -Naurp a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
--- a/drivers/media/video/cx23885/cx23885-cards.c	2012-01-14 18:43:40.000000000 +0100
+++ b/drivers/media/video/cx23885/cx23885-cards.c	2012-01-14 19:04:58.412366747 +0100
@@ -205,35 +205,87 @@ struct cx23885_board cx23885_boards[] =
 	},
 	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = {
 		.name		= "Leadtek Winfast PxDVR3200 H",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_ENCODER,
 		.portc		= CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_XC2028,
+		.tuner_addr	= 0x61,
+		.radio_type	= UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_bus	= 1,
+		.input		= {{
+			.type	= CX23885_VMUX_TELEVISION,
+			.vmux	= CX25840_VIN2_CH1 |
+				  CX25840_VIN5_CH2,
+			.amux	= CX25840_AUDIO8,
+			.gpio0	= 0x704040,
+		}, {
+			.type	= CX23885_VMUX_COMPOSITE1,
+			.vmux	= CX25840_VIN1_CH1,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
+		}, {
+			.type	= CX23885_VMUX_SVIDEO,
+			.vmux	= CX25840_VIN3_CH1 |
+				  CX25840_SVIDEO_ON,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
+		}, {
+			.type	= CX23885_VMUX_COMPONENT,
+			.vmux	= CX25840_VIN7_CH1 |
+				  CX25840_VIN6_CH2 |
+				  CX25840_VIN8_CH3 |
+				  CX25840_COMPONENT_ON,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
+		} },
+		.radio = {
+			.type	= CX23885_RADIO,
+			.amux	= CX25840_AUDIO8,
+			.gpio0	= 0x706060,
+		},
 	},
 	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000] = {
 		.name		= "Leadtek Winfast PxDVR3200 H XC4000",
 		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_ENCODER,
 		.portc		= CX23885_MPEG_DVB,
 		.tuner_type	= TUNER_XC4000,
 		.tuner_addr	= 0x61,
 		.radio_type	= UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.tuner_bus	= 1,
 		.input		= {{
 			.type	= CX23885_VMUX_TELEVISION,
 			.vmux	= CX25840_VIN2_CH1 |
-				  CX25840_VIN5_CH2 |
-				  CX25840_NONE0_CH3,
+				  CX25840_VIN5_CH2,
+			.amux	= CX25840_AUDIO8,
+			.gpio0	= 0x704040,
 		}, {
 			.type	= CX23885_VMUX_COMPOSITE1,
-			.vmux	= CX25840_COMPOSITE1,
+			.vmux	= CX25840_VIN1_CH1,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
 		}, {
 			.type	= CX23885_VMUX_SVIDEO,
-			.vmux	= CX25840_SVIDEO_LUMA3 |
-				  CX25840_SVIDEO_CHROMA4,
+			.vmux	= CX25840_VIN3_CH1 |
+				  CX25840_SVIDEO_ON,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
 		}, {
 			.type	= CX23885_VMUX_COMPONENT,
 			.vmux	= CX25840_VIN7_CH1 |
 				  CX25840_VIN6_CH2 |
 				  CX25840_VIN8_CH3 |
 				  CX25840_COMPONENT_ON,
+			.amux	= CX25840_AUDIO7,
+			.gpio0	= 0x704040,
 		} },
+		.radio = {
+			.type	= CX23885_RADIO,
+			.amux	= CX25840_AUDIO8,
+			.gpio0	= 0x706060,
+		},
 	},
 	[CX23885_BOARD_COMPRO_VIDEOMATE_E650F] = {
 		.name		= "Compro VideoMate E650F",
@@ -818,27 +870,95 @@ static void hauppauge_eeprom(struct cx23
 			dev->name, tv.model);
 }
 
+static int cx23885_xc2028_leadtek_callback(struct cx23885_dev *dev,
+					   int command, int arg)
+{
+	switch (command) {
+	case XC2028_TUNER_RESET:
+		/* GPIO 12 (xc2028 tuner reset) */
+		cx_set(GP0_IO, 0x00040000);
+		mdelay(75);
+		cx_clear(GP0_IO, 0x00000004);
+		mdelay(75);
+		cx_set(GP0_IO, 0x00040004);
+		mdelay(75);
+		return 0;
+	case XC2028_RESET_CLK:
+	case XC2028_I2C_FLUSH:
+		break;
+	}
+	return -EINVAL;
+}
+
+static int cx23885_xc4000_leadtek_callback(struct cx23885_dev *dev,
+					   int command, int arg)
+{
+	switch (command) {
+	case XC4000_TUNER_RESET:
+		/* GPIO 12 (xc4000 tuner reset) */
+		cx_set(GP0_IO, 0x00040000);
+		mdelay(75);
+		cx_clear(GP0_IO, 0x00000004);
+		mdelay(75);
+		cx_set(GP0_IO, 0x00040004);
+		mdelay(75);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int cx23885_xc2028_tuner_callback(struct cx23885_dev *dev,
+					 int command, int arg)
+{
+	/* Board-specific callbacks */
+	switch (dev->board) {
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		return cx23885_xc2028_leadtek_callback(dev, command, arg);
+	}
+
+	return -EINVAL;
+}
+
+static int cx23885_xc4000_tuner_callback(struct cx23885_dev *dev,
+					 int command, int arg)
+{
+	/* Board-specific callbacks */
+	switch (dev->board) {
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
+		return cx23885_xc4000_leadtek_callback(dev, command, arg);
+	}
+
+	return -EINVAL;
+}
+
 int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 {
 	struct cx23885_tsport *port = priv;
-	struct cx23885_dev *dev = port->dev;
+	struct cx23885_dev *dev;
 	u32 bitmask = 0;
 
-	if (command == XC2028_RESET_CLK)
-		return 0;
+	if (!port) {
+		printk(KERN_ERR "cx23885: Error - private data undefined.\n");
+		return -EINVAL;
+	}
+
+	dev = port->dev;
 
-	if (command != 0) {
-		printk(KERN_ERR "%s(): Unknown command 0x%x.\n",
-			__func__, command);
+	if (!dev) {
+		printk(KERN_ERR "cx23885: Error - device struct undefined.\n");
 		return -EINVAL;
 	}
 
 	switch (dev->board) {
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		printk(KERN_INFO "%s: Calling XC2028/3028 callback\n", dev->name);
+		return cx23885_xc2028_tuner_callback(dev, command, arg);
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
+		printk(KERN_INFO "%s: Calling XC4000 callback\n", dev->name);
+		return cx23885_xc4000_tuner_callback(dev, command, arg);
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
-	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
-	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
@@ -861,6 +981,9 @@ int cx23885_tuner_callback(void *priv, i
 	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
 		altera_ci_tuner_reset(dev, port->nr);
 		break;
+	default:
+		printk(KERN_ERR "cx23885: Error: Calling callback for card %d\n", dev->board);
+		break;
 	}
 
 	if (bitmask) {
@@ -872,6 +995,7 @@ int cx23885_tuner_callback(void *priv, i
 
 	return 0;
 }
+EXPORT_SYMBOL(cx23885_tuner_callback);
 
 void cx23885_gpio_setup(struct cx23885_dev *dev)
 {
@@ -999,7 +1123,11 @@ void cx23885_gpio_setup(struct cx23885_d
 		cx_set(GP0_IO, 0x000f000f);
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		cx23885_xc2028_leadtek_callback(dev, XC2028_TUNER_RESET, 0);
+		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
+		cx23885_xc4000_leadtek_callback(dev, XC4000_TUNER_RESET, 0);
+		break;
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
@@ -1312,6 +1440,30 @@ void cx23885_ir_pci_int_enable(struct cx
 	}
 }
 
+void cx23885_setup_xc3028(struct cx23885_dev *dev, struct xc2028_ctrl *ctl)
+{
+	memset(ctl, 0, sizeof(*ctl));
+
+	ctl->fname   = XC2028_DEFAULT_FIRMWARE;
+	ctl->max_len = 64;
+
+	switch (dev->board) {
+	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
+		break;
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+		ctl->demod = XC3028_FE_ZARLINK456;
+		break;
+	default:
+		ctl->demod = XC3028_FE_OREN538;
+		ctl->mts = 1;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(cx23885_setup_xc3028);
+
 void cx23885_card_setup(struct cx23885_dev *dev)
 {
 	struct cx23885_tsport *ts1 = &dev->ts1;
diff -Naurp a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
--- a/drivers/media/video/cx23885/cx23885.h	2012-01-05 00:55:44.000000000 +0100
+++ b/drivers/media/video/cx23885/cx23885.h	2012-01-14 18:48:44.172366746 +0100
@@ -35,6 +35,7 @@
 #include "btcx-risc.h"
 #include "cx23885-reg.h"
 #include "media/cx2341x.h"
+#include "tuner-xc2028.h"
 
 #include <linux/mutex.h>
 
@@ -225,6 +226,7 @@ struct cx23885_board {
 	 */
 	u32			clk_freq;
 	struct cx23885_input    input[MAX_CX23885_INPUT];
+	struct cx23885_input    radio;
 	int			ci_type; /* for NetUP */
 };
 
@@ -416,6 +418,9 @@ struct cx23885_dev {
 
 	/* V4l */
 	u32                        freq;
+	int                        users;
+	int                        mpeg_users;
+
 	struct video_device        *video_dev;
 	struct video_device        *vbi_dev;
 	struct video_device        *radio_dev;
@@ -554,6 +559,8 @@ extern void cx23885_gpio_setup(struct cx
 extern void cx23885_card_setup(struct cx23885_dev *dev);
 extern void cx23885_card_setup_pre_i2c(struct cx23885_dev *dev);
 
+extern void cx23885_setup_xc3028(struct cx23885_dev *dev, struct xc2028_ctrl *ctl);
+
 extern int cx23885_dvb_register(struct cx23885_tsport *port);
 extern int cx23885_dvb_unregister(struct cx23885_tsport *port);
 
diff -Naurp a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
--- a/drivers/media/video/cx23885/cx23885-video.c	2012-01-05 00:55:44.000000000 +0100
+++ b/drivers/media/video/cx23885/cx23885-video.c	2012-01-14 19:11:43.148366748 +0100
@@ -36,6 +36,7 @@
 #include <media/v4l2-ioctl.h>
 #include "cx23885-ioctl.h"
 #include "tuner-xc2028.h"
+#include "xc4000.h"
 
 #include <media/cx25840.h>
 
@@ -502,18 +503,6 @@ static int cx23885_video_mux(struct cx23
 	v4l2_subdev_call(dev->sd_cx25840, video, s_routing,
 			INPUT(input)->vmux, 0, 0);
 
-	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
-		(dev->board == CX23885_BOARD_MPX885)) {
-		/* Configure audio routing */
-		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
-			INPUT(input)->amux, 0, 0);
-
-		if (INPUT(input)->amux == CX25840_AUDIO7)
-			cx23885_flatiron_mux(dev, 1);
-		else if (INPUT(input)->amux == CX25840_AUDIO6)
-			cx23885_flatiron_mux(dev, 2);
-	}
-
 	return 0;
 }
 
@@ -521,6 +510,10 @@ static int cx23885_audio_mux(struct cx23
 {
 	dprintk(1, "%s(input=%d)\n", __func__, input);
 
+	/* Configure audio routing */
+	v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
+		INPUT(input)->amux, 0, 0);
+
 	/* The baseband video core of the cx23885 has two audio inputs.
 	 * LR1 and LR2. In almost every single case so far only HVR1xxx
 	 * cards we've only ever supported LR1. Time to support LR2,
@@ -871,20 +864,29 @@ static int video_open(struct file *file)
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_YUYV);
 
+	mutex_lock(&dev->lock);
+
 	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx23885_buffer),
 			    fh, NULL);
-
 	videobuf_queue_sg_init(&fh->vbiq, &cx23885_vbi_qops,
-		&dev->pci->dev, &dev->slock,
-		V4L2_BUF_TYPE_VBI_CAPTURE,
-		V4L2_FIELD_SEQ_TB,
-		sizeof(struct cx23885_buffer),
-		fh, NULL);
+			    &dev->pci->dev, &dev->slock,
+			    V4L2_BUF_TYPE_VBI_CAPTURE,
+			    V4L2_FIELD_SEQ_TB,
+			    sizeof(struct cx23885_buffer),
+			    fh, NULL);
 
+	if (fh->radio) {
+		dprintk(1,"video_open: setting radio device\n");
+		cx_write(GPIO_0, cx23885_boards[dev->board].radio.gpio0);
+		call_all(dev, tuner, s_radio);
+	}
+
+	dev->users++;
+	mutex_unlock(&dev->lock);
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
@@ -981,13 +983,24 @@ static int video_release(struct file *fi
 	}
 
 	videobuf_mmap_free(&fh->vidq);
+	videobuf_mmap_free(&fh->vbiq);
+
+	mutex_lock(&dev->lock);
 	file->private_data = NULL;
 	kfree(fh);
 
+	dev->users--;
+
 	/* We are not putting the tuner to sleep here on exit, because
 	 * we want to use the mpeg encoder in another session to capture
 	 * tuner video. Closing this will result in no video to the encoder.
 	 */
+#if 0
+	if (!dev->users)
+		call_all(dev, core, s_power, 0);
+#endif
+
+	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -1255,17 +1268,13 @@ static int cx23885_enum_input(struct cx2
 		[CX23885_VMUX_DVB]        = "DVB",
 		[CX23885_VMUX_DEBUG]      = "for debug only",
 	};
-	unsigned int n;
+	unsigned int n = i->index;
 	dprintk(1, "%s()\n", __func__);
 
-	n = i->index;
 	if (n >= MAX_CX23885_INPUT)
 		return -EINVAL;
-
 	if (0 == INPUT(n)->type)
 		return -EINVAL;
-
-	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n)->type]);
 	if ((CX23885_VMUX_TELEVISION == INPUT(n)->type) ||
@@ -1505,6 +1514,108 @@ static int vidioc_s_frequency(struct fil
 }
 
 /* ----------------------------------------------------------- */
+/* RADIO ESPECIFIC IOCTLS                                      */
+/* ----------------------------------------------------------- */
+
+static int radio_querycap (struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+
+	strcpy(cap->driver, "cx23885");
+	strlcpy(cap->card, cx23885_boards[dev->board].name, sizeof(cap->card));
+	sprintf(cap->bus_info,"PCIe:%s", pci_name(dev->pci));
+	cap->capabilities = V4L2_CAP_TUNER;
+	return 0;
+}
+
+static int radio_g_tuner (struct file *file, void *priv,
+				struct v4l2_tuner *t)
+{
+	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+
+	if (unlikely(t->index > 0))
+		return -EINVAL;
+
+	strcpy(t->name, "Radio");
+	t->type = V4L2_TUNER_RADIO;
+
+	call_all(dev, tuner, g_tuner, t);
+	return 0;
+}
+
+static int radio_enum_input (struct file *file, void *priv,
+				struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+	strcpy(i->name,"Radio");
+	i->type = V4L2_INPUT_TYPE_TUNER;
+
+	return 0;
+}
+
+static int radio_g_audio (struct file *file, void *priv, struct v4l2_audio *a)
+{
+	if (unlikely(a->index))
+		return -EINVAL;
+
+	strcpy(a->name,"Radio");
+	return 0;
+}
+
+/* FIXME: Should add a standard for radio */
+
+static int radio_s_tuner (struct file *file, void *priv,
+				struct v4l2_tuner *t)
+{
+	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+
+	if (0 != t->index)
+		return -EINVAL;
+
+	call_all(dev, tuner, s_tuner, t);
+
+	return 0;
+}
+
+static int radio_s_audio (struct file *file, void *fh,
+			  struct v4l2_audio *a)
+{
+	return 0;
+}
+
+static int radio_s_input (struct file *file, void *fh, unsigned int i)
+{
+	return 0;
+}
+
+static int radio_queryctrl (struct file *file, void *priv,
+			    struct v4l2_queryctrl *c)
+{
+	int i;
+
+	if (c->id < V4L2_CID_BASE ||
+		c->id >= V4L2_CID_LASTP1)
+		return -EINVAL;
+	if (c->id == V4L2_CID_AUDIO_MUTE ||
+		c->id == V4L2_CID_AUDIO_VOLUME ||
+		c->id == V4L2_CID_AUDIO_BALANCE) {
+		for (i = 0; i < CX23885_CTLS; i++) {
+			if (cx23885_ctls[i].v.id == c->id)
+				break;
+		}
+		if (i == CX23885_CTLS) {
+			*c = no_ctl;
+			return 0;
+		}
+		*c = cx23885_ctls[i].v;
+	} else
+		*c = no_ctl;
+	return 0;
+}
+
+/* ----------------------------------------------------------- */
 
 static void cx23885_vid_timeout(unsigned long data)
 {
@@ -1652,12 +1763,43 @@ static const struct v4l2_file_operations
 	.ioctl         = video_ioctl2,
 };
 
+static const struct v4l2_ioctl_ops radio_ioctl_ops = {
+	.vidioc_querycap      = radio_querycap,
+	.vidioc_g_tuner       = radio_g_tuner,
+	.vidioc_enum_input    = radio_enum_input,
+	.vidioc_g_audio       = radio_g_audio,
+	.vidioc_s_tuner       = radio_s_tuner,
+	.vidioc_s_audio       = radio_s_audio,
+	.vidioc_s_input       = radio_s_input,
+	.vidioc_queryctrl     = radio_queryctrl,
+	.vidioc_g_ctrl        = vidioc_g_ctrl,
+	.vidioc_s_ctrl        = vidioc_s_ctrl,
+	.vidioc_g_frequency   = vidioc_g_frequency,
+	.vidioc_s_frequency   = vidioc_s_frequency,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register    = cx23885_g_register,
+	.vidioc_s_register    = cx23885_s_register,
+#endif
+};
+
+static struct video_device cx23885_radio_template = {
+	.name                 = "cx23885-radio",
+	.fops                 = &radio_fops,
+	.ioctl_ops            = &radio_ioctl_ops,
+};
 
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
 	cx23885_irq_remove(dev, 0x01);
 
+	if (dev->radio_dev) {
+		if (video_is_registered(dev->radio_dev))
+			video_unregister_device(dev->radio_dev);
+		else
+			video_device_release(dev->radio_dev);
+		dev->radio_dev = NULL;
+	}
 	if (dev->vbi_dev) {
 		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
@@ -1730,22 +1872,28 @@ int cx23885_video_register(struct cx2388
 			struct tuner_setup tun_setup;
 
 			memset(&tun_setup, 0, sizeof(tun_setup));
-			tun_setup.mode_mask = T_ANALOG_TV;
+
+			tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
 			tun_setup.type = dev->tuner_type;
 			tun_setup.addr = v4l2_i2c_subdev_addr(sd);
+
 			tun_setup.tuner_callback = cx23885_tuner_callback;
 
 			v4l2_subdev_call(sd, tuner, s_type_addr, &tun_setup);
 
-			if (dev->board == CX23885_BOARD_LEADTEK_WINFAST_PXTV1200) {
-				struct xc2028_ctrl ctrl = {
-					.fname = XC2028_DEFAULT_FIRMWARE,
-					.max_len = 64
-				};
-				struct v4l2_priv_tun_config cfg = {
-					.tuner = dev->tuner_type,
-					.priv = &ctrl
-				};
+			if (dev->tuner_type == TUNER_XC2028) {
+				struct v4l2_priv_tun_config  cfg;
+				struct xc2028_ctrl           ctl;
+
+				/* Fills device-dependent initialization parameters */
+				cx23885_setup_xc3028(dev, &ctl);
+
+				memset(&cfg, 0, sizeof(cfg));
+				cfg.tuner = TUNER_XC2028;
+				cfg.priv  = &ctl;
+
+				printk(KERN_INFO "%s: Asking xc2028/3028 to load firmware %s\n",
+				       dev->name, ctl.fname);
 				v4l2_subdev_call(sd, tuner, s_config, &cfg);
 			}
 		}
@@ -1777,6 +1925,21 @@ int cx23885_video_register(struct cx2388
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
+	if (cx23885_boards[dev->board].radio.type == CX23885_RADIO) {
+		dev->radio_dev = cx23885_vdev_init(dev, dev->pci,
+						&cx23885_radio_template, "radio");
+		video_set_drvdata(dev->radio_dev, dev);
+		err = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+					    radio_nr[dev->nr]);
+		if (err < 0) {
+			printk(KERN_ERR "%s: can't register radio device\n",
+			       dev->name);
+			goto fail_unreg;
+		}
+		printk(KERN_INFO "%s: registered device %s\n",
+		       dev->name, video_device_node_name(dev->radio_dev));
+	}
+
 	/* Register ALSA audio device */
 	dev->audio_dev = cx23885_audio_register(dev);
 

--------------050009070306070902050608
Content-Type: text/x-diff;
 name="cx23885_add_radio_signal_support_for_all_tuners.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885_add_radio_signal_support_for_all_tuners.patch"

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
From: Miroslav Slugen <thunder.mmm@gmail.com>
Date: Sat, 17 Dec 2011 01:23:22 +0100
Subject: [PATCH] Add radio lock and current mode detection for all cx23885 cards.

---
diff -Naurp a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
--- a/drivers/media/video/cx23885/cx23885.h	2012-01-05 13:30:41.000000000 +0100
+++ b/drivers/media/video/cx23885/cx23885.h	2012-01-05 14:04:29.441910804 +0100
@@ -403,6 +403,7 @@ struct cx23885_dev {
 	unsigned int               radio_type;
 	unsigned char              radio_addr;
 	unsigned int               has_radio;
+	struct v4l2_subdev         *sd_tuner;
 	struct v4l2_subdev 	   *sd_cx25840;
 	struct work_struct	   cx25840_work;
 
@@ -446,6 +447,10 @@ static inline struct cx23885_dev *to_cx2
 	return container_of(v4l2_dev, struct cx23885_dev, v4l2_dev);
 }
 
+#define cx25840_call(dev, o, f, args...) \
+	v4l2_subdev_call(dev->sd_cx25840, o, f, ##args)
+#define tuner_call(dev, o, f, args...) \
+	v4l2_subdev_call(dev->sd_tuner, o, f, ##args)
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
diff -Naurp a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
--- a/drivers/media/video/cx23885/cx23885-video.c	2012-01-05 13:36:38.000000000 +0100
+++ b/drivers/media/video/cx23885/cx23885-video.c	2012-01-05 14:04:29.441910804 +0100
@@ -1550,7 +1550,28 @@ static int radio_g_tuner (struct file *f
 	strcpy(t->name, "Radio");
 	t->type = V4L2_TUNER_RADIO;
 
-	call_all(dev, tuner, g_tuner, t);
+	/* First call tuner g_tuner for radio range and signal
+	 * from tuner (xc3028 and xc4000), then call cx25840
+	 * g_tuner to get real tuner mode (stereo/mono) and signal.
+	 */
+	if (dev->sd_tuner) {
+		v4l2_subdev_call(dev->sd_tuner, tuner, g_tuner, t);
+
+		if (dev->sd_cx25840) {
+			/* restore capability and signal */
+			u32 capability = t->capability;
+			u16 signal = t->signal;
+
+			v4l2_subdev_call(dev->sd_cx25840, tuner, g_tuner, t);
+
+			t->capability = capability;
+
+			/* xc4000 tuner can return real signal */
+			if (dev->tuner_type == TUNER_XC4000)
+				t->signal = signal;
+		}
+	}
+
 	return 0;
 }
 
@@ -1868,28 +1889,26 @@ int cx23885_video_register(struct cx2388
 
 	if ((TUNER_ABSENT != dev->tuner_type) &&
 			((dev->tuner_bus == 0) || (dev->tuner_bus == 1))) {
-		struct v4l2_subdev *sd = NULL;
-
 		if (dev->tuner_addr)
-			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[dev->tuner_bus].i2c_adap,
-				"tuner", dev->tuner_addr, NULL);
+			dev->sd_tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+					&dev->i2c_bus[dev->tuner_bus].i2c_adap,
+					"tuner", dev->tuner_addr, NULL);
 		else
-			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[dev->tuner_bus].i2c_adap,
-				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
-		if (sd) {
+			dev->sd_tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+					&dev->i2c_bus[dev->tuner_bus].i2c_adap,
+					"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
+		if (dev->sd_tuner) {
 			struct tuner_setup tun_setup;
 
 			memset(&tun_setup, 0, sizeof(tun_setup));
 
 			tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
 			tun_setup.type = dev->tuner_type;
-			tun_setup.addr = v4l2_i2c_subdev_addr(sd);
+			tun_setup.addr = v4l2_i2c_subdev_addr(dev->sd_tuner);
 
 			tun_setup.tuner_callback = cx23885_tuner_callback;
 
-			v4l2_subdev_call(sd, tuner, s_type_addr, &tun_setup);
+			v4l2_subdev_call(dev->sd_tuner, tuner, s_type_addr, &tun_setup);
 
 			if (dev->tuner_type == TUNER_XC2028) {
 				struct v4l2_priv_tun_config  cfg;
@@ -1904,7 +1923,7 @@ int cx23885_video_register(struct cx2388
 
 				printk(KERN_INFO "%s: Asking xc2028/3028 to load firmware %s\n",
 				       dev->name, ctl.fname);
-				v4l2_subdev_call(sd, tuner, s_config, &cfg);
+				v4l2_subdev_call(dev->sd_tuner, tuner, s_config, &cfg);
 			}
 		}
 	}
-- 
1.7.2.3


--------------050009070306070902050608--
