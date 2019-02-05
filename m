Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE93EC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C080C20818
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfBEUY4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:24:56 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41762 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfBEUY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 15:24:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 5595028020E
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 03/10] rockchip/vpu: Use v4l2_m2m_buf_copy_data
Date:   Tue,  5 Feb 2019 17:24:10 -0300
Message-Id: <20190205202417.16555-4-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190205202417.16555-1-ezequiel@collabora.com>
References: <20190205202417.16555-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use the recently introduced v4l2_m2m_buf_copy_data helper
and get rid of some code.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 962412c79b91..c332dbeb9dbc 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -59,14 +59,7 @@ static void rockchip_vpu_job_finish(struct rockchip_vpu_dev *vpu,
 	src->sequence = ctx->sequence_out++;
 	dst->sequence = ctx->sequence_cap++;
 
-	dst->field = src->field;
-	if (src->flags & V4L2_BUF_FLAG_TIMECODE)
-		dst->timecode = src->timecode;
-	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
-	dst->flags &= ~(V4L2_BUF_FLAG_TSTAMP_SRC_MASK |
-			V4L2_BUF_FLAG_TIMECODE);
-	dst->flags |= src->flags & (V4L2_BUF_FLAG_TSTAMP_SRC_MASK |
-				    V4L2_BUF_FLAG_TIMECODE);
+	v4l2_m2m_buf_copy_data(src, dst, true);
 
 	avail_size = vb2_plane_size(&dst->vb2_buf, 0) -
 		     ctx->vpu_dst_fmt->header_size;
-- 
2.20.1

