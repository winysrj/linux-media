Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1745 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3AKN5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:57:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCHv3 1/3] DocBook: fix various validation errors
Date: Fri, 11 Jan 2013 14:57:00 +0100
Message-Id: <66daf776429bc348c156f96eb36141588087783b.1357912476.git.hans.verkuil@cisco.com>
In-Reply-To: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
References: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fixed the following errors (with exception of the SVG errors):

  GEN     /home/hans/work/src/v4l/media-git/Documentation/DocBook//v4l2.xml
  rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 3.8.0-rc1</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/media_api.html >> Documentation/DocBook/index.html
  /tmp/x.xml:883: element revremark: validity error : Element structname is not declared in revremark list of possible children
  /tmp/x.xml:883: element revremark: validity error : Element xref is not declared in revremark list of possible children
  /tmp/x.xml:1829: element footnote: validity error : Element footnote content does not follow the DTD, expecting (calloutlist | glosslist | itemizedlist | orderedlist | segmentedlist | simplelist | variablelist | literallayout | programlisting | programlistingco | screen | screenco | screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis | fieldsynopsis | constructorsynopsis | destructorsynopsis | methodsynopsis | formalpara | para | simpara | address | blockquote | graphic | graphicco | mediaobject | mediaobjectco | informalequation | informalexample | informalfigure | informaltable)+, got (para para errorcode CDATA para )
  /tmp/x.xml:9580: element xref: validity error : Element xref was declared EMPTY this one has content
  /tmp/x.xml:13508: element link: validity error : Element link does not carry attribute linkend
  /tmp/x.xml:13508: element link: validity error : No declaration for attribute linked of element link
  /tmp/x.xml:16986: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
  /tmp/x.xml:17003: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
  /tmp/x.xml:17022: element imagedata: validity error : Value "SVG" for attribute format of imagedata is not among the enumerated set
  /tmp/x.xml:26795: element refsect1: validity error : Element refsect1 content does not follow the DTD, expecting (refsect1info? , (title , subtitle? , titleabbrev?) , (((calloutlist | glosslist | itemizedlist | orderedlist | segmentedlist | simplelist | variablelist | caution | important | note | tip | warning | literallayout | programlisting | programlistingco | screen | screenco | screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis | fieldsynopsis | constructorsynopsis | destructorsynopsis | methodsynopsis | formalpara | para | simpara | address | blockquote | graphic | graphicco | mediaobject | mediaobjectco | informalequation | informalexample | informalfigure | informaltable | equation | example | figure | table | msgset | procedure | sidebar | qandaset | anchor | bridgehead | remark | highlights | abstract | authorblurb | epigraph | indexterm | beginpage)+ , refsect2*) | refsect2+)), got (section )
  /tmp/x.xml:26852: element refsect1: validity error : Element refsect1 content does not follow the DTD, expecting (refsect1info? , (title , subtitle? , titleabbrev?) , (((calloutlist | glosslist | itemizedlist | orderedlist | segmentedlist | simplelist | variablelist | caution | important | note | tip | warning | literallayout | programlisting | programlistingco | screen | screenco | screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis | fieldsynopsis | constructorsynopsis | destructorsynopsis | methodsynopsis | formalpara | para | simpara | address | blockquote | graphic | graphicco | mediaobject | mediaobjectco | informalequation | informalexample | informalfigure | informaltable | equation | example | figure | table | msgset | procedure | sidebar | qandaset | anchor | bridgehead | remark | highlights | abstract | authorblurb | epigraph | indexterm | beginpage)+ , refsect2*) | refsect2+)), got (table )

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml         |    2 +-
 Documentation/DocBook/media/v4l/io.xml             |    4 +--
 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |    2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    5 +---
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |   28 +++++++++-----------
 5 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 73c6847..ae06afb 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -609,7 +609,7 @@ to zero and the <constant>VIDIOC_G_STD</constant>,
 	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
 <xref linkend="output-capabilities"/> flags to determine whether the video standard ioctls
 are available for the device.</para>
-&ENOTTY;.
+
 	<para>See <xref linkend="buffer" /> for a rationale. Probably
 even USB cameras follow some well known video standard. It might have
 been better to explicitly indicate elsewhere if a device cannot live
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 2c4646d..e6c5855 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -477,7 +477,7 @@ rest should be evident.</para>
 
     <note>
       <title>Experimental</title>
-      <para>This is an <link linkend="experimental"> experimental </link>
+      <para>This is an <link linkend="experimental">experimental</link>
       interface and may change in the future.</para>
     </note>
 
@@ -488,7 +488,7 @@ DMA buffer from userspace using a file descriptor previously exported for a
 different or the same device (known as the importer role), or both. This
 section describes the DMABUF importer role API in V4L2.</para>
 
-    <para>Refer to <link linked="vidioc-expbuf"> DMABUF exporting </link> for
+    <para>Refer to <link linkend="vidioc-expbuf">DMABUF exporting</link> for
 details about exporting V4L2 buffers as DMABUF file descriptors.</para>
 
 <para>Input and output devices support the streaming I/O method when the
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
index c934192..29acc20 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
@@ -29,6 +29,6 @@
 	    formats with 10 bits per color compressed to 8 bits each,
 	    using the A-LAW algorithm. Each color component consumes 8
 	    bits of memory. In other respects this format is similar to
-	    <xref linkend="V4L2-PIX-FMT-SRGGB8">.</xref></para>
+	    <xref linkend="V4L2-PIX-FMT-SRGGB8"></xref>.</para>
 	  </refsect1>
 	</refentry>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 8fe2942..94ab0e1 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -143,10 +143,7 @@ applications. -->
 	<revnumber>3.9</revnumber>
 	<date>2012-12-03</date>
 	<authorinitials>sa</authorinitials>
-	<revremark>Added timestamp types to
-	<structname>v4l2_buffer</structname>, see <xref
-	linkend="buffer-flags" />.
-	</revremark>
+	<revremark>Added timestamp types to v4l2_buffer.</revremark>
       </revision>
 
       <revision>
diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
index 72dfbd2..e287c8f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -83,15 +83,14 @@ descriptor. The application may pass it to other DMABUF-aware devices. Refer to
 <link linkend="dmabuf">DMABUF importing</link> for details about importing
 DMABUF files into V4L2 nodes. It is recommended to close a DMABUF file when it
 is no longer used to allow the associated memory to be reclaimed. </para>
-
   </refsect1>
+
   <refsect1>
-   <section>
-      <title>Examples</title>
+    <title>Examples</title>
 
-      <example>
-	<title>Exporting a buffer.</title>
-	<programlisting>
+    <example>
+      <title>Exporting a buffer.</title>
+      <programlisting>
 int buffer_export(int v4lfd, &v4l2-buf-type; bt, int index, int *dmafd)
 {
 	&v4l2-exportbuffer; expbuf;
@@ -108,12 +107,12 @@ int buffer_export(int v4lfd, &v4l2-buf-type; bt, int index, int *dmafd)
 
 	return 0;
 }
-        </programlisting>
-      </example>
+      </programlisting>
+    </example>
 
-      <example>
-	<title>Exporting a buffer using the multi-planar API.</title>
-	<programlisting>
+    <example>
+      <title>Exporting a buffer using the multi-planar API.</title>
+      <programlisting>
 int buffer_export_mp(int v4lfd, &v4l2-buf-type; bt, int index,
 	int dmafd[], int n_planes)
 {
@@ -137,12 +136,9 @@ int buffer_export_mp(int v4lfd, &v4l2-buf-type; bt, int index,
 
 	return 0;
 }
-        </programlisting>
-      </example>
-   </section>
-  </refsect1>
+      </programlisting>
+    </example>
 
-  <refsect1>
     <table pgwide="1" frame="none" id="v4l2-exportbuffer">
       <title>struct <structname>v4l2_exportbuffer</structname></title>
       <tgroup cols="3">
-- 
1.7.10.4

