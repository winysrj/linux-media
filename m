Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43300 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbcAKBrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 20:47:32 -0500
Received: from avalon.bb.dnainternet.fi (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 29EB62005E
	for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 02:46:45 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] media-ctl: Initialize ioctl arguments to 0
Date: Mon, 11 Jan 2016 03:47:39 +0200
Message-Id: <1452476859-11051-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures that the reserved fields are properly set to 0 as required
by the API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/libmediactl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 4a82d24c6722..5525fbb2c0a7 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -243,6 +243,8 @@ int media_setup_link(struct media_device *media,
 		goto done;
 	}
 
+	memset(&ulink, 0, sizeof(ulink));
+
 	/* source pad */
 	ulink.source.entity = source->entity->info.id;
 	ulink.source.index = source->index;
@@ -333,6 +335,8 @@ static int media_enum_links(struct media_device *media)
 		struct media_links_enum links;
 		unsigned int i;
 
+		memset(&links, 0, sizeof(links));
+
 		links.entity = entity->info.id;
 		links.pads = calloc(entity->info.pads, sizeof(struct media_pad_desc));
 		links.links = calloc(entity->info.links, sizeof(struct media_link_desc));
@@ -596,6 +600,8 @@ int media_device_enumerate(struct media_device *media)
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

