Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3675 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaHDJTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 05:19:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 1/2] DocBook media: fix fieldname in struct v4l2_subdev_selection
Date: Mon,  4 Aug 2014 11:19:02 +0200
Message-Id: <1407143943-4557-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Field 'rect' is really named 'r'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index 1ba9e99..c62a736 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -119,7 +119,7 @@
 	  </row>
 	  <row>
 	    <entry>&v4l2-rect;</entry>
-	    <entry><structfield>rect</structfield></entry>
+	    <entry><structfield>r</structfield></entry>
 	    <entry>Selection rectangle, in pixels.</entry>
 	  </row>
 	  <row>
-- 
2.0.1

