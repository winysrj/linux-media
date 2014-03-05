Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53813 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaCEJVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 04:21:10 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 7/8] of: Document simplified graph binding for single port devices
Date: Wed,  5 Mar 2014 10:20:41 +0100
Message-Id: <1394011242-16783-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For simple devices with only one port, it can be made implicit.
The endpoint node can be a direct child of the device node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/devicetree/bindings/graph.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/graph.txt b/Documentation/devicetree/bindings/graph.txt
index 1a69c07..e496547 100644
--- a/Documentation/devicetree/bindings/graph.txt
+++ b/Documentation/devicetree/bindings/graph.txt
@@ -84,6 +84,14 @@ device {
         };
 };
 
+For devices with only a single port and a single endpoint, this can be further
+simplified by making the port implicit, and adding the endpoint node as a direct
+child of the device node.
+
+device {
+	endpoint { ... };
+};
+
 Links between endpoints
 -----------------------
 
-- 
1.9.0.rc3

