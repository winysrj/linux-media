Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55883 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752554AbeBSKiO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 10/15] media-device.c: zero reserved fields
Date: Mon, 19 Feb 2018 11:38:01 +0100
Message-Id: <20180219103806.17032-11-hverkuil@xs4all.nl>
In-Reply-To: <20180219103806.17032-1-hverkuil@xs4all.nl>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
struct. Do so in media_device_setup_link().

MEDIA_IOC_ENUM_LINKS didn't zero the reserved field of the media_links_enum
struct. Do so in media_device_enum_links().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e79f72b8b858..639fa703e91e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -190,6 +190,7 @@ static long media_device_enum_links(struct media_device *mdev,
 			ulink_desc++;
 		}
 	}
+	memset(links->reserved, 0, sizeof(links->reserved));
 
 	return 0;
 }
@@ -218,6 +219,8 @@ static long media_device_setup_link(struct media_device *mdev,
 	if (link == NULL)
 		return -EINVAL;
 
+	memset(linkd->reserved, 0, sizeof(linkd->reserved));
+
 	/* Setup the link on both entities. */
 	return __media_entity_setup_link(link, linkd->flags);
 }
-- 
2.16.1
