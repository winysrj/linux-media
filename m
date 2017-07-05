Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41972 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752086AbdGEXAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/8] dt: bindings: Explicitly specify bus type
Date: Thu,  6 Jul 2017 02:00:12 +0300
Message-Id: <20170705230019.5461-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

In the vast majority of cases the bus type is known to the driver(s)
since a receiver or transmitter can only support a single one. There
are cases however where different options are possible, or the bus type
cannot be automatically detected.

The existing V4L2 OF support tries to figure out the bus type and
parse the bus parameters based on that. This does not scale too well
as there are multiple serial busses that share common properties.

Some hardware also supports multiple types of busses on the same
interfaces.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reviewed-By: Sebastian Reichel <sre@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 9cd2a369125d..9aa2722b6920 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -76,6 +76,11 @@ Optional endpoint properties
   mode horizontal and vertical synchronization signals are provided to the
   slave device (data source) by the master device (data sink). In the master
   mode the data source device is also the source of the synchronization signals.
+- bus-type: data bus type. Possible values are:
+  0 - autodetect based on other properties (MIPI CSI-2 D-PHY, parallel or Bt656)
+  1 - MIPI CSI-2 C-PHY
+  2 - MIPI CSI1
+  3 - CCP2
 - bus-width: number of data lines actively used, valid for the parallel busses.
 - data-shift: on the parallel data busses, if bus-width is used to specify the
   number of data lines, data-shift can be used to specify which data lines are
-- 
2.11.0
