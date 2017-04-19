Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59079
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762403AbdDSLFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:05:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] [media] pixfmt-meta-vsp1-hgo.rst: remove spurious '-'
Date: Wed, 19 Apr 2017 08:04:30 -0300
Message-Id: <242b0c4cc96f97d0a3b96343acd21613b63fa4a6.1492599862.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove spurious '-' in the VSP1 hgo table.

This resulted in a weird dot character that also caused
the row to be double-height.

We used to have it on other tables, but we got rid of them
on changeset 8ed29e302dd1 ("[media] subdev-formats.rst: remove
spurious '-'").

Fixes: 14d665387165 ("[media] v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
index 8d37bb313493..67796594fd48 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
@@ -53,19 +53,19 @@ contains one byte.
       - [15:8]
       - [7:0]
     * - 0
-      - -
+      -
       - R/Cr/H max [7:0]
-      - -
+      -
       - R/Cr/H min [7:0]
     * - 4
-      - -
+      -
       - G/Y/S max [7:0]
-      - -
+      -
       - G/Y/S min [7:0]
     * - 8
-      - -
+      -
       - B/Cb/V max [7:0]
-      - -
+      -
       - B/Cb/V min [7:0]
     * - 12
       - :cspan:`4` R/Cr/H sum [31:0]
@@ -104,9 +104,9 @@ contains one byte.
       - [15:8]
       - [7:0]
     * - 0
-      - -
+      -
       - max(R,G,B) max [7:0]
-      - -
+      -
       - max(R,G,B) min [7:0]
     * - 4
       - :cspan:`4` max(R,G,B) sum [31:0]
@@ -129,9 +129,9 @@ contains one byte.
       - [15:8]
       - [7:0]
     * - 0
-      - -
+      -
       - Y max [7:0]
-      - -
+      -
       - Y min [7:0]
     * - 4
       - :cspan:`4` Y sum [31:0]
@@ -154,9 +154,9 @@ contains one byte.
       - [15:8]
       - [7:0]
     * - 0
-      - -
+      -
       - max(R,G,B) max [7:0]
-      - -
+      -
       - max(R,G,B) min [7:0]
     * - 4
       - :cspan:`4` max(R,G,B) sum [31:0]
-- 
2.9.3
