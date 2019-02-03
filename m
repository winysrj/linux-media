Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3660DC282DA
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 042EC20821
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfBCQEE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 11:04:04 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:33226 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfBCQED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Feb 2019 11:04:03 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 9E56B5FB7A; Mon,  4 Feb 2019 00:04:01 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] media: sun6i: Fix CSI regmap's max_register
Date:   Mon,  4 Feb 2019 00:03:56 +0800
Message-Id: <20190203160358.21050-2-wens@csie.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190203160358.21050-1-wens@csie.org>
References: <20190203160358.21050-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

max_register is currently set to 0x1000. This is beyond the mapped
address range of the hardware, so attempts to dump the regmap from
debugfs would trigger a kernel exception.

Furthermore, the useful registers only occupy a small section at the
beginning of the full range. Change the value to 0x9c, the last known
register on the V3s and H3.

On the A31, the register range is extended to support additional
capture channels. Since this is not yet supported, ignore it for now.

Fixes: 5cc7522d8965 ("media: sun6i: Add support for Allwinner CSI V3s")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index ee882b66a5ea..332cf81a7ecf 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -793,7 +793,7 @@ static const struct regmap_config sun6i_csi_regmap_config = {
 	.reg_bits       = 32,
 	.reg_stride     = 4,
 	.val_bits       = 32,
-	.max_register	= 0x1000,
+	.max_register	= 0x9c,
 };
 
 static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
-- 
2.20.1

