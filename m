Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1L0Tny (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 14:43:54 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so11868452eek.19
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 11:43:53 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 2/4] V4L: Add the JPEG compression control class documentation
Date: Tue, 27 Dec 2011 20:43:29 +0100
Message-Id: <1325015011-11904-3-git-send-email-snjw23@gmail.com>
In-Reply-To: <1325015011-11904-1-git-send-email-snjw23@gmail.com>
References: <4EBECD11.8090709@gmail.com>
 <1325015011-11904-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DocBook entries for the JPEG control class.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 Documentation/DocBook/media/v4l/biblio.xml         |   20 +++
 Documentation/DocBook/media/v4l/controls.xml       |  161 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   16 ++-
 3 files changed, 195 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index cea6fd3..7dc65c5 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -128,6 +128,26 @@ url="http://www.ijg.org">http://www.ijg.org</ulink>)</corpauthor>
       <subtitle>Version 1.02</subtitle>
     </biblioentry>
 
+    <biblioentry id="itu-t81">
+      <abbrev>ITU-T.81</abbrev>
+      <authorgroup>
+	<corpauthor>International Telecommunication Union
+(<ulink url="http://www.itu.int">http://www.itu.int</ulink>)</corpauthor>
+      </authorgroup>
+      <title>ITU-T Recommendation T.81
+"Information Technology &mdash; Digital Compression and Coding of Continous-Tone
+Still Images &mdash; Requirements and Guidelines"</title>
+    </biblioentry>
+
+    <biblioentry id="w3c-jpeg-jfif">
+      <abbrev>W3C JPEG JFIF</abbrev>
+      <authorgroup>
+	<corpauthor>The World Wide Web Consortium (<ulink
+url="http://www.w3.org/Graphics/JPEG">http://www.w3.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>JPEG JFIF</title>
+    </biblioentry>
+
     <biblioentry id="smpte12m">
       <abbrev>SMPTE&nbsp;12M</abbrev>
       <authorgroup>
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index c0422c6..ab9e56b 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3364,6 +3364,167 @@ interface and may change in the future.</para>
 	</tbody>
       </tgroup>
       </table>
+    </section>
+
+    <section id="jpeg-controls">
+      <title>JPEG Control Reference</title>
+      <para>The JPEG class includes controls for common features of JPEG
+      encoders and decoders. Currently it includes features for codecs
+      implementing progressive baseline DCT compression process with
+      Huffman entrophy coding.</para>
+      <table pgwide="1" frame="none" id="jpeg-control-id">
+      <title>JPEG Control IDs</title>
 
+      <tgroup cols="4">
+	<colspec colname="c1" colwidth="1*" />
+	<colspec colname="c2" colwidth="6*" />
+	<colspec colname="c3" colwidth="2*" />
+	<colspec colname="c4" colwidth="6*" />
+	<spanspec namest="c1" nameend="c2" spanname="id" />
+	<spanspec namest="c2" nameend="c4" spanname="descr" />
+	<thead>
+	  <row>
+	    <entry spanname="id" align="left">ID</entry>
+	    <entry align="left">Type</entry>
+	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row><entry></entry></row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_JPEG_CLASS</constant>&nbsp;</entry>
+	    <entry>class</entry>
+	  </row><row><entry spanname="descr">The JPEG class descriptor. Calling
+	  &VIDIOC-QUERYCTRL; for this control will return a description of this
+	  control class.
+
+	</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_JPEG_CHROMA_SUBSAMPLING</constant></entry>
+	    <entry>menu</entry>
+	  </row>
+	  <row id="jpeg-chroma-subsampling-control">
+	    <entry spanname="descr">The chroma subsampling factors describe how
+	    each component of an input image is sampled, in respect to maximum
+	    sample rate in each spatial dimension. See <xref linkend="itu-t81"/>,
+	    clause A.1.1. for more details. The <constant>
+	    V4L2_CID_JPEG_CHROMA_SUBSAMPLING</constant> control determines how
+	    Cb and Cr components are downsampled after coverting an input image
+	    from RGB to Y'CbCr color space.
+	    </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_JPEG_CHROMA_SUBSAMPLING_444</constant>
+		  </entry><entry>No chroma subsampling, each pixel has
+		  Y, Cr and Cb values.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_JPEG_CHROMA_SUBSAMPLING_422</constant>
+		  </entry><entry>Horizontally subsample Cr, Cb components
+		  by a factor of 2.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_JPEG_CHROMA_SUBSAMPLING_420</constant>
+		  </entry><entry>Subsample Cr, Cb components horizontally
+		  and vertically by 2.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_JPEG_CHROMA_SUBSAMPLING_411</constant>
+		  </entry><entry>Horizontally subsample Cr, Cb components
+		  by a factor of 4.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_JPEG_CHROMA_SUBSAMPLING_410</constant>
+		  </entry><entry>Subsample Cr, Cb components horizontally
+		  by 4 and vertically by 2.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY</constant>
+		  </entry><entry>Use only luminance component.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_JPEG_RESTART_INTERVAL</constant>
+	    </entry><entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">
+	      The restart interval determines an interval of inserting RSTm
+	      markers (m = 0..7). The purpose of these markers is to additionally
+	      reinitialize the encoder process, in order to process blocks of
+	      an image independently.
+	      For the lossy compression processes the restart interval unit is
+	      MCU (Minimum Coded Unit) and its value is contained in DRI
+	      (Define Restart Interval) marker. If <constant>
+	      V4L2_CID_JPEG_RESTART_INTERVAL</constant> control is set to 0,
+	      DRI and RSTm markers will not be inserted.
+	    </entry>
+	  </row>
+	  <row id="jpeg-quality-control">
+	    <entry spanname="id"><constant>V4L2_CID_JPEG_COMPRESION_QUALITY</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">
+	      <constant>V4L2_CID_JPEG_COMPRESION_QUALITY</constant> control
+	      determines trade-off between image quality and size.
+	      It provides simpler method for applications to control image quality,
+	      without a need for direct reconfiguration of luminance and chrominance
+	      quantization tables.
+
+	      In cases where a driver uses quantization tables configured directly
+	      by an application, using interfaces defined elsewhere, <constant>
+	      V4L2_CID_JPEG_COMPRESION_QUALITY</constant> control should be set
+	      by driver to 0.
+
+	      <para>The value range of this control is driver-specific. Only
+	      positive, non-zero values are meaningful. The recommended range
+	      is 1 - 100, where larger values correspond to better image quality.
+	      </para>
+	    </entry>
+	    </row>
+	  <row id="jpeg-active-marker-control">
+	    <entry spanname="id"><constant>V4L2_CID_JPEG_ACTIVE_MARKER</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Specify which JPEG markers are included
+	    in compressed stream. This control is valid only for encoders.
+	    </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_JPEG_ACTIVE_MARKER_APP0</constant></entry>
+		  <entry>Application data segment APP<subscript>0</subscript>.</entry>
+		</row><row>
+		  <entry><constant>V4L2_JPEG_ACTIVE_MARKER_APP1</constant></entry>
+		  <entry>Application data segment APP<subscript>1</subscript>.</entry>
+		</row><row>
+		  <entry><constant>V4L2_JPEG_ACTIVE_MARKER_COM</constant></entry>
+		  <entry>Comment segment.</entry>
+		</row><row>
+		  <entry><constant>V4L2_JPEG_ACTIVE_MARKER_DQT</constant></entry>
+		  <entry>Quantization tables segment.</entry>
+		</row><row>
+		  <entry><constant>V4L2_JPEG_ACTIVE_MARKER_DHT</constant></entry>
+		  <entry>Huffman tables segment.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+	</tbody>
+      </tgroup>
+      </table>
+      <para>For more details about JPEG specification, refer
+      to <xref linkend="itu-t81"/>, <xref linkend="jfif"/>,
+      <xref linkend="w3c-jpeg-jfif"/>.</para>
     </section>
 </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
index 01ea24b..4874849 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
@@ -57,6 +57,11 @@
   <refsect1>
     <title>Description</title>
 
+    <para>These ioctls are <emphasis role="bold">deprecated</emphasis>.
+    New drivers and applications should use <link linkend="jpeg-controls">
+    JPEG class controls</link> for image quality and JPEG markers control.
+    </para>
+
     <para>[to do]</para>
 
     <para>Ronald Bultje elaborates:</para>
@@ -86,7 +91,10 @@ to add them.</para>
 	  <row>
 	    <entry>int</entry>
 	    <entry><structfield>quality</structfield></entry>
-	    <entry></entry>
+	    <entry>Deprecated. If <link linkend="jpeg-quality-control"><constant>
+	    V4L2_CID_JPEG_IMAGE_QUALITY</constant></link> control is exposed by
+	    a driver applications should use it instead and ignore this field.
+	    </entry>
 	  </row>
 	  <row>
 	    <entry>int</entry>
@@ -116,7 +124,11 @@ to add them.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>jpeg_markers</structfield></entry>
-	    <entry>See <xref linkend="jpeg-markers" />.</entry>
+	    <entry>See <xref linkend="jpeg-markers"/>. Deprecated.
+	    If <link linkend="jpeg-active-marker-control"><constant>
+	    V4L2_CID_JPEG_ACTIVE_MARKER</constant></link> control
+	    is exposed by a driver applications should use it instead
+	    and ignore this field.</entry>
 	  </row>
 	</tbody>
       </tgroup>
-- 
1.7.4.1

