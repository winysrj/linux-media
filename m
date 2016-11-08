Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35232 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751611AbcKHNze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:34 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 05/21] media: devnode: Rename mdev argument as devnode
Date: Tue,  8 Nov 2016 15:55:14 +0200
Message-Id: <1478613330-24691-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
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
index bb19c04..a9d543f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -540,9 +540,9 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
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

