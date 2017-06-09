Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45202 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdFINY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 09:24:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
Subject: [PATCH v2 2/2] v4l: controls: Improve documentation for V4L2_CID_GAIN
Date: Fri,  9 Jun 2017 16:21:47 +0300
Message-Id: <1497014507-1835-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497014507-1835-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497014507-1835-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Elaborate the differences between V4L2_CID_GAIN and gain-type specific
V4L2_CID_DIGITAL_GAIN and V4L2_CID_ANALOGUE_GAIN.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/control.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
index 51112ba..c1e6adb 100644
--- a/Documentation/media/uapi/v4l/control.rst
+++ b/Documentation/media/uapi/v4l/control.rst
@@ -137,6 +137,12 @@ Control IDs
 ``V4L2_CID_GAIN`` ``(integer)``
     Gain control.
 
+    Primarily used to control gain on e.g. TV tuners but also on
+    webcams. Most devices control only digital gain with this control
+    but on some this could include analogue gain as well. Devices that
+    recognise the difference between digital and analogue gain use
+    controls ``V4L2_CID_DIGITAL_GAIN`` and ``V4L2_CID_ANALOGUE_GAIN``.
+
 ``V4L2_CID_HFLIP`` ``(boolean)``
     Mirror the picture horizontally.
 
-- 
2.7.4
