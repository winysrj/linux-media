Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:23132 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2INK55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:57 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBj013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:56 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 14/31] DocBook: fix awkward language and fix the documented return value.
Date: Fri, 14 Sep 2012 12:57:29 +0200
Message-Id: <531c334494477b45d1ad035bbec98d11b406d71c.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Video Standard section contains some awkward language. It also wasn't
updated when the error code for unimplemented ioctls changed from EINVAL
to ENOTTY.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml |   30 +++++++++++++---------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index b91d253..08db1cf 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -564,7 +564,7 @@ automatically.</para>
     <para>To query and select the standard used by the current video
 input or output applications call the &VIDIOC-G-STD; and
 &VIDIOC-S-STD; ioctl, respectively. The <emphasis>received</emphasis>
-standard can be sensed with the &VIDIOC-QUERYSTD; ioctl. Note parameter of all these ioctls is a pointer to a &v4l2-std-id; type (a standard set), <emphasis>not</emphasis> an index into the standard enumeration.<footnote>
+standard can be sensed with the &VIDIOC-QUERYSTD; ioctl. Note that the parameter of all these ioctls is a pointer to a &v4l2-std-id; type (a standard set), <emphasis>not</emphasis> an index into the standard enumeration.<footnote>
 	<para>An alternative to the current scheme is to use pointers
 to indices as arguments of <constant>VIDIOC_G_STD</constant> and
 <constant>VIDIOC_S_STD</constant>, the &v4l2-input; and
@@ -588,30 +588,28 @@ switch to a standard by &v4l2-std-id;.</para>
       </footnote> Drivers must implement all video standard ioctls
 when the device has one or more video inputs or outputs.</para>
 
-    <para>Special rules apply to USB cameras where the notion of video
-standards makes little sense. More generally any capture device,
-output devices accordingly, which is <itemizedlist>
+    <para>Special rules apply to devices such as USB cameras where the notion of video
+standards makes little sense. More generally for any capture or output device
+which is: <itemizedlist>
 	<listitem>
 	  <para>incapable of capturing fields or frames at the nominal
 rate of the video standard, or</para>
 	</listitem>
 	<listitem>
-	  <para>where <link linkend="buffer">timestamps</link> refer
-to the instant the field or frame was received by the driver, not the
-capture time, or</para>
-	</listitem>
-	<listitem>
-	  <para>where <link linkend="buffer">sequence numbers</link>
-refer to the frames received by the driver, not the captured
-frames.</para>
+	  <para>that does not support the video standard formats at all.</para>
 	</listitem>
       </itemizedlist> Here the driver shall set the
 <structfield>std</structfield> field of &v4l2-input; and &v4l2-output;
-to zero, the <constant>VIDIOC_G_STD</constant>,
+to zero and the <constant>VIDIOC_G_STD</constant>,
 <constant>VIDIOC_S_STD</constant>,
 <constant>VIDIOC_QUERYSTD</constant> and
 <constant>VIDIOC_ENUMSTD</constant> ioctls shall return the
-&EINVAL;.<footnote>
+&ENOTTY;.<footnote>
+	<para>See <xref linkend="buffer" /> for a rationale.</para>
+	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
+<xref linkend="output-capabilities"/> flags to determine whether the video standard ioctls
+are available for the device.</para>
+&ENOTTY;.<footnote>
 	<para>See <xref linkend="buffer" /> for a rationale. Probably
 even USB cameras follow some well known video standard. It might have
 been better to explicitly indicate elsewhere if a device cannot live
@@ -626,9 +624,9 @@ up to normal expectations, instead of this exception.</para>
 &v4l2-standard; standard;
 
 if (-1 == ioctl (fd, &VIDIOC-G-STD;, &amp;std_id)) {
-	/* Note when VIDIOC_ENUMSTD always returns EINVAL this
+	/* Note when VIDIOC_ENUMSTD always returns ENOTTY this
 	   is no video device or it falls under the USB exception,
-	   and VIDIOC_G_STD returning EINVAL is no error. */
+	   and VIDIOC_G_STD returning ENOTTY is no error. */
 
 	perror ("VIDIOC_G_STD");
 	exit (EXIT_FAILURE);
-- 
1.7.10.4

