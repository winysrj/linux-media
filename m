Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BD5C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 09:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AB0720883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 09:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbfAIJea (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 04:34:30 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37275 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbfAIJdm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 04:33:42 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 7614C209EF; Wed,  9 Jan 2019 10:33:40 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id 3C4B420A0D;
        Wed,  9 Jan 2019 10:33:30 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v4 3/9] phy: dphy: Clarify lanes parameter documentation
Date:   Wed,  9 Jan 2019 10:33:20 +0100
Message-Id: <e905df5df30f577b3cb731bd1e2ca7e52300dfb3.1547026369.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The lanes parameter is not solely about the number of lanes, but it also
carries the fact that those are the first lanes in use during the
transmission.

It was implicit so far, so make sure it's explicit now.

Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 include/linux/phy/phy-mipi-dphy.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
index 627d28080d3a..a877ffee845d 100644
--- a/include/linux/phy/phy-mipi-dphy.h
+++ b/include/linux/phy/phy-mipi-dphy.h
@@ -269,7 +269,8 @@ struct phy_configure_opts_mipi_dphy {
 	/**
 	 * @lanes:
 	 *
-	 * Number of active data lanes used for the transmissions.
+	 * Number of active, consecutive, data lanes, starting from
+	 * lane 0, used for the transmissions.
 	 */
 	unsigned char		lanes;
 };
-- 
git-series 0.9.1
