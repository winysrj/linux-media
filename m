Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp08.uk.clara.net ([195.8.89.41]:57310 "EHLO
	claranet-outbound-smtp08.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370AbaJaPsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:48:50 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH v2] DocBook media: Clarify V4L2_FIELD_ANY for drivers
Date: Fri, 31 Oct 2014 15:48:42 +0000
Message-Id: <1414770522-22863-1-git-send-email-simon.farnsworth@onelan.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation for enum v4l2_field did not make it clear that V4L2_FIELD_ANY
is only acceptable as input to the kernel, not as a response from the
driver.

Make it clear, to stop userspace developers like me assuming it can be
returned by the driver.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---

Change wording as suggested by Hans. The new wording still makes sense to
me, and leaves it clear that V4L2_FIELD_ANY is not a valid answer from
TRY_FMT.

 Documentation/DocBook/media/v4l/io.xml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index e5e8325..1c17f80 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1422,7 +1422,10 @@ one of the <constant>V4L2_FIELD_NONE</constant>,
 <constant>V4L2_FIELD_BOTTOM</constant>, or
 <constant>V4L2_FIELD_INTERLACED</constant> formats is acceptable.
 Drivers choose depending on hardware capabilities or e.&nbsp;g. the
-requested image size, and return the actual field order. &v4l2-buffer;
+requested image size, and return the actual field order. Drivers must
+never return <constant>V4L2_FIELD_ANY</constant>. If multiple
+field orders are possible the driver must choose one of the possible
+field orders during &VIDIOC-S-FMT; or &VIDIOC-TRY-FMT;. &v4l2-buffer;
 <structfield>field</structfield> can never be
 <constant>V4L2_FIELD_ANY</constant>.</entry>
 	  </row>
-- 
1.9.3

