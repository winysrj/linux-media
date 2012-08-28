Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48414 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2H1KyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 14/14] ARM i.MX5: Add CODA7 to device tree for i.MX51 and i.MX53
Date: Tue, 28 Aug 2012 12:54:01 +0200
Message-Id: <1346151241-10449-15-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx51.dtsi |    6 ++++++
 arch/arm/boot/dts/imx53.dtsi |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/imx51.dtsi b/arch/arm/boot/dts/imx51.dtsi
index aba28dc..8f38d83 100644
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -278,6 +278,12 @@
 				interrupts = <87>;
 				status = "disabled";
 			};
+
+			vpu@83ff4000 {
+				compatible = "fsl,imx51-vpu";
+				reg = <0x83ff4000 0x1000>;
+				interrupts = <9>;
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index cd37165..4cf59e5 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -336,6 +336,12 @@
 				interrupts = <87>;
 				status = "disabled";
 			};
+
+			vpu@63ff4000 {
+				compatible = "fsl,imx53-vpu";
+				reg = <0x63ff4000 0x1000>;
+				interrupts = <9>;
+			};
 		};
 	};
 };
-- 
1.7.10.4

