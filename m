Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3381 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2EAJGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 05:06:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] V4L2: Mark the DV Preset API as deprecated.
Date: Tue,  1 May 2012 11:05:52 +0200
Message-Id: <bdf36b3c1ef4796e021ac8d46685c1bc741150bc.1335862609.git.hans.verkuil@cisco.com>
In-Reply-To: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
References: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
References: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The DV Preset API will be phased out in favor of the more flexible DV Timings
API. Mark the preset API accordingly in the header and documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml                 |    6 ++++--
 Documentation/DocBook/media/v4l/compat.xml                 |    4 ++++
 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml     |    6 ++++++
 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml |    4 ++++
 include/linux/videodev2.h                                  |    6 ++++++
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 81b7cf3..4101aeb 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -744,11 +744,13 @@ header can be used to get the timings of the formats in the <xref linkend="cea86
 	</para>
 	</listitem>
 	<listitem>
-	<para>DV Presets: Digital Video (DV) presets. These are IDs representing a
+	<para>DV Presets: Digital Video (DV) presets (<emphasis role="bold">deprecated</emphasis>).
+	These are IDs representing a
 video timing at the input/output. Presets are pre-defined timings implemented
 by the hardware according to video standards. A __u32 data type is used to represent
 a preset unlike the bit mask that is used in &v4l2-std-id; allowing future extensions
-to support as many different presets as needed.</para>
+to support as many different presets as needed. This API is deprecated in favor of the DV Timings
+API.</para>
 	</listitem>
 	</itemizedlist>
 	<para>To enumerate and query the attributes of the DV timings supported by a device,
diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 21424a6..001ecdf 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2571,6 +2571,10 @@ interfaces and should not be implemented in new drivers.</para>
 <xref linkend="extended-controls" />.</para>
         </listitem>
         <listitem>
+	  <para>&VIDIOC-G-DV-PRESET;, &VIDIOC-S-DV-PRESET;, &VIDIOC-ENUM-DV-PRESETS; and
+	  &VIDIOC-QUERY-DV-PRESET; ioctls. Use the DV Timings API (<xref linkend="dv-timings" />).</para>
+        </listitem>
+        <listitem>
 	  <para><constant>VIDIOC_SUBDEV_G_CROP</constant> and
 	  <constant>VIDIOC_SUBDEV_S_CROP</constant> ioctls. Use
 	  <constant>VIDIOC_SUBDEV_G_SELECTION</constant> and
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
index 7940c11..61be9fa 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
@@ -48,6 +48,12 @@
 
   <refsect1>
     <title>Description</title>
+
+    <para>These ioctls are <emphasis role="bold">deprecated</emphasis>.
+    New drivers and applications should use &VIDIOC-G-DV-TIMINGS; and &VIDIOC-S-DV-TIMINGS;
+    instead.
+    </para>
+
     <para>To query and select the current DV preset, applications
 use the <constant>VIDIOC_G_DV_PRESET</constant> and <constant>VIDIOC_S_DV_PRESET</constant>
 ioctls which take a pointer to a &v4l2-dv-preset; type as argument.
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
index 23b17f6..1bc8aeb 100644
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
@@ -49,6 +49,10 @@ input</refpurpose>
   <refsect1>
     <title>Description</title>
 
+    <para>This ioctl is <emphasis role="bold">deprecated</emphasis>.
+    New drivers and applications should use &VIDIOC-QUERY-DV-TIMINGS; instead.
+    </para>
+
     <para>The hardware may be able to detect the current DV preset
 automatically, similar to sensing the video standard. To do so, applications
 call <constant> VIDIOC_QUERY_DV_PRESET</constant> with a pointer to a
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 6062c57..8e2e827 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -939,6 +939,9 @@ struct v4l2_standard {
 	__u32		     reserved[4];
 };
 
+/* The DV Preset API is deprecated in favor of the DV Timings API.
+   New drivers shouldn't use this anymore! */
+
 /*
  *	V I D E O	T I M I N G S	D V	P R E S E T
  */
@@ -2507,6 +2510,9 @@ struct v4l2_create_buffers {
 #endif
 
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+
+/* These four DV Preset ioctls are deprecated in favor of the DV Timings
+   ioctls. */
 #define	VIDIOC_ENUM_DV_PRESETS	_IOWR('V', 83, struct v4l2_dv_enum_preset)
 #define	VIDIOC_S_DV_PRESET	_IOWR('V', 84, struct v4l2_dv_preset)
 #define	VIDIOC_G_DV_PRESET	_IOWR('V', 85, struct v4l2_dv_preset)
-- 
1.7.10

