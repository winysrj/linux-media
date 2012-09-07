Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2218 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab2IGN3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 04/28] DocBook: make the G/S/TRY_FMT specification more strict.
Date: Fri,  7 Sep 2012 15:29:04 +0200
Message-Id: <5c449812e54fff0816282e712ab9e24c8b278cb6.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- S/TRY_FMT should always succeed, unless an invalid type field is passed in.
- TRY_FMT should give the same result as S_FMT, all other things being equal.
- ENUMFMT may return different formats for different inputs or outputs.

This was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml |    3 +++
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml    |    9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
index 81ebe48..0bd3324 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
@@ -58,6 +58,9 @@ structure. Drivers fill the rest of the structure or return an
 incrementing by one until <errorcode>EINVAL</errorcode> is
 returned.</para>
 
+    <para>Note that after switching input or output the list of enumerated image
+formats may be different.</para>
+
     <table pgwide="1" frame="none" id="v4l2-fmtdesc">
       <title>struct <structname>v4l2_fmtdesc</structname></title>
       <tgroup cols="3">
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
index 52acff1..9ef279a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
@@ -81,7 +81,7 @@ the application calls the <constant>VIDIOC_S_FMT</constant> ioctl
 with a pointer to a <structname>v4l2_format</structname> structure
 the driver checks
 and adjusts the parameters against hardware abilities. Drivers
-should not return an error code unless the input is ambiguous, this is
+should not return an error code unless the <structfield>type</structfield> field is invalid, this is
 a mechanism to fathom device capabilities and to approach parameters
 acceptable for both the application and driver. On success the driver
 may program the hardware, allocate resources and generally prepare for
@@ -107,6 +107,10 @@ disabling I/O or possibly time consuming hardware preparations.
 Although strongly recommended drivers are not required to implement
 this ioctl.</para>
 
+    <para>The format as returned by <constant>VIDIOC_TRY_FMT</constant>
+must be identical to what <constant>VIDIOC_S_FMT</constant> returns for
+the same input or output.</para>
+
     <table pgwide="1" frame="none" id="v4l2-format">
       <title>struct <structname>v4l2_format</structname></title>
       <tgroup cols="4">
@@ -187,8 +191,7 @@ capture and output devices.</entry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-format; <structfield>type</structfield>
-field is invalid, the requested buffer type not supported, or the
-format is not supported with this buffer type.</para>
+field is invalia or the requested buffer type not supported.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.7.10.4

