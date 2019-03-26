Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175BFC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D36BD2084B
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UFOAt6sy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbfCZHoy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:44:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42201 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfCZHox (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 03:44:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id cv12so1246425plb.9
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2019 00:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WN5U6KXN7zp8x4sdlZnFG53yaxOCJgECjRiQIMNvhe4=;
        b=UFOAt6syz/ZSn9uIr/iXNruJy5QF6TB7LHi1oriFBi4EylajNF97/WfREzpHKa82YZ
         7AK4IEuXOymOKLSon2OhbPSj+oAjSuIzk2YCUfnkcaWaDoCeiIkLbJwSQ7fRF5u/WnM4
         FxE0o4fhSyaKX0O3Mw2JwLkmxLvnSXdMAGBqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WN5U6KXN7zp8x4sdlZnFG53yaxOCJgECjRiQIMNvhe4=;
        b=KETQxpteiegY3WmsNmVSsMxi5OXqWXCJ9b3ilcUcx3AUi52qXpd14vFyKAboktQI9B
         92Sq2vFK13b7IsK1Sk6yOrA6KWiqEak7eADRkiJqdMZuJ1tEzNZ/HzOD+7WRy70eqZlW
         lmTjPDQTevYcru/7xoT/x9PyXev10EeZTSyl/f7cJBdEDbMnDTMYQDvTGJr9wB41T3nB
         kF+tKqjpMWuWWC1/rIqU5z84GDO0AnzJeciRLw4ALDEPQ5PDuxAUa5ydxfxks+KdWMy7
         3u4XLoRrTcZH1X1j4BvDNPcnSqmNdqVjUrc+csQsbzwXT8hX08YYsyTdHH19Kjx8Epyi
         liJQ==
X-Gm-Message-State: APjAAAUjn2qSH8A77nbSefFrT+y0X3e2HIhtzngN6LBV7JPgIb/VJNSb
        hq/Q+W9lKi2hahSRltRdXP9zu1cYqFk=
X-Google-Smtp-Source: APXvYqwqCuWrtEbTSXcTCIzjkhkrreh05C7B3xpiMWN2Bew7wwyKI1ojX0PNg+zVbEG7jYLBc9RpFA==
X-Received: by 2002:a17:902:e20e:: with SMTP id ce14mr16000701plb.193.1553586293140;
        Tue, 26 Mar 2019 00:44:53 -0700 (PDT)
Received: from acourbot.tok.corp.google.com ([2401:fa00:4:4:9712:8cf1:d0f:7d33])
        by smtp.gmail.com with ESMTPSA id p14sm35710708pgn.34.2019.03.26.00.44.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 00:44:52 -0700 (PDT)
From:   Alexandre Courbot <acourbot@chromium.org>
To:     Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: mtk-vcodec: remove ready_to_display
Date:   Tue, 26 Mar 2019 16:44:46 +0900
Message-Id: <20190326074446.123945-1-acourbot@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This member is never read throughout the code, so remove it.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 5 -----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h | 2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index e20b340855e7..710dcebb42b3 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -133,8 +133,6 @@ static struct vb2_buffer *get_display_buffer(struct mtk_vcodec_ctx *ctx)
 		vb2_set_plane_payload(&dstbuf->vb.vb2_buf, 1,
 					ctx->picinfo.c_bs_sz);
 
-		dstbuf->ready_to_display = true;
-
 		mtk_v4l2_debug(2,
 				"[%d]status=%x queue id=%d to done_list %d",
 				ctx->id, disp_frame_buffer->status,
@@ -1122,11 +1120,9 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 			v4l2_m2m_buf_queue(ctx->m2m_ctx, vb2_v4l2);
 			buf->queued_in_vb2 = true;
 			buf->queued_in_v4l2 = true;
-			buf->ready_to_display = false;
 		} else {
 			buf->queued_in_vb2 = false;
 			buf->queued_in_v4l2 = true;
-			buf->ready_to_display = false;
 		}
 		mutex_unlock(&ctx->lock);
 		return;
@@ -1253,7 +1249,6 @@ static int vb2ops_vdec_buf_init(struct vb2_buffer *vb)
 
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		buf->used = false;
-		buf->ready_to_display = false;
 		buf->queued_in_v4l2 = false;
 	} else {
 		buf->lastframe = false;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
index dc4fc1df63c5..e4984edec4f8 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
@@ -45,7 +45,6 @@ struct vdec_fb {
  * @list:	link list
  * @used:	Capture buffer contain decoded frame data and keep in
  *			codec data structure
- * @ready_to_display:	Capture buffer not display yet
  * @queued_in_vb2:	Capture buffer is queue in vb2
  * @queued_in_v4l2:	Capture buffer is in v4l2 driver, but not in vb2
  *			queue yet
@@ -60,7 +59,6 @@ struct mtk_video_dec_buf {
 	struct list_head	list;
 
 	bool	used;
-	bool	ready_to_display;
 	bool	queued_in_vb2;
 	bool	queued_in_v4l2;
 	bool	lastframe;
-- 
2.21.0.392.gf8f6787159e-goog

