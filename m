Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49347 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759814Ab2HXQSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 12:18:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 12/12] ARM i.MX5: Add CODA7 to device tree for i.MX51 and i.MX53
Date: Fri, 24 Aug 2012 18:17:58 +0200
Message-Id: <1345825078-3688-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx51.dtsi |    6 ++++++
 arch/arm/boot/dts/imx53.dtsi |    7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/imx51.dtsi b/arch/arm/boot/dts/imx51.dtsi
index bfa65ab..8e23068 100644
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -274,6 +274,12 @@
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
index e3e8694..108f204 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -329,6 +329,13 @@
 				interrupts = <87>;
 				status = "disabled";
 			};
+
+			vpu@63ff4000 {
+				compatible = "fsl,imx53-vpu";
+				reg = <0x63ff4000 0x1000>;
+				interrupts = <9>;
+				iram = <&iram 0>;
+			};
 		};
 	};
 };
-- 
1.7.10.4

