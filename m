Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:37906 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbZCZPFk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 11:05:40 -0400
Date: Thu, 26 Mar 2009 16:05:38 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: [patch] add documentation for planar YUV 4:4:4 format
Message-ID: <20090326150538.GB28126@emlix.com>
References: <1238077846-25751-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238077846-25751-1-git-send-email-dg@emlix.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the planar YUV 4:4:4 format to the v4l2 specification.

Signed-off-by: Daniel Glöckner <dg@emlix.com>

diff -r 55df63b82fef -r bd23aedbd597 v4l2-spec/Makefile
--- a/v4l2-spec/Makefile	Thu Mar 26 09:13:40 2009 +0100
+++ b/v4l2-spec/Makefile	Thu Mar 26 14:06:09 2009 +0100
@@ -48,6 +48,7 @@
 	pixfmt-yuv411p.sgml \
 	pixfmt-yuv420.sgml \
 	pixfmt-yuv422p.sgml \
+	pixfmt-yuv444p.sgml \
 	pixfmt-yuyv.sgml \
 	pixfmt-yvyu.sgml \
 	pixfmt.sgml \
diff -r 55df63b82fef -r bd23aedbd597 v4l2-spec/pixfmt-yuv444p.sgml
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-spec/pixfmt-yuv444p.sgml	Thu Mar 26 14:06:09 2009 +0100
@@ -0,0 +1,171 @@
+    <refentry id="V4L2-PIX-FMT-YUV444P">
+      <refmeta>
+	<refentrytitle>V4L2_PIX_FMT_YUV444P ('444P')</refentrytitle>
+	&manvol;
+      </refmeta>
+      <refnamediv>
+	<refname><constant>V4L2_PIX_FMT_YUV444P</constant></refname>
+	<refpurpose>Format with full horizontal and vertical chroma resolution,
+also known as YUV 4:4:4. Planar layout</refpurpose>
+      </refnamediv>
+      <refsect1>
+	<title>Description</title>
+
+	<para>This format is not commonly used. The three components are
+separated into three sub-images or planes. The Y plane is first. The Cb plane
+immediately follows the Y plane in memory. Following the Cb plane is the Cr
+plane. All planes have on byte per pixel.</para>
+
+	<para>If the Y plane has pad bytes after each row, then the Cr
+and Cb planes have the same number of pad bytes after their rows. In other
+words, one Cx row (including padding) is exactly as long as one Y row
+(including padding).</para>
+
+	<example>
+	  <title><constant>V4L2_PIX_FMT_YUV444P</constant> 4 &times; 4
+pixel image</title>
+
+	  <formalpara>
+	    <title>Byte Order.</title>
+	    <para>Each cell is one byte.
+		<informaltable frame="none">
+		<tgroup cols="5" align="center">
+		  <colspec align="left" colwidth="2*">
+		  <tbody valign="top">
+		    <row>
+		      <entry>start&nbsp;+&nbsp;0:</entry>
+		      <entry>Y'<subscript>00</subscript></entry>
+		      <entry>Y'<subscript>01</subscript></entry>
+		      <entry>Y'<subscript>02</subscript></entry>
+		      <entry>Y'<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;4:</entry>
+		      <entry>Y'<subscript>10</subscript></entry>
+		      <entry>Y'<subscript>11</subscript></entry>
+		      <entry>Y'<subscript>12</subscript></entry>
+		      <entry>Y'<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;8:</entry>
+		      <entry>Y'<subscript>20</subscript></entry>
+		      <entry>Y'<subscript>21</subscript></entry>
+		      <entry>Y'<subscript>22</subscript></entry>
+		      <entry>Y'<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;12:</entry>
+		      <entry>Y'<subscript>30</subscript></entry>
+		      <entry>Y'<subscript>31</subscript></entry>
+		      <entry>Y'<subscript>32</subscript></entry>
+		      <entry>Y'<subscript>33</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;16:</entry>
+		      <entry>Cb<subscript>00</subscript></entry>
+		      <entry>Cb<subscript>01</subscript></entry>
+		      <entry>Cb<subscript>02</subscript></entry>
+		      <entry>Cb<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;20:</entry>
+		      <entry>Cb<subscript>10</subscript></entry>
+		      <entry>Cb<subscript>11</subscript></entry>
+		      <entry>Cb<subscript>12</subscript></entry>
+		      <entry>Cb<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;24:</entry>
+		      <entry>Cb<subscript>20</subscript></entry>
+		      <entry>Cb<subscript>21</subscript></entry>
+		      <entry>Cb<subscript>22</subscript></entry>
+		      <entry>Cb<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;28:</entry>
+		      <entry>Cb<subscript>30</subscript></entry>
+		      <entry>Cb<subscript>31</subscript></entry>
+		      <entry>Cb<subscript>32</subscript></entry>
+		      <entry>Cb<subscript>33</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;32:</entry>
+		      <entry>Cr<subscript>00</subscript></entry>
+		      <entry>Cr<subscript>01</subscript></entry>
+		      <entry>Cr<subscript>02</subscript></entry>
+		      <entry>Cr<subscript>03</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;36:</entry>
+		      <entry>Cr<subscript>10</subscript></entry>
+		      <entry>Cr<subscript>11</subscript></entry>
+		      <entry>Cr<subscript>12</subscript></entry>
+		      <entry>Cr<subscript>13</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;40:</entry>
+		      <entry>Cr<subscript>20</subscript></entry>
+		      <entry>Cr<subscript>21</subscript></entry>
+		      <entry>Cr<subscript>22</subscript></entry>
+		      <entry>Cr<subscript>23</subscript></entry>
+		    </row>
+		    <row>
+		      <entry>start&nbsp;+&nbsp;44:</entry>
+		      <entry>Cr<subscript>30</subscript></entry>
+		      <entry>Cr<subscript>31</subscript></entry>
+		      <entry>Cr<subscript>32</subscript></entry>
+		      <entry>Cr<subscript>33</subscript></entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+
+	  <formalpara>
+	    <title>Color Sample Location.</title>
+	    <para>
+		<informaltable frame="none">
+		<tgroup cols="5" align="center">
+		  <tbody valign="top">
+		    <row>
+		      <entry></entry>
+		      <entry>0</entry><entry>1</entry>
+		      <entry>2</entry><entry>3</entry>
+		    </row>
+		    <row>
+		      <entry>0</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		    </row>
+		    <row>
+		      <entry>1</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		    </row>
+		    <row>
+		      <entry>2</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		    </row>
+		    <row>
+		      <entry>3</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		      <entry>Y/C</entry><entry>Y/C</entry>
+		    </row>
+		  </tbody>
+		</tgroup>
+		</informaltable>
+	      </para>
+	  </formalpara>
+	</example>
+      </refsect1>
+    </refentry>
+
+  <!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "pixfmt.sgml"
+indent-tabs-mode: nil
+End:
+  -->
diff -r 55df63b82fef -r bd23aedbd597 v4l2-spec/pixfmt.sgml
--- a/v4l2-spec/pixfmt.sgml	Thu Mar 26 09:13:40 2009 +0100
+++ b/v4l2-spec/pixfmt.sgml	Thu Mar 26 14:06:09 2009 +0100
@@ -596,6 +596,7 @@
     &sub-y41p;
     &sub-yuv420;
     &sub-yuv410;
+    &sub-yuv444p;
     &sub-yuv422p;
     &sub-yuv411p;
     &sub-nv12;
