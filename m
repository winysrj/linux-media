Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6824AC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E49B2082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E49B2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbeLEJZw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:25:52 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39883 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727515AbeLEJZ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:28 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 9915520A44; Wed,  5 Dec 2018 10:25:24 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 74E3F20A58;
        Wed,  5 Dec 2018 10:25:06 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 11/15] dt-bindings: media: cedrus: Add compatibles for the A64 and H5
Date:   Wed,  5 Dec 2018 10:24:40 +0100
Message-Id: <20181205092444.29497-12-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This introduces two new compatibles for the cedrus driver, for the
A64 and H5 platforms.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/cedrus.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/cedrus.txt b/Documentation/devicetree/bindings/media/cedrus.txt
index 33833a43fff8..bce0705df953 100644
--- a/Documentation/devicetree/bindings/media/cedrus.txt
+++ b/Documentation/devicetree/bindings/media/cedrus.txt
@@ -11,6 +11,8 @@ Required properties:
 			- "allwinner,sun7i-a20-video-engine"
 			- "allwinner,sun8i-a33-video-engine"
 			- "allwinner,sun8i-h3-video-engine"
+			- "allwinner,sun50i-a64-video-engine"
+			- "allwinner,sun50i-h5-video-engine"
 - reg			: register base and length of VE;
 - clocks		: list of clock specifiers, corresponding to entries in
 			  the clock-names property;
-- 
2.19.2

