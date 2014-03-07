Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3782 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaCGO0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:26:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/5] DocBook media: fix broken FIELD_ALTERNATE description.
Date: Fri,  7 Mar 2014 15:26:23 +0100
Message-Id: <1394202384-5762-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
References: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The sizeimage is that of a single field, not that of a full frame.
That makes no sense, and in fact all drivers supporting ALTERNATE will
set sizeimage to that of a field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 0a5d8c6..97a69bf 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1470,10 +1470,9 @@ or application, depending on data direction, must set &v4l2-buffer;
 <constant>V4L2_FIELD_BOTTOM</constant>. Any two successive fields pair
 to build a frame. If fields are successive, without any dropped fields
 between them (fields can drop individually), can be determined from
-the &v4l2-buffer; <structfield>sequence</structfield> field. Image
-sizes refer to the frame, not fields. This format cannot be selected
-when using the read/write I/O method.<!-- Where it's indistinguishable
-from V4L2_FIELD_SEQ_*. --></entry>
+the &v4l2-buffer; <structfield>sequence</structfield> field. This format
+cannot be selected when using the read/write I/O method since there
+is no way to communicate if a field was a top or bottom field.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_FIELD_INTERLACED_TB</constant></entry>
-- 
1.9.0

