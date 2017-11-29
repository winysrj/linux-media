Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54420 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752216AbdK2ToF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:44:05 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v8 03/28] rcar-vin: unregister video device on driver removal
Date: Wed, 29 Nov 2017 20:43:17 +0100
Message-Id: <20171129194342.26239-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the video device was registered by the complete() callback it should
be unregistered when the driver is removed. Protect from printing a
uninitialized video device node name by adding a checking in
rvin_v4l2_unregister() by checking that the video device is registered.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f7a4c21909da6923..6d99542ec74b49a7 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -272,6 +272,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	rvin_v4l2_unregister(vin);
+
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 178aecc94962abe2..32a658214f48fa49 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -841,6 +841,9 @@ static const struct v4l2_file_operations rvin_fops = {
 
 void rvin_v4l2_unregister(struct rvin_dev *vin)
 {
+	if (!video_is_registered(&vin->vdev))
+		return;
+
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
 		  video_device_node_name(&vin->vdev));
 
-- 
2.15.0
