Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:55380 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933066AbaJaPMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:12:23 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] DocBook media: Clarify V4L2_FIELD_ANY for drivers
Date: Fri, 31 Oct 2014 14:48:28 +0000
Message-Id: <1414766908-24894-1-git-send-email-simon.farnsworth@onelan.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation for enum v4l2_field did not make it clear that V4L2_FIELD_ANY
is only acceptable as input to the kernel, not as a response from the
driver.

Make it clear, to stop userspace developers like me assuming it can be
returned by the driver.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---
 Documentation/DocBook/media/v4l/io.xml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index e5e8325..8918bb2 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1422,7 +1422,10 @@ one of the <constant>V4L2_FIELD_NONE</constant>,
 <constant>V4L2_FIELD_BOTTOM</constant>, or
 <constant>V4L2_FIELD_INTERLACED</constant> formats is acceptable.
 Drivers choose depending on hardware capabilities or e.&nbsp;g. the
-requested image size, and return the actual field order. &v4l2-buffer;
+requested image size, and return the actual field order. If multiple
+field orders are possible the driver must choose one of the possible
+field orders during &VIDIOC-S-FMT; or &VIDIOC-TRY-FMT; and must not
+return V4L2_FIELD_ANY. &v4l2-buffer;
 <structfield>field</structfield> can never be
 <constant>V4L2_FIELD_ANY</constant>.</entry>
 	  </row>
-- 
1.9.3

