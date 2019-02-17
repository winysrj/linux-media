Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418E7C10F00
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0818E2147C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="AVVdJWCl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfBQCtF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:49:05 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45164 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbfBQCtE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:49:04 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4D96A122E;
        Sun, 17 Feb 2019 03:49:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550371741;
        bh=29n3BxTgJ5sJ0aQ5mrhT/+zIH+ac8AS5sXn6yJizhHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVVdJWClQvkhbQWJoQKMXKCbkkxQVGrhfitE7YBeNxynFI/xZlyghhbdzGLJMA5Dp
         7+X7Rdne8hexrApaoAPxO1dHx0kA4f08RhaJ2dI3gnE+177HDVl5kAphKO/NUlibz0
         9prr5noIG/QWNtAE8V/Wg2c0SKGBfr/5NXDuopQ8=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 4/7] media: vsp1: Fix addresses of display-related registers for VSP-DL
Date:   Sun, 17 Feb 2019 04:48:49 +0200
Message-Id: <20190217024852.23328-5-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VSP-DL instances have two LIFs, and thus two copies of the
VI6_DISP_IRQ_ENB, VI6_DISP_IRQ_STA and VI6_WPF_WRBCK_CTRL registers. Fix
the corresponding macros accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c  | 4 ++--
 drivers/media/platform/vsp1/vsp1_regs.h | 6 +++---
 drivers/media/platform/vsp1/vsp1_wpf.c  | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 8d86f618ec77..048190fd3a2d 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -700,8 +700,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	drm_pipe->du_private = cfg->callback_data;
 
 	/* Disable the display interrupts. */
-	vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
-	vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
+	vsp1_write(vsp1, VI6_DISP_IRQ_STA(pipe_index), 0);
+	vsp1_write(vsp1, VI6_DISP_IRQ_ENB(pipe_index), 0);
 
 	/* Configure all entities in the pipeline. */
 	vsp1_du_pipeline_configure(pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index f6e4157095cc..1bb1d39c60d9 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -39,12 +39,12 @@
 #define VI6_WFP_IRQ_STA_DFE		(1 << 1)
 #define VI6_WFP_IRQ_STA_FRE		(1 << 0)
 
-#define VI6_DISP_IRQ_ENB		0x0078
+#define VI6_DISP_IRQ_ENB(n)		(0x0078 + (n) * 60)
 #define VI6_DISP_IRQ_ENB_DSTE		(1 << 8)
 #define VI6_DISP_IRQ_ENB_MAEE		(1 << 5)
 #define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << (n))
 
-#define VI6_DISP_IRQ_STA		0x007c
+#define VI6_DISP_IRQ_STA(n)		(0x007c + (n) * 60)
 #define VI6_DISP_IRQ_STA_DST		(1 << 8)
 #define VI6_DISP_IRQ_STA_MAE		(1 << 5)
 #define VI6_DISP_IRQ_STA_LNE(n)		(1 << (n))
@@ -307,7 +307,7 @@
 #define VI6_WPF_DSTM_ADDR_C0		0x1028
 #define VI6_WPF_DSTM_ADDR_C1		0x102c
 
-#define VI6_WPF_WRBCK_CTRL		0x1034
+#define VI6_WPF_WRBCK_CTRL(n)		(0x1034 + (n) * 0x100)
 #define VI6_WPF_WRBCK_CTRL_WBMD		(1 << 0)
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index a07c5944b598..18c49e3a7875 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -291,7 +291,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 			   VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL, 0);
+	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(wpf->entity.index), 0);
 
 	/*
 	 * Sources. If the pipeline has a single input and BRx is not used,
-- 
Regards,

Laurent Pinchart

