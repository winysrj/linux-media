Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49875 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730617AbeIMTJk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:09:40 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, slongerbeam@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/3] dt-bindings: media: renesas-ceu: Refer to video-interfaces.txt
Date: Thu, 13 Sep 2018 15:59:49 +0200
Message-Id: <1536847191-17175-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1536847191-17175-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1536847191-17175-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refer to video-interfaces.txt when describing standard properties.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/renesas,ceu.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
index 8a7a616..23e91106 100644
--- a/Documentation/devicetree/bindings/media/renesas,ceu.txt
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
@@ -17,15 +17,15 @@ Required properties:
 The CEU supports a single parallel input and should contain a single 'port'
 subnode with a single 'endpoint'. Connection to input devices are modeled
 according to the video interfaces OF bindings specified in:
-Documentation/devicetree/bindings/media/video-interfaces.txt
+[1] Documentation/devicetree/bindings/media/video-interfaces.txt
 
 Optional endpoint properties applicable to parallel input bus described in
 the above mentioned "video-interfaces.txt" file are supported.
 
-- hsync-active: Active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
-  If property is not present, default is active high.
-- vsync-active: Active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
-  If property is not present, default is active high.
+- hsync-active: See [1] for description. If property is not present,
+  default is active high.
+- vsync-active: See [1] for description. If property is not present,
+  default is active high.
 
 Example:
 
-- 
2.7.4
