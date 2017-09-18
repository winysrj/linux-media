Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18847 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752299AbdIRI14 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 04:27:56 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
Subject: [PATCH 2/2] dt: bindings: media: Document data lane numbering without lane reordering
Date: Mon, 18 Sep 2017 11:25:05 +0300
Message-Id: <1505723105-16238-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1505723105-16238-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1505723105-16238-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most devices do not support lane reordering and in many cases the
documentation of the data-lanes property is incomplete for such devices.
Document that in case the lane reordering isn't supported, monotonically
incremented values from 0 or 1 shall be used.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 4e0527d..fc1964e 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -111,7 +111,10 @@ Optional endpoint properties
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
