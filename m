Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EA3C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EEF32175B
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697648;
	bh=TAmGb1Xgkz1iCflV6tbClJSsCWqJ1LRWmLtsCjC2ULA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NE62rppuXYRMZkGX0dkiQkWhegrSDHiT4pOeXisM7m62zThBeAVTd53DA8vse1aVt
	 kWmenRlz/syCoGjWojfWNj24RzKnTGRtzEJ489DlecK8e4idYr21M2jdgy9nCdbj2U
	 5FIp4WvjWctTXFwcbKjlTGSiGj6EJVh+NnRqoqwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfA1Pq2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:46:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727371AbfA1Pq1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:46:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E6820880;
        Mon, 28 Jan 2019 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690387;
        bh=TAmGb1Xgkz1iCflV6tbClJSsCWqJ1LRWmLtsCjC2ULA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEBy9wAAwCEbJMLcz6r+oWZG1zewRL+BIAqvOJxK/U7DP5GsKdcp+NsOksewxyR2y
         pa/Z/asoNNOzbNQsRitq1AXCvwKGH9yOPX01UAU1VTvt19ZvmLVV10I6/C2qdMBd2l
         44TZ536MM+yNT5b1e+fKuvHR25N11K9lS9X2hbuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 069/304] media: vivid: fill in media_device bus_info
Date:   Mon, 28 Jan 2019 10:39:46 -0500
Message-Id: <20190128154341.47195-69-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit e10b40f3304360d3a2d07d690ff12197f828f2c8 ]

If you create multiple vivid instances, each with their own media
device, then there was no way to tell them apart.

Fill in the bus_info so each instance has a unique bus_info string.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 626e2b24a403..ec1b1a8ea775 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -669,6 +669,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	/* Initialize media device */
 	strlcpy(dev->mdev.model, VIVID_MODULE_NAME, sizeof(dev->mdev.model));
+	snprintf(dev->mdev.bus_info, sizeof(dev->mdev.bus_info),
+		 "platform:%s-%03d", VIVID_MODULE_NAME, inst);
 	dev->mdev.dev = &pdev->dev;
 	media_device_init(&dev->mdev);
 	dev->mdev.ops = &vivid_media_ops;
-- 
2.19.1

