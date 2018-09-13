Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41355 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730617AbeIMTJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:09:42 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, slongerbeam@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/3] dt-bindings: media: renesas-ceu: Add more endpoint properties
Date: Thu, 13 Sep 2018 15:59:50 +0200
Message-Id: <1536847191-17175-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1536847191-17175-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1536847191-17175-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the v4l2-fwnode framework now allows specifying defaults configurations,
expand the description of the optional endpoint properties for the CEU
interface to better explain which are their defaults values.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/renesas,ceu.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
index 23e91106..3e2a265 100644
--- a/Documentation/devicetree/bindings/media/renesas,ceu.txt
+++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
@@ -26,6 +26,10 @@ the above mentioned "video-interfaces.txt" file are supported.
   default is active high.
 - vsync-active: See [1] for description. If property is not present,
   default is active high.
+- bus-width: See [1] for description. Accepted values are '8' and '16'.
+  If property is not present, default is '8'.
+- field-even-active: See [1] for description. If property is not present,
+  an even field is identified by a logic 0 (active-low signal).

 Example:

--
2.7.4
