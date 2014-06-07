Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60437 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaFGV5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:02 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so3811289pdi.13
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:01 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 02/43] ARM: dts: imx6qdl: Add ipu aliases
Date: Sat,  7 Jun 2014 14:56:04 -0700
Message-Id: <1402178205-22697-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ipu0 (and ipu1 for quad) aliases to ipu1/ipu2 nodes respectively.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6q.dtsi   |    1 +
 arch/arm/boot/dts/imx6qdl.dtsi |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index addd3f8..c7544f0 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -15,6 +15,7 @@
 / {
 	aliases {
 		spi4 = &ecspi5;
+		ipu1 = &ipu2;
 	};
 
 	cpus {
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index eca0971..04c978c 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -43,6 +43,7 @@
 		spi3 = &ecspi4;
 		usbphy0 = &usbphy1;
 		usbphy1 = &usbphy2;
+		ipu0 = &ipu1;
 	};
 
 	intc: interrupt-controller@00a01000 {
-- 
1.7.9.5

