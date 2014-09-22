Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42348 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIVPX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:23:27 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v6 5/6] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Mon, 22 Sep 2014 17:22:55 +0200
Message-id: <1411399376-16497-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1411399376-16497-1-git-send-email-j.anaszewski@samsung.com>
References: <1411399376-16497-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use "skyworks" as the vendor prefix for the
Skyworks Solutions, Inc.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..9d5b3f6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -117,6 +117,7 @@ renesas	Renesas Electronics Corporation
 ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
+skyworks	Skyworks Solutions, Inc.
 sbs	Smart Battery System
 schindler	Schindler
 seagate	Seagate Technology PLC
-- 
1.7.9.5

