Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3665DC6786C
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05DAA20811
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05DAA20811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbeLNGTc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 01:19:32 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:23789 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbeLNGTc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 01:19:32 -0500
X-Halon-ID: 2faf7d72-ff68-11e8-911a-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 2faf7d72-ff68-11e8-911a-0050569116f7;
        Fri, 14 Dec 2018 07:19:20 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 3/4] rcar-vin: make rvin_{start,stop}_streaming() available for internal use
Date:   Fri, 14 Dec 2018 07:18:23 +0100
Message-Id: <20181214061824.10296-4-niklas.soderlund+renesas@ragnatech.se>
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

To support suspend/resume rvin_{start,stop}_streaming() needs to be
accessible from the suspend and resume callbacks. Up until now the only
users of these functions have been the callbacks in struct vb2_ops so
the arguments to the functions are not suitable for use by the driver it
self.

Fix this by adding wrappers for the struct vb2_ops callbacks which calls
the new rvin_{start,stop}_streaming() using more friendly arguments.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 20 ++++++++++++++------
 drivers/media/platform/rcar-vin/rcar-vin.h |  3 +++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 64f7636f94d6a0a3..d11d4df1906a8962 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1143,9 +1143,8 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	return ret;
 }
 
-static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
+int rvin_start_streaming(struct rvin_dev *vin)
 {
-	struct rvin_dev *vin = vb2_get_drv_priv(vq);
 	unsigned long flags;
 	int ret;
 
@@ -1187,9 +1186,13 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return ret;
 }
 
-static void rvin_stop_streaming(struct vb2_queue *vq)
+static int rvin_start_streaming_vq(struct vb2_queue *vq, unsigned int count)
+{
+	return rvin_start_streaming(vb2_get_drv_priv(vq));
+}
+
+void rvin_stop_streaming(struct rvin_dev *vin)
 {
-	struct rvin_dev *vin = vb2_get_drv_priv(vq);
 	unsigned long flags;
 	int retries = 0;
 
@@ -1238,12 +1241,17 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 			  vin->scratch_phys);
 }
 
+static void rvin_stop_streaming_vq(struct vb2_queue *vq)
+{
+	rvin_stop_streaming(vb2_get_drv_priv(vq));
+}
+
 static const struct vb2_ops rvin_qops = {
 	.queue_setup		= rvin_queue_setup,
 	.buf_prepare		= rvin_buffer_prepare,
 	.buf_queue		= rvin_buffer_queue,
-	.start_streaming	= rvin_start_streaming,
-	.stop_streaming		= rvin_stop_streaming,
+	.start_streaming	= rvin_start_streaming_vq,
+	.stop_streaming		= rvin_stop_streaming_vq,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 };
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index d21fc991b7a9da36..700fae1c1225a2f3 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -269,4 +269,7 @@ void rvin_crop_scale_comp(struct rvin_dev *vin);
 
 int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
 
+int rvin_start_streaming(struct rvin_dev *vin);
+void rvin_stop_streaming(struct rvin_dev *vin);
+
 #endif
-- 
2.19.2

