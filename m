Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52894 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750944AbdHRM67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 08:58:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, robh@kernel.org,
        jacek.anaszewski@gmail.com
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/1] dt: bindings: Add a binding for flash devices associated to a sensor
Date: Fri, 18 Aug 2017 15:58:57 +0300
Message-Id: <20170818125857.13430-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera flash drivers (and LEDs) are separate from the sensor devices in
DT. In order to make an association between the two, provide the
association information to the software.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Rob and Jacek, others,

I know I've submitted previous versions of this patch that I have changed
since getting your acks... that's bad. I realised there will be problems
due to the vague referencing in the old version.

Instead of referring to the flash LED controller itself, the references are
now suggested to be made to the LEDs explicitly.

While most of the time all LEDs are associated to the same camera sensor,
there's nothing that suggests that this will always be the case. This will
work rather nicely with this change to the V4L2 flash class:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=flash&id=ef62781f4468d93ba8328caf7db629add453e01d>

An alternative to this could be to refer to the LEDs using the LED
controller node and integer arguments. That would require e.g. #led-cells
property to tell how many arguments there are. The actual LEDs also have
device nodes already so I thought using them would probably be a good idea
so we continue to have a single way to refer to LEDs.

Let me know your thoughts / if you're ok with the patch.

 Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 852041a7480c..fee73cf2a714 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -67,6 +67,14 @@ are required in a relevant parent node:
 		    identifier, should be 1.
  - #size-cells    : should be zero.
 
+
+Optional properties
+-------------------
+
+- flash: An array of phandles referring to the flash LED, a sub-node
+  of the LED driver device node.
+
+
 Optional endpoint properties
 ----------------------------
 
-- 
2.11.0
