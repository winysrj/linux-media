Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44512 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbcDVJHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 05:07:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] DocBook media: drop 'experimental' annotations
Date: Fri, 22 Apr 2016 11:06:59 +0200
Message-Id: <1461316019-2497-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461316019-2497-1-git-send-email-hverkuil@xs4all.nl>
References: <1461316019-2497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the 'experimental' annotations. The only remaining part of the API
that is still marked 'experimental' are the debug ioctls/structs, and
that is intentional. Only the v4l2-dbg application should use those.

All others have been around for years, so it is time to drop the
'experimental' designation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml         | 38 ----------------------
 Documentation/DocBook/media/v4l/controls.xml       | 31 ------------------
 Documentation/DocBook/media/v4l/dev-sdr.xml        |  6 ----
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  6 ----
 Documentation/DocBook/media/v4l/io.xml             |  6 ----
 Documentation/DocBook/media/v4l/selection-api.xml  |  9 +----
 Documentation/DocBook/media/v4l/subdev-formats.xml |  6 ----
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  6 ----
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  6 ----
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  6 ----
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |  6 ----
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  6 ----
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  6 ----
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |  6 ----
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |  6 ----
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |  6 ----
 .../media/v4l/vidioc-subdev-enum-frame-size.xml    |  6 ----
 .../media/v4l/vidioc-subdev-enum-mbus-code.xml     |  6 ----
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      |  6 ----
 .../media/v4l/vidioc-subdev-g-frame-interval.xml   |  6 ----
 .../media/v4l/vidioc-subdev-g-selection.xml        |  6 ----
 21 files changed, 1 insertion(+), 185 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 5399e89..82fa328 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2686,50 +2686,12 @@ and may change in the future.</para>
 
       <itemizedlist>
         <listitem>
-	  <para>Video Output Overlay (OSD) Interface, <xref
-	    linkend="osd" />.</para>
-        </listitem>
-        <listitem>
 	  <para>&VIDIOC-DBG-G-REGISTER; and &VIDIOC-DBG-S-REGISTER;
 ioctls.</para>
         </listitem>
         <listitem>
 	  <para>&VIDIOC-DBG-G-CHIP-INFO; ioctl.</para>
         </listitem>
-        <listitem>
-	  <para>&VIDIOC-ENUM-DV-TIMINGS;, &VIDIOC-QUERY-DV-TIMINGS; and
-	  &VIDIOC-DV-TIMINGS-CAP; ioctls.</para>
-        </listitem>
-        <listitem>
-	  <para>Flash API. <xref linkend="flash-controls" /></para>
-        </listitem>
-        <listitem>
-	  <para>&VIDIOC-CREATE-BUFS; and &VIDIOC-PREPARE-BUF; ioctls.</para>
-        </listitem>
-        <listitem>
-	  <para>Selection API. <xref linkend="selection-api" /></para>
-        </listitem>
-        <listitem>
-	  <para>Sub-device selection API: &VIDIOC-SUBDEV-G-SELECTION;
-	  and &VIDIOC-SUBDEV-S-SELECTION; ioctls.</para>
-        </listitem>
-        <listitem>
-	  <para>Support for frequency band enumeration: &VIDIOC-ENUM-FREQ-BANDS; ioctl.</para>
-        </listitem>
-        <listitem>
-	  <para>Vendor and device specific media bus pixel formats.
-	    <xref linkend="v4l2-mbus-vendor-spec-fmts" />.</para>
-        </listitem>
-        <listitem>
-	  <para>Importing DMABUF file descriptors as a new IO method described
-	  in <xref linkend="dmabuf" />.</para>
-        </listitem>
-        <listitem>
-	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
-        </listitem>
-        <listitem>
-	  <para>Software Defined Radio (SDR) Interface, <xref linkend="sdr" />.</para>
-        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 361040e..81efa88 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4272,13 +4272,6 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
     <section id="flash-controls">
       <title>Flash Control Reference</title>
 
-      <note>
-	<title>Experimental</title>
-
-	<para>This is an <link linkend="experimental">experimental</link>
-interface and may change in the future.</para>
-      </note>
-
       <para>
 	The V4L2 flash controls are intended to provide generic access
 	to flash controller devices. Flash controller devices are
@@ -4743,14 +4736,6 @@ interface and may change in the future.</para>
     <section id="image-source-controls">
       <title>Image Source Control Reference</title>
 
-      <note>
-	<title>Experimental</title>
-
-	<para>This is an <link
-	linkend="experimental">experimental</link> interface and may
-	change in the future.</para>
-      </note>
-
       <para>
 	The Image Source control class is intended for low-level
 	control of image source devices such as image sensors. The
@@ -4862,14 +4847,6 @@ interface and may change in the future.</para>
     <section id="image-process-controls">
       <title>Image Process Control Reference</title>
 
-      <note>
-	<title>Experimental</title>
-
-	<para>This is an <link
-	linkend="experimental">experimental</link> interface and may
-	change in the future.</para>
-      </note>
-
       <para>
 	The Image Process control class is intended for low-level control of
 	image processing functions. Unlike
@@ -4955,14 +4932,6 @@ interface and may change in the future.</para>
     <section id="dv-controls">
       <title>Digital Video Control Reference</title>
 
-      <note>
-	<title>Experimental</title>
-
-	<para>This is an <link
-	linkend="experimental">experimental</link> interface and may
-	change in the future.</para>
-      </note>
-
       <para>
 	The Digital Video control class is intended to control receivers
 	and transmitters for <ulink url="http://en.wikipedia.org/wiki/Vga">VGA</ulink>,
diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
index a659771..6da1157 100644
--- a/Documentation/DocBook/media/v4l/dev-sdr.xml
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -1,11 +1,5 @@
   <title>Software Defined Radio Interface (SDR)</title>
 
-  <note>
-    <title>Experimental</title>
-    <para>This is an <link linkend="experimental"> experimental </link>
-    interface and may change in the future.</para>
-  </note>
-
   <para>
 SDR is an abbreviation of Software Defined Radio, the radio device
 which uses application software for modulation or demodulation. This interface
diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 4f0ba58..f4bc27a 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -1,11 +1,5 @@
   <title>Sub-device Interface</title>
 
-  <note>
-    <title>Experimental</title>
-    <para>This is an <link linkend="experimental">experimental</link>
-    interface and may change in the future.</para>
-  </note>
-
   <para>The complex nature of V4L2 devices, where hardware is often made of
   several integrated circuits that need to interact with each other in a
   controlled way, leads to complex V4L2 drivers. The drivers usually reflect
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 144158b..e09025d 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -475,12 +475,6 @@ rest should be evident.</para>
   <section id="dmabuf">
     <title>Streaming I/O (DMA buffer importing)</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
 <para>The DMABUF framework provides a generic method for sharing buffers
 between multiple devices. Device drivers that support DMABUF can export a DMA
 buffer to userspace as a file descriptor (known as the exporter role), import a
diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index 28cbded..b764cba 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -1,13 +1,6 @@
 <section id="selection-api">
 
-  <title>Experimental API for cropping, composing and scaling</title>
-
-      <note>
-	<title>Experimental</title>
-
-	<para>This is an <link linkend="experimental">experimental</link>
-interface and may change in the future.</para>
-      </note>
+  <title>API for cropping, composing and scaling</title>
 
   <section>
     <title>Introduction</title>
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 4e73345..199c84e 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -4002,12 +4002,6 @@ see <xref linkend="colorspaces" />.</entry>
     <section id="v4l2-mbus-vendor-spec-fmts">
       <title>Vendor and Device Specific Formats</title>
 
-      <note>
-	<title>Experimental</title>
-	<para>This is an <link linkend="experimental">experimental</link>
-interface and may change in the future.</para>
-      </note>
-
       <para>This section lists complex data formats that are either vendor or
 	device specific.
       </para>
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index d81fa0d..6528e97 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>This ioctl is used to create buffers for <link linkend="mmap">memory
 mapped</link> or <link linkend="userp">user pointer</link> or <link
 linkend="dmabuf">DMA buffer</link> I/O. It can be used as an alternative or in
diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
index b6f47a6..ca9ffce 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>To query the capabilities of the DV receiver/transmitter applications initialize the
 <structfield>pad</structfield> field to 0, zero the reserved array of &v4l2-dv-timings-cap;
 and call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl on a video node
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
index 70ca76d..9b3d420 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>While some DV receivers or transmitters support a wide range of timings, others
 support only a limited number of timings. With this ioctl applications can enumerate a list
 of known supported timings. Call &VIDIOC-DV-TIMINGS-CAP; to check if it also supports other
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
index 4e8ea65..a0608ab 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>Enumerates the frequency bands that a tuner or modulator supports.
 To do this applications initialize the <structfield>tuner</structfield>,
 <structfield>type</structfield> and <structfield>index</structfield> fields,
diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
index 0ae0b6a..a6558a6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
 <para>This ioctl is an extension to the <link linkend="mmap">memory
 mapping</link> I/O method, therefore it is available only for
 <constant>V4L2_MEMORY_MMAP</constant> buffers.  It can be used to export a
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index 7865351..9523bc5 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -50,12 +50,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>The ioctls are used to query and configure selection rectangles.</para>
 
 <para>To query the cropping (composing) rectangle set &v4l2-selection;
diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
index fa7ad7e..7bde698 100644
--- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
@@ -48,12 +48,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>Applications can optionally call the
 <constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
 to the driver before actually enqueuing it, using the
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
index 0c93677..d41bf47 100644
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
@@ -50,12 +50,6 @@ input</refpurpose>
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>The hardware may be able to detect the current DV timings
 automatically, similar to sensing the video standard. To do so, applications
 call <constant>VIDIOC_QUERY_DV_TIMINGS</constant> with a pointer to a
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
index cff59f5..9d0251a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>This ioctl lets applications enumerate available frame intervals on a
     given sub-device pad. Frame intervals only makes sense for sub-devices that
     can control the frame period on their own. This includes, for instance,
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
index abd545e..9b91b83 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>This ioctl allows applications to enumerate all frame sizes
     supported by a sub-device on the given pad for the given media bus format.
     Supported formats can be retrieved with the &VIDIOC-SUBDEV-ENUM-MBUS-CODE;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
index 0bcb278..c67256a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>To enumerate media bus formats available at a given sub-device pad
     applications initialize the <structfield>pad</structfield>, <structfield>which</structfield>
     and <structfield>index</structfield> fields of &v4l2-subdev-mbus-code-enum; and
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
index a67cde6..781089c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
@@ -50,12 +50,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>These ioctls are used to negotiate the frame format at specific
     subdev pads in the image pipeline.</para>
 
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
index 0bc3ea22..848ec78 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
@@ -50,12 +50,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>These ioctls are used to get and set the frame interval at specific
     subdev pads in the image pipeline. The frame interval only makes sense for
     sub-devices that can control the frame period on their own. This includes,
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index c62a736..8346b2e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -49,12 +49,6 @@
   <refsect1>
     <title>Description</title>
 
-    <note>
-      <title>Experimental</title>
-      <para>This is an <link linkend="experimental">experimental</link>
-      interface and may change in the future.</para>
-    </note>
-
     <para>The selections are used to configure various image
     processing functionality performed by the subdevs which affect the
     image size. This currently includes cropping, scaling and
-- 
2.8.0.rc3

