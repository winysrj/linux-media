Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86204C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 23:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F2520657
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 23:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfANXFC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 18:05:02 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726776AbfANXFC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 18:05:02 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id A364B634C85;
        Tue, 15 Jan 2019 01:03:22 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 1/1] ov7670: Remove useless use of a ret variable
Date:   Tue, 15 Jan 2019 01:05:01 +0200
Message-Id: <20190114230501.32235-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Instead of assigning the return value to ret and then checking and
returning it, just return the value to the caller directly. The success
value is always 0.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7670.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 4939a83b50e4..61c47c61c693 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -859,11 +859,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
 	/* Recalculate frame rate */
 	ov7675_get_framerate(sd, tpf);
 
-	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ov7670_write(sd, REG_CLKRC, info->clkrc);
 }
 
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
-- 
2.11.0

