Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4866 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaCGKVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:21:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 5/5] DocBook v4l2: update the G/S_EDID documentation
Date: Fri,  7 Mar 2014 11:21:19 +0100
Message-Id: <1394187679-7345-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document that it is now possible to call G/S_EDID from video nodes, not
just sub-device nodes. Add a note that -EINVAL will be returned if
the pad does not support EDIDs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |   2 +-
 .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     | 152 ---------------------
 2 files changed, 1 insertion(+), 153 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml

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
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
deleted file mode 100644
index bbd18f0..0000000
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
+++ /dev/null
@@ -1,152 +0,0 @@
-<refentry id="vidioc-subdev-g-edid">
-  <refmeta>
-    <refentrytitle>ioctl VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>VIDIOC_SUBDEV_G_EDID</refname>
-    <refname>VIDIOC_SUBDEV_S_EDID</refname>
-    <refpurpose>Get or set the EDID of a video receiver/transmitter</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>const struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-
-    <variablelist>
-      <varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	  <para></para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-    <para>These ioctls can be used to get or set an EDID associated with an input pad
-    from a receiver or an output pad of a transmitter subdevice.</para>
-
-    <para>To get the EDID data the application has to fill in the <structfield>pad</structfield>,
-    <structfield>start_block</structfield>, <structfield>blocks</structfield> and <structfield>edid</structfield>
-    fields and call <constant>VIDIOC_SUBDEV_G_EDID</constant>. The current EDID from block
-    <structfield>start_block</structfield> and of size <structfield>blocks</structfield>
-    will be placed in the memory <structfield>edid</structfield> points to. The <structfield>edid</structfield>
-    pointer must point to memory at least <structfield>blocks</structfield>&nbsp;*&nbsp;128 bytes
-    large (the size of one block is 128 bytes).</para>
-
-    <para>If there are fewer blocks than specified, then the driver will set <structfield>blocks</structfield>
-    to the actual number of blocks. If there are no EDID blocks available at all, then the error code
-    ENODATA is set.</para>
-
-    <para>If blocks have to be retrieved from the sink, then this call will block until they
-    have been read.</para>
-
-    <para>To set the EDID blocks of a receiver the application has to fill in the <structfield>pad</structfield>,
-    <structfield>blocks</structfield> and <structfield>edid</structfield> fields and set
-    <structfield>start_block</structfield> to 0. It is not possible to set part of an EDID,
-    it is always all or nothing. Setting the EDID data is only valid for receivers as it makes
-    no sense for a transmitter.</para>
-
-    <para>The driver assumes that the full EDID is passed in. If there are more EDID blocks than
-    the hardware can handle then the EDID is not written, but instead the error code E2BIG is set
-    and <structfield>blocks</structfield> is set to the maximum that the hardware supports.
-    If <structfield>start_block</structfield> is any
-    value other than 0 then the error code EINVAL is set.</para>
-
-    <para>To disable an EDID you set <structfield>blocks</structfield> to 0. Depending on the
-    hardware this will drive the hotplug pin low and/or block the source from reading the EDID
-    data in some way. In any case, the end result is the same: the EDID is no longer available.
-    </para>
-
-    <table pgwide="1" frame="none" id="v4l2-subdev-edid">
-      <title>struct <structname>v4l2_subdev_edid</structname></title>
-      <tgroup cols="3">
-        &cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>pad</structfield></entry>
-	    <entry>Pad for which to get/set the EDID blocks.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>start_block</structfield></entry>
-	    <entry>Read the EDID from starting with this block. Must be 0 when setting
-	    the EDID.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>blocks</structfield></entry>
-	    <entry>The number of blocks to get or set. Must be less or equal to 256 (the
-	    maximum number of blocks as defined by the standard). When you set the EDID and
-	    <structfield>blocks</structfield> is 0, then the EDID is disabled or erased.</entry>
-	  </row>
-	  <row>
-	    <entry>__u8&nbsp;*</entry>
-	    <entry><structfield>edid</structfield></entry>
-	    <entry>Pointer to memory that contains the EDID. The minimum size is
-	    <structfield>blocks</structfield>&nbsp;*&nbsp;128.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[5]</entry>
-	    <entry>Reserved for future extensions. Applications and drivers must
-	    set the array to zero.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
-
-  <refsect1>
-    &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>ENODATA</errorcode></term>
-	<listitem>
-	  <para>The EDID data is not available.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>E2BIG</errorcode></term>
-	<listitem>
-	  <para>The EDID data you provided is more than the hardware can handle.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-</refentry>
-- 
1.9.0

