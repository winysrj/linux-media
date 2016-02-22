Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49822 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754052AbcBVUrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:47:08 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 3/4] media: Properly handle user pointers
Date: Mon, 22 Feb 2016 22:47:03 +0200
Message-Id: <1456174024-11389-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark pointers containing user pointers as such.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5ebb3cd..f001c27 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -245,10 +245,10 @@ static long __media_device_get_topology(struct media_device *mdev,
 	struct media_interface *intf;
 	struct media_pad *pad;
 	struct media_link *link;
-	struct media_v2_entity kentity, *uentity;
-	struct media_v2_interface kintf, *uintf;
-	struct media_v2_pad kpad, *upad;
-	struct media_v2_link klink, *ulink;
+	struct media_v2_entity kentity, __user *uentity;
+	struct media_v2_interface kintf, __user *uintf;
+	struct media_v2_pad kpad, __user *upad;
+	struct media_v2_link klink, __user *ulink;
 	unsigned int i;
 	int ret = 0;
 
-- 
2.1.4

