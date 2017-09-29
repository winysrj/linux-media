Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59381 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdI2I0i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 04:26:38 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH v3 2/2] dt: bindings: media: Document data lane numbering without lane reordering
Date: Fri, 29 Sep 2017 11:23:41 +0300
Message-Id: <1506673421-6085-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1506673421-6085-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1506673421-6085-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most devices do not support lane reordering and in many cases the
documentation of the data-lanes property is incomplete for such devices.
Document that in case the lane reordering isn't supported, monotonically
incremented values from 0 or 1 shall be used.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index bc8f18fb..bd64749 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -108,7 +108,10 @@ Optional endpoint properties
   determines the logical lane number, while the value of an entry indicates
   physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
   "data-lanes = <1 2>;", assuming the clock lane is on hardware lane 0.
-  This property is valid for serial busses only (e.g. MIPI CSI-2).
+  If the hardware does not support lane reordering, monotonically
+  incremented values shall be used from 0 or 1 onwards, depending on
+  whether or not there is also a clock lane. This property is valid for
+  serial busses only (e.g. MIPI CSI-2).
 - clock-lanes: an array of physical clock lane indexes. Position of an entry
   determines the logical lane number, while the value of an entry indicates
   physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes = <0>;",
-- 
2.7.4
