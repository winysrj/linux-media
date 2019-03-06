Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA976C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C06A20854
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfCFWnU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:43:20 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60850 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfCFWnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 17:43:20 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:798c:6bb0:a97a:4a09:e6d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id C704628036E;
        Wed,  6 Mar 2019 22:43:12 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com
Subject: [PATCH 3/8] media: vimc: cap: fix step width/height in enum framesize
Date:   Wed,  6 Mar 2019 19:42:39 -0300
Message-Id: <20190306224244.21070-4-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190306224244.21070-1-helen.koike@collabora.com>
References: <20190306224244.21070-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The type V4L2_FRMSIZE_TYPE_CONTINUOUS expects a step of 1.
This fixes v4l2-compliance test error:

        fail: v4l2-test-formats.cpp(184): invalid step_width/height for continuous framesize
test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---

 drivers/media/platform/vimc/vimc-capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 3d433361d297..e976a9d6b460 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -187,8 +187,8 @@ static int vimc_cap_enum_framesizes(struct file *file, void *fh,
 	fsize->stepwise.max_width = VIMC_FRAME_MAX_WIDTH;
 	fsize->stepwise.min_height = VIMC_FRAME_MIN_HEIGHT;
 	fsize->stepwise.max_height = VIMC_FRAME_MAX_HEIGHT;
-	fsize->stepwise.step_width = 2;
-	fsize->stepwise.step_height = 2;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.step_height = 1;
 
 	return 0;
 }
-- 
2.20.1

