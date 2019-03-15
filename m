Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E68C4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F310C218D9
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfCOQpo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:44 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49070 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbfCOQpn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:43 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 8D3C928157F
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 13/16] media: vimc: sen: Add support for multiplanar formats
Date:   Fri, 15 Mar 2019 13:43:56 -0300
Message-Id: <20190315164359.626-14-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190315164359.626-1-andrealmeid@collabora.com>
References: <20190315164359.626-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This commit adapts vimc-sensor to handle multiplanar pixel formats,
adapting the memory allocation and TPG configuration.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-sensor.c | 48 +++++++++++++----------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 020651320ac9..33cbe2cd42ee 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -97,16 +97,16 @@ static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
 static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
 {
 	u32 pixelformat = vsen->ved.stream->producer_pixfmt;
-	const struct v4l2_format_info *pix_info;
-
-	pix_info = v4l2_format_info(pixelformat);
+	unsigned int i;
 
+	tpg_s_fourcc(&vsen->tpg, pixelformat);
 	tpg_reset_source(&vsen->tpg, vsen->mbus_format.width,
 			 vsen->mbus_format.height, vsen->mbus_format.field);
-	tpg_s_bytesperline(&vsen->tpg, 0,
-			   vsen->mbus_format.width * pix_info->bpp[0]);
 	tpg_s_buf_height(&vsen->tpg, vsen->mbus_format.height);
-	tpg_s_fourcc(&vsen->tpg, pixelformat);
+
+	for (i = 0; i < tpg_g_planes(&vsen->tpg); i++)
+		tpg_s_bytesperline(&vsen->tpg, i, vsen->frame.bytesperline[i]);
+
 	/* TODO: add support for V4L2_FIELD_ALTERNATE */
 	tpg_s_field(&vsen->tpg, vsen->mbus_format.field, false);
 	tpg_s_colorspace(&vsen->tpg, vsen->mbus_format.colorspace);
@@ -182,8 +182,12 @@ static struct vimc_frame *vimc_sen_process_frame(struct vimc_ent_device *ved,
 {
 	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
 						    ved);
+	unsigned int i;
+
+	for (i = 0; i < tpg_g_planes(&vsen->tpg); i++)
+		tpg_fill_plane_buffer(&vsen->tpg, 0, i,
+					vsen->frame.plane_addr[i]);
 
-	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame.plane_addr[0]);
 	return &vsen->frame;
 }
 
@@ -191,32 +195,36 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct vimc_sen_device *vsen =
 				container_of(sd, struct vimc_sen_device, sd);
+	unsigned int i;
 
 	if (enable) {
-		u32 pixelformat = vsen->ved.stream->producer_pixfmt;
-		const struct v4l2_format_info *pix_info;
-		unsigned int frame_size;
-
 		/* Calculate the frame size */
-		pix_info = v4l2_format_info(pixelformat);
-		frame_size = vsen->mbus_format.width * pix_info->bpp[0] *
-			     vsen->mbus_format.height;
-
+		vimc_fill_frame(&vsen->frame, vsen->ved.stream->producer_pixfmt,
+				vsen->mbus_format.width,
+				vsen->mbus_format.height);
 		/*
 		 * Allocate the frame buffer. Use vmalloc to be able to
 		 * allocate a large amount of memory
 		 */
-		vsen->frame.plane_addr[0] = vmalloc(frame_size);
-		if (!vsen->frame.plane_addr[0])
-			return -ENOMEM;
+		for (i = 0; i < vsen->frame.num_planes; i++) {
+			vsen->frame.plane_addr[i] =
+				vmalloc(vsen->frame.sizeimage[i]);
+			if (!vsen->frame.plane_addr[i]) {
+				for (i -= 1; i >= 0; i--)
+					vfree(vsen->frame.plane_addr[i]);
+				return -ENOMEM;
+			}
+		}
 
 		/* configure the test pattern generator */
 		vimc_sen_tpg_s_format(vsen);
 
 	} else {
+		for (i = 0; i < vsen->frame.num_planes; i++) {
+			vfree(vsen->frame.plane_addr[i]);
+			vsen->frame.plane_addr[i] = NULL;
+		}
 
-		vfree(vsen->frame.plane_addr[0]);
-		vsen->frame.plane_addr[0] = NULL;
 		return 0;
 	}
 
-- 
2.21.0

