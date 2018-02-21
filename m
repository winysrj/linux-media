Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47705 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965198AbeBUPcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 10/15] media-device.c: zero reserved fields
Date: Wed, 21 Feb 2018 16:32:13 +0100
Message-Id: <20180221153218.15654-11-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
struct. Do so in media_device_setup_link().

MEDIA_IOC_ENUM_LINKS didn't zero the reserved field of the media_links_enum
struct. Do so in media_device_enum_links().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
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
