Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41503 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751852AbdDNKZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:25:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
Date: Fri, 14 Apr 2017 12:25:05 +0200
Message-Id: <20170414102512.48834-2-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-1-hverkuil@xs4all.nl>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC pin was always pulled up, making it impossible to use it.

Change to PIN_INPUT so it can be used by the new CEC support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/omap4-panda-a4.dts | 2 +-
 arch/arm/boot/dts/omap4-panda-es.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-a4.dts b/arch/arm/boot/dts/omap4-panda-a4.dts
index 78d363177762..f1a6476af371 100644
--- a/arch/arm/boot/dts/omap4-panda-a4.dts
+++ b/arch/arm/boot/dts/omap4-panda-a4.dts
@@ -13,7 +13,7 @@
 /* Pandaboard Rev A4+ have external pullups on SCL & SDA */
 &dss_hdmi_pins {
 	pinctrl-single,pins = <
-		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_cec */
+		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)		/* hdmi_cec.hdmi_cec */
 		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
 		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
 		>;
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 119f8e657edc..940fe4f7c5f6 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -34,7 +34,7 @@
 /* PandaboardES has external pullups on SCL & SDA */
 &dss_hdmi_pins {
 	pinctrl-single,pins = <
-		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_cec */
+		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)		/* hdmi_cec.hdmi_cec */
 		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
 		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
 		>;
-- 
2.11.0
