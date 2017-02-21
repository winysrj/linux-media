Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12776 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752917AbdBUQB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 11:01:29 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rmk+kernel@armlinux.org.uk
Subject: [PATCH 1/1] docs-rst: media: Explicitly refer to sub-sampling in scaling documentation
Date: Tue, 21 Feb 2017 17:59:45 +0200
Message-Id: <1487692785-1016-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Skipping, which is sometimes used in terminology related to sensors when
referring to sub-sampling is replaced by more suitable sub-sampling
instead. Skipping is retained in a note in parentheses.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 3e03dc2..2a5164a 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -284,7 +284,8 @@ Types and flags used to represent the media graph elements
 	  supported scaling ratios is entity-specific and can differ
 	  between the horizontal and vertical directions (in particular
 	  scaling can be supported in one direction only). Binning and
-	  skipping are considered as scaling.
+	  sub-sampling (occasionally also referred to as skipping) are
+	  considered as scaling.
 
     -  ..  row 28
 
-- 
2.7.4
