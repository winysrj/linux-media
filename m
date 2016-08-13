Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43616 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbcHMNSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 09:18:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D530118026F
	for <linux-media@vger.kernel.org>; Sat, 13 Aug 2016 15:17:04 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] vidioc-g-dv-timings.rst: document the v4l2_bt_timings
 reserved field
Message-ID: <00837cf9-22db-7888-b82c-380b9013bf3b@xs4all.nl>
Date: Sat, 13 Aug 2016 15:17:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This field was never documented, and neither was it mentioned that
it should be zeroed by the application.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
v1 of this patch was for the old DocBook documentation and was never merged,
so update the patch for the new sphinx documentation.
---
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index f7bf21f..955e5e9 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -219,6 +219,14 @@ EBUSY
        -  Several flags giving more information about the format. See
 	  :ref:`dv-bt-flags` for a description of the flags.

+    -  .. row 17
+
+       -  __u32
+
+       -  ``reserved[14]``
+
+       -  Reserved for future extensions. Drivers and applications must set
+          the array to zero.


 .. _v4l2-dv-timings:
