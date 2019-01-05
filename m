Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1FFC43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 18:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB2F222392
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 18:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfAESmJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 5 Jan 2019 13:42:09 -0500
Received: from kozue.soulik.info ([108.61.200.231]:40308 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfAESmJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2019 13:42:09 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:a00])
        by kozue.soulik.info (Postfix) with ESMTPA id 23BD0101811;
        Sun,  6 Jan 2019 03:32:44 +0900 (JST)
From:   Randy Li <ayaka@soulik.info>
To:     linux-rockchip@lists.infradead.org
Cc:     Randy Li <ayaka@soulik.info>, nicolas.dufresne@collabora.com,
        myy@miouyouyou.fr, paul.kocialkowski@bootlin.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: video: rockchip: add video codec
Date:   Sun,  6 Jan 2019 02:31:49 +0800
Message-Id: <20190105183150.20266-4-ayaka@soulik.info>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190105183150.20266-1-ayaka@soulik.info>
References: <20190105183150.20266-1-ayaka@soulik.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 drivers/staging/Kconfig  | 2 ++
 drivers/staging/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e4f608815c05..81634dd0a283 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -122,4 +122,6 @@ source "drivers/staging/axis-fifo/Kconfig"
 
 source "drivers/staging/erofs/Kconfig"
 
+source "drivers/staging/rockchip-mpp/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 5868631e8f1b..22499c68c21e 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_SOC_MT7621)	+= mt7621-dts/
 obj-$(CONFIG_STAGING_GASKET_FRAMEWORK)	+= gasket/
 obj-$(CONFIG_XIL_AXIS_FIFO)	+= axis-fifo/
 obj-$(CONFIG_EROFS_FS)		+= erofs/
+obj-$(CONFIG_ROCKCHIP_MPP_SERVICE)	+= rockchip-mpp/
-- 
2.20.1

