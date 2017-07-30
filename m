Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59935 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751002AbdG3NHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:07:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] arm: dts: qcom: add cec clock for apq8016 board
Date: Sun, 30 Jul 2017 15:07:41 +0200
Message-Id: <20170730130743.19681-3-hverkuil@xs4all.nl>
In-Reply-To: <20170730130743.19681-1-hverkuil@xs4all.nl>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The adv7533 on this board needs a cec clock. Hook it up in the dtsi
to enable CEC for the HDMI transmitters.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
index eb513d625562..475d92d165ca 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -88,6 +88,8 @@
 				interrupts = <31 2>;
 
 				adi,dsi-lanes = <4>;
+				clocks = <&rpmcc RPM_SMD_BB_CLK2>;
+				clock-names = "cec";
 
 				pd-gpios = <&msmgpio 32 0>;
 
-- 
2.13.1
