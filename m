Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCACC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44882206BA
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713515;
	bh=1onbAR8z8mJe0hW+2m32ZehJMYtCj81YVxwmXsCbvkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dobedkyDsowMKlzOUKixmgKhLYcyCaL/mNjQ1qOuxnVGMX0qF3g6UgL3xUEy1YTue
	 MeIhhkCV0Ib2AeyEGsupGQp+fdiOguKhNCApnpdmg8SJi+htmGRSJoNJCSAcao8wFE
	 87v54sbALzn6yQIrnWfYHBrHKiOwNkmWQTZ+vD3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbfC0TFO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389287AbfC0SMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:12:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10BA21741;
        Wed, 27 Mar 2019 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710373;
        bh=1onbAR8z8mJe0hW+2m32ZehJMYtCj81YVxwmXsCbvkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Urfm3i4A1UunTdSwgjQ+Sf0Sz0bsm4TQGxPSRsffKs7A7DwSoJZyk86DC8SiWiba5
         QuaeafIf6GbjzQMR1YauZur45qD6xovwrp8MKiwEYwRORXZ2N/BFK+39hw/e0UfbuB
         wwamcghp4kE4tMXrlQQRPMz18gkn4hy7mCqINkmY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 085/192] media: sh_veu: Correct return type for mem2mem buffer helpers
Date:   Wed, 27 Mar 2019 14:08:37 -0400
Message-Id: <20190327181025.13507-85-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 43c145195c7fc3025ee7ecfc67112ac1c82af7c2 ]

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
 drivers/media/platform/sh_veu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 1d274c64de09..03ee9839a03e 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -273,13 +273,13 @@ static void sh_veu_process(struct sh_veu_dev *veu,
 static void sh_veu_device_run(void *priv)
 {
 	struct sh_veu_dev *veu = priv;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(veu->m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(veu->m2m_ctx);
 
 	if (src_buf && dst_buf)
-		sh_veu_process(veu, src_buf, dst_buf);
+		sh_veu_process(veu, &src_buf->vb2_buf, &dst_buf->vb2_buf);
 }
 
 		/* ========== video ioctls ========== */
-- 
2.19.1

