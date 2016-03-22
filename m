Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:31452 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbcCVK34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 06:29:56 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] vidioc-dv-timings-cap.xml: explicitly state that pad and reserved should be zeroed
Date: Tue, 22 Mar 2016 11:30:29 +0100
Message-Id: <1458642629-15742-4-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
References: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DV_TIMINGS_CAP documentation didn't state clearly that the pad and
reserved fields should be zeroed by the application. For subdev pad can
be other values as well.

It also mistakenly said that only drivers would have to zero the reserved
field, that's not correct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
index a2017bf..b6f47a6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
@@ -55,8 +55,9 @@
       interface and may change in the future.</para>
     </note>
 
-    <para>To query the capabilities of the DV receiver/transmitter applications
-can call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl on a video node
+    <para>To query the capabilities of the DV receiver/transmitter applications initialize the
+<structfield>pad</structfield> field to 0, zero the reserved array of &v4l2-dv-timings-cap;
+and call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl on a video node
 and the driver will fill in the structure. Note that drivers may return
 different values after switching the video input or output.</para>
 
@@ -65,8 +66,8 @@ queried by calling the <constant>VIDIOC_SUBDEV_DV_TIMINGS_CAP</constant> ioctl
 directly on a subdevice node. The capabilities are specific to inputs (for DV
 receivers) or outputs (for DV transmitters), applications must specify the
 desired pad number in the &v4l2-dv-timings-cap; <structfield>pad</structfield>
-field. Attempts to query capabilities on a pad that doesn't support them will
-return an &EINVAL;.</para>
+field and zero the <structfield>reserved</structfield> array. Attempts to query
+capabilities on a pad that doesn't support them will return an &EINVAL;.</para>
 
     <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
       <title>struct <structname>v4l2_bt_timings_cap</structname></title>
@@ -145,7 +146,8 @@ return an &EINVAL;.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[2]</entry>
-	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
+	    <entry>Reserved for future extensions. Drivers and applications must
+	    set the array to zero.</entry>
 	  </row>
 	  <row>
 	    <entry>union</entry>
-- 
2.7.0

