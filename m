Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5DAC67872
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6326520811
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6326520811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbeLNGTy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 01:19:54 -0500
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:51815 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727168AbeLNGTx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 01:19:53 -0500
X-Halon-ID: 33d047d0-ff68-11e8-911a-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 33d047d0-ff68-11e8-911a-0050569116f7;
        Fri, 14 Dec 2018 07:19:41 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 4/4] rcar-vin: add support for suspend and resume
Date:   Fri, 14 Dec 2018 07:18:24 +0100
Message-Id: <20181214061824.10296-5-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

To be able to properly support suspend and resume the VIN and all
subdevices involved in a running capture needs to be stopped before the
system is suspended. Likewise the whole pipeline needs to be started
once the system is resumed if it was running.

Achieve this by using the existing rvin_{start,stop}_stream() functions
while making sure the CSI-2 channel selection is applied to the VIN
master before restarting the capture. To be able to do keep track of
which VINs should be resumed a new internal state SUSPENDED is added to
describe this state.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 51 +++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  | 10 ++--
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97a9f9..7b34d69a97f4771d 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -862,6 +862,54 @@ static int rvin_mc_init(struct rvin_dev *vin)
 	return ret;
 }
 
+/* -----------------------------------------------------------------------------
+ * Suspend / Resume
+ */
+
+static int __maybe_unused rvin_suspend(struct device *dev)
+{
+	struct rvin_dev *vin = dev_get_drvdata(dev);
+
+	if (vin->state != RUNNING)
+		return 0;
+
+	rvin_stop_streaming(vin);
+
+	vin->state = SUSPENDED;
+
+	return 0;
+}
+
+static int __maybe_unused rvin_resume(struct device *dev)
+{
+	struct rvin_dev *vin = dev_get_drvdata(dev);
+
+	if (vin->state != SUSPENDED)
+		return 0;
+
+	/*
+	 * Restore group master CHSEL setting.
+	 *
+	 * This needs to be by every VIN resuming not only the master
+	 * as we don't know if and in which order the master VINs will
+	 * be resumed.
+	 */
+	if (vin->info->use_mc) {
+		unsigned int master_id = rvin_group_id_to_master(vin->id);
+		struct rvin_dev *master = vin->group->vin[master_id];
+		int ret;
+
+		if (WARN_ON(!master))
+			return -ENODEV;
+
+		ret = rvin_set_channel_routing(master, master->chsel);
+		if (ret)
+			return ret;
+	}
+
+	return rvin_start_streaming(vin);
+}
+
 /* -----------------------------------------------------------------------------
  * Platform Device Driver
  */
@@ -1313,9 +1361,12 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rvin_pm_ops, rvin_suspend, rvin_resume);
+
 static struct platform_driver rcar_vin_driver = {
 	.driver = {
 		.name = "rcar-vin",
+		.pm = &rvin_pm_ops,
 		.of_match_table = rvin_of_id_table,
 	},
 	.probe = rcar_vin_probe,
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 700fae1c1225a2f3..9bbc5a57fcb2915e 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -48,16 +48,18 @@ enum rvin_csi_id {
 };
 
 /**
- * STOPPED  - No operation in progress
- * STARTING - Capture starting up
- * RUNNING  - Operation in progress have buffers
- * STOPPING - Stopping operation
+ * STOPPED   - No operation in progress
+ * STARTING  - Capture starting up
+ * RUNNING   - Operation in progress have buffers
+ * STOPPING  - Stopping operation
+ * SUSPENDED - Capture is suspended
  */
 enum rvin_dma_state {
 	STOPPED = 0,
 	STARTING,
 	RUNNING,
 	STOPPING,
+	SUSPENDED,
 };
 
 /**
-- 
2.19.2

