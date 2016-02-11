Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:58182 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbcBKXme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:34 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 21/22] media: au0828 video change to use v4l_enable_media_source()
Date: Thu, 11 Feb 2016 16:41:37 -0700
Message-Id: <8aa1bf61a24ea273b87a20cb83a502f8a01bedfe.1455233156.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828 to check if tuner is free or not
before changing tuner configuration.

vidioc_g_tuner(), and au0828_v4l2_close() now call
v4l-core interface v4l_enable_media_source() before
changing tuner configuration.

Remove au0828_enable_analog_tuner() as it is
no longer needed because v4l2-core implements
common interfaces to check for media source
availability.

In addition, queue_setup() no longer needs the
tuner availability check since v4l2-core does it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 102 ++++++++++++--------------------
 1 file changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 8c54fd2..9304f96 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -638,64 +638,6 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int au0828_enable_analog_tuner(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *source;
-	struct media_link *link, *found_link = NULL;
-	int ret, active_links = 0;
-
-	if (!mdev || !dev->decoder)
-		return 0;
-
-	/*
-	 * This will find the tuner that is connected into the decoder.
-	 * Technically, this is not 100% correct, as the device may be
-	 * using an analog input instead of the tuner. However, as we can't
-	 * do DVB streaming while the DMA engine is being used for V4L2,
-	 * this should be enough for the actual needs.
-	 */
-	list_for_each_entry(link, &dev->decoder->links, list) {
-		if (link->sink->entity == dev->decoder) {
-			found_link = link;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
-			break;
-		}
-	}
-
-	if (active_links == 1 || !found_link)
-		return 0;
-
-	source = found_link->source->entity;
-	list_for_each_entry(link, &source->links, list) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		sink = link->sink->entity;
-
-		if (sink == dev->decoder)
-			flags = MEDIA_LNK_FL_ENABLED;
-
-		ret = media_entity_setup_link(link, flags);
-		if (ret) {
-			pr_err(
-				"Couldn't change link %s->%s to %s. Error %d\n",
-				source->name, sink->name,
-				flags ? "enabled" : "disabled",
-				ret);
-			return ret;
-		} else
-			au0828_isocdbg(
-				"link %s->%s was %s\n",
-				source->name, sink->name,
-				flags ? "ENABLED" : "disabled");
-	}
-#endif
-	return 0;
-}
-
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
@@ -707,9 +649,6 @@ static int queue_setup(struct vb2_queue *vq,
 		return sizes[0] < size ? -EINVAL : 0;
 	*nplanes = 1;
 	sizes[0] = size;
-
-	au0828_enable_analog_tuner(dev);
-
 	return 0;
 }
 
@@ -1067,8 +1006,39 @@ static int au0828_v4l2_close(struct file *filp)
 		goto end;
 
 	if (dev->users == 1) {
-		/* Save some power by putting tuner to sleep */
-		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
+		/*
+		 * Avoid putting tuner in sleep if DVB or ALSA are
+		 * streaming.
+		 *
+		 * On most USB devices  like au0828 the tuner can
+		 * be safely put in sleep stare here if ALSA isn't
+		 * streaming. Exceptions are some very old USB tuner
+		 * models such as em28xx-based WinTV USB2 which have
+		 * a separate audio output jack. The devices that have
+		 * a separate audio output jack have analog tuners,
+		 * like Philips FM1236. Those devices are always on,
+		 * so the s_power callback are silently ignored.
+		 * So, the current logic here does the following:
+		 * Disable (put tuner to sleep) when
+		 * - ALSA and DVB aren't not streaming;
+		 * - the last V4L2 file handler is closed.
+		 *
+		 * FIXME:
+		 *
+		 * Additionally, this logic could be improved to
+		 * disable the media source if the above conditions
+		 * are met and if the device:
+		 * - doesn't have a separate audio out plug (or
+		 * - doesn't use a silicon tuner like xc2028/3028/4000/5000).
+		 *
+		 * Once this additional logic is in place, a callback
+		 * is needed to enable the media source and power on
+		 * the tuner, for radio to work.
+		*/
+		ret = v4l_enable_media_source(vdev);
+		if (ret == 0)
+			v4l2_device_call_all(&dev->v4l2_dev, 0, core,
+					     s_power, 0);
 		dev->std_set_in_tuner_core = 0;
 
 		/* When close the device, set the usb intf0 into alt0 to free
@@ -1469,10 +1439,16 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
 static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct au0828_dev *dev = video_drvdata(file);
+	struct video_device *vfd = video_devdata(file);
+	int ret;
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
+
 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
 		dev->std_set_in_tuner_core, dev->dev_state);
 
-- 
2.5.0

