Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:56513 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbeENL2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:28:12 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 1/5] media: docs: selection: fix typos
Date: Mon, 14 May 2018 13:27:23 +0200
Message-Id: <1526297247-20881-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typos in the selection documentation:
 - over -> cover
 - BONDS -> BOUNDS

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>

---

Changed v1 -> v2:
 - add a commit message (Hans)
---
 Documentation/media/uapi/v4l/selection-api-004.rst | 2 +-
 Documentation/media/uapi/v4l/selection.svg         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/selection-api-004.rst b/Documentation/media/uapi/v4l/selection-api-004.rst
index d782cd5b2117..0a4ddc2d71db 100644
--- a/Documentation/media/uapi/v4l/selection-api-004.rst
+++ b/Documentation/media/uapi/v4l/selection-api-004.rst
@@ -41,7 +41,7 @@ The driver may further adjust the requested size and/or position
 according to hardware limitations.
 
 Each capture device has a default source rectangle, given by the
-``V4L2_SEL_TGT_CROP_DEFAULT`` target. This rectangle shall over what the
+``V4L2_SEL_TGT_CROP_DEFAULT`` target. This rectangle shall cover what the
 driver writer considers the complete picture. Drivers shall set the
 active crop rectangle to the default when the driver is first loaded,
 but not later.
diff --git a/Documentation/media/uapi/v4l/selection.svg b/Documentation/media/uapi/v4l/selection.svg
index a93e3b59786d..911062bd2844 100644
--- a/Documentation/media/uapi/v4l/selection.svg
+++ b/Documentation/media/uapi/v4l/selection.svg
@@ -1128,11 +1128,11 @@
    </text>
   </g>
   <text transform="matrix(.96106 0 0 1.0405 48.571 195.53)" x="2438.062" y="1368.429" enable-background="new" font-size="50" style="line-height:125%">
-   <tspan x="2438.062" y="1368.429">COMPOSE_BONDS</tspan>
+   <tspan x="2438.062" y="1368.429">COMPOSE_BOUNDS</tspan>
   </text>
   <g font-size="40">
    <text transform="translate(48.571 195.53)" x="8.082" y="1438.896" enable-background="new" style="line-height:125%">
-    <tspan x="8.082" y="1438.896" font-size="50">CROP_BONDS</tspan>
+    <tspan x="8.082" y="1438.896" font-size="50">CROP_BOUNDS</tspan>
    </text>
    <text transform="translate(48.571 195.53)" x="1455.443" y="-26.808" enable-background="new" style="line-height:125%">
     <tspan x="1455.443" y="-26.808" font-size="50">overscan area</tspan>
-- 
2.7.4
