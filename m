Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:60039 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaCGOTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:19:11 -0500
Message-ID: <5319D55B.6080202@cisco.com>
Date: Fri, 07 Mar 2014 15:19:07 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv1 PATCH 5/5] DocBook v4l2: update the G/S_EDID documentation
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl> <1394187679-7345-6-git-send-email-hverkuil@xs4all.nl> <1636382.IFSev3egjD@avalon>
In-Reply-To: <1636382.IFSev3egjD@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2014 03:09 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday 07 March 2014 11:21:19 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Document that it is now possible to call G/S_EDID from video nodes, not
>> just sub-device nodes. Add a note that -EINVAL will be returned if
>> the pad does not support EDIDs.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/DocBook/media/v4l/v4l2.xml           |   2 +-
>>  .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     | 152 ------------------
>>  2 files changed, 1 insertion(+), 153 deletions(-)
>>  delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
> 
> The patch just removes the EDID ioctls documentation, I highly doubt that this 
> is what you intended :-)

Let's try again:


Document that it is now possible to call G/S_EDID from video nodes, not
just sub-device nodes. Add a note that -EINVAL will be returned if
the pad does not support EDIDs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |  2 +-
 ...{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} | 36 ++++++++++++++--------
 2 files changed, 24 insertions(+), 14 deletions(-)
 rename Documentation/DocBook/media/v4l/{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} (77%)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 61a7bb1..b445161 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -607,6 +607,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-g-crop;
     &sub-g-ctrl;
     &sub-g-dv-timings;
+    &sub-g-edid;
     &sub-g-enc-index;
     &sub-g-ext-ctrls;
     &sub-g-fbuf;
@@ -638,7 +639,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-enum-frame-size;
     &sub-subdev-enum-mbus-code;
     &sub-subdev-g-crop;
-    &sub-subdev-g-edid;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
     &sub-subdev-g-selection;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
similarity index 77%
rename from Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-edid.xml
index bbd18f0..becd7cb 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
@@ -1,12 +1,12 @@
-<refentry id="vidioc-subdev-g-edid">
+<refentry id="vidioc-g-edid">
   <refmeta>
-    <refentrytitle>ioctl VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</refentrytitle>
+    <refentrytitle>ioctl VIDIOC_G_EDID, VIDIOC_S_EDID</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
-    <refname>VIDIOC_SUBDEV_G_EDID</refname>
-    <refname>VIDIOC_SUBDEV_S_EDID</refname>
+    <refname>VIDIOC_G_EDID</refname>
+    <refname>VIDIOC_S_EDID</refname>
     <refpurpose>Get or set the EDID of a video receiver/transmitter</refpurpose>
   </refnamediv>
 
@@ -16,7 +16,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
+	<paramdef>struct v4l2_edid *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
     <funcsynopsis>
@@ -24,7 +24,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>const struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
+	<paramdef>const struct v4l2_edid *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -42,7 +42,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</para>
+	  <para>VIDIOC_G_EDID, VIDIOC_S_EDID</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -56,12 +56,20 @@
 
   <refsect1>
     <title>Description</title>
-    <para>These ioctls can be used to get or set an EDID associated with an input pad
-    from a receiver or an output pad of a transmitter subdevice.</para>
+    <para>These ioctls can be used to get or set an EDID associated with an input
+    from a receiver or an output of a transmitter device. These ioctls can be
+    used with subdevice nodes (/dev/v4l-subdevX) or with video nodes (/dev/videoX).</para>
+
+    <para>When used with video nodes the <structfield>pad</structfield> field represents the
+    input (for video capture devices) or output (for video output devices) index as
+    is returned by &VIDIOC-ENUMINPUT; and &VIDIOC-ENUMOUTPUT; respectively. When used
+    with subdevice nodes the <structfield>pad</structfield> field represents the
+    input or output pad of the subdevice. If there is no EDID support for the given
+    <structfield>pad</structfield> value, then the &EINVAL; will be returned.</para>
 
     <para>To get the EDID data the application has to fill in the <structfield>pad</structfield>,
     <structfield>start_block</structfield>, <structfield>blocks</structfield> and <structfield>edid</structfield>
-    fields and call <constant>VIDIOC_SUBDEV_G_EDID</constant>. The current EDID from block
+    fields and call <constant>VIDIOC_G_EDID</constant>. The current EDID from block
     <structfield>start_block</structfield> and of size <structfield>blocks</structfield>
     will be placed in the memory <structfield>edid</structfield> points to. The <structfield>edid</structfield>
     pointer must point to memory at least <structfield>blocks</structfield>&nbsp;*&nbsp;128 bytes
@@ -91,15 +99,17 @@
     data in some way. In any case, the end result is the same: the EDID is no longer available.
     </para>
 
-    <table pgwide="1" frame="none" id="v4l2-subdev-edid">
-      <title>struct <structname>v4l2_subdev_edid</structname></title>
+    <table pgwide="1" frame="none" id="v4l2-edid">
+      <title>struct <structname>v4l2_edid</structname></title>
       <tgroup cols="3">
         &cs-str;
 	<tbody valign="top">
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>pad</structfield></entry>
-	    <entry>Pad for which to get/set the EDID blocks.</entry>
+	    <entry>Pad for which to get/set the EDID blocks. When used with a video device
+	    node the pad represents the input or output index as returned by
+	    &VIDIOC-ENUMINPUT; and &VIDIOC-ENUMOUTPUT; respectively.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.9.0


