Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33527 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbcGFXh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:37:26 -0400
Received: by mail-io0-f196.google.com with SMTP id t74so1029217ioi.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:37:02 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 5/6] ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
Date: Wed,  6 Jul 2016 16:36:42 -0700
Message-Id: <1467848203-14007-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pinctrl groups for both GPT input capture channels.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 3f12d74..737bb54 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -456,6 +456,18 @@
 			>;
 		};
 
+		pinctrl_gpt_input_capture0: gptinputcapture0grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT0__GPT_CAPTURE1	0x80000000
+			>;
+		};
+
+		pinctrl_gpt_input_capture1: gptinputcapture1grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT1__GPT_CAPTURE2	0x80000000
+			>;
+		};
+
 		pinctrl_spdif: spdifgrp {
 			fsl,pins = <
 				MX6QDL_PAD_KEY_COL3__SPDIF_IN 0x1b0b0
-- 
1.9.1

