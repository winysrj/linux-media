Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3156 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3G2MlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/8] DocBook/media/v4l: il_* fields always 0 for progressive formats
Date: Mon, 29 Jul 2013 14:40:57 +0200
Message-Id: <1375101661-6493-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clarify that the il_vfrontporch, il_vsync and il_vbackporch fields must
always be 0 for progressive formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index 7236970..c433657 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -156,19 +156,19 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vfrontporch</structfield></entry>
 	    <entry>Vertical front porch in lines for the even field (aka field 2) of
-	    interlaced field formats.</entry>
+	    interlaced field formats. Must be 0 for progressive formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vsync</structfield></entry>
 	    <entry>Vertical sync length in lines for the even field (aka field 2) of
-	    interlaced field formats.</entry>
+	    interlaced field formats. Must be 0 for progressive formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vbackporch</structfield></entry>
 	    <entry>Vertical back porch in lines for the even field (aka field 2) of
-	    interlaced field formats.</entry>
+	    interlaced field formats. Must be 0 for progressive formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.8.3.2

