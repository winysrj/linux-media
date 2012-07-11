Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:52088 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2GKLtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 07:49:06 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q6BBn4lH005382
	for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 11:49:04 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.6] Fix DV_TIMINGS_CAP documentation
Date: Wed, 11 Jul 2012 13:48:52 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111348.52223.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the DV_TIMINGS_CAP documentation: part of it was copy-and-paste from
the ENUM_DV_TIMINGS documentation.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
index 6673ce5..cd7720d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
@@ -54,15 +54,9 @@
       interface and may change in the future.</para>
     </note>
 
-    <para>To query the available timings, applications initialize the
-<structfield>index</structfield> field and zero the reserved array of &v4l2-dv-timings-cap;
-and call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl with a pointer to this
-structure. Drivers fill the rest of the structure or return an
-&EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
-applications shall begin at index zero, incrementing by one until the
-driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
-different set of DV timings after switching the video input or
-output.</para>
+    <para>To query the capabilities of the DV receiver/transmitter applications can call
+this ioctl and the driver will fill in the structure. Note that drivers may return
+different values after switching the video input or output.</para>
 
     <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
       <title>struct <structname>v4l2_bt_timings_cap</structname></title>
@@ -115,7 +109,7 @@ output.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[16]</entry>
-	    <entry></entry>
+	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
 	  </row>
 	</tbody>
       </tgroup>
