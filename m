Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:50078 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750954AbeBHIhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:37:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 11/15] media-device.c: zero reserved field
Date: Thu,  8 Feb 2018 09:36:51 +0100
Message-Id: <20180208083655.32248-12-hverkuil@xs4all.nl>
In-Reply-To: <20180208083655.32248-1-hverkuil@xs4all.nl>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
struct. Do so in media_device_setup_link().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.15.1
