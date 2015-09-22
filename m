Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:33872 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758786AbbIVR2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:05 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 15/21] media: au0828 video remove au0828_enable_analog_tuner()
Date: Tue, 22 Sep 2015 11:19:34 -0600
Message-Id: <e7c7243008cf3479b08dfa5d8c5f429d1020a4fc.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828_enable_analog_tuner() is no longer needed with
v4l2-core and au0828-video invoking enable_source and
disable_source handlers. In addition, it is unnecessary
to check for tuner availability in queue_setup() as
v4l2-core handles the tuner availability checks.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 62 ---------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 939b2ad..b63ae78 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -637,66 +637,6 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int au0828_enable_analog_tuner(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity  *entity, *source;
-	struct media_link *link, *found_link = NULL;
-	int i, ret, active_links = 0;
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
-	for (i = 0; i < dev->decoder->num_links; i++) {
-		link = &dev->decoder->links[i];
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
-	for (i = 0; i < source->num_links; i++) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		link = &source->links[i];
-		sink = link->sink->entity;
-
-		if (sink == entity)
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
 static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
@@ -712,8 +652,6 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	*nplanes = 1;
 	sizes[0] = size;
 
-	au0828_enable_analog_tuner(dev);
-
 	return 0;
 }
 
-- 
2.1.4

