Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26005 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaKUQPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:15:25 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFE00KTCD5NI260@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 22 Nov 2014 01:15:23 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 09/11] mediactl: Close only pipeline sub-devices
Date: Fri, 21 Nov 2014 17:14:38 +0100
Message-id: <1416586480-19982-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function media_device_new_by_entity_devname queries
media devices available in the system for containment
if given media entity. If a verification is negative
the media_device is released with media_device_unref.
In the previous approach media_device_unref was closing
all media entities it contained, which was undesirable
behavior as there might exist other initialized plugins
which had opened the same media_device and initialized
a pipeline. With this patch only the sub-devices that
belong to the pipeline of current media_device instance
will be closed.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 003902b..9419fb4 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -917,13 +917,13 @@ void media_device_unref(struct media_device *media)
 	if (media->refcount > 0)
 		return;
 
+	media_close_pipeline_subdevs(media);
+
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
 
 		free(entity->pads);
 		free(entity->links);
-		if (entity->sd->fd != -1)
-			close(entity->sd->fd);
 		free(entity->sd->v4l2_controls);
 		free(entity->sd);
 	}
-- 
1.7.9.5

