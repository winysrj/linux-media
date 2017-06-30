Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:57894 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751796AbdF3OfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:35:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Eric Anholt <eric@anholt.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/12] rpi: add cec-gpio support to dts
Date: Fri, 30 Jun 2017 16:35:09 +0200
Message-Id: <20170630143509.56029-13-hverkuil@xs4all.nl>
In-Reply-To: <20170630143509.56029-1-hverkuil@xs4all.nl>
References: <20170630143509.56029-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A simple example of the use of cec-gpio for Raspberry Pi 2B and 3.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/bcm2836-rpi-2-b.dts            | 5 +++++
 arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2836-rpi-2-b.dts b/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
index bf19e8cfb9e6..8cb82a70f33d 100644
--- a/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
+++ b/arch/arm/boot/dts/bcm2836-rpi-2-b.dts
@@ -24,6 +24,11 @@
 			linux,default-trigger = "default-on";
 		};
 	};
+
+	cec-gpio {
+		compatible = "cec-gpio";
+		gpio = <&gpio 4 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &gpio {
diff --git a/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts b/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
index c309633a1e87..ac753786444c 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
@@ -17,6 +17,11 @@
 			gpios = <&gpio 47 0>;
 		};
 	};
+
+	cec-gpio {
+		compatible = "cec-gpio";
+		gpio = <&gpio 4 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &uart1 {
-- 
2.11.0
