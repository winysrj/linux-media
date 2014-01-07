Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3418 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaAGNHN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:07:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] DocBook media: drop the old incorrect packed RGB table.
Date: Tue,  7 Jan 2014 14:06:57 +0100
Message-Id: <1389100017-42855-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The old table is most definitely wrong. All applications and all
drivers that I have ever tested follow the corrected table. Furthermore,
that's what all applications expect as well. Any drivers that do not
follow the corrected table are broken and should be fixed.

This patch drops the old table and replaces it with the corrected
table. This should prevent a lot of confusion.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 513 ++-------------------
 1 file changed, 49 insertions(+), 464 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 166c8d6..e1c4f8b 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -121,14 +121,14 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry><constant>V4L2_PIX_FMT_RGB332</constant></entry>
 	    <entry>'RGB1'</entry>
 	    <entry></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
 	    <entry>r<subscript>2</subscript></entry>
 	    <entry>r<subscript>1</subscript></entry>
 	    <entry>r<subscript>0</subscript></entry>
+	    <entry>g<subscript>2</subscript></entry>
+	    <entry>g<subscript>1</subscript></entry>
+	    <entry>g<subscript>0</subscript></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
 	  </row>
 	  <row id="V4L2-PIX-FMT-RGB444">
 	    <entry><constant>V4L2_PIX_FMT_RGB444</constant></entry>
@@ -159,18 +159,18 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>g<subscript>2</subscript></entry>
 	    <entry>g<subscript>1</subscript></entry>
 	    <entry>g<subscript>0</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>a</entry>
 	    <entry>b<subscript>4</subscript></entry>
 	    <entry>b<subscript>3</subscript></entry>
 	    <entry>b<subscript>2</subscript></entry>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
+	    <entry></entry>
+	    <entry>a</entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
 	    <entry>g<subscript>4</subscript></entry>
 	    <entry>g<subscript>3</subscript></entry>
 	  </row>
@@ -181,17 +181,17 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>g<subscript>2</subscript></entry>
 	    <entry>g<subscript>1</subscript></entry>
 	    <entry>g<subscript>0</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
 	    <entry>b<subscript>4</subscript></entry>
 	    <entry>b<subscript>3</subscript></entry>
 	    <entry>b<subscript>2</subscript></entry>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
+	    <entry></entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
 	    <entry>g<subscript>5</subscript></entry>
 	    <entry>g<subscript>4</subscript></entry>
 	    <entry>g<subscript>3</subscript></entry>
@@ -201,32 +201,32 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>'RGBQ'</entry>
 	    <entry></entry>
 	    <entry>a</entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
 	    <entry>r<subscript>4</subscript></entry>
 	    <entry>r<subscript>3</subscript></entry>
 	    <entry>r<subscript>2</subscript></entry>
 	    <entry>r<subscript>1</subscript></entry>
 	    <entry>r<subscript>0</subscript></entry>
-	  </row>
-	  <row id="V4L2-PIX-FMT-RGB565X">
-	    <entry><constant>V4L2_PIX_FMT_RGB565X</constant></entry>
-	    <entry>'RGBR'</entry>
+	    <entry>g<subscript>4</subscript></entry>
+	    <entry>g<subscript>3</subscript></entry>
 	    <entry></entry>
+	    <entry>g<subscript>2</subscript></entry>
+	    <entry>g<subscript>1</subscript></entry>
+	    <entry>g<subscript>0</subscript></entry>
 	    <entry>b<subscript>4</subscript></entry>
 	    <entry>b<subscript>3</subscript></entry>
 	    <entry>b<subscript>2</subscript></entry>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-RGB565X">
+	    <entry><constant>V4L2_PIX_FMT_RGB565X</constant></entry>
+	    <entry>'RGBR'</entry>
+	    <entry></entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
 	    <entry>g<subscript>5</subscript></entry>
 	    <entry>g<subscript>4</subscript></entry>
 	    <entry>g<subscript>3</subscript></entry>
@@ -234,11 +234,11 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>g<subscript>2</subscript></entry>
 	    <entry>g<subscript>1</subscript></entry>
 	    <entry>g<subscript>0</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
+	    <entry>b<subscript>4</subscript></entry>
+	    <entry>b<subscript>3</subscript></entry>
+	    <entry>b<subscript>2</subscript></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
 	  </row>
 	  <row id="V4L2-PIX-FMT-BGR666">
 	    <entry><constant>V4L2_PIX_FMT_BGR666</constant></entry>
@@ -385,6 +385,15 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry><constant>V4L2_PIX_FMT_RGB32</constant></entry>
 	    <entry>'RGB4'</entry>
 	    <entry></entry>
+	    <entry>a<subscript>7</subscript></entry>
+	    <entry>a<subscript>6</subscript></entry>
+	    <entry>a<subscript>5</subscript></entry>
+	    <entry>a<subscript>4</subscript></entry>
+	    <entry>a<subscript>3</subscript></entry>
+	    <entry>a<subscript>2</subscript></entry>
+	    <entry>a<subscript>1</subscript></entry>
+	    <entry>a<subscript>0</subscript></entry>
+	    <entry></entry>
 	    <entry>r<subscript>7</subscript></entry>
 	    <entry>r<subscript>6</subscript></entry>
 	    <entry>r<subscript>5</subscript></entry>
@@ -411,25 +420,16 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
 	    <entry>b<subscript>2</subscript></entry>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>a<subscript>7</subscript></entry>
-	    <entry>a<subscript>6</subscript></entry>
-	    <entry>a<subscript>5</subscript></entry>
-	    <entry>a<subscript>4</subscript></entry>
-	    <entry>a<subscript>3</subscript></entry>
-	    <entry>a<subscript>2</subscript></entry>
-	    <entry>a<subscript>1</subscript></entry>
-	    <entry>a<subscript>0</subscript></entry>
 	  </row>
 	</tbody>
       </tgroup>
     </table>
 
-    <para>Bit 7 is the most significant bit. The value of a = alpha
+    <para>Bit 7 is the most significant bit. The value of the a = alpha
 bits is undefined when reading from the driver, ignored when writing
 to the driver, except when alpha blending has been negotiated for a
 <link linkend="overlay">Video Overlay</link> or <link linkend="osd">
-Video Output Overlay</link> or when alpha component has been configured
+Video Output Overlay</link> or when the alpha component has been configured
 for a <link linkend="capture">Video Capture</link> by means of <link
 linkend="v4l2-alpha-component"> <constant>V4L2_CID_ALPHA_COMPONENT
 </constant> </link> control.</para>
@@ -512,421 +512,6 @@ image</title>
       </formalpara>
     </example>
 
-    <important>
-      <para>Drivers may interpret these formats differently.</para>
-    </important>
-
-    <para>Some RGB formats above are uncommon and were probably
-defined in error. Drivers may interpret them as in <xref
-	linkend="rgb-formats-corrected" />.</para>
-
-    <table pgwide="1" frame="none" id="rgb-formats-corrected">
-      <title>Packed RGB Image Formats (corrected)</title>
-      <tgroup cols="37" align="center">
-	<colspec colname="id" align="left" />
-	<colspec colname="fourcc" />
-	<colspec colname="bit" />
-
-	<colspec colnum="4" colname="b07" align="center" />
-	<colspec colnum="5" colname="b06" align="center" />
-	<colspec colnum="6" colname="b05" align="center" />
-	<colspec colnum="7" colname="b04" align="center" />
-	<colspec colnum="8" colname="b03" align="center" />
-	<colspec colnum="9" colname="b02" align="center" />
-	<colspec colnum="10" colname="b01" align="center" />
-	<colspec colnum="11" colname="b00" align="center" />
-
-	<colspec colnum="13" colname="b17" align="center" />
-	<colspec colnum="14" colname="b16" align="center" />
-	<colspec colnum="15" colname="b15" align="center" />
-	<colspec colnum="16" colname="b14" align="center" />
-	<colspec colnum="17" colname="b13" align="center" />
-	<colspec colnum="18" colname="b12" align="center" />
-	<colspec colnum="19" colname="b11" align="center" />
-	<colspec colnum="20" colname="b10" align="center" />
-
-	<colspec colnum="22" colname="b27" align="center" />
-	<colspec colnum="23" colname="b26" align="center" />
-	<colspec colnum="24" colname="b25" align="center" />
-	<colspec colnum="25" colname="b24" align="center" />
-	<colspec colnum="26" colname="b23" align="center" />
-	<colspec colnum="27" colname="b22" align="center" />
-	<colspec colnum="28" colname="b21" align="center" />
-	<colspec colnum="29" colname="b20" align="center" />
-
-	<colspec colnum="31" colname="b37" align="center" />
-	<colspec colnum="32" colname="b36" align="center" />
-	<colspec colnum="33" colname="b35" align="center" />
-	<colspec colnum="34" colname="b34" align="center" />
-	<colspec colnum="35" colname="b33" align="center" />
-	<colspec colnum="36" colname="b32" align="center" />
-	<colspec colnum="37" colname="b31" align="center" />
-	<colspec colnum="38" colname="b30" align="center" />
-
-	<spanspec namest="b07" nameend="b00" spanname="b0" />
-	<spanspec namest="b17" nameend="b10" spanname="b1" />
-	<spanspec namest="b27" nameend="b20" spanname="b2" />
-	<spanspec namest="b37" nameend="b30" spanname="b3" />
-	<thead>
-	  <row>
-	    <entry>Identifier</entry>
-	    <entry>Code</entry>
-	    <entry>&nbsp;</entry>
-	    <entry spanname="b0">Byte&nbsp;0 in memory</entry>
-	    <entry spanname="b1">Byte&nbsp;1</entry>
-	    <entry spanname="b2">Byte&nbsp;2</entry>
-	    <entry spanname="b3">Byte&nbsp;3</entry>
-	  </row>
-	  <row>
-	    <entry>&nbsp;</entry>
-	    <entry>&nbsp;</entry>
-	    <entry>Bit</entry>
-	    <entry>7</entry>
-	    <entry>6</entry>
-	    <entry>5</entry>
-	    <entry>4</entry>
-	    <entry>3</entry>
-	    <entry>2</entry>
-	    <entry>1</entry>
-	    <entry>0</entry>
-	    <entry>&nbsp;</entry>
-	    <entry>7</entry>
-	    <entry>6</entry>
-	    <entry>5</entry>
-	    <entry>4</entry>
-	    <entry>3</entry>
-	    <entry>2</entry>
-	    <entry>1</entry>
-	    <entry>0</entry>
-	    <entry>&nbsp;</entry>
-	    <entry>7</entry>
-	    <entry>6</entry>
-	    <entry>5</entry>
-	    <entry>4</entry>
-	    <entry>3</entry>
-	    <entry>2</entry>
-	    <entry>1</entry>
-	    <entry>0</entry>
-	    <entry>&nbsp;</entry>
-	    <entry>7</entry>
-	    <entry>6</entry>
-	    <entry>5</entry>
-	    <entry>4</entry>
-	    <entry>3</entry>
-	    <entry>2</entry>
-	    <entry>1</entry>
-	    <entry>0</entry>
-	  </row>
-	</thead>
-	<tbody valign="top">
-	  <row><!-- id="V4L2-PIX-FMT-RGB332" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB332</constant></entry>
-	    <entry>'RGB1'</entry>
-	    <entry></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB444" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB444</constant></entry>
-	    <entry>'R444'</entry>
-	    <entry></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>a<subscript>3</subscript></entry>
-	    <entry>a<subscript>2</subscript></entry>
-	    <entry>a<subscript>1</subscript></entry>
-	    <entry>a<subscript>0</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB555" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB555</constant></entry>
-	    <entry>'RGBO'</entry>
-	    <entry></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>a</entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB565" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB565</constant></entry>
-	    <entry>'RGBP'</entry>
-	    <entry></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB555X" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB555X</constant></entry>
-	    <entry>'RGBQ'</entry>
-	    <entry></entry>
-	    <entry>a</entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB565X" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB565X</constant></entry>
-	    <entry>'RGBR'</entry>
-	    <entry></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-BGR666" -->
-	    <entry><constant>V4L2_PIX_FMT_BGR666</constant></entry>
-	    <entry>'BGRH'</entry>
-	    <entry></entry>
-	    <entry>b<subscript>5</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>r<subscript>5</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-BGR24" -->
-	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
-	    <entry>'BGR3'</entry>
-	    <entry></entry>
-	    <entry>b<subscript>7</subscript></entry>
-	    <entry>b<subscript>6</subscript></entry>
-	    <entry>b<subscript>5</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>7</subscript></entry>
-	    <entry>g<subscript>6</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>r<subscript>7</subscript></entry>
-	    <entry>r<subscript>6</subscript></entry>
-	    <entry>r<subscript>5</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB24" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB24</constant></entry>
-	    <entry>'RGB3'</entry>
-	    <entry></entry>
-	    <entry>r<subscript>7</subscript></entry>
-	    <entry>r<subscript>6</subscript></entry>
-	    <entry>r<subscript>5</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>7</subscript></entry>
-	    <entry>g<subscript>6</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>b<subscript>7</subscript></entry>
-	    <entry>b<subscript>6</subscript></entry>
-	    <entry>b<subscript>5</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-BGR32" -->
-	    <entry><constant>V4L2_PIX_FMT_BGR32</constant></entry>
-	    <entry>'BGR4'</entry>
-	    <entry></entry>
-	    <entry>b<subscript>7</subscript></entry>
-	    <entry>b<subscript>6</subscript></entry>
-	    <entry>b<subscript>5</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>7</subscript></entry>
-	    <entry>g<subscript>6</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>r<subscript>7</subscript></entry>
-	    <entry>r<subscript>6</subscript></entry>
-	    <entry>r<subscript>5</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>a<subscript>7</subscript></entry>
-	    <entry>a<subscript>6</subscript></entry>
-	    <entry>a<subscript>5</subscript></entry>
-	    <entry>a<subscript>4</subscript></entry>
-	    <entry>a<subscript>3</subscript></entry>
-	    <entry>a<subscript>2</subscript></entry>
-	    <entry>a<subscript>1</subscript></entry>
-	    <entry>a<subscript>0</subscript></entry>
-	  </row>
-	  <row><!-- id="V4L2-PIX-FMT-RGB32" -->
-	    <entry><constant>V4L2_PIX_FMT_RGB32</constant></entry>
-	    <entry>'RGB4'</entry>
-	    <entry></entry>
-	    <entry>a<subscript>7</subscript></entry>
-	    <entry>a<subscript>6</subscript></entry>
-	    <entry>a<subscript>5</subscript></entry>
-	    <entry>a<subscript>4</subscript></entry>
-	    <entry>a<subscript>3</subscript></entry>
-	    <entry>a<subscript>2</subscript></entry>
-	    <entry>a<subscript>1</subscript></entry>
-	    <entry>a<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>r<subscript>7</subscript></entry>
-	    <entry>r<subscript>6</subscript></entry>
-	    <entry>r<subscript>5</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>7</subscript></entry>
-	    <entry>g<subscript>6</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry>b<subscript>7</subscript></entry>
-	    <entry>b<subscript>6</subscript></entry>
-	    <entry>b<subscript>5</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
     <para>A test utility to determine which RGB formats a driver
 actually supports is available from the LinuxTV v4l-dvb repository.
 See &v4l-dvb; for access instructions.</para>
-- 
1.8.5.2

