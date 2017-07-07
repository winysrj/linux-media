Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35922 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751816AbdGGOUo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 10:20:44 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] docs-rst: v4l: Fix sink compose selection target documentation
Date: Fri,  7 Jul 2017 17:20:39 +0300
Message-Id: <20170707142039.15954-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rectangle which the sink compose rectangle is related to is documented
to be the source compose bounds rectangle. This is in obvious conflict with
the ground rule of the format propagation (from sink to source). The reason
behind this is that this was always supposed to be the sink compose bounds
rectangle. Fix it.

Fixes: 955f645aea04 ("[media] v4l: Add subdev selections documentation")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/dev-subdev.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index f0e762167730..2205a3abb2a9 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -370,7 +370,7 @@ circumstances. This may also cause the accessed rectangle to be adjusted
 by the driver, depending on the properties of the underlying hardware.
 
 The coordinates to a step always refer to the actual size of the
-previous step. The exception to this rule is the source compose
+previous step. The exception to this rule is the sink compose
 rectangle, which refers to the sink compose bounds rectangle --- if it
 is supported by the hardware.
 
-- 
2.11.0
