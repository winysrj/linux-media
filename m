Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56332 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388091AbeGWOsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:48:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se
Subject: [PATCH 05/21] dt-bindings: media: Specify bus type for MIPI D-PHY, others, explicitly
Date: Mon, 23 Jul 2018 16:46:50 +0300
Message-Id: <20180723134706.15334-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow specifying the bus type explicitly for MIPI D-PHY, parallel and
Bt.656 busses. This is useful for devices that can make use of different
bus types. There are CSI-2 transmitters and receivers but the PHY
selection needs to be made between C-PHY and D-PHY; many devices also
support parallel and Bt.656 interfaces but the means to pass that
information to software wasn't there.

Autodetection (value 0) is removed as an option as the property could be
simply omitted in that case.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index baf9d9756b3c..f884ada0bffc 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -100,10 +100,12 @@ Optional endpoint properties
   slave device (data source) by the master device (data sink). In the master
   mode the data source device is also the source of the synchronization signals.
 - bus-type: data bus type. Possible values are:
-  0 - autodetect based on other properties (MIPI CSI-2 D-PHY, parallel or Bt656)
   1 - MIPI CSI-2 C-PHY
   2 - MIPI CSI1
   3 - CCP2
+  4 - MIPI CSI-2 D-PHY
+  5 - Parallel
+  6 - Bt.656
 - bus-width: number of data lines actively used, valid for the parallel busses.
 - data-shift: on the parallel data busses, if bus-width is used to specify the
   number of data lines, data-shift can be used to specify which data lines are
-- 
2.11.0
