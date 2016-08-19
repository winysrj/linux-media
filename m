Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46790 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754117AbcHSKYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 06:24:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v2 05/17] media: devnode: Rename mdev argument as devnode
Date: Fri, 19 Aug 2016 13:23:36 +0300
Message-Id: <1471602228-30722-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Historically, mdev argument name was being used on both struct
media_device and struct media_devnode. Recently most occurrences of mdev
referring to struct media_devnode were replaced by devnode, which makes
more sense. Fix the last remaining occurrence.

Fixes: 163f1e93e9950 ("[media] media-devnode: fix namespace mess")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 8bdc316..a431775 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -542,9 +542,9 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
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

