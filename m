Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53600 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752536AbeBSKiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 12/15] media: zero reservedX fields in media_v2_topology
Date: Mon, 19 Feb 2018 11:38:03 +0100
Message-Id: <20180219103806.17032-13-hverkuil@xs4all.nl>
In-Reply-To: <20180219103806.17032-1-hverkuil@xs4all.nl>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MEDIA_IOC_G_TOPOLOGY implementation did not zero the reservedX fields.
Fix this.

Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 639fa703e91e..5b1dbb8540af 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -266,6 +266,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		uentity++;
 	}
 	topo->num_entities = i;
+	topo->reserved1 = 0;
 
 	/* Get interfaces and number of interfaces */
 	i = 0;
@@ -301,6 +302,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		uintf++;
 	}
 	topo->num_interfaces = i;
+	topo->reserved2 = 0;
 
 	/* Get pads and number of pads */
 	i = 0;
@@ -327,6 +329,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		upad++;
 	}
 	topo->num_pads = i;
+	topo->reserved3 = 0;
 
 	/* Get links and number of links */
 	i = 0;
@@ -358,6 +361,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		ulink++;
 	}
 	topo->num_links = i;
+	topo->reserved4 = 0;
 
 	return ret;
 }
-- 
2.16.1
