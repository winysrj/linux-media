Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaKFKM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:27 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00F9W4CPH340@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:25 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 10/11] mediactl: Close only pipeline sub-devices
Date: Thu, 06 Nov 2014 11:11:41 +0100
Message-id: <1415268702-23685-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
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
index 75021e7..fe38270 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -919,13 +919,13 @@ void media_device_unref(struct media_device *media)
 	if (media->refcount > 0)
 		return;
 
+	media_close_pipeline_subdevs(media);
+
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
 
 		free(entity->pads);
 		free(entity->links);
-		if (entity->fd != -1)
-			close(entity->fd);
 	}
 
 	free(media->entities);
-- 
1.7.9.5

