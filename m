Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42860
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755973AbcK2CPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 21:15:22 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: au0828 fix to protect enable/disable source set and clear
Date: Mon, 28 Nov 2016 19:15:13 -0700
Message-Id: <6a4776ad1450ecf6ce73e5c005e0549fc29e7710.1480384155.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1480384155.git.shuahkh@osg.samsung.com>
References: <cover.1480384155.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1480384155.git.shuahkh@osg.samsung.com>
References: <cover.1480384155.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Protect enable/disable source set and clear to avoid races with callers.
There is a possibility clear could occur while dvb-core and v4l2 try to
access these handlers.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index bf53553..a1f696a 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -153,9 +153,11 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	}
 
 	/* clear enable_source, disable_source */
+	mutex_lock(&mdev->graph_mutex);
 	dev->media_dev->source_priv = NULL;
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
+	mutex_unlock(&mdev->graph_mutex);
 
 	media_device_unregister(dev->media_dev);
 	media_device_cleanup(dev->media_dev);
@@ -549,9 +551,11 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 		return ret;
 	}
 	/* set enable_source */
+	mutex_lock(&dev->media_dev->graph_mutex);
 	dev->media_dev->source_priv = (void *) dev;
 	dev->media_dev->enable_source = au0828_enable_source;
 	dev->media_dev->disable_source = au0828_disable_source;
+	mutex_unlock(&dev->media_dev->graph_mutex);
 #endif
 	return 0;
 }
-- 
2.7.4

