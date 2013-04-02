Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45247 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860Ab3DBNc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 09:32:26 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Correct clock properties description at the DT
 binding documentation
Date: Tue, 02 Apr 2013 15:32:10 +0200
Message-id: <1364909530-25392-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'camera' DT node needs to have sclk_cam0/1 and pxl_async0/1 clocks
specified, while 'fimc' nodes should have only "fimc" and "sclk_fimc".
"mux" and "parent" are leftovers from early versions of patches adding
DT support, when the IP bus clock parent clock was being set by the
driver. A better solution is needed to have e.g. clocks driver setting
all required parent clocks, before clock consumers start using the
clocks. Currently this binding doesn't describe the parent clocks setup,
it needs to be specified and handled somewhere else.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 2a63ddd..51c776b 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -17,9 +17,9 @@ Required properties:

 - compatible	: must be "samsung,fimc", "simple-bus"
 - clocks	: list of clock specifiers, corresponding to entries in
-		  clock-names property;
-- clock-names	: must contain "fimc", "sclk_fimc" entries, matching entries
-		  in the clocks property.
+		  the clock-names property;
+- clock-names	: must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
+		  "pxl_async1" entries, matching entries in the clocks property.

 The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
 to define a required pinctrl state named "default" and optional pinctrl states:
@@ -32,7 +32,6 @@ way around.

 The 'camera' node must include at least one 'fimc' child node.

-
 'fimc' device nodes
 -------------------

@@ -44,8 +43,7 @@ Required properties:
 - interrupts: should contain FIMC interrupt;
 - clocks: list of clock specifiers, must contain an entry for each required
   entry in clock-names;
-- clock-names: must include "fimc", "sclk_fimc", "mux" entries and optionally
-  "parent" entry.
+- clock-names: must contain "fimc", "sclk_fimc" entries.
 - samsung,pix-limits: an array of maximum supported image sizes in pixels, for
   details refer to Table 2-1 in the S5PV210 SoC User Manual; The meaning of
   each cell is as follows:
--
1.7.9.5

