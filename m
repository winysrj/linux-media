Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:42202 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbcCVK35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 06:29:57 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] vidioc-enum-dv-timings.xml: explicitly state that pad and reserved should be zeroed
Date: Tue, 22 Mar 2016 11:30:28 +0100
Message-Id: <1458642629-15742-3-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
References: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ENUM_DV_TIMINGS documentation did not clearly state that the pad and reserved
fields should be zeroed (pad only when used with a video device node).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
index 6e3cadd..70ca76d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
@@ -61,8 +61,9 @@ of known supported timings. Call &VIDIOC-DV-TIMINGS-CAP; to check if it also sup
 standards or even custom timings that are not in this list.</para>
 
     <para>To query the available timings, applications initialize the
-<structfield>index</structfield> field and zero the reserved array of &v4l2-enum-dv-timings;
-and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl on a video node with a
+<structfield>index</structfield> field, set the <structfield>pad</structfield> field to 0,
+zero the reserved array of &v4l2-enum-dv-timings; and call the
+<constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl on a video node with a
 pointer to this structure. Drivers fill the rest of the structure or return an
 &EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
 applications shall begin at index zero, incrementing by one until the
-- 
2.7.0

