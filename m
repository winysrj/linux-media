Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45314 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755869AbdC2OPv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 10:15:51 -0400
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
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: [PATCHv5 09/11] stih-cec.txt: document new hdmi phandle
Date: Wed, 29 Mar 2017 16:15:41 +0200
Message-Id: <20170329141543.32935-10-hverkuil@xs4all.nl>
In-Reply-To: <20170329141543.32935-1-hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
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
