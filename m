Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:61976 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZK0BeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 20:34:25 -0500
Subject: [IR-RFC PATCH v4 5/6] Example of PowerPC device tree support for GPT
	based IR
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
From: Jon Smirl <jonsmirl@gmail.com>
Date: Thu, 26 Nov 2009 20:34:29 -0500
Message-ID: <20091127013429.7671.65302.stgit@terra>
In-Reply-To: <20091127013217.7671.32355.stgit@terra>
References: <20091127013217.7671.32355.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


---
 arch/powerpc/boot/dts/dspeak01.dts |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/boot/dts/dspeak01.dts b/arch/powerpc/boot/dts/dspeak01.dts
index 429bb2f..50cc247 100644
--- a/arch/powerpc/boot/dts/dspeak01.dts
+++ b/arch/powerpc/boot/dts/dspeak01.dts
@@ -131,16 +131,6 @@
 			#gpio-cells = <2>;
 		};
 
-		gpt7: timer@670 { /* General Purpose Timer in GPIO mode */
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			cell-index = <7>;
-			reg = <0x670 0x10>;
-			interrupts = <0x1 0x10 0x0>;
-			interrupt-parent = <&mpc5200_pic>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		rtc@800 {	// Real time clock
 			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
 			device_type = "rtc";
@@ -320,6 +310,14 @@
 			reg = <0x8000 0x4000>;
 		};
 
+		ir0@670 { /* General Purpose Timer 6 in Input mode */
+			compatible = "gpt-ir";
+			cell-index = <7>;
+			reg = <0x670 0x10>;
+			interrupts = <0x1 0x10 0x0>;
+			interrupt-parent = <&mpc5200_pic>;
+		};
+
 		/* This is only an example device to show the usage of gpios. It maps all available
 		 * gpios to the "gpio-provider" device.
 		 */
@@ -335,7 +333,6 @@
 				 &gpt3		0 0 /* timer3		13d		x6-4	   */
 				 &gpt4		0 0 /* timer4		61c		x2-16	   */
 				 &gpt6		0 0 /* timer6		60c		x8-15	   */
-				 &gpt7		0 0 /* timer7		36a		x17-9	   */
 				 >;
 		};
 	};

