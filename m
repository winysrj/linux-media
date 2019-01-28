Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09156C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE2132173C
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548694172;
	bh=khEciF1J8C5dG2EQcIl21l4X5RDmspjmIGFXJSMYwDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H3O7WQf3eSI3firgoDkXnZigwAVPwMn2lGR0x8QMQEFufonZvKPJF9nzVsiMTbdXT
	 gtYFtR9PFMNJdnkNdw91B8UQR9H4TAIU+RkFMCnLXceTfxkAoHsrIS8C1d6R2WqLb6
	 NpBL6LKhgncwPCeLeiXyGo3kAHK+dlRNXDXvdkXE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388879AbfA1QUq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388872AbfA1QUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:20:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEEF82147A;
        Mon, 28 Jan 2019 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692445;
        bh=khEciF1J8C5dG2EQcIl21l4X5RDmspjmIGFXJSMYwDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhNU5x+UjOOk/lfozUJv4Nb2miv7P3NAfQTC9HxfapCLRf7i+Dl5xtpfB/kxyg42M
         64E8UB1N3i8x3UMzeXgwI6J9gzzXDGPHwAn+s6AntDhYjTwUukZvvONKkqrfXwn+GC
         m0pqd3kuM8f/LDvuzf/hVIe7tDkMs96LwvIHTerM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 022/107] media: mtk-vcodec: Release device nodes in mtk_vcodec_init_enc_pm()
Date:   Mon, 28 Jan 2019 11:18:22 -0500
Message-Id: <20190128161947.57405-22-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128161947.57405-1-sashal@kernel.org>
References: <20190128161947.57405-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 8ea0f2ba0fa3f91ea1b8d823a54b042026ada6b3 ]

of_parse_phandle() returns the device node with refcount incremented.
There are two nodes that are used temporary in mtk_vcodec_init_enc_pm(),
but their refcounts are not decremented.

The patch adds one of_node_put() and fixes returning error codes.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
index 3e73e9db781f..7c025045ea90 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
@@ -41,25 +41,27 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
 	node = of_parse_phandle(dev->of_node, "mediatek,larb", 0);
 	if (!node) {
 		mtk_v4l2_err("no mediatek,larb found");
-		return -1;
+		return -ENODEV;
 	}
 	pdev = of_find_device_by_node(node);
+	of_node_put(node);
 	if (!pdev) {
 		mtk_v4l2_err("no mediatek,larb device found");
-		return -1;
+		return -ENODEV;
 	}
 	pm->larbvenc = &pdev->dev;
 
 	node = of_parse_phandle(dev->of_node, "mediatek,larb", 1);
 	if (!node) {
 		mtk_v4l2_err("no mediatek,larb found");
-		return -1;
+		return -ENODEV;
 	}
 
 	pdev = of_find_device_by_node(node);
+	of_node_put(node);
 	if (!pdev) {
 		mtk_v4l2_err("no mediatek,larb device found");
-		return -1;
+		return -ENODEV;
 	}
 
 	pm->larbvenclt = &pdev->dev;
-- 
2.19.1

