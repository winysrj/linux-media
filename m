Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34173 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbcGFXLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:11:25 -0400
Received: by mail-pa0-f67.google.com with SMTP id us13so104020pab.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:11:24 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 27/28] ARM: dts: imx6qdl: add mem2mem devices
Date: Wed,  6 Jul 2016 16:11:16 -0700
Message-Id: <1467846677-13265-1-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables ipu-mem2mem devices on imx6qdl.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6q.dtsi   | 7 +++++++
 arch/arm/boot/dts/imx6qdl.dtsi | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 9b9fc91..b81d262 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -204,6 +204,13 @@
 				};
 			};
 		};
+
+
+		ipum2m1: ipum2m@ipu2 {
+			compatible = "fsl,imx-video-mem2mem";
+			ipu = <&ipu2>;
+			status = "okay";
+		};
 	};
 
 	display-subsystem {
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 838d1d5..ec0be0e 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1288,5 +1288,11 @@
 				};
 			};
 		};
+
+		ipum2m0: ipum2m@ipu1 {
+			compatible = "fsl,imx-video-mem2mem";
+			ipu = <&ipu1>;
+			status = "okay";
+		};
 	};
 };
-- 
1.9.1

