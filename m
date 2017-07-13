Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46472 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752330AbdGMPXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:23:54 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0F9D0600CC
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 18:23:50 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 6/6] media: devnode: Rename mdev argument as devnode
Date: Thu, 13 Jul 2017 18:23:49 +0300
Message-Id: <20170713152349.14480-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
References: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Historically, mdev argument name was being used on both struct
media_device and struct media_devnode. Recently most occurrences of mdev
referring to struct media_devnode were replaced by devnode, which makes
more sense. Fix the last remaining occurrence.

Fixes: 163f1e93e9950 ("[media] media-devnode: fix namespace mess")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c51e2e5636f3..fce91b543c14 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -537,9 +537,9 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
  * Registration/unregistration
  */
 
-static void media_device_release(struct media_devnode *mdev)
+static void media_device_release(struct media_devnode *devnode)
 {
-	dev_dbg(mdev->parent, "Media device released\n");
+	dev_dbg(devnode->parent, "Media device released\n");
 }
 
 /**
-- 
2.11.0
