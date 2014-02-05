Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaBEQl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 27/47] v4l: Add support for DV timings ioctls on subdev nodes
Date: Wed,  5 Feb 2014 17:42:18 +0100
Message-Id: <1391618558-5580-28-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    | 27 ++++++++++++++++++----
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   | 27 +++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-subdev.c              | 15 ++++++++++++
 include/uapi/linux/v4l2-subdev.h                   |  5 ++++
 4 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
index cd7720d..baef771 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
@@ -1,11 +1,12 @@
 <refentry id="vidioc-dv-timings-cap">
   <refmeta>
-    <refentrytitle>ioctl VIDIOC_DV_TIMINGS_CAP</refentrytitle>
+    <refentrytitle>ioctl VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
     <refname>VIDIOC_DV_TIMINGS_CAP</refname>
+    <refname>VIDIOC_SUBDEV_DV_TIMINGS_CAP</refname>
     <refpurpose>The capabilities of the Digital Video receiver/transmitter</refpurpose>
   </refnamediv>
 
@@ -33,7 +34,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>VIDIOC_DV_TIMINGS_CAP</para>
+	  <para>VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -54,10 +55,19 @@
       interface and may change in the future.</para>
     </note>
 
-    <para>To query the capabilities of the DV receiver/transmitter applications can call
-this ioctl and the driver will fill in the structure. Note that drivers may return
+    <para>To query the capabilities of the DV receiver/transmitter applications
+can call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl on a video node
+and the driver will fill in the structure. Note that drivers may return
 different values after switching the video input or output.</para>
 
+    <para>When implemented by the driver DV capabilities of subdevices can be
+queried by calling the <constant>VIDIOC_SUBDEV_DV_TIMINGS_CAP</constant> ioctl
+directly on a subdevice node. The capabilities are specific to inputs (for DV
+receivers) or outputs (for DV transmitters), application must specify the
+desired pad number in the &v4l2-dv-timings-cap; <structfield>pad</structfield>
+field. Attemps to query capabilities on a pad that doesn't support them will
+return an &EINVAL;.</para>
+
     <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
       <title>struct <structname>v4l2_bt_timings_cap</structname></title>
       <tgroup cols="3">
@@ -127,7 +137,14 @@ different values after switching the video input or output.</para>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[3]</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad number as reported by the media controller API. This field
+	    is only used when operating on a subdevice node. When operating on a
+	    video node applications must set this field to zero.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[2]</entry>
 	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
index b3e17c1..e55df46 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
@@ -1,11 +1,12 @@
 <refentry id="vidioc-enum-dv-timings">
   <refmeta>
-    <refentrytitle>ioctl VIDIOC_ENUM_DV_TIMINGS</refentrytitle>
+    <refentrytitle>ioctl VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
     <refname>VIDIOC_ENUM_DV_TIMINGS</refname>
+    <refname>VIDIOC_SUBDEV_ENUM_DV_TIMINGS</refname>
     <refpurpose>Enumerate supported Digital Video timings</refpurpose>
   </refnamediv>
 
@@ -33,7 +34,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>VIDIOC_ENUM_DV_TIMINGS</para>
+	  <para>VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -61,14 +62,21 @@ standards or even custom timings that are not in this list.</para>
 
     <para>To query the available timings, applications initialize the
 <structfield>index</structfield> field and zero the reserved array of &v4l2-enum-dv-timings;
-and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl with a pointer to this
-structure. Drivers fill the rest of the structure or return an
+and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl on a video node with a
+pointer to this structure. Drivers fill the rest of the structure or return an
 &EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
 applications shall begin at index zero, incrementing by one until the
 driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
 different set of DV timings after switching the video input or
 output.</para>
 
+    <para>When implemented by the driver DV timings of subdevices can be queried
+by calling the <constant>VIDIOC_SUBDEV_ENUM_DV_TIMINGS</constant> ioctl directly
+on a subdevice node. The DV timings are specific to inputs (for DV receivers) or
+outputs (for DV transmitters), application must specify the desired pad number
+in the &v4l2-enum-dv-timings; <structfield>pad</structfield> field. Attemps to
+enumerate timings on a pad that doesn't support them will return an &EINVAL;.</para>
+
     <table pgwide="1" frame="none" id="v4l2-enum-dv-timings">
       <title>struct <structname>v4l2_enum_dv_timings</structname></title>
       <tgroup cols="3">
@@ -82,7 +90,14 @@ application.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[3]</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad number as reported by the media controller API. This field
+	    is only used when operating on a subdevice node. When operating on a
+	    video node applications must set this field to zero.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[2]</entry>
 	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
 	  </row>
 	  <row>
@@ -103,7 +118,7 @@ application.</entry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-enum-dv-timings; <structfield>index</structfield>
-is out of bounds.</para>
+is out of bounds or the <structfield>pad</structfield> number is invalid.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..0ccf9c8 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -354,6 +354,21 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_SUBDEV_S_EDID:
 		return v4l2_subdev_call(sd, pad, set_edid, arg);
+
+	case VIDIOC_SUBDEV_DV_TIMINGS_CAP:
+		return v4l2_subdev_call(sd, pad, dv_timings_cap, arg);
+
+	case VIDIOC_SUBDEV_ENUM_DV_TIMINGS:
+		return v4l2_subdev_call(sd, pad, enum_dv_timings, arg);
+
+	case VIDIOC_SUBDEV_QUERY_DV_TIMINGS:
+		return v4l2_subdev_call(sd, video, query_dv_timings, arg);
+
+	case VIDIOC_SUBDEV_G_DV_TIMINGS:
+		return v4l2_subdev_call(sd, video, g_dv_timings, arg);
+
+	case VIDIOC_SUBDEV_S_DV_TIMINGS:
+		return v4l2_subdev_call(sd, video, s_dv_timings, arg);
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 9fe3493..6f5c5de 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -169,5 +169,10 @@ struct v4l2_subdev_edid {
 #define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct v4l2_subdev_selection)
 #define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct v4l2_subdev_edid)
 #define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct v4l2_subdev_edid)
+#define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 42, struct v4l2_dv_timings_cap)
+#define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 43, struct v4l2_enum_dv_timings)
+#define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 44, struct v4l2_dv_timings)
+#define VIDIOC_SUBDEV_G_DV_TIMINGS		_IOWR('V', 45, struct v4l2_dv_timings)
+#define VIDIOC_SUBDEV_S_DV_TIMINGS		_IOWR('V', 46, struct v4l2_dv_timings)
 
 #endif
-- 
1.8.3.2

