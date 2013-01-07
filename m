Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47636 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3AGU2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 15:28:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] DocBook: media: struct v4l2_capability card field is a UTF-8 string
Date: Mon,  7 Jan 2013 21:30:24 +0100
Message-Id: <1357590624-28567-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct v4l2_capability card field stores the device name. That name
can be hardcoded in drivers, or be retrieved directly from the device.
The later is very common with USB devices. As several devices already
report names that include non-ASCII characters, update the field
description to use UTF-8.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-querycap.xml          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 4c70215..d5a3c97 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -76,7 +76,7 @@ make sure the strings are properly NUL-terminated.</para></entry>
 	  <row>
 	    <entry>__u8</entry>
 	    <entry><structfield>card</structfield>[32]</entry>
-	    <entry>Name of the device, a NUL-terminated ASCII string.
+	    <entry>Name of the device, a NUL-terminated UTF-8 string.
 For example: "Yoyodyne TV/FM". One driver may support different brands
 or models of video hardware. This information is intended for users,
 for example in a menu of available devices. Since multiple TV cards of
-- 
Regards,

Laurent Pinchart

