Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:37664 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2FREuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 00:50:00 -0400
Received: from shed.thedillows.org ([IPv6:2001:470:8:bf8::2])
	by matrix.voodoobox.net (8.13.8/8.13.8) with ESMTP id q5I4nw57025138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:50:00 -0400
Received: from [192.168.0.10] (obelisk.thedillows.org [192.168.0.10])
	by shed.thedillows.org (8.14.4/8.14.4) with ESMTP id q5I4nwAJ031213
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:49:58 -0400
Message-ID: <1339994998.32360.61.camel@obelisk.thedillows.org>
Subject: [RFC] [media] cx231xx: restore tuner settings on first open
From: David Dillow <dave@thedillows.org>
To: linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 00:49:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this patch, MythTV requires some workarounds to be able to
capture analog TV on my HVR-850. I need to keep the v4l device open via
'sleep 365d < /dev/video0' or some other mechanism or there will be no
recording. Also, I need to run vq4l2 and change the standard away and
back to NTSC or I'll get garbage. Both of these can be traced to the
settings (or lack there of) on the tuner.

The first problem is that we will tell applications that we are in NTSC
mode for the HVR-850 when they open the device for the first time after
plugging it in, but never actually set the TDA18271 to NTSC, so it
defaults to PAL_I. Applications may decide to not change the signal
standard, as they have been told it is already in the desired state.
This could be resolved by setting it during init (as we claim in the
query results), as it seems to survive putting the tuner into standby
mode.

The second problem is a bad interaction between driver behavior and
MythTV. MythTV opens the video device, tunes to the desired channel,
then closes the device. It then reopens the device and starts recording.
While this works for my WinTV-FM PCI card, the cx231xx driver puts the
tuner into standby after MythTV closes the device, and the tuner looses
the frequency when waking back up.

I solved both of these issues by just setting the standard and frequency
when opening the device for the first user. This fixes the immediate
problem, but I'm not sure it's the right fix, and I'm a bit
uncomfortable faking a call into the ioctl() routines.

What does the V4L2 API spec say about tuning frequency being persistent
when there are no users of a video capture device? Is MythTV wrong to
have that assumption, or is cx231xx wrong to not restore the frequency
when a user first opens the device?

Either way, I think MythTV should keep the device open until it is done
with it, as that would avoid added latency from putting the tuner to
sleep and waking it back up. But, I think we should address the issue in
the driver if it is not living up to the guarantees of the API.



diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 7f916f0..2794396 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2190,6 +2190,12 @@ static int cx231xx_v4l2_open(struct file *filp)
 	filp->private_data = fh;
 
 	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
+		struct v4l2_frequency freq = {
+			.tuner = 0,
+			.type = V4L2_TUNER_ANALOG_TV,
+			.frequency = dev->ctl_freq,
+		};
+
 		dev->width = norm_maxw(dev);
 		dev->height = norm_maxh(dev);
 
@@ -2214,6 +2220,11 @@ static int cx231xx_v4l2_open(struct file *filp)
 		/* device needs to be initialized before isoc transfer */
 		dev->video_input = dev->video_input > 2 ? 2 : dev->video_input;
 
+		/* Restore standard and channel, as they may be lost when
+		 * the tuner went to sleep.
+		 */
+		vidioc_s_std(filp, fh, &dev->norm);
+		vidioc_s_frequency(filp, fh, &freq);
 	}
 	if (fh->radio) {
 		cx231xx_videodbg("video_open: setting radio device\n");



