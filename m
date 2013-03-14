Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41460 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3CNWMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:17 -0400
Received: by mail-wg0-f48.google.com with SMTP id 16so2528170wgi.27
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2013 15:12:15 -0700 (PDT)
Message-ID: <1363299126.5156.19.camel@tux>
Subject: [review patch] radio-mr800: move clamp_t check inside
 amradio_set_freq()
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Date: Fri, 15 Mar 2013 02:12:06 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, all,

If i run verbose v4l2-compliance with my radio-mr800 device few times
then i get warning about frequency out of range:

root@machine:~# v4l2-compliance -r /dev/radio0 -v 2
is radio
Driver Info:
	Driver name   : radio-mr800
	Card type     : AverMedia MR 800 USB FM Radio
	Bus info      : usb-0000:00:1a.0-1.2
	Driver version: 3.9.0
	Capabilities  : 0x80050400
		Tuner
		Radio
		Device Capabilities
	Device Caps   : 0x00050400
		Tuner
		Radio

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second radio open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: OK
		warn: v4l2-test-input-output.cpp(234): returned tuner 0 frequency out
of range (6550200 not in [1400000...1728000])
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Mute' (0x00980909)
		info: checking v4l2_queryctrl of control 'Mute' (0x00980909)
	test VIDIOC_QUERYCTRL/MENU: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Mute' (0x00980909)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Mute' (0x00980909)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		info: checking control event 'Mute' (0x00980909)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 2 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)

Total: 38, Succeeded: 38, Failed: 0, Warnings: 1

Some printk() debugging showed that vidioc_s_hw_freq_seek() setups
radio->curfreq to out of range value (lines 395-396) and calls
amradio_set_freq() to set this frequency on device without any
out-of-range checks.

I suggest to move clamp_t check inside amradio_set_freq() function. It
will protect from setting up frequency to incorrect values in different
places. It also makes compliance test happy.

If this fix is right may be it necessary to push this patch in 3.9
current development tree.

================================================================


radio-mr800: move clamp_t check inside amradio_set_freq()

Patch protects from setting up frequency on device to incorrect value
moving clamp_t check inside amradio_set_freq. With this patch we can
call amradio_set_freq() with out of range frequency from any place.
Also put comment that sometimes radio->curfreq is set to out of range
value in vidioc_s_hw_freq_seek().

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>


diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 9c5a267..1cbdbfd 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -203,10 +203,14 @@ static int amradio_set_mute(struct amradio_device *radio, bool mute)
 /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
 static int amradio_set_freq(struct amradio_device *radio, int freq)
 {
-	unsigned short freq_send = 0x10 + (freq >> 3) / 25;
+	unsigned short freq_send;
 	u8 buf[3];
 	int retval;
 
+	/* we need to be sure that frequency isn't out of range */
+	freq = clamp_t(unsigned, freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
+	freq_send = 0x10 + (freq >> 3) / 25;
+
 	/* frequency is calculated from freq_send and placed in first 2 bytes */
 	buf[0] = (freq_send >> 8) & 0xff;
 	buf[1] = freq_send & 0xff;
@@ -329,8 +333,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	if (f->tuner != 0)
 		return -EINVAL;
-	return amradio_set_freq(radio, clamp_t(unsigned, f->frequency,
-				FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL));
+	return amradio_set_freq(radio, f->frequency);
 }
 
 /* vidioc_g_frequency - get tuner radio frequency */
@@ -389,6 +392,7 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *priv,
 			continue;
 		amradio_send_cmd(radio, AMRADIO_GET_FREQ, 0, NULL, 0, true);
 		if (radio->buffer[1] || radio->buffer[2]) {
+			/* To check: sometimes radio->curfreq is set to out of range value */
 			radio->curfreq = (radio->buffer[1] << 8) | radio->buffer[2];
 			radio->curfreq = (radio->curfreq - 0x10) * 200;
 			amradio_send_cmd(radio, AMRADIO_STOP_SEARCH,




