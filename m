Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3K2Wu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:50:58 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 3/6] v4l: Add media format codes for AHSV8888 on 32-bit busses
Date: Fri, 29 Nov 2013 23:50:49 +0100
Message-Id: <1385765452-25754-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 157 +++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                 |   3 +
 2 files changed, 160 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index f72c1cc..bfaef50 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2492,6 +2492,163 @@
     </section>
 
     <section>
+      <title>HSV/HSL Formats</title>
+
+      <para>Those formats transfer pixel data as RGB values in a cylindrical-coordinate
+      system using Hue-Saturation-Value or Hue-Saturation-Lightness components. The
+      format code is made of the following information.
+      <itemizedlist>
+	<listitem><para>The hue, saturation, value or lightness and optional alpha
+	components order code, as encoded in a pixel sample. The only currently
+	supported value is AHSV.
+	</para></listitem>
+	<listitem><para>The number of bits per component, for each component. The values
+	can be different for all components. The only currently supported value is 8888.
+	</para></listitem>
+	<listitem><para>The number of bus samples per pixel. Pixels that are wider than
+	the bus width must be transferred in multiple samples. The only currently
+	supported value is 1.</para></listitem>
+	<listitem><para>The bus width.</para></listitem>
+	<listitem><para>For formats where the total number of bits per pixel is smaller
+	than the number of bus samples per pixel times the bus width, a padding
+	value stating if the bytes are padded in their most high order bits
+	(PADHI) or low order bits (PADLO).</para></listitem>
+	<listitem><para>For formats where the number of bus samples per pixel is larger
+	than 1, an endianness value stating if the pixel is transferred MSB first
+	(BE) or LSB first (LE).</para></listitem>
+      </itemizedlist>
+      </para>
+
+      <para>The following table lists existing HSV/HSL formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-hsv">
+	<title>HSV/HSL formats</title>
+	<tgroup cols="27">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="center"/>
+	  <colspec colname="bit" />
+	  <colspec colnum="4" colname="b31" align="center" />
+	  <colspec colnum="5" colname="b20" align="center" />
+	  <colspec colnum="6" colname="b29" align="center" />
+	  <colspec colnum="7" colname="b28" align="center" />
+	  <colspec colnum="8" colname="b27" align="center" />
+	  <colspec colnum="9" colname="b26" align="center" />
+	  <colspec colnum="10" colname="b25" align="center" />
+	  <colspec colnum="11" colname="b24" align="center" />
+	  <colspec colnum="12" colname="b23" align="center" />
+	  <colspec colnum="13" colname="b22" align="center" />
+	  <colspec colnum="14" colname="b21" align="center" />
+	  <colspec colnum="15" colname="b20" align="center" />
+	  <colspec colnum="16" colname="b19" align="center" />
+	  <colspec colnum="17" colname="b18" align="center" />
+	  <colspec colnum="18" colname="b17" align="center" />
+	  <colspec colnum="19" colname="b16" align="center" />
+	  <colspec colnum="20" colname="b15" align="center" />
+	  <colspec colnum="21" colname="b14" align="center" />
+	  <colspec colnum="22" colname="b13" align="center" />
+	  <colspec colnum="23" colname="b12" align="center" />
+	  <colspec colnum="24" colname="b11" align="center" />
+	  <colspec colnum="25" colname="b10" align="center" />
+	  <colspec colnum="26" colname="b09" align="center" />
+	  <colspec colnum="27" colname="b08" align="center" />
+	  <colspec colnum="28" colname="b07" align="center" />
+	  <colspec colnum="29" colname="b06" align="center" />
+	  <colspec colnum="30" colname="b05" align="center" />
+	  <colspec colnum="31" colname="b04" align="center" />
+	  <colspec colnum="32" colname="b03" align="center" />
+	  <colspec colnum="33" colname="b02" align="center" />
+	  <colspec colnum="34" colname="b01" align="center" />
+	  <colspec colnum="35" colname="b00" align="center" />
+	  <spanspec namest="b31" nameend="b00" spanname="b0" />
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry></entry>
+	      <entry spanname="b0">Data organization</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>Bit</entry>
+	      <entry>31</entry>
+	      <entry>30</entry>
+	      <entry>29</entry>
+	      <entry>28</entry>
+	      <entry>27</entry>
+	      <entry>26</entry>
+	      <entry>25</entry>
+	      <entry>24</entry>
+	      <entry>23</entry>
+	      <entry>22</entry>
+	      <entry>21</entry>
+	      <entry>20</entry>
+	      <entry>19</entry>
+	      <entry>18</entry>
+	      <entry>17</entry>
+	      <entry>16</entry>
+	      <entry>15</entry>
+	      <entry>14</entry>
+	      <entry>13</entry>
+	      <entry>12</entry>
+	      <entry>11</entry>
+	      <entry>10</entry>
+	      <entry>9</entry>
+	      <entry>8</entry>
+	      <entry>7</entry>
+	      <entry>6</entry>
+	      <entry>5</entry>
+	      <entry>4</entry>
+	      <entry>3</entry>
+	      <entry>2</entry>
+	      <entry>1</entry>
+	      <entry>0</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2-MBUS-FMT-AHSV8888-1X32">
+	      <entry>V4L2_MBUS_FMT_AHSV8888_1X32</entry>
+	      <entry>0x6001</entry>
+	      <entry></entry>
+	      <entry>a<subscript>7</subscript></entry>
+	      <entry>a<subscript>6</subscript></entry>
+	      <entry>a<subscript>5</subscript></entry>
+	      <entry>a<subscript>4</subscript></entry>
+	      <entry>a<subscript>3</subscript></entry>
+	      <entry>a<subscript>2</subscript></entry>
+	      <entry>a<subscript>1</subscript></entry>
+	      <entry>a<subscript>0</subscript></entry>
+	      <entry>h<subscript>7</subscript></entry>
+	      <entry>h<subscript>6</subscript></entry>
+	      <entry>h<subscript>5</subscript></entry>
+	      <entry>h<subscript>4</subscript></entry>
+	      <entry>h<subscript>3</subscript></entry>
+	      <entry>h<subscript>2</subscript></entry>
+	      <entry>h<subscript>1</subscript></entry>
+	      <entry>h<subscript>0</subscript></entry>
+	      <entry>s<subscript>7</subscript></entry>
+	      <entry>s<subscript>6</subscript></entry>
+	      <entry>s<subscript>5</subscript></entry>
+	      <entry>s<subscript>4</subscript></entry>
+	      <entry>s<subscript>3</subscript></entry>
+	      <entry>s<subscript>2</subscript></entry>
+	      <entry>s<subscript>1</subscript></entry>
+	      <entry>s<subscript>0</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+
+    <section>
       <title>JPEG Compressed Formats</title>
 
       <para>Those data formats consist of an ordered sequence of 8-bit bytes
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index a960125..b5c3aab 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -110,6 +110,9 @@ enum v4l2_mbus_pixelcode {
 
 	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
 	V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
+
+	/* HSV - next is 0x6002 */
+	V4L2_MBUS_FMT_AHSV8888_1X32 = 0x6001,
 };
 
 /**
-- 
1.8.3.2

