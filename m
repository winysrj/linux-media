Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbcE0MsT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:48:19 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Jouni Ukkonen <jouni.ukkonen@intel.com>
Subject: [PATCH 4/6] media: Add 1X14 14-bit raw bayer media bus code definitions
Date: Fri, 27 May 2016 15:44:38 +0300
Message-Id: <1464353080-18300-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jouni Ukkonen <jouni.ukkonen@intel.com>

The codes will be called:

	MEDIA_BUS_FMT_SBGGR14_1X14
	MEDIA_BUS_FMT_SGBRG14_1X14
	MEDIA_BUS_FMT_SGRBG14_1X14
	MEDIA_BUS_FMT_SRGGB14_1X14

Signed-off-by: Jouni Ukkonen <jouni.ukkonen@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 162 +++++++++++++++++++--
 include/uapi/linux/media-bus-format.h              |   6 +-
 2 files changed, 154 insertions(+), 14 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 199c84e..6d45dc8 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -1098,22 +1098,24 @@ see <xref linkend="colorspaces" />.</entry>
 
       <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-bayer">
 	<title>Bayer Formats</title>
-	<tgroup cols="15">
+	<tgroup cols="17">
 	  <colspec colname="id" align="left" />
 	  <colspec colname="code" align="center"/>
 	  <colspec colname="bit" />
-	  <colspec colnum="4" colname="b11" align="center" />
-	  <colspec colnum="5" colname="b10" align="center" />
-	  <colspec colnum="6" colname="b09" align="center" />
-	  <colspec colnum="7" colname="b08" align="center" />
-	  <colspec colnum="8" colname="b07" align="center" />
-	  <colspec colnum="9" colname="b06" align="center" />
-	  <colspec colnum="10" colname="b05" align="center" />
-	  <colspec colnum="11" colname="b04" align="center" />
-	  <colspec colnum="12" colname="b03" align="center" />
-	  <colspec colnum="13" colname="b02" align="center" />
-	  <colspec colnum="14" colname="b01" align="center" />
-	  <colspec colnum="15" colname="b00" align="center" />
+	  <colspec colnum="4" colname="b13" align="center" />
+	  <colspec colnum="5" colname="b12" align="center" />
+	  <colspec colnum="6" colname="b11" align="center" />
+	  <colspec colnum="7" colname="b10" align="center" />
+	  <colspec colnum="8" colname="b09" align="center" />
+	  <colspec colnum="9" colname="b08" align="center" />
+	  <colspec colnum="10" colname="b07" align="center" />
+	  <colspec colnum="11" colname="b06" align="center" />
+	  <colspec colnum="12" colname="b05" align="center" />
+	  <colspec colnum="13" colname="b04" align="center" />
+	  <colspec colnum="14" colname="b03" align="center" />
+	  <colspec colnum="15" colname="b02" align="center" />
+	  <colspec colnum="16" colname="b01" align="center" />
+	  <colspec colnum="17" colname="b00" align="center" />
 	  <spanspec namest="b11" nameend="b00" spanname="b0" />
 	  <thead>
 	    <row>
@@ -1126,6 +1128,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry>Bit</entry>
+	      <entry>13</entry>
+	      <entry>12</entry>
 	      <entry>11</entry>
 	      <entry>10</entry>
 	      <entry>9</entry>
@@ -1149,6 +1153,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1166,6 +1172,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1183,6 +1191,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1200,6 +1210,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -1217,6 +1229,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1234,6 +1248,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1251,6 +1267,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1268,6 +1286,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -1285,6 +1305,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1302,6 +1324,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1319,6 +1343,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1336,6 +1362,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -1353,6 +1381,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -1370,6 +1400,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1387,6 +1419,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1404,6 +1438,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -1421,6 +1457,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	      <entry>b<subscript>7</subscript></entry>
@@ -1438,6 +1476,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	      <entry>0</entry>
@@ -1455,6 +1495,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	      <entry>0</entry>
@@ -1472,6 +1514,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	      <entry>b<subscript>7</subscript></entry>
@@ -1487,6 +1531,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	      <entry>b<subscript>7</subscript></entry>
@@ -1504,6 +1550,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>9</subscript></entry>
 	      <entry>g<subscript>8</subscript></entry>
 	      <entry>g<subscript>7</subscript></entry>
@@ -1521,6 +1569,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>9</subscript></entry>
 	      <entry>g<subscript>8</subscript></entry>
 	      <entry>g<subscript>7</subscript></entry>
@@ -1538,6 +1588,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>r<subscript>9</subscript></entry>
 	      <entry>r<subscript>8</subscript></entry>
 	      <entry>r<subscript>7</subscript></entry>
@@ -1553,6 +1605,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR12_1X12</entry>
 	      <entry>0x3008</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>11</subscript></entry>
 	      <entry>b<subscript>10</subscript></entry>
 	      <entry>b<subscript>9</subscript></entry>
@@ -1570,6 +1624,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGBRG12_1X12</entry>
 	      <entry>0x3010</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>11</subscript></entry>
 	      <entry>g<subscript>10</subscript></entry>
 	      <entry>g<subscript>9</subscript></entry>
@@ -1587,6 +1643,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGRBG12_1X12</entry>
 	      <entry>0x3011</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>11</subscript></entry>
 	      <entry>g<subscript>10</subscript></entry>
 	      <entry>g<subscript>9</subscript></entry>
@@ -1604,6 +1662,84 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SRGGB12_1X12</entry>
 	      <entry>0x3012</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>11</subscript></entry>
+	      <entry>r<subscript>10</subscript></entry>
+	      <entry>r<subscript>9</subscript></entry>
+	      <entry>r<subscript>8</subscript></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-SBGGR14-1X14">
+	      <entry>MEDIA_BUS_FMT_SBGGR14_1X14</entry>
+	      <entry>0x3019</entry>
+	      <entry></entry>
+	      <entry>b<subscript>13</subscript></entry>
+	      <entry>b<subscript>12</subscript></entry>
+	      <entry>b<subscript>11</subscript></entry>
+	      <entry>b<subscript>10</subscript></entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-SGBRG14-1X14">
+	      <entry>MEDIA_BUS_FMT_SGBRG14_1X14</entry>
+	      <entry>0x301a</entry>
+	      <entry></entry>
+	      <entry>g<subscript>13</subscript></entry>
+	      <entry>g<subscript>12</subscript></entry>
+	      <entry>g<subscript>11</subscript></entry>
+	      <entry>g<subscript>10</subscript></entry>
+	      <entry>g<subscript>9</subscript></entry>
+	      <entry>g<subscript>8</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-SGRBG14-1X14">
+	      <entry>MEDIA_BUS_FMT_SGRBG14_1X14</entry>
+	      <entry>0x301b</entry>
+	      <entry></entry>
+	      <entry>g<subscript>13</subscript></entry>
+	      <entry>g<subscript>12</subscript></entry>
+	      <entry>g<subscript>11</subscript></entry>
+	      <entry>g<subscript>10</subscript></entry>
+	      <entry>g<subscript>9</subscript></entry>
+	      <entry>g<subscript>8</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-SRGGB14-1X14">
+	      <entry>MEDIA_BUS_FMT_SRGGB14_1X14</entry>
+	      <entry>0x301c</entry>
+	      <entry></entry>
+	      <entry>r<subscript>13</subscript></entry>
+	      <entry>r<subscript>12</subscript></entry>
 	      <entry>r<subscript>11</subscript></entry>
 	      <entry>r<subscript>10</subscript></entry>
 	      <entry>r<subscript>9</subscript></entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 190d491..1dff459 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -97,7 +97,7 @@
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
 
-/* Bayer - next is	0x3019 */
+/* Bayer - next is	0x301d */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
 #define MEDIA_BUS_FMT_SGBRG8_1X8		0x3013
 #define MEDIA_BUS_FMT_SGRBG8_1X8		0x3002
@@ -122,6 +122,10 @@
 #define MEDIA_BUS_FMT_SGBRG12_1X12		0x3010
 #define MEDIA_BUS_FMT_SGRBG12_1X12		0x3011
 #define MEDIA_BUS_FMT_SRGGB12_1X12		0x3012
+#define MEDIA_BUS_FMT_SBGGR14_1X14		0x3019
+#define MEDIA_BUS_FMT_SGBRG14_1X14		0x301a
+#define MEDIA_BUS_FMT_SGRBG14_1X14		0x301b
+#define MEDIA_BUS_FMT_SRGGB14_1X14		0x301c
 
 /* JPEG compressed formats - next is	0x4002 */
 #define MEDIA_BUS_FMT_JPEG_1X8			0x4001
-- 
1.9.1

