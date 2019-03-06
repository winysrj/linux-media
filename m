Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B313FC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 06:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A8620828
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 06:15:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SrCrQLvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfCFGPS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 01:15:18 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37937 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCFGPO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 01:15:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id m2so7490805pgl.5
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2019 22:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yKqYoiAT0Tmmo3srRdNf++4aPyW5uQd7VuC7jZ4Ae0=;
        b=SrCrQLvMzMrdQBfMF2hf4vL7DVph7K8/C4/HascSXSHP6hPJb9pqkxZdirMYWrBTvD
         3beFbrpMwjOAN3puKSi5yLF46/XQ0+DbO3s19GIWDgdw7c6ZNRwX3SIyPL6GCgo5RNFq
         crJ/I3ky1uzcOoLBHNZnC77/4xuKyt7mbdUQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+yKqYoiAT0Tmmo3srRdNf++4aPyW5uQd7VuC7jZ4Ae0=;
        b=kb12IS3KwZ/7owdTzwt9q1ZKdvBvMYCTvXuV87v2/seAT9BFQ/ONKoMYkcd1FolB7J
         fYbtdok43O2XDthUNE8R0je67j/jTErPuFnqdte/81+Ffbz+7oTLEthpw4hg3DOnvuZ9
         LASvb5Yqk/eHonGQrXvcszbbspEuBcrVuOo6qp7o8q370NUFxo3yGkftSwU/ousHQ+gE
         a+f3druVkjXhYLhATHsbaqWQL6OXXX+Pjigp3sJHHs1DZZXLjTKvrHgAN4xPRA8+MxRS
         yuTCB/R9HxQaBpHMpHt0RxiGr8S6QdDCKqVjrhE44gwkfO+oXPHJ/x71uFk0O2Bdqczn
         a6zw==
X-Gm-Message-State: APjAAAVoQ81w6z5FDLYjYORxV4Ff368iDqacLn5RK9pezlQtDQmB+l/e
        eSsWhZrRqfgXgFCLqFY2cCpOHQ==
X-Google-Smtp-Source: APXvYqyFrfyPokVCZ0UNRCvO3ZJgdZKDC9H1a48lxdMOuEltaAY3I7LKkXeuE3ikzh2FOmbi+zOKnQ==
X-Received: by 2002:a17:902:6b08:: with SMTP id o8mr5219821plk.105.1551852913262;
        Tue, 05 Mar 2019 22:15:13 -0800 (PST)
Received: from acourbot.tok.corp.google.com ([2401:fa00:4:4:9712:8cf1:d0f:7d33])
        by smtp.gmail.com with ESMTPSA id k9sm1511981pfc.57.2019.03.05.22.15.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 22:15:12 -0800 (PST)
From:   Alexandre Courbot <acourbot@chromium.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: mtk-vcodec: fix access to vb2_v4l2_buffer struct
Date:   Wed,  6 Mar 2019 15:15:02 +0900
Message-Id: <20190306061502.126904-1-acourbot@chromium.org>
X-Mailer: git-send-email 2.21.0.352.gf09ad66450-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem
buffer helpers") fixed the return types for mem2mem buffer helper
functions, but omitted two occurrences that are accessed in the
mtk_v4l2_debug() macro. These only trigger compiler errors when DEBUG is
defined.

Fixes: 0650a91499e0 ("media: mtk-vcodec: Correct return type for mem2mem buffer helpers")
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index d022c65bb34c..a85c7cc8328e 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1158,7 +1158,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 	src_mem.size = (size_t)src_buf->planes[0].bytesused;
 	mtk_v4l2_debug(2,
 			"[%d] buf id=%d va=%p dma=%pad size=%zx",
-			ctx->id, src_buf->index,
+			ctx->id, src_buf->vb2_buf.index,
 			src_mem.va, &src_mem.dma_addr,
 			src_mem.size);
 
@@ -1182,7 +1182,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 		}
 		mtk_v4l2_debug(ret ? 0 : 1,
 			       "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
-			       ctx->id, src_buf->index,
+			       ctx->id, src_buf->vb2_buf.index,
 			       src_mem.size, ret, res_chg);
 		return;
 	}
-- 
2.21.0.352.gf09ad66450-goog

