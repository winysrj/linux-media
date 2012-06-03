Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1981 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2FCKdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2012 06:33:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [RFC/PATCH v2] media: Add stk1160 new driver
Date: Sun, 3 Jun 2012 12:33:24 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
References: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com> <CALF0-+W5DCf1HMs=MYMc2KVgz=SJKS2YLY7LSrxU6-gnc=+LAA@mail.gmail.com>
In-Reply-To: <CALF0-+W5DCf1HMs=MYMc2KVgz=SJKS2YLY7LSrxU6-gnc=+LAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206031233.24758.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel!

On Sat June 2 2012 17:37:28 Ezequiel Garcia wrote:
> On Sat, Jun 2, 2012 at 12:32 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > This driver adds support for stk1160 usb bridge as used in some
> > video/audio usb capture devices.
> > It is a complete rewrite of staging/media/easycap driver and
> > it's expected as a future replacement.
> >
> > Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> > ---
> > As of today testing has been performed using both vlc and mplayer
> > on a gentoo machine, including hot unplug and on-the-fly standard
> > change using a device with 1-cvs and 1-audio output.
> > However more testing is underway with another device and/or another
> > distribution.
> >
> > Support for multiple input devices is a missing feature.
> > Alsa sound support is a missing feature. (I'm working on both)
> >
> > As this is my first complete driver,
> > the patch (obviously) intended as RFC only.
> > Any comments/reviews of *any* kind will be greatly appreciated.
> >
> > This new version tries to solve the issues pointed out by
> > Hans Verkuil and Sylwester Nawrocki (thanks to both!)
> >
> > Changes from v1:
> >  * Use media control framework
> >  * Register video device as the last thing
> >  * Use v4l_device release to release all resources
> >  * Add explicit locking for file operations
> >  * Add vb2 buffer sanity check
> >  * Minor style cleanups
> >
> 
> I'm adding "v4l2-compliance -v 2 -d /dev/video1" output as requested by Hans.

Thanks. I've fixed several things reported by v4l2-compliance (see my patch
below), but you are using an older v4l2-compliance version. You should clone
and compile the v4l-utils.git repository yourself, rather than using a distro
provided version (which I think is what you are doing now).

Can you apply my patch on yours and run the latest v4l2-compliance again?

> Driver Info:
> 	Driver name   : stk1160
> 	Card type     : stk1160
> 	Bus info      :
> 	Driver version: 3.4.0
> 	Capabilities  : 0x05000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 
> Compliance test for device /dev/video1 (not using libv4l2):
> 
> Required ioctls:
> 		fail: v4l2-compliance.cpp(217): string empty
> 		warn: VIDIOC_QUERYCAP: empty bus_info
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 		fail: v4l2-compliance.cpp(217): string empty
> 		warn: VIDIOC_QUERYCAP: empty bus_info
> 	test VIDIOC_QUERYCAP: OK
> 		fail: v4l2-compliance.cpp(273): doioctl(node, VIDIOC_G_PRIORITY, &prio)
> 	test VIDIOC_G/S_PRIORITY: FAIL
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G_CHIP_IDENT: FAIL
> 		fail: v4l2-test-debug.cpp(82): uid == 0 && ret
> 	test VIDIOC_DBG_G/S_REGISTER: FAIL
> 	test VIDIOC_LOG_STATUS: FAIL
> 
> Input ioctls:
> 		fail: v4l2-test-input-output.cpp(133): couldn't get tuner 0
> 	test VIDIOC_G/S_TUNER: FAIL
> 		fail: v4l2-test-input-output.cpp(228): could get frequency for invalid tuner 0
> 	test VIDIOC_G/S_FREQUENCY: FAIL
> 		fail: v4l2-test-input-output.cpp(358): could not enumerate audio input 0
> 	test VIDIOC_ENUMAUDIO: FAIL
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 		fail: v4l2-test-input-output.cpp(377): No audio inputs, but G_AUDIO
> did not return EINVAL
> 		fail: v4l2-test-input-output.cpp(421): invalid audioset for input 0
> 	test VIDIOC_G/S_AUDIO: FAIL
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 		fail: v4l2-test-input-output.cpp(479): couldn't get modulator 0
> 	test VIDIOC_G/S_MODULATOR: FAIL
> 		fail: v4l2-test-input-output.cpp(563): could get frequency for
> invalid modulator 0
> 	test VIDIOC_G/S_FREQUENCY: FAIL
> 		fail: v4l2-test-input-output.cpp(682): could not enumerate audio output 0
> 	test VIDIOC_ENUMAUDOUT: FAIL
> 	test VIDIOC_G/S/ENUMOUTPUT: FAIL
> 	test VIDIOC_G/S_AUDOUT: Not Supported
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
> 		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
> 		info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
> 		info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
> 		info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
> 		info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
> 		info: checking v4l2_queryctrl of control 'Chroma AGC' (0x0098091d)
> 		info: checking v4l2_queryctrl of control 'Chroma Gain' (0x00980924)
> 		info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
> 		info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
> 		info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
> 		info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
> 		info: checking v4l2_queryctrl of control 'Chroma AGC' (0x0098091d)
> 		info: checking v4l2_queryctrl of control 'Chroma Gain' (0x00980924)
> 	test VIDIOC_QUERYCTRL/MENU: OK
> 		info: checking control 'User Controls' (0x00980001)
> 		info: checking control 'Brightness' (0x00980900)
> 		info: checking control 'Contrast' (0x00980901)
> 		info: checking control 'Saturation' (0x00980902)
> 		info: checking control 'Hue' (0x00980903)
> 		info: checking control 'Chroma AGC' (0x0098091d)
> 		info: checking control 'Chroma Gain' (0x00980924)
> 	test VIDIOC_G/S_CTRL: OK
> 		info: checking extended control 'User Controls' (0x00980001)
> 		info: checking extended control 'Brightness' (0x00980900)
> 		info: checking extended control 'Contrast' (0x00980901)
> 		info: checking extended control 'Saturation' (0x00980902)
> 		info: checking extended control 'Hue' (0x00980903)
> 		info: checking extended control 'Chroma AGC' (0x0098091d)
> 		info: checking extended control 'Chroma Gain' (0x00980924)
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 	Standard Controls: 7 Private Controls: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK
> 		fail: v4l2-test-io-config.cpp(167): could set preset V4L2_DV_INVALID
> 		fail: v4l2-test-io-config.cpp(216): Presets failed for input 0.
> 	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: FAIL
> 	test VIDIOC_G/S_DV_TIMINGS: Not Supported
> 
> Format ioctls:
> 		info: found 1 formats for buftype 1
> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		fail: v4l2-test-formats.cpp(327): expected EINVAL, but got 25 when
> getting framebuffer format
> 	test VIDIOC_G_FBUF: FAIL
> 		fail: v4l2-test-formats.cpp(481): Video Capture Multiplanar cap set,
> but no Video Capture Multiplanar formats defined
> 	test VIDIOC_G_FMT: FAIL
> 		fail: v4l2-test-formats.cpp(509): ret && ret != EINVAL && sliced_type
> 	test VIDIOC_G_SLICED_VBI_CAP: FAIL
> Total: 27 Succeeded: 11 Failed: 16 Warnings: 2
> 

Below is my (untested) patch that should fix a number of things.

BTW, I hate the use of current_norm, and in fact I plan to get rid of current_norm
in the near future. So that's why I replaced it with g_std.

Regards,

	Hans

Date: Sun, 3 Jun 2012 12:27:57 +0200
Subject: [PATCH] stk1160: add prio & control event support. Fix querycap.

Also add g_std instead of using current_norm.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/stk1160/stk1160-core.c |    2 +-
 drivers/media/video/stk1160/stk1160-v4l.c  |   40 +++++++++++++++++++---------
 drivers/media/video/stk1160/stk1160.h      |    1 +
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/stk1160/stk1160-core.c b/drivers/media/video/stk1160/stk1160-core.c
index b638363..1e58a19 100644
--- a/drivers/media/video/stk1160/stk1160-core.c
+++ b/drivers/media/video/stk1160/stk1160-core.c
@@ -189,7 +189,7 @@ static void stk1160_release(struct v4l2_device *v4l2_dev)
 static int stk1160_scan_usb(struct usb_interface *intf, struct usb_device *udev,
 		unsigned int *max_pkt_size)
 {
-	int i, e, sizedescr, size, ifnum, inputnum;
+	int i, e, sizedescr, size, ifnum, inputnum = 1;
 	const struct usb_endpoint_descriptor *desc;
 
 	bool has_video = false, has_audio = false;
diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
index 67c1b2b..82eeee3 100644
--- a/drivers/media/video/stk1160/stk1160-v4l.c
+++ b/drivers/media/video/stk1160/stk1160-v4l.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include <media/saa7115.h>
@@ -93,11 +94,11 @@ static void stk1160_set_std(struct stk1160 *dev)
 		{0xffff, 0xffff}
 	};
 
-	if (dev->vdev.current_norm & V4L2_STD_525_60) {
+	if (dev->norm & V4L2_STD_525_60) {
 		stk1160_dbg("registers to NTSC like standard\n");
 		for (i = 0; std525[i].reg != 0xffff; i++)
 			stk1160_write_reg(dev, std525[i].reg, std525[i].val);
-	} else if (dev->vdev.current_norm & V4L2_STD_625_50) {
+	} else if (dev->norm & V4L2_STD_625_50) {
 		stk1160_dbg("registers to PAL like standard\n");
 		for (i = 0; std625[i].reg != 0xffff; i++)
 			stk1160_write_reg(dev, std625[i].reg, std625[i].val);
@@ -430,12 +431,16 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 static int vidioc_querycap(struct file *file,
 		void *priv, struct v4l2_capability *cap)
 {
+	struct stk1160 *dev = video_drvdata(file);
+
 	strcpy(cap->driver, "stk1160");
 	strcpy(cap->card, "stk1160");
-	cap->capabilities =
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
+	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -523,6 +528,14 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	*norm = dev->norm;
+	return 0;
+}
+
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
 	struct stk1160 *dev = video_drvdata(file);
@@ -541,10 +554,10 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 		return -ENODEV;
 
 	/* This is taken from saa7115 video decoder */
-	if (dev->vdev.current_norm & V4L2_STD_525_60) {
+	if (dev->norm & V4L2_STD_525_60) {
 		dev->width = 720;
 		dev->height = 480;
-	} else if (dev->vdev.current_norm & V4L2_STD_625_50) {
+	} else if (dev->norm & V4L2_STD_625_50) {
 		dev->width = 720;
 		dev->height = 576;
 	} else {
@@ -553,12 +566,12 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
 	}
 
 	/* We need to set this now, before we call stk1160_set_std */
-	dev->vdev.current_norm = *norm;
+	dev->norm = *norm;
 
 	stk1160_set_std(dev);
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
-			dev->vdev.current_norm);
+			dev->norm);
 
 	return 0;
 }
@@ -647,7 +660,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
 	.vidioc_querystd      = vidioc_querystd,
-	.vidioc_g_std         = NULL, /* don't worry v4l handles this */
+	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
@@ -664,6 +677,9 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 	.vidioc_streamoff     = vidioc_streamoff,
 
 	/* TODO: Add debug ioctls: s/g_register, log_status, etc */
+	.vidioc_log_status  = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /********************************************************************/
@@ -824,10 +840,10 @@ int stk1160_video_register(struct stk1160 *dev)
 
 	/* This will be used to set video_device parent */
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
 
-	/* NTSC is default. Could be any other, but has to match
-	 * with video_device current_norm field */
-	dev->vdev.current_norm = V4L2_STD_NTSC_M;
+	/* NTSC is default */
+	dev->norm = V4L2_STD_NTSC_M;
 	dev->width = 720;
 	dev->height = 480;
 
@@ -836,7 +852,7 @@ int stk1160_video_register(struct stk1160 *dev)
 	stk1160_set_std(dev);
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
-			dev->vdev.current_norm);
+			dev->norm);
 
 	video_set_drvdata(&dev->vdev, dev);
 	rc = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
diff --git a/drivers/media/video/stk1160/stk1160.h b/drivers/media/video/stk1160/stk1160.h
index 67148de..79e9291 100644
--- a/drivers/media/video/stk1160/stk1160.h
+++ b/drivers/media/video/stk1160/stk1160.h
@@ -141,6 +141,7 @@ struct stk1160 {
 	int width;		  /* current frame width */
 	int height;		  /* current frame height */
 	unsigned int ctl_input;	  /* selected input */
+	v4l2_std_id norm;	  /* current norm */
 	struct stk1160_fmt *fmt;  /* selected format */
 
 	unsigned int field_count; /* not sure ??? */
-- 
1.7.10

