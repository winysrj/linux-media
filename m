Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39298 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932328AbdJZHyr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 03:54:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v16 21/32] dt: bindings: Add lens-focus binding for image sensors
Date: Thu, 26 Oct 2017 10:53:31 +0300
Message-Id: <20171026075342.5760-22-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
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
index dc66e3224692..3994b0143dd1 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -83,6 +83,8 @@ Optional properties
 - flash-leds: An array of phandles, each referring to a flash LED, a sub-node
   of the LED driver device node.
 
+- lens-focus: A phandle to the node of the focus lens controller.
+
 
 Optional endpoint properties
 ----------------------------
-- 
2.11.0
