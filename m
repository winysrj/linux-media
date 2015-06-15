Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50787 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbbFOLlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:41:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/14] DocBook/media: fix bad spacing in VIDIOC_EXPBUF
Date: Mon, 15 Jun 2015 13:33:41 +0200
Message-Id: <1434368021-7467-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The VIDIOC_EXPBUF documentation had spurious spaces that made it irritating
to read. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml | 38 +++++++++++------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
index a78c920..0ae0b6a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -62,28 +62,28 @@ buffer as a DMABUF file at any time after buffers have been allocated with the
 &VIDIOC-REQBUFS; ioctl.</para>
 
 <para> To export a buffer, applications fill &v4l2-exportbuffer;.  The
-<structfield> type </structfield> field is set to the same buffer type as was
-previously used with  &v4l2-requestbuffers;<structfield> type </structfield>.
-Applications must also set the <structfield> index </structfield> field. Valid
+<structfield>type</structfield> field is set to the same buffer type as was
+previously used with &v4l2-requestbuffers; <structfield>type</structfield>.
+Applications must also set the <structfield>index</structfield> field. Valid
 index numbers range from zero to the number of buffers allocated with
-&VIDIOC-REQBUFS; (&v4l2-requestbuffers;<structfield> count </structfield>)
-minus one.  For the multi-planar API, applications set the <structfield> plane
-</structfield> field to the index of the plane to be exported. Valid planes
+&VIDIOC-REQBUFS; (&v4l2-requestbuffers; <structfield>count</structfield>)
+minus one.  For the multi-planar API, applications set the <structfield>plane</structfield>
+field to the index of the plane to be exported. Valid planes
 range from zero to the maximal number of valid planes for the currently active
-format. For the single-planar API, applications must set <structfield> plane
-</structfield> to zero.  Additional flags may be posted in the <structfield>
-flags </structfield> field.  Refer to a manual for open() for details.
+format. For the single-planar API, applications must set <structfield>plane</structfield>
+to zero.  Additional flags may be posted in the <structfield>flags</structfield>
+field.  Refer to a manual for open() for details.
 Currently only O_CLOEXEC, O_RDONLY, O_WRONLY, and O_RDWR are supported.  All
 other fields must be set to zero.
 In the case of multi-planar API, every plane is exported separately using
-multiple <constant> VIDIOC_EXPBUF </constant> calls. </para>
+multiple <constant>VIDIOC_EXPBUF</constant> calls.</para>
 
-<para> After calling <constant>VIDIOC_EXPBUF</constant> the <structfield> fd
-</structfield> field will be set by a driver.  This is a DMABUF file
+<para>After calling <constant>VIDIOC_EXPBUF</constant> the <structfield>fd</structfield>
+field will be set by a driver.  This is a DMABUF file
 descriptor. The application may pass it to other DMABUF-aware devices. Refer to
 <link linkend="dmabuf">DMABUF importing</link> for details about importing
 DMABUF files into V4L2 nodes. It is recommended to close a DMABUF file when it
-is no longer used to allow the associated memory to be reclaimed. </para>
+is no longer used to allow the associated memory to be reclaimed.</para>
   </refsect1>
 
   <refsect1>
@@ -170,9 +170,9 @@ multi-planar API. Otherwise this value must be set to zero. </entry>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>flags</structfield></entry>
-	    <entry>Flags for the newly created file, currently only <constant>
-O_CLOEXEC </constant>, <constant>O_RDONLY</constant>, <constant>O_WRONLY
-</constant>, and <constant>O_RDWR</constant> are supported, refer to the manual
+	    <entry>Flags for the newly created file, currently only
+<constant>O_CLOEXEC</constant>, <constant>O_RDONLY</constant>, <constant>O_WRONLY</constant>,
+and <constant>O_RDWR</constant> are supported, refer to the manual
 of open() for more details.</entry>
 	  </row>
 	  <row>
@@ -200,9 +200,9 @@ set the array to zero.</entry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>A queue is not in MMAP mode or DMABUF exporting is not
-supported or <structfield> flags </structfield> or <structfield> type
-</structfield> or <structfield> index </structfield> or <structfield> plane
-</structfield> fields are invalid.</para>
+supported or <structfield>flags</structfield> or <structfield>type</structfield>
+or <structfield>index</structfield> or <structfield>plane</structfield> fields
+are invalid.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
2.1.4

