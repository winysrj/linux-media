Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60928 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753821AbdBTPWm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 10:22:42 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0DB30600A8
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 17:22:27 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/6] media: devnode: Rename mdev argument as devnode
Date: Mon, 20 Feb 2017 17:22:22 +0200
Message-Id: <1487604142-27610-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Historically, mdev argument name was being used on both struct
media_device and struct media_devnode. Recently most occurrences of mdev
referring to struct media_devnode were replaced by devnode, which makes
more sense. Fix the last remaining occurrence.

Fixes: 163f1e93e9950 ("[media] media-devnode: fix namespace mess")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c51e2e5..fce91b5 100644
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
2.1.4
