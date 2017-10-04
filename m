Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40340 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751398AbdJDVvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v15 21/32] dt: bindings: Add lens-focus binding for image sensors
Date: Thu,  5 Oct 2017 00:50:40 +0300
Message-Id: <20171004215051.13385-22-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lens-focus property contains a phandle to the lens voice coil driver
that is associated to the sensor; typically both are contained in the same
camera module.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index fdba30479b47..b535bdde861c 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -74,6 +74,8 @@ Optional properties
 - flash-leds: An array of phandles, each referring to a flash LED, a sub-node
   of the LED driver device node.
 
+- lens-focus: A phandle to the node of the focus lens controller.
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.11.0
