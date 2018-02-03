Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:48431 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755347AbeBCSqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 13:46:10 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-device.c: zero reserved field
Message-ID: <2441b5d8-f6dd-1f6c-9d4a-341856826c87@xs4all.nl>
Date: Sat, 3 Feb 2018 19:46:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
struct. Do so in media_device_setup_link().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e79f72b8b858..afbf23a19e16 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -218,6 +218,8 @@ static long media_device_setup_link(struct media_device *mdev,
 	if (link == NULL)
 		return -EINVAL;

+	memset(linkd->reserved, 0, sizeof(linkd->reserved));
+
 	/* Setup the link on both entities. */
 	return __media_entity_setup_link(link, linkd->flags);
 }
