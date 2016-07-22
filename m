Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35495 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcGVTJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 15:09:13 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2] [media] Documentation: Fix V4L2_CTRL_FLAG_VOLATILE
Date: Fri, 22 Jul 2016 21:09:06 +0200
Message-Id: <1469214546-27855-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CTRL_FLAG_VOLATILE behaviour when V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
is set was not properly explained.

Also set some hyperlink to ease the Documentation browsing.

Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
Credit-to: Hans Verkuil <hansverk@cisco.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: By Hans Verkuil <hansverk@cisco.com>
-Fix some syntax errors

By Mauro Carvalho Chehab <mchehab@kernel.org>
-Add hyperlinks

 Documentation/media/uapi/v4l/vidioc-queryctrl.rst | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 8d6e61a7284d..22475f484cb3 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -728,10 +728,12 @@ See also the examples in :ref:`control`.
 	  case the hardware calculates the gain value based on the lighting
 	  conditions which can change over time.
 
-	  .. note:: Setting a new value for a volatile control will have no
-	     effect and no ``V4L2_EVENT_CTRL_CH_VALUE`` will be sent, unless
-	     the ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE`` flag (see below) is
-	     also set. Otherwise the new value will just be ignored.
+	  .. note:: Setting a new value for a volatile control will be ignored
+             unless
+             :ref:`V4L2_CTRL_FLAG_EXECUTE_ON_WRITE <FLAG_EXECUTE_ON_WRITE>`
+             is also set.
+             Setting a new value for a volatile control will *never* trigger a
+             :ref:`V4L2_EVENT_CTRL_CH_VALUE <ctrl-changes-flags>` event.
 
     -  .. row 9
 
@@ -747,6 +749,7 @@ See also the examples in :ref:`control`.
 	  payload of the control.
 
     -  .. row 10
+       .. _FLAG_EXECUTE_ON_WRITE:
 
        -  ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE``
 
-- 
2.8.1

