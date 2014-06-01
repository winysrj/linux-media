Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59653 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaFADjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 02/18] DocBook: media: Document ALPHA_COMPONENT control usage on output devices
Date: Sun,  1 Jun 2014 05:39:21 +0200
Message-Id: <1401593977-30660-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the V4L2_CID_ALPHA_COMPONENT control for use on output devices,
to set the alpha component value when the output format doesn't have an
alpha channel.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 47198ee..4dfea27 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -398,14 +398,17 @@ to work.</entry>
 	  <row id="v4l2-alpha-component">
 	    <entry><constant>V4L2_CID_ALPHA_COMPONENT</constant></entry>
 	    <entry>integer</entry>
-	    <entry> Sets the alpha color component on the capture device or on
-	    the capture buffer queue of a mem-to-mem device. When a mem-to-mem
-	    device produces frame format that includes an alpha component
+	    <entry>Sets the alpha color component. When a capture device (or
+	    capture queue of a mem-to-mem device) produces a frame format that
+	    includes an alpha component
 	    (e.g. <link linkend="rgb-formats">packed RGB image formats</link>)
-	    and the alpha value is not defined by the mem-to-mem input data
-	    this control lets you select the alpha component value of all
-	    pixels. It is applicable to any pixel format that contains an alpha
-	    component.
+	    and the alpha value is not defined by the device or the mem-to-mem
+	    input data this control lets you select the alpha component value of
+	    all pixels. When an output device (or output queue of a mem-to-mem
+	    device) consumes a frame format that doesn't include an alpha
+	    component and the device supports alpha channel processing this
+	    control lets you set the alpha component value of all pixels for
+	    further processing in the device.
 	    </entry>
 	  </row>
 	  <row>
-- 
1.8.5.5

