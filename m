Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:30690 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2INK56 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:58 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBn013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:57 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 18/31] DocBook: Mark CROPCAP as optional instead of as compulsory.
Date: Fri, 14 Sep 2012 12:57:33 +0200
Message-Id: <79f0c1953430028885661869b696f01bff8d0c40.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the documentation says that VIDIOC_CROPCAP is compulsory for
all video capture and output devices, in practice VIDIOC_CROPCAP is
only implemented for devices that can do cropping and/or scaling.

Update the documentation to no longer require VIDIOC_CROPCAP if the
driver does not support cropping or scaling or non-square pixels.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
index 4559c45..bf7cc97 100644
--- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
@@ -59,6 +59,9 @@ constant except when switching the video standard. Remember this
 switch can occur implicit when switching the video input or
 output.</para>
 
+    <para>This ioctl must be implemented for video capture or output devices that
+support cropping and/or scaling and/or have non-square pixels, and for overlay devices.</para>
+
     <table pgwide="1" frame="none" id="v4l2-cropcap">
       <title>struct <structname>v4l2_cropcap</structname></title>
       <tgroup cols="3">
@@ -70,7 +73,9 @@ output.</para>
 	    <entry>Type of the data stream, set by the application.
 Only these types are valid here:
 <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> and
+<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>,
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant> and
 <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>. See <xref linkend="v4l2-buf-type" />.</entry>
 	  </row>
 	  <row>
@@ -154,8 +159,7 @@ on 22 Oct 2002 subject "Re:[V4L][patches!] Re:v4l2/kernel-2.5" -->
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-cropcap; <structfield>type</structfield> is
-invalid. This is not permitted for video capture, output and overlay devices,
-which must support <constant>VIDIOC_CROPCAP</constant>.</para>
+invalid.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.7.10.4

