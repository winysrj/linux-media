Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:48847 "EHLO
	relmlor2.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CRLsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 07:48:35 -0400
Received: from relmlir2.idc.renesas.com ([10.200.68.152])
 by relmlor2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MJU001BQU4PED40@relmlor2.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 18 Mar 2013 20:48:25 +0900 (JST)
Received: from relmlac1.idc.renesas.com ([10.200.69.21])
 by relmlir2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MJU0046IU4PXWD0@relmlir2.idc.renesas.com> for
 linux-media@vger.kernel.org; Mon, 18 Mar 2013 20:48:25 +0900 (JST)
From: Phil Edworthy <phil.edworthy@renesas.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Phil Edworthy <phil.edworthy@renesas.com>
Subject: [PATCH v2] soc_camera: Add RGB666 & RGB888 formats
In-reply-to: <Pine.LNX.4.64.1303081228050.24912@axis700.grange>
References: <Pine.LNX.4.64.1303081228050.24912@axis700.grange>
Message-id: <1363607279-22125-1-git-send-email-phil.edworthy@renesas.com>
Date: Mon, 18 Mar 2013 11:47:59 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on work done by Katsuya Matsubara.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
---
v2:
 - Added documentation.
 - Added SOCAM_DATAWIDTH_12 definition.

 Documentation/DocBook/media/v4l/subdev-formats.xml |  206 +++++++++++++++++++-
 Documentation/DocBook/media_api.tmpl               |    1 +
 drivers/media/platform/soc_camera/soc_mediabus.c   |   42 ++++
 include/media/soc_camera.h                         |    7 +-
 include/media/soc_mediabus.h                       |    3 +
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 6 files changed, 253 insertions(+), 12 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index cc51372..adc6198 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -93,19 +93,35 @@
 
       <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
 	<title>RGB formats</title>
-	<tgroup cols="11">
+	<tgroup cols="27">
 	  <colspec colname="id" align="left" />
 	  <colspec colname="code" align="center"/>
 	  <colspec colname="bit" />
-	  <colspec colnum="4" colname="b07" align="center" />
-	  <colspec colnum="5" colname="b06" align="center" />
-	  <colspec colnum="6" colname="b05" align="center" />
-	  <colspec colnum="7" colname="b04" align="center" />
-	  <colspec colnum="8" colname="b03" align="center" />
-	  <colspec colnum="9" colname="b02" align="center" />
-	  <colspec colnum="10" colname="b01" align="center" />
-	  <colspec colnum="11" colname="b00" align="center" />
-	  <spanspec namest="b07" nameend="b00" spanname="b0" />
+	  <colspec colnum="4" colname="b23" align="center" />
+	  <colspec colnum="5" colname="b22" align="center" />
+	  <colspec colnum="6" colname="b21" align="center" />
+	  <colspec colnum="7" colname="b20" align="center" />
+	  <colspec colnum="8" colname="b19" align="center" />
+	  <colspec colnum="9" colname="b18" align="center" />
+	  <colspec colnum="10" colname="b17" align="center" />
+	  <colspec colnum="11" colname="b16" align="center" />
+	  <colspec colnum="12" colname="b15" align="center" />
+	  <colspec colnum="13" colname="b14" align="center" />
+	  <colspec colnum="14" colname="b13" align="center" />
+	  <colspec colnum="15" colname="b12" align="center" />
+	  <colspec colnum="16" colname="b11" align="center" />
+	  <colspec colnum="17" colname="b10" align="center" />
+	  <colspec colnum="18" colname="b09" align="center" />
+	  <colspec colnum="19" colname="b08" align="center" />
+	  <colspec colnum="20" colname="b07" align="center" />
+	  <colspec colnum="21" colname="b06" align="center" />
+	  <colspec colnum="22" colname="b05" align="center" />
+	  <colspec colnum="23" colname="b04" align="center" />
+	  <colspec colnum="24" colname="b03" align="center" />
+	  <colspec colnum="25" colname="b02" align="center" />
+	  <colspec colnum="26" colname="b01" align="center" />
+	  <colspec colnum="27" colname="b00" align="center" />
+	  <spanspec namest="b23" nameend="b00" spanname="b0" />
 	  <thead>
 	    <row>
 	      <entry>Identifier</entry>
@@ -117,6 +133,22 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry>Bit</entry>
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
 	      <entry>7</entry>
 	      <entry>6</entry>
 	      <entry>5</entry>
@@ -132,6 +164,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE</entry>
 	      <entry>0x1001</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -145,6 +178,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>3</subscript></entry>
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
@@ -158,6 +192,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE</entry>
 	      <entry>0x1002</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>3</subscript></entry>
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
@@ -171,6 +206,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -184,6 +220,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</entry>
 	      <entry>0x1003</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>0</entry>
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
@@ -197,6 +234,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -210,6 +248,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE</entry>
 	      <entry>0x1004</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -223,6 +262,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>0</entry>
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
@@ -236,6 +276,7 @@
 	      <entry>V4L2_MBUS_FMT_BGR565_2X8_BE</entry>
 	      <entry>0x1005</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>b<subscript>4</subscript></entry>
 	      <entry>b<subscript>3</subscript></entry>
 	      <entry>b<subscript>2</subscript></entry>
@@ -249,6 +290,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -262,6 +304,7 @@
 	      <entry>V4L2_MBUS_FMT_BGR565_2X8_LE</entry>
 	      <entry>0x1006</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -275,6 +318,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>b<subscript>4</subscript></entry>
 	      <entry>b<subscript>3</subscript></entry>
 	      <entry>b<subscript>2</subscript></entry>
@@ -288,6 +332,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB565_2X8_BE</entry>
 	      <entry>0x1007</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
 	      <entry>r<subscript>2</subscript></entry>
@@ -301,6 +346,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -314,6 +360,7 @@
 	      <entry>V4L2_MBUS_FMT_RGB565_2X8_LE</entry>
 	      <entry>0x1008</entry>
 	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>g<subscript>2</subscript></entry>
 	      <entry>g<subscript>1</subscript></entry>
 	      <entry>g<subscript>0</subscript></entry>
@@ -327,6 +374,27 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-16;
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB666-1X18">
+	      <entry>V4L2_MBUS_FMT_RGB666_1X18</entry>
+	      <entry>0x1009</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>5</subscript></entry>
 	      <entry>r<subscript>4</subscript></entry>
 	      <entry>r<subscript>3</subscript></entry>
 	      <entry>r<subscript>2</subscript></entry>
@@ -335,6 +403,124 @@
 	      <entry>g<subscript>5</subscript></entry>
 	      <entry>g<subscript>4</subscript></entry>
 	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB888-1X24">
+	      <entry>V4L2_MBUS_FMT_RGB888_1X24</entry>
+	      <entry>0x100a</entry>
+	      <entry></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB888-2X12-BE">
+	      <entry>V4L2_MBUS_FMT_RGB888_2X12_BE</entry>
+	      <entry>0x100b</entry>
+	      <entry></entry>
+	      &dash-ent-10;
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-10;
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB888-2X12-LE">
+	      <entry>V4L2_MBUS_FMT_RGB888_2X12_LE</entry>
+	      <entry>0x100c</entry>
+	      <entry></entry>
+	      &dash-ent-10;
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-10;
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
 	    </row>
 	  </tbody>
 	</tgroup>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 1f6593d..6a8b715 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -23,6 +23,7 @@
 <!-- LinuxTV v4l-dvb repository. -->
 <!ENTITY v4l-dvb		"<ulink url='http://linuxtv.org/repo/'>http://linuxtv.org/repo/</ulink>">
 <!ENTITY dash-ent-10            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
+<!ENTITY dash-ent-16            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 ]>
 
 <book id="media_api">
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 89dce09..7569e77 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -97,6 +97,42 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
+	.code = V4L2_MBUS_FMT_RGB666_1X18,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB666/32bpp",
+		.bits_per_sample	= 18,
+		.packing		= SOC_MBUS_PACKING_EXTEND32,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_RGB888_1X24,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB888/32bpp",
+		.bits_per_sample	= 24,
+		.packing		= SOC_MBUS_PACKING_EXTEND32,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_RGB888_2X12_BE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB888/32bpp",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND32,
+		.order			= SOC_MBUS_ORDER_BE,
+	},
+}, {
+	.code = V4L2_MBUS_FMT_RGB888_2X12_LE,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB888/32bpp",
+		.bits_per_sample	= 12,
+		.packing		= SOC_MBUS_PACKING_EXTEND32,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
 	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR8,
@@ -358,6 +394,10 @@ int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
 		*numerator = 1;
 		*denominator = 1;
 		return 0;
+	case SOC_MBUS_PACKING_EXTEND32:
+		*numerator = 1;
+		*denominator = 1;
+		return 0;
 	case SOC_MBUS_PACKING_2X8_PADHI:
 	case SOC_MBUS_PACKING_2X8_PADLO:
 		*numerator = 2;
@@ -392,6 +432,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 		return width * 3 / 2;
 	case SOC_MBUS_PACKING_VARIABLE:
 		return 0;
+	case SOC_MBUS_PACKING_EXTEND32:
+		return width * 4;
 	}
 	return -EINVAL;
 }
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2cc70cf..ff77d08 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -292,12 +292,17 @@ struct soc_camera_sense {
 #define SOCAM_DATAWIDTH_8	SOCAM_DATAWIDTH(8)
 #define SOCAM_DATAWIDTH_9	SOCAM_DATAWIDTH(9)
 #define SOCAM_DATAWIDTH_10	SOCAM_DATAWIDTH(10)
+#define SOCAM_DATAWIDTH_12	SOCAM_DATAWIDTH(12)
 #define SOCAM_DATAWIDTH_15	SOCAM_DATAWIDTH(15)
 #define SOCAM_DATAWIDTH_16	SOCAM_DATAWIDTH(16)
+#define SOCAM_DATAWIDTH_18	SOCAM_DATAWIDTH(18)
+#define SOCAM_DATAWIDTH_24	SOCAM_DATAWIDTH(24)
 
 #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
 			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
-			      SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_16)
+			      SOCAM_DATAWIDTH_12 | SOCAM_DATAWIDTH_15 | \
+			      SOCAM_DATAWIDTH_16 | SOCAM_DATAWIDTH_18 | \
+			      SOCAM_DATAWIDTH_24)
 
 static inline void soc_camera_limit_side(int *start, int *length,
 		unsigned int start_min,
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 0dc6f46..d33f6d0 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -26,6 +26,8 @@
  * @SOC_MBUS_PACKING_VARIABLE:	compressed formats with variable packing
  * @SOC_MBUS_PACKING_1_5X8:	used for packed YUV 4:2:0 formats, where 4
  *				pixels occupy 6 bytes in RAM
+ * @SOC_MBUS_PACKING_EXTEND32:	sample width (e.g., 24 bits) has to be extended
+ *				to 32 bits
  */
 enum soc_mbus_packing {
 	SOC_MBUS_PACKING_NONE,
@@ -34,6 +36,7 @@ enum soc_mbus_packing {
 	SOC_MBUS_PACKING_EXTEND16,
 	SOC_MBUS_PACKING_VARIABLE,
 	SOC_MBUS_PACKING_1_5X8,
+	SOC_MBUS_PACKING_EXTEND32,
 };
 
 /**
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index b9b7bea..6ee63d0 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -37,7 +37,7 @@
 enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_FIXED = 0x0001,
 
-	/* RGB - next is 0x1009 */
+	/* RGB - next is 0x100d */
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
@@ -46,6 +46,10 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
+	V4L2_MBUS_FMT_RGB666_1X18 = 0x1009,
+	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
+	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
+	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
 
 	/* YUV (including grey) - next is 0x2017 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
-- 
1.7.5.4

