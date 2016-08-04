Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcHDLrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 07:47:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2] media-ctl: Initialize ioctl arguments to 0
Date: Thu,  4 Aug 2016 14:38:06 +0300
Message-Id: <1470310686-19896-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures that the reserved fields are properly set to 0 as required
by the API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/libmediactl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Changes since v1:

- Use struct initializers instead of memset

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 636821abc85c..1fd6525b40d3 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -212,8 +212,8 @@ int media_setup_link(struct media_device *media,
 		     struct media_pad *sink,
 		     __u32 flags)
 {
+	struct media_link_desc ulink = { { 0 } };
 	struct media_link *link;
-	struct media_link_desc ulink;
 	unsigned int i;
 	int ret;
 
@@ -324,7 +324,7 @@ static int media_enum_links(struct media_device *media)
 
 	for (id = 1; id <= media->entities_count; id++) {
 		struct media_entity *entity = &media->entities[id - 1];
-		struct media_links_enum links;
+		struct media_links_enum links = { 0 };
 		unsigned int i;
 
 		links.entity = entity->info.id;
@@ -593,6 +593,8 @@ int media_device_enumerate(struct media_device *media)
 	if (ret < 0)
 		return ret;
 
+	memset(&media->info, 0, sizeof(media->info));
+
 	ret = ioctl(media->fd, MEDIA_IOC_DEVICE_INFO, &media->info);
 	if (ret < 0) {
 		ret = -errno;
-- 
Regards,

Laurent Pinchart

