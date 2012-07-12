Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab2GLUzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 16:55:14 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, halli manjunatha <hallimanju@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/5] v4l2: Add rangelow and rangehigh fields to the v4l2_hw_freq_seek struct
Date: Thu, 12 Jul 2012 22:55:45 +0200
Message-Id: <1342126548-19349-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
References: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To allow apps to limit a hw-freq-seek to a specific band, for further
info see the documentation this patch adds for these new fields.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   50 ++++++++++++++++----
 include/linux/videodev2.h                          |    5 +-
 2 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index f4db44d..3dd1bec 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -52,11 +52,23 @@
     <para>Start a hardware frequency seek from the current frequency.
 To do this applications initialize the <structfield>tuner</structfield>,
 <structfield>type</structfield>, <structfield>seek_upward</structfield>,
-<structfield>spacing</structfield> and
-<structfield>wrap_around</structfield> fields, and zero out the
-<structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
-call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
-to this structure.</para>
+<structfield>wrap_around</structfield>, <structfield>spacing</structfield>,
+<structfield>rangelow</structfield> and <structfield>rangehigh</structfield>
+fields, and zero out the <structfield>reserved</structfield> array of a
+&v4l2-hw-freq-seek; and call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant>
+ioctl with a pointer to this structure.</para>
+
+    <para>The <structfield>rangelow</structfield> and
+<structfield>rangehigh</structfield> fields can be set to a non-zero value to
+tell the driver to search a specific band. If the &v4l2-tuner;
+<structfield>capability</structfield> field has the
+<constant>V4L2_TUNER_CAP_HWSEEK_PROG_LIM</constant> flag set, these values
+must fall within one of the bands returned by &VIDIOC-ENUM-FREQ-BANDS;. If
+the <constant>V4L2_TUNER_CAP_HWSEEK_PROG_LIM</constant> flag is not set,
+then these values must exactly match those of one of the bands returned by
+&VIDIOC-ENUM-FREQ-BANDS;. If the current frequency of the tuner does not fall
+within the selected band it will be clamped to fit in the band before the
+seek is started.</para>
 
     <para>If an error is returned, then the original frequency will
     be restored.</para>
@@ -102,7 +114,27 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[7]</entry>
+	    <entry><structfield>rangelow</structfield></entry>
+	    <entry>If non-zero, the lowest tunable frequency of the band to
+search in units of 62.5 kHz, or if the &v4l2-tuner;
+<structfield>capability</structfield> field has the
+<constant>V4L2_TUNER_CAP_LOW</constant> flag set, in units of 62.5 Hz.
+If <structfield>rangelow</structfield> is zero a reasonable default value
+is used.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>rangehigh</structfield></entry>
+	    <entry>If non-zero, the highest tunable frequency of the band to
+search in units of 62.5 kHz, or if the &v4l2-tuner;
+<structfield>capability</structfield> field has the
+<constant>V4L2_TUNER_CAP_LOW</constant> flag set, in units of 62.5 Hz.
+If <structfield>rangehigh</structfield> is zero a reasonable default value
+is used.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[5]</entry>
 	    <entry>Reserved for future extensions. Applications
 	    must set the array to zero.</entry>
 	  </row>
@@ -119,8 +151,10 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The <structfield>tuner</structfield> index is out of
-bounds, the wrap_around value is not supported or the value in the <structfield>type</structfield> field is
-wrong.</para>
+bounds, the <structfield>wrap_around</structfield> value is not supported or
+one of the values in the <structfield>type</structfield>,
+<structfield>rangelow</structfield> or <structfield>rangehigh</structfield>
+fields is wrong.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9fa822a..1c6aa63 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2029,6 +2029,7 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
 #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
 #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
+#define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
@@ -2074,7 +2075,9 @@ struct v4l2_hw_freq_seek {
 	__u32	seek_upward;
 	__u32	wrap_around;
 	__u32	spacing;
-	__u32	reserved[7];
+	__u32	rangelow;
+	__u32	rangehigh;
+	__u32	reserved[5];
 };
 
 /*
-- 
1.7.10.4

