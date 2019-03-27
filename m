Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9029FC10F00
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61E5121738
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712171;
	bh=JjjoZCR+5qNZBkOkxuTOpvubcK9g2vxjOe910tjKSzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TJNWo8IuLzX5pCnwxYifnSu73s/ZOlUDZGiBPH34B6sJmriTQ1v9AJtTFPwZNVgCp
	 liRmieCf9RzWU7IZJ5n40e1pv/gRXJGIHRlTVKX5mhFuBSdUSUsc5oJZL33jK82wTN
	 vBe8WdX6x5hwCqYIWJ4lCcKFFuDs6RwcguKE9Y8M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391226AbfC0Smp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390689AbfC0SVw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:21:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87BCD21738;
        Wed, 27 Mar 2019 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710911;
        bh=JjjoZCR+5qNZBkOkxuTOpvubcK9g2vxjOe910tjKSzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7QWjEbnWjtphCKRGbyrNI3KVZ8KcM6anRBzdlhrrlRtJP0OJ10t7MRFDlUySG6c7
         +YwFGpzOZbE4C3XNoRU5Lzg0GxJagj1Y9EctALuOTJrDB6wn0VedsTTg8jvzxhrLAN
         xmOo9v/mYpPE/vSOthA8mm8XfblhpQT6gRBNKyF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 42/87] media: mx2_emmaprp: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:19:55 -0400
Message-Id: <20190327182040.17444-42-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182040.17444-1-sashal@kernel.org>
References: <20190327182040.17444-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 8d20dcefe471763f23ad538369ec65b51993ffff ]

Fix the assigned type of mem2mem buffer handling API.
Namely, these functions:

 v4l2_m2m_next_buf
 v4l2_m2m_last_buf
 v4l2_m2m_buf_remove
 v4l2_m2m_next_src_buf
 v4l2_m2m_next_dst_buf
 v4l2_m2m_last_src_buf
 v4l2_m2m_last_dst_buf
 v4l2_m2m_src_buf_remove
 v4l2_m2m_dst_buf_remove

return a struct vb2_v4l2_buffer, and not a struct vb2_buffer.

Fixing this is necessary to fix the mem2mem buffer handling API,
changing the return to the correct struct vb2_v4l2_buffer instead
of a void pointer.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mx2_emmaprp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index e68d271b10af..8354ad20865a 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -288,7 +288,7 @@ static void emmaprp_device_run(void *priv)
 {
 	struct emmaprp_ctx *ctx = priv;
 	struct emmaprp_q_data *s_q_data, *d_q_data;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct emmaprp_dev *pcdev = ctx->dev;
 	unsigned int s_width, s_height;
 	unsigned int d_width, d_height;
@@ -308,8 +308,8 @@ static void emmaprp_device_run(void *priv)
 	d_height = d_q_data->height;
 	d_size = d_width * d_height;
 
-	p_in = vb2_dma_contig_plane_dma_addr(src_buf, 0);
-	p_out = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	p_in = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	p_out = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&pcdev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
-- 
2.19.1

