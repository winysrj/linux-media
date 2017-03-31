Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33427 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932932AbdCaMUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:20:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Patrice.chotard@st.com, Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: [PATCHv6 05/10] s5p-cec.txt: document the HDMI controller phandle
Date: Fri, 31 Mar 2017 14:20:31 +0200
Message-Id: <20170331122036.55706-6-hverkuil@xs4all.nl>
In-Reply-To: <20170331122036.55706-1-hverkuil@xs4all.nl>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the bindings documenting the new hdmi phandle.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
CC: linux-samsung-soc@vger.kernel.org
CC: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/media/s5p-cec.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
index 925ab4d72eaa..4bb08d9d940b 100644
--- a/Documentation/devicetree/bindings/media/s5p-cec.txt
+++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
@@ -15,6 +15,7 @@ Required properties:
   - clock-names : from common clock binding: must contain "hdmicec",
 		  corresponding to entry in the clocks property.
   - samsung,syscon-phandle - phandle to the PMU system controller
+  - hdmi-phandle - phandle to the HDMI controller
 
 Example:
 
@@ -25,6 +26,7 @@ hdmicec: cec@100B0000 {
 	clocks = <&clock CLK_HDMI_CEC>;
 	clock-names = "hdmicec";
 	samsung,syscon-phandle = <&pmu_system_controller>;
+	hdmi-phandle = <&hdmi>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&hdmi_cec>;
 	status = "okay";
-- 
2.11.0
