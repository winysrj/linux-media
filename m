Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283B9C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED5E7218D0
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfCOQpP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:15 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49004 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbfCOQpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 08107260215
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 05/16] media: vimc: Create multiplanar parameter
Date:   Fri, 15 Mar 2019 13:43:48 -0300
Message-Id: <20190315164359.626-6-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190315164359.626-1-andrealmeid@collabora.com>
References: <20190315164359.626-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Create multiplanar kernel module parameter to define if
the driver is running in single planar or in multiplanar mode.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-common.h | 2 ++
 drivers/media/platform/vimc/vimc-core.c   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 7ceb9ea937e2..25e47c8691dd 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -26,6 +26,8 @@
 
 #define VIMC_PDEV_NAME "vimc"
 
+extern unsigned int multiplanar;
+
 /* VIMC-specific controls */
 #define VIMC_CID_VIMC_BASE		(0x00f00000 | 0xf000)
 #define VIMC_CID_VIMC_CLASS		(0x00f00000 | 1)
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 0fbb7914098f..34ca90fa6e79 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -26,6 +26,11 @@
 
 #define VIMC_MDEV_MODEL_NAME "VIMC MDEV"
 
+unsigned int multiplanar;
+module_param(multiplanar, uint, 0000);
+MODULE_PARM_DESC(sca_mult, "0 (default) creates a single planar device, 1 creates a multiplanar device.");
+
+
 #define VIMC_ENT_LINK(src, srcpad, sink, sinkpad, link_flags) {	\
 	.src_ent = src,						\
 	.src_pad = srcpad,					\
@@ -388,6 +393,9 @@ static int __init vimc_init(void)
 		return ret;
 	}
 
+	dev_dbg(&vimc_dev.pdev.dev, "vimc: multiplanar mode is %s\n",
+		multiplanar ? "ON" : "OFF");
+
 	return 0;
 }
 
-- 
2.21.0

