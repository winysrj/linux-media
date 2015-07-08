Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33211 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933677AbbGHIse (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2015 04:48:34 -0400
Message-ID: <559CE38C.4090706@xs4all.nl>
Date: Wed, 08 Jul 2015 10:47:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] DocBook media: fix typo in V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix small typo (missing 'it') in the documentation for
V4L2_CTRL_FLAG_EXECUTE_ON_WRITE.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index dc83ad7..6ec39c6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -616,7 +616,7 @@ pointer to memory containing the payload of the control.</entry>
 	    <entry><constant>V4L2_CTRL_FLAG_EXECUTE_ON_WRITE</constant></entry>
 	    <entry>0x0200</entry>
 	    <entry>The value provided to the control will be propagated to the driver
-even if remains constant. This is required when the control represents an action
+even if it remains constant. This is required when the control represents an action
 on the hardware. For example: clearing an error flag or triggering the flash. All the
 controls of the type <constant>V4L2_CTRL_TYPE_BUTTON</constant> have this flag set.</entry>
 	  </row>
