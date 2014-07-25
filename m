Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61172 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969AbaGYOVN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:21:13 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 1/9] [media] s5p-jpeg: Document sclk-jpeg clock for
 Exynos3250 SoC
Date: Fri, 25 Jul 2014 16:20:45 +0200
Message-id: <1406298053-30184-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
References: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacek Anaszewski <j.anaszewski@samsung.com>

JPEG IP on Exynos3250 SoC requires enabling two clock gates
for its operation. This patch documents this requirement.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org
---
 .../bindings/media/exynos-jpeg-codec.txt           |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
index 937b755..bf52ed4 100644
--- a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
+++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
@@ -3,9 +3,13 @@ Samsung S5P/EXYNOS SoC series JPEG codec
 Required properties:

 - compatible	: should be one of:
-		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg";
+		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg",
+		  "samsung,exynos3250-jpeg";
 - reg		: address and length of the JPEG codec IP register set;
 - interrupts	: specifies the JPEG codec IP interrupt;
-- clocks	: should contain the JPEG codec IP gate clock specifier, from the
-		  common clock bindings;
-- clock-names	: should contain "jpeg" entry.
+- clock-names   : should contain:
+		   - "jpeg" for the core gate clock,
+		   - "sclk" for the special clock (optional).
+- clocks	: should contain the clock specifier and clock ID list
+		  matching entries in the clock-names property; from
+		  the common clock bindings.
--
1.7.9.5

