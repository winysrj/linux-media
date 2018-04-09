Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39680 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbeDIMQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 08:16:51 -0400
In-Reply-To: <20180409121529.GA31403@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v3 7/7] dt-bindings: tda998x: add the calibration gpio
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1f5Vj1-0002Lx-Hz@rmk-PC.armlinux.org.uk>
Date: Mon, 09 Apr 2018 13:16:43 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the optional calibration gpio for integrated TDA9950 CEC support.
This GPIO corresponds with the interrupt from the TDA998x, as the
calibration requires driving the interrupt pin low.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/devicetree/bindings/display/bridge/tda998x.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/bridge/tda998x.txt b/Documentation/devicetree/bindings/display/bridge/tda998x.txt
index 24cc2466185a..1a4eaca40d94 100644
--- a/Documentation/devicetree/bindings/display/bridge/tda998x.txt
+++ b/Documentation/devicetree/bindings/display/bridge/tda998x.txt
@@ -27,6 +27,9 @@ Required properties;
 	in question is used. The implementation allows one or two DAIs. If two
 	DAIs are defined, they must be of different type.
 
+  - nxp,calib-gpios: calibration GPIO, which must correspond with the
+	gpio used for the TDA998x interrupt pin.
+
 [1] Documentation/sound/alsa/soc/DAI.txt
 [2] include/dt-bindings/display/tda998x.h
 
-- 
2.7.4
