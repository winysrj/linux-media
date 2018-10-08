Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbeJHUfW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 16:35:22 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH v10 5/5] dt-bindings: media: Document bindings for venus firmware device
Date: Mon,  8 Oct 2018 18:53:02 +0530
Message-Id: <1539004982-32555-6-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1539004982-32555-1-git-send-email-vgarodia@codeaurora.org>
References: <1539004982-32555-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add devicetree binding documentation for firmware loader for video
hardware running on qualcomm chip.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/qcom,venus.txt | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
index 00d0d1b..7e04586 100644
--- a/Documentation/devicetree/bindings/media/qcom,venus.txt
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -53,7 +53,7 @@
 
 * Subnodes
 The Venus video-codec node must contain two subnodes representing
-video-decoder and video-encoder.
+video-decoder and video-encoder, and one optional firmware subnode.
 
 Every of video-encoder or video-decoder subnode should have:
 
@@ -79,6 +79,13 @@ Every of video-encoder or video-decoder subnode should have:
 		    power domain which is responsible for collapsing
 		    and restoring power to the subcore.
 
+The firmware subnode must have:
+
+- iommus:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
+
 * An Example
 	video-codec@1d00000 {
 		compatible = "qcom,msm8916-venus";
@@ -105,4 +112,8 @@ Every of video-encoder or video-decoder subnode should have:
 			clock-names = "core";
 			power-domains = <&mmcc VENUS_CORE1_GDSC>;
 		};
+
+		video-firmware {
+			iommus = <&apps_iommu 0x10b2 0x0>;
+		};
 	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
