Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC88C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F49D2175B
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfA1UzU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:55:20 -0500
Received: from mailoutvs35.siol.net ([185.57.226.226]:40910 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726719AbfA1UzU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 15:55:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTP id A05C0521E13;
        Mon, 28 Jan 2019 21:55:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta12.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta12.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QIsLjbqUufl8; Mon, 28 Jan 2019 21:55:17 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTPS id 59D8D521CC1;
        Mon, 28 Jan 2019 21:55:17 +0100 (CET)
Received: from localhost.localdomain (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Zimbra) with ESMTPSA id D3E8A521849;
        Mon, 28 Jan 2019 21:55:12 +0100 (CET)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 1/6] dt-bindings: media: cedrus: Add H6 compatible
Date:   Mon, 28 Jan 2019 21:54:59 +0100
Message-Id: <20190128205504.11225-2-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128205504.11225-1-jernej.skrabec@siol.net>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This adds a compatible for H6. H6 VPU supports 10-bit HEVC decoding and
additional AFBC output format for HEVC.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 Documentation/devicetree/bindings/media/cedrus.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/cedrus.txt b/Documen=
tation/devicetree/bindings/media/cedrus.txt
index bce0705df953..20c82fb0c343 100644
--- a/Documentation/devicetree/bindings/media/cedrus.txt
+++ b/Documentation/devicetree/bindings/media/cedrus.txt
@@ -13,6 +13,7 @@ Required properties:
 			- "allwinner,sun8i-h3-video-engine"
 			- "allwinner,sun50i-a64-video-engine"
 			- "allwinner,sun50i-h5-video-engine"
+			- "allwinner,sun50i-h6-video-engine"
 - reg			: register base and length of VE;
 - clocks		: list of clock specifiers, corresponding to entries in
 			  the clock-names property;
--=20
2.20.1

