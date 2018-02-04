Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57715 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750868AbeBDNkl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 08:40:41 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-types.rst: fix type, small improvements
Message-ID: <e23dc203-bad7-229c-2d91-a6763b4f99ed@xs4all.nl>
Date: Sun, 4 Feb 2018 14:40:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

data conector -> connector

... -> etc.

... looked odd when my browser put the ... by itself on the next line, 'etc.'
is clearer IMHO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: 'data connector' makes no sense. Just 'connector' is fine, I think.
---
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 8d64b0c06ebc..9c1e3d3f590c 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -293,7 +293,7 @@ Types and flags used to represent the media graph elements

        -  ``MEDIA_ENT_F_PROC_VIDEO_STATISTICS``

-       -  Video statistics computation (histogram, 3A, ...). An entity
+       -  Video statistics computation (histogram, 3A, etc.). An entity
 	  capable of statistics computation must have one sink pad and
 	  one source pad. It computes statistics over the frames
 	  received on its sink pad and outputs the statistics data on
@@ -318,8 +318,8 @@ Types and flags used to represent the media graph elements
        - Video interface bridge. A video interface bridge entity must have at
          least one sink pad and at least one source pad. It receives video
          frames on its sink pad from an input video bus of one type (HDMI, eDP,
-         MIPI CSI-2, ...), and outputs them on its source pad to an output
-         video bus of another type (eDP, MIPI CSI-2, parallel, ...).
+         MIPI CSI-2, etc.), and outputs them on its source pad to an output
+         video bus of another type (eDP, MIPI CSI-2, parallel, etc.).

 ..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|

@@ -337,7 +337,7 @@ Types and flags used to represent the media graph elements
        -  ``MEDIA_ENT_FL_DEFAULT``

        -  Default entity for its type. Used to discover the default audio,
-	  VBI and video devices, the default camera sensor, ...
+	  VBI and video devices, the default camera sensor, etc.

     -  .. row 2

@@ -345,7 +345,7 @@ Types and flags used to represent the media graph elements

        -  ``MEDIA_ENT_FL_CONNECTOR``

-       -  The entity represents a data conector
+       -  The entity represents a connector.


 ..  tabularcolumns:: |p{6.5cm}|p{6.0cm}|p{5.0cm}|
