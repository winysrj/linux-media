Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42951 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388566AbeKPA65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 19:58:57 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 11/15] dt-bindings: media: cedrus: Add compatibles for the A64 and H5
Date: Thu, 15 Nov 2018 15:50:09 +0100
Message-Id: <20181115145013.3378-12-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces two new compatibles for the cedrus driver, for the
A64 and H5 platforms.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 Documentation/devicetree/bindings/media/cedrus.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/cedrus.txt b/Documentation/devicetree/bindings/media/cedrus.txt
index a089a0c1ff05..b3c0635dcd0e 100644
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
2.19.1
