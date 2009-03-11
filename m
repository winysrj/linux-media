Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58967 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZCKTa1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 15:30:27 -0400
Subject: [REVIEW] Draft of V4L2 API and spec changes for
 V4L2_MPEG_STREAM_VBI_FMT_IVTV
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, hverkuil@xs4all.nl
Content-Type: text/plain
Date: Wed, 11 Mar 2009 15:25:28 -0400
Message-Id: <1236799528.3111.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

The inline diff below has my completed draft of V4L2 API and
Specifcation changes to add proper definitions and documentation for the
MPEG stream embedded, sliced VBI data format triggered by the
V4L2_MPEG_STREAM_VBI_FMT_IVTV control setting.  These changes only add
to the V4L2 API and do modify or remove exiting elements.

Please review.  The only question remaining in my mind is whether the
type "__le32" can be used in the userspace API structures.  I think it
can, but I don't know what kernel version introduced "__le32".


Mauro,

When I make a pull request for this, do you want 1 request, or separate
requests for videodev2.h changes and v4l2-spec changes?


Regards,
Andy

diff -r 5361470b10f4 linux/include/linux/ivtv.h
--- a/linux/include/linux/ivtv.h	Sun Mar 01 21:10:07 2009 -0500
+++ b/linux/include/linux/ivtv.h	Wed Mar 11 15:09:50 2009 -0400
@@ -60,10 +60,10 @@
 
 #define IVTV_IOC_DMA_FRAME  _IOW ('V', BASE_VIDIOC_PRIVATE+0, struct ivtv_dma_frame)
 
-/* These are the VBI types as they appear in the embedded VBI private packets. */
-#define IVTV_SLICED_TYPE_TELETEXT_B     (1)
-#define IVTV_SLICED_TYPE_CAPTION_525    (4)
-#define IVTV_SLICED_TYPE_WSS_625        (5)
-#define IVTV_SLICED_TYPE_VPS            (7)
+/* Deprecated defines: applications should use the defines from videodev2.h */
+#define IVTV_SLICED_TYPE_TELETEXT_B     V4L2_MPEG_VBI_IVTV_TELETEXT_B
+#define IVTV_SLICED_TYPE_CAPTION_525    V4L2_MPEG_VBI_IVTV_CAPTION_525
+#define IVTV_SLICED_TYPE_WSS_625        V4L2_MPEG_VBI_IVTV_WSS_625
+#define IVTV_SLICED_TYPE_VPS            V4L2_MPEG_VBI_IVTV_VPS
 
 #endif /* _LINUX_IVTV_H */
diff -r 5361470b10f4 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Sun Mar 01 21:10:07 2009 -0500
+++ b/linux/include/linux/videodev2.h	Wed Mar 11 15:09:50 2009 -0400
@@ -1348,6 +1348,53 @@
 };
 
 /*
+ * Sliced VBI data inserted into MPEG Streams
+ */
+
+/*
+ * V4L2_MPEG_STREAM_VBI_FMT_IVTV:
+ *
+ * Structure of payload contained in an MPEG 2 Private Stream 1 PES Packet in an
+ * MPEG-2 Program Pack that contains V4L2_MPEG_STREAM_VBI_FMT_IVTV Sliced VBI
+ * data
+ *
+ * Note, the MPEG-2 Program Pack and Private Stream 1 PES packet header
+ * definitions are not included here.  See the MPEG-2 specifications for details
+ * on these headers.
+ */
+
+/* Line type IDs */
+#define V4L2_MPEG_VBI_IVTV_TELETEXT_B     (1)
+#define V4L2_MPEG_VBI_IVTV_CAPTION_525    (4)
+#define V4L2_MPEG_VBI_IVTV_WSS_625        (5)
+#define V4L2_MPEG_VBI_IVTV_VPS            (7)
+
+struct v4l2_mpeg_vbi_itv0_line {
+	__u8 id;	/* One of V4L2_MPEG_VBI_IVTV_* above */
+	__u8 data[42];	/* Sliced VBI data for the line */
+} __attribute__ ((packed));
+
+struct v4l2_mpeg_vbi_itv0 {
+	__le32 linemask[2]; /* Bitmasks of VBI service lines present */
+	struct v4l2_mpeg_vbi_itv0_line line[35];
+} __attribute__ ((packed));
+
+struct v4l2_mpeg_vbi_ITV0 {
+	struct v4l2_mpeg_vbi_itv0_line line[36];
+} __attribute__ ((packed));
+
+#define V4L2_MPEG_VBI_IVTV_MAGIC0	"itv0"
+#define V4L2_MPEG_VBI_IVTV_MAGIC1	"ITV0"
+
+struct v4l2_mpeg_vbi_fmt_ivtv {
+	__u8 magic[4];
+	union {
+		struct v4l2_mpeg_vbi_itv0 itv0;
+		struct v4l2_mpeg_vbi_ITV0 ITV0;
+	};
+} __attribute__ ((packed));
+
+/*
  *	A G G R E G A T E   S T R U C T U R E S
  */
 
diff -r 5361470b10f4 v4l2-spec/Makefile
--- a/v4l2-spec/Makefile	Sun Mar 01 21:10:07 2009 -0500
+++ b/v4l2-spec/Makefile	Wed Mar 11 15:09:50 2009 -0400
@@ -274,6 +274,7 @@
 	v4l2_input \
 	v4l2_jpegcompression \
 	v4l2_modulator \
+	v4l2_mpeg_vbi_fmt_ivtv \
 	v4l2_output \
 	v4l2_outputparm \
 	v4l2_pix_format \
diff -r 5361470b10f4 v4l2-spec/dev-sliced-vbi.sgml
--- a/v4l2-spec/dev-sliced-vbi.sgml	Sun Mar 01 21:10:07 2009 -0500
+++ b/v4l2-spec/dev-sliced-vbi.sgml	Wed Mar 11 15:09:50 2009 -0400
@@ -48,7 +48,7 @@
 supported.</para>
   </section>
 
-  <section>
+  <section id="sliced-vbi-format-negotitation">
     <title>Sliced VBI Format Negotiation</title>
 
     <para>To find out which data services are supported by the
@@ -386,6 +386,319 @@
 
   </section>
 
+  <section>
+    <title>Sliced VBI Data in MPEG Streams</title>
+
+    <para>If a device can produce an MPEG output stream, it may be
+capable of providing <link 
+linkend="sliced-vbi-format-negotitation">negotiated sliced VBI
+services</link> as data embedded in the MPEG stream.  Users or
+applications control this sliced VBI data insertion with the <link
+linkend="v4l2-mpeg-stream-vbi-fmt">V4L2_CID_MPEG_STREAM_VBI_FMT</link>
+control.</para>
+
+    <para>If the driver does not provide the <link
+linkend="v4l2-mpeg-stream-vbi-fmt">V4L2_CID_MPEG_STREAM_VBI_FMT</link>
+control, or only allows that control to be set to <link
+linkend="v4l2-mpeg-stream-vbi-fmt"><constant>
+V4L2_MPEG_STREAM_VBI_FMT_NONE</constant></link>, then the device
+cannot embed sliced VBI data in the MPEG stream.</para>
+
+    <para>The <link linkend="v4l2-mpeg-stream-vbi-fmt">
+V4L2_CID_MPEG_STREAM_VBI_FMT</link> control does not implicitly set
+the device driver to capture nor cease capturing sliced VBI data.  The
+control only indicates to embed sliced VBI data in the MPEG stream, if
+an application has negotiated sliced VBI service be captured.</para>
+
+    <para>It may also be the case that a device can embed sliced VBI
+data in only certain types of MPEG streams: for example in an MPEG-2
+PS but not an MPEG-2 TS.  In this situation, if sliced VBI data
+insertion is requested, the sliced VBI data will be embedded in MPEG
+stream types when supported, and silently omitted from MPEG stream
+types where sliced VBI data insertion is not supported by the device.
+</para>
+
+    <para>The following subsections specify the format of the
+embedded sliced VBI data.</para>
+
+  <section>
+    <title>MPEG Stream Embedded, Sliced VBI Data Format: NONE</title>
+    <para>The <link linkend="v4l2-mpeg-stream-vbi-fmt"><constant>
+V4L2_MPEG_STREAM_VBI_FMT_NONE</constant></link> embedded sliced VBI
+format shall be interpreted by drivers as a control to cease
+embedding sliced VBI data in MPEG streams.  Neither the device nor
+driver shall insert "empty" embedded sliced VBI data packets in the
+MPEG stream when this format is set.  No MPEG stream data structures
+are specified for this format.</para>
+  </section>
+
+  <section>
+    <title>MPEG Stream Embedded, Sliced VBI Data Format: IVTV</title>
+    <para>The <link linkend="v4l2-mpeg-stream-vbi-fmt"><constant>
+V4L2_MPEG_STREAM_VBI_FMT_IVTV</constant></link> embedded sliced VBI
+format, when supported, indicates to the driver to embed up to 36
+lines of sliced VBI data per frame in an MPEG-2 <emphasis>Private
+Stream 1 PES</emphasis> packet encapsulated in an MPEG-2 <emphasis>
+Program Pack</emphasis> in the MPEG stream.</para>
+
+    <para><emphasis>Historical context</emphasis>: This format
+specification originates from a custom, embedded, sliced VBI data
+format used by the <filename>ivtv</filename> driver.  This format
+has already been informally specified in the kernel sources in the
+file <filename>Documentation/video4linux/cx2341x/README.vbi</filename>
+.  The maximum size of the payload and other aspects of this format
+are driven by the CX23415 MPEG decoder's capabilities and limitations
+with respect to extracting, decoding, and displaying sliced VBI data
+embedded within an MPEG stream.</para>
+
+    <para>This format's use is <emphasis>not</emphasis> exclusive to
+the <filename>ivtv</filename> driver <emphasis>nor</emphasis>
+exclusive to CX2341x devices, as the sliced VBI data packet insertion
+into the MPEG stream is implemented in driver software.  At least the
+<filename>cx18</filename> driver provides sliced VBI data insertion
+into an MPEG-2 PS in this format as well.</para>
+
+    <para>The following definitions specify the payload of the
+MPEG-2 <emphasis>Private Stream 1 PES</emphasis> packets that contain
+sliced VBI data when <link linkend="v4l2-mpeg-stream-vbi-fmt">
+<constant>V4L2_MPEG_STREAM_VBI_FMT_IVTV</constant></link> is set.
+(The MPEG-2 <emphasis>Private Stream 1 PES</emphasis> packet header
+and encapsulating MPEG-2 <emphasis>Program Pack</emphasis> header are
+not detailed here.  Please refer to the MPEG-2 specifications for
+details on those packet headers.)</para>
+
+    <para>The payload of the MPEG-2 <emphasis>Private Stream 1 PES
+</emphasis> packets that contain sliced VBI data is specified by
+&v4l2-mpeg-vbi-fmt-ivtv;.  The payload is variable
+length, depending on the actual number of lines of sliced VBI data
+present in a video frame.  The payload may be padded at the end with
+unspecified fill bytes to align the end of the payload to a 4-byte
+boundary.  The payload shall never exceed 1552 bytes (2 fields with
+18 lines/field with 43 bytes of data/line and a 4 byte magic number).
+</para>
+
+    <table frame="none" pgwide="1" id="v4l2-mpeg-vbi-fmt-ivtv">
+      <title>struct <structname>v4l2_mpeg_vbi_fmt_ivtv</structname>
+      </title>
+      <tgroup cols="4">
+	&cs-ustr;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>magic</structfield>[4]</entry>
+	    <entry></entry>
+	    <entry>A "magic" constant from <xref
+	    linkend="v4l2-mpeg-vbi-fmt-ivtv-magic"> that indicates
+this is a valid sliced VBI data payload and also indicates which
+member of the anonymous union, <structfield>itv0</structfield> or 
+<structfield>ITV0</structfield>, to use for the payload data.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry>(anonymous)</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+            <entry>struct <link linkend="v4l2-mpeg-vbi-itv0">
+              <structname>v4l2_mpeg_vbi_itv0</structname></link>
+            </entry>
+	    <entry><structfield>itv0</structfield></entry>
+	    <entry>The primary form of the sliced VBI data payload
+that contains anywhere from 1 to 35 lines of sliced VBI data.
+Line masks are provided in this form of the payload indicating
+which VBI lines are provided.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+            <entry>struct <link linkend="v4l2-mpeg-vbi-ITV0-1">
+              <structname>v4l2_mpeg_vbi_ITV0</structname></link>
+            </entry>
+	    <entry><structfield>ITV0</structfield></entry>
+	    <entry>An alternate form of the sliced VBI data payload
+used when 36 lines of sliced VBI data are present.  No line masks are
+provided in this form of the payload; all valid line mask bits are
+implcitly set.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="v4l2-mpeg-vbi-fmt-ivtv-magic">
+      <title>Magic Constants for &v4l2-mpeg-vbi-fmt-ivtv;
+        <structfield>magic</structfield> field</title>
+      <tgroup cols="3">
+	&cs-def;
+	<thead>
+	  <row>
+	    <entry align="left">Defined Symbol</entry>
+	    <entry align="left">Value</entry>
+	    <entry align="left">Description</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_MPEG_VBI_IVTV_MAGIC0</constant>
+	    </entry>
+	    <entry>"itv0"</entry>
+	    <entry>Indicates the <structfield>itv0</structfield>
+member of the union in &v4l2-mpeg-vbi-fmt-ivtv; is valid.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_MPEG_VBI_IVTV_MAGIC1</constant>
+	    </entry>
+	    <entry>"ITV0"</entry>
+	    <entry>Indicates the <structfield>ITV0</structfield>
+member of the union in &v4l2-mpeg-vbi-fmt-ivtv; is valid and
+that 36 lines of sliced VBI data are present.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="v4l2-mpeg-vbi-itv0">
+      <title>struct <structname>v4l2_mpeg_vbi_itv0</structname>
+      </title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__le32</entry>
+	    <entry><structfield>linemask</structfield>[2]</entry>
+	    <entry><para>Bitmasks indicating the VBI service lines
+present.  These <structfield>linemask</structfield> values are stored
+in little endian byte order in the MPEG stream.  Some reference
+<structfield>linemask</structfield> bit positions with their
+corresponding VBI line number and video field are given below.
+b<subscript>0</subscript> indicates the least significant bit of a
+<structfield>linemask</structfield> value:<screen>
+<structfield>linemask</structfield>[0] b<subscript>0</subscript>:		line  6		first field
+<structfield>linemask</structfield>[0] b<subscript>17</subscript>:		line 23		first field
+<structfield>linemask</structfield>[0] b<subscript>18</subscript>:		line  6		second field
+<structfield>linemask</structfield>[0] b<subscript>31</subscript>:		line 19		second field
+<structfield>linemask</structfield>[1] b<subscript>0</subscript>:		line 20		second field
+<structfield>linemask</structfield>[1] b<subscript>3</subscript>:		line 23		second field
+<structfield>linemask</structfield>[1] b<subscript>4</subscript>-b<subscript>31</subscript>:	unused and set to 0</screen></para></entry>
+	  </row>
+	  <row>
+            <entry>struct <link linkend="v4l2-mpeg-vbi-itv0-line">
+              <structname>v4l2_mpeg_vbi_itv0_line</structname></link>
+            </entry>
+	    <entry><structfield>line</structfield>[35]</entry>
+	    <entry>This is a variable length array that holds from 1
+to 35 lines of sliced VBI data.  The sliced VBI data lines present
+correspond to the bits set in the <structfield>linemask</structfield>
+array, starting from b<subscript>0</subscript> of <structfield>
+linemask</structfield>[0] up through b<subscript>31</subscript> of
+<structfield>linemask</structfield>[0], and from b<subscript>0
+</subscript> of <structfield>linemask</structfield>[1] up through b
+<subscript>3</subscript> of <structfield>linemask</structfield>[1].
+<structfield>line</structfield>[0] corresponds to the first bit
+found set in the <structfield>linemask</structfield> array,
+<structfield>line</structfield>[1] corresponds to the second bit
+found set in the <structfield>linemask</structfield> array, etc.
+If no <structfield>linemask</structfield> array bits are set, then
+<structfield>line</structfield>[0] may contain one line of
+unspecified data that should be ignored by applications.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="v4l2-mpeg-vbi-ITV0-1">
+      <title>struct <structname>v4l2_mpeg_vbi_ITV0</structname>
+      </title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+            <entry>struct <link linkend="v4l2-mpeg-vbi-itv0-line">
+              <structname>v4l2_mpeg_vbi_itv0_line</structname></link>
+            </entry>
+	    <entry><structfield>line</structfield>[36]</entry>
+	    <entry>A fixed length array of 36 lines of sliced VBI
+data.  <structfield>line</structfield>[0] through <structfield>line
+</structfield>[17] correspond to lines 6 through 23 of the
+first field.  <structfield>line</structfield>[18] through
+<structfield>line</structfield>[35] corresponds to lines 6
+through 23 of the second field.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="v4l2-mpeg-vbi-itv0-line">
+      <title>struct <structname>v4l2_mpeg_vbi_itv0_line</structname>
+      </title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>id</structfield></entry>
+	    <entry>A line identifier value from
+<xref linkend="ITV0-Line-Identifier-Constants"> that indicates
+the type of sliced VBI data stored on this line.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8</entry>
+	    <entry><structfield>data</structfield>[42]</entry>
+	    <entry>The sliced VBI data for the line.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="ITV0-Line-Identifier-Constants">
+      <title>Line Identifiers for struct <link
+      linkend="v4l2-mpeg-vbi-itv0-line"><structname>
+v4l2_mpeg_vbi_itv0_line</structname></link> <structfield>id
+</structfield> field</title>
+      <tgroup cols="3">
+	&cs-def;
+	<thead>
+	  <row>
+	    <entry align="left">Defined Symbol</entry>
+	    <entry align="left">Value</entry>
+	    <entry align="left">Decription</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_MPEG_VBI_IVTV_TELETEXT_B</constant>
+	    </entry>
+	    <entry>1</entry>
+	    <entry>Refer to <link linkend="vbi-services2">
+Sliced VBI services</link> for a description of the line payload.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_MPEG_VBI_IVTV_CAPTION_525</constant>
+	    </entry>
+	    <entry>4</entry>
+	    <entry>Refer to <link linkend="vbi-services2">
+Sliced VBI services</link> for a description of the line payload.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_MPEG_VBI_IVTV_WSS_625</constant>
+	    </entry>
+	    <entry>5</entry>
+	    <entry>Refer to <link linkend="vbi-services2">
+Sliced VBI services</link> for a description of the line payload.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_MPEG_VBI_IVTV_VPS</constant>
+	    </entry>
+	    <entry>7</entry>
+	    <entry>Refer to <link linkend="vbi-services2">
+Sliced VBI services</link> for a description of the line payload.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </section>
+  </section>
+
+
 <!--
 Local Variables:
 mode: sgml
diff -r 5361470b10f4 v4l2-spec/v4l2.sgml
--- a/v4l2-spec/v4l2.sgml	Sun Mar 01 21:10:07 2009 -0500
+++ b/v4l2-spec/v4l2.sgml	Wed Mar 11 15:09:50 2009 -0400
@@ -25,7 +25,7 @@
 <book id="v4l2spec">
   <bookinfo>
     <title>Video for Linux Two API Specification</title>
-    <subtitle>Revision 0.25</subtitle>
+    <subtitle>Revision 0.26</subtitle>
 
     <authorgroup>
       <author>
@@ -77,6 +77,19 @@
 	<contrib>Designed and documented the VIDIOC_ENUM_FRAMESIZES
 and VIDIOC_ENUM_FRAMEINTERVALS ioctls.</contrib>
       </author>
+
+      <author>
+	<firstname>Andy</firstname>
+	<surname>Walls</surname>
+	<contrib>Documented the fielded V4L2_MPEG_STREAM_VBI_FMT_IVTV
+MPEG stream embedded, sliced VBI data format in this specification.
+</contrib>
+	<affiliation>
+	  <address>
+	    <email>awalls@radix.net</email>
+	  </address>
+	</affiliation>
+      </author>
     </authorgroup>
 
     <copyright>
@@ -92,12 +105,12 @@
       <year>2008</year>
       <year>2009</year>
       <holder>Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin
-Rubli</holder>
+Rubli, Andy Walls</holder>
     </copyright>
 
     <legalnotice>
       <para>This document is copyrighted &copy; 1999-2009 by Bill
-Dirks, Michael H. Schimek, Hans Verkuil and Martin Rubli.</para>
+Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, and Andy Walls.</para>
 
       <para>Permission is granted to copy, distribute and/or modify
 this document under the terms of the GNU Free Documentation License,
@@ -116,6 +129,14 @@
 structs, ioctls) must be noted in more detail in the history chapter
 (compat.sgml), along with the possible impact on existing drivers and
 applications. -->
+
+      <revision>
+	<revnumber>0.26</revnumber>
+	<date>2009-03-11</date>
+	<authorinitials>aw</authorinitials>
+	<revremark>Added the fielded V4L2_MPEG_STREAM_VBI_FMT_IVTV
+MPEG stream embedded, sliced VBI data format.</revremark>
+      </revision>
 
       <revision>
 	<revnumber>0.25</revnumber>


