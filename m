Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33427 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933098AbdCaMUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:20:52 -0400
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
Subject: [PATCHv6 08/10] stih-cec.txt: document new hdmi phandle
Date: Fri, 31 Mar 2017 14:20:34 +0200
Message-Id: <20170331122036.55706-9-hverkuil@xs4all.nl>
In-Reply-To: <20170331122036.55706-1-hverkuil@xs4all.nl>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Update the bindings documentation with the new hdmi phandle.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Rob Herring <robh@kernel.org>
CC: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/media/stih-cec.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
index 71c4b2f4bcef..289a08b33651 100644
--- a/Documentation/devicetree/bindings/media/stih-cec.txt
+++ b/Documentation/devicetree/bindings/media/stih-cec.txt
@@ -9,6 +9,7 @@ Required properties:
  - pinctrl-names: Contains only one value - "default"
  - pinctrl-0: Specifies the pin control groups used for CEC hardware.
  - resets: Reference to a reset controller
+ - hdmi-phandle: Phandle to the HDMI controller
 
 Example for STIH407:
 
@@ -22,4 +23,5 @@ sti-cec@094a087c {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_cec0_default>;
 	resets = <&softreset STIH407_LPM_SOFTRESET>;
+	hdmi-phandle = <&hdmi>;
 };
-- 
2.11.0
