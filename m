Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52404 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3DWKwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 06:52:31 -0400
Received: by mail-pd0-f169.google.com with SMTP id 10so362221pdc.28
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 03:52:31 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 1/3] [media] sh_veu: invoke v4l2_m2m_job_finish() even if a job has been aborted
Date: Tue, 23 Apr 2013 19:51:35 +0900
Message-Id: <1366714297-2784-2-git-send-email-matsu@igel.co.jp>
In-Reply-To: <1366714297-2784-1-git-send-email-matsu@igel.co.jp>
References: <1366714297-2784-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_job_finish() should be invoked even if the current
ongoing job has been aborted since v4l2_m2m_ctx_release() which
has issued the job abort may wait until the finish function is invoked.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 drivers/media/platform/sh_veu.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index cb54c69..f88c0e8 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1137,10 +1137,7 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 
 	veu->xaction++;
 
-	if (!veu->aborting)
-		return IRQ_WAKE_THREAD;
-
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 static int sh_veu_probe(struct platform_device *pdev)
-- 
1.7.0.4

