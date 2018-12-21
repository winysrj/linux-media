Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D21C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 065B9218E0
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355199;
	bh=rwCJS7LxUaf+cIczKJrdX1wVEI0teHsOKIWCd6xIIQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=s5H71AU0jNDO512fo97aeTVOSbKTMNQyGbDTemf4z23k26yQbdVWoeAE+2CLsKxhF
	 fL9MyM/MfoCZBEyMn+s7Lq6DfEVwzRPlNY8Wz6QRihc8wqYRkWqhe/UQc3v4GD0TPM
	 ExQ5rNX7PdBMTsiN1U9x3LWcGoK0K/O9VyzhLYQE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403763AbeLUBT4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388626AbeLUBSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:17 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A3DF218E0;
        Fri, 21 Dec 2018 01:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355096;
        bh=rwCJS7LxUaf+cIczKJrdX1wVEI0teHsOKIWCd6xIIQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHmmfzA2YBPVMXTvgkRYNRve4QO4qsTQwwQJtSRex+vRvRs4aK0QGvs8WP61hpVwL
         ELINZNFbRO1cUiHy6yi4i9/0zS3DglEc3vaF/ZTavD07lP3YhKEyCG09YJHznO+hkC
         azsAAfYPMhMMpDkIQQdjL1g9sb4cl+Y7xoFLr6kE=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 04/14] media: wl128x-radio: remove module version
Date:   Fri, 21 Dec 2018 02:17:42 +0100
Message-Id: <20181221011752.25627-5-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

Drop module version. We already have the kernel's version and
this module is mainline.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/media/radio/wl128x/fmdrv.h        | 1 -
 drivers/media/radio/wl128x/fmdrv_common.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 1ff2eec4ed52..8ed7c0aeb8b9 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -29,7 +29,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 
-#define FM_DRV_VERSION            "0.1.1"
 #define FM_DRV_NAME               "ti_fmdrv"
 #define FM_DRV_CARD_SHORT_NAME    "TI FM Radio"
 #define FM_DRV_CARD_LONG_NAME     "Texas Instruments FM Radio"
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 800d69c3f80b..6bbae074f02d 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1622,7 +1622,7 @@ static int __init fm_drv_init(void)
 	struct fmdev *fmdev = NULL;
 	int ret = -ENOMEM;
 
-	fmdbg("FM driver version %s\n", FM_DRV_VERSION);
+	fmdbg("FM driver\n");
 
 	fmdev = kzalloc(sizeof(struct fmdev), GFP_KERNEL);
 	if (NULL == fmdev) {
@@ -1671,6 +1671,5 @@ module_exit(fm_drv_exit);
 
 /* ------------- Module Info ------------- */
 MODULE_AUTHOR("Manjunatha Halli <manjunatha_halli@ti.com>");
-MODULE_DESCRIPTION("FM Driver for TI's Connectivity chip. " FM_DRV_VERSION);
-MODULE_VERSION(FM_DRV_VERSION);
+MODULE_DESCRIPTION("FM Driver for TI's Connectivity chip");
 MODULE_LICENSE("GPL");
-- 
2.19.2

