Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:49833 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbcF0PCZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 11:02:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v2.1 8/9] media: Add 1X16 16-bit raw bayer media bus code definitions
Date: Mon, 27 Jun 2016 17:57:50 +0300
Message-Id: <1467039471-19416-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1466439608-22890-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1466439608-22890-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The codes will be called:

	MEDIA_BUS_FMT_SBGGR16_1X16
	MEDIA_BUS_FMT_SGBRG16_1X16
	MEDIA_BUS_FMT_SGRBG16_1X16
	MEDIA_BUS_FMT_SRGGB16_1X16

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 252 +++++++++++----------
 include/uapi/linux/media-bus-format.h              |   6 +-
 2 files changed, 137 insertions(+), 121 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 6d45dc8..db5b935 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -1116,6 +1116,8 @@ see <xref linkend="colorspaces" />.</entry>
 	  <colspec colnum="15" colname="b02" align="center" />
 	  <colspec colnum="16" colname="b01" align="center" />
 	  <colspec colnum="17" colname="b00" align="center" />
+	  <colspec colnum="18" colname="b01" align="center" />
+	  <colspec colnum="19" colname="b00" align="center" />
 	  <spanspec namest="b11" nameend="b00" spanname="b0" />
 	  <thead>
 	    <row>
@@ -1128,6 +1130,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry>Bit</entry>
+	      <entry>15</entry>
+	      <entry>14</entry>
 	      <entry>13</entry>
 	      <entry>12</entry>
 	      <entry>11</entry>
@@ -1149,12 +1153,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR8_1X8</entry>
 	      <entry>0x3001</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1168,12 +1167,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGBRG8_1X8</entry>
 	      <entry>0x3013</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1187,12 +1181,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGRBG8_1X8</entry>
 	      <entry>0x3002</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1206,12 +1195,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SRGGB8_1X8</entry>
 	      <entry>0x3014</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -1225,12 +1209,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8</entry>
 	      <entry>0x3015</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1244,12 +1223,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8</entry>
 	      <entry>0x3016</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1263,12 +1237,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8</entry>
 	      <entry>0x3017</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1282,12 +1251,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8</entry>
 	      <entry>0x3018</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -1301,12 +1265,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8</entry>
 	      <entry>0x300b</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1320,12 +1279,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8</entry>
 	      <entry>0x300c</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1339,12 +1293,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8</entry>
 	      <entry>0x3009</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>g<subscript>7</subscript></entry>
 	      <entry>g<subscript>6</subscript></entry>
 	      <entry>g<subscript>5</subscript></entry>
@@ -1358,12 +1307,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8</entry>
 	      <entry>0x300d</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>r<subscript>7</subscript></entry>
 	      <entry>r<subscript>6</subscript></entry>
 	      <entry>r<subscript>5</subscript></entry>
@@ -1377,12 +1321,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
 	      <entry>0x3003</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -1396,12 +1335,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1415,12 +1349,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE</entry>
 	      <entry>0x3004</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>7</subscript></entry>
 	      <entry>b<subscript>6</subscript></entry>
 	      <entry>b<subscript>5</subscript></entry>
@@ -1434,12 +1363,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>0</entry>
 	      <entry>0</entry>
 	      <entry>0</entry>
@@ -1453,12 +1377,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE</entry>
 	      <entry>0x3005</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	      <entry>b<subscript>7</subscript></entry>
@@ -1472,12 +1391,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	      <entry>0</entry>
@@ -1491,12 +1405,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE</entry>
 	      <entry>0x3006</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	      <entry>0</entry>
@@ -1510,12 +1419,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-8;
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	      <entry>b<subscript>7</subscript></entry>
@@ -1533,6 +1437,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>9</subscript></entry>
 	      <entry>b<subscript>8</subscript></entry>
 	      <entry>b<subscript>7</subscript></entry>
@@ -1552,6 +1458,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>9</subscript></entry>
 	      <entry>g<subscript>8</subscript></entry>
 	      <entry>g<subscript>7</subscript></entry>
@@ -1571,6 +1479,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>9</subscript></entry>
 	      <entry>g<subscript>8</subscript></entry>
 	      <entry>g<subscript>7</subscript></entry>
@@ -1590,6 +1500,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>r<subscript>9</subscript></entry>
 	      <entry>r<subscript>8</subscript></entry>
 	      <entry>r<subscript>7</subscript></entry>
@@ -1607,6 +1519,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>11</subscript></entry>
 	      <entry>b<subscript>10</subscript></entry>
 	      <entry>b<subscript>9</subscript></entry>
@@ -1626,6 +1540,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>11</subscript></entry>
 	      <entry>g<subscript>10</subscript></entry>
 	      <entry>g<subscript>9</subscript></entry>
@@ -1645,6 +1561,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>11</subscript></entry>
 	      <entry>g<subscript>10</subscript></entry>
 	      <entry>g<subscript>9</subscript></entry>
@@ -1664,6 +1582,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>r<subscript>11</subscript></entry>
 	      <entry>r<subscript>10</subscript></entry>
 	      <entry>r<subscript>9</subscript></entry>
@@ -1681,6 +1601,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SBGGR14_1X14</entry>
 	      <entry>0x3019</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>b<subscript>13</subscript></entry>
 	      <entry>b<subscript>12</subscript></entry>
 	      <entry>b<subscript>11</subscript></entry>
@@ -1700,6 +1622,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGBRG14_1X14</entry>
 	      <entry>0x301a</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>13</subscript></entry>
 	      <entry>g<subscript>12</subscript></entry>
 	      <entry>g<subscript>11</subscript></entry>
@@ -1719,6 +1643,8 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SGRBG14_1X14</entry>
 	      <entry>0x301b</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
 	      <entry>g<subscript>13</subscript></entry>
 	      <entry>g<subscript>12</subscript></entry>
 	      <entry>g<subscript>11</subscript></entry>
@@ -1738,6 +1664,92 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>MEDIA_BUS_FMT_SRGGB14_1X14</entry>
 	      <entry>0x301c</entry>
 	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>13</subscript></entry>
+	      <entry>r<subscript>12</subscript></entry>
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
+	    <row id="MEDIA-BUS-FMT-SBGGR16-1X16">
+	      <entry>MEDIA_BUS_FMT_SBGGR16_1X16</entry>
+	      <entry>0x301d</entry>
+	      <entry></entry>
+	      <entry>b<subscript>15</subscript></entry>
+	      <entry>b<subscript>14</subscript></entry>
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
+	    <row id="MEDIA-BUS-FMT-SGBRG16-1X16">
+	      <entry>MEDIA_BUS_FMT_SGBRG16_1X16</entry>
+	      <entry>0x301e</entry>
+	      <entry></entry>
+	      <entry>g<subscript>15</subscript></entry>
+	      <entry>g<subscript>14</subscript></entry>
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
+	    <row id="MEDIA-BUS-FMT-SGRBG16-1X16">
+	      <entry>MEDIA_BUS_FMT_SGRBG16_1X16</entry>
+	      <entry>0x301f</entry>
+	      <entry></entry>
+	      <entry>g<subscript>15</subscript></entry>
+	      <entry>g<subscript>14</subscript></entry>
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
+	    <row id="MEDIA-BUS-FMT-SRGGB16-1X16">
+	      <entry>MEDIA_BUS_FMT_SRGGB16_1X16</entry>
+	      <entry>0x3020</entry>
+	      <entry></entry>
+	      <entry>r<subscript>15</subscript></entry>
+	      <entry>r<subscript>14</subscript></entry>
 	      <entry>r<subscript>13</subscript></entry>
 	      <entry>r<subscript>12</subscript></entry>
 	      <entry>r<subscript>11</subscript></entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 1dff459..2168759 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -97,7 +97,7 @@
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
 
-/* Bayer - next is	0x301d */
+/* Bayer - next is	0x3021 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
 #define MEDIA_BUS_FMT_SGBRG8_1X8		0x3013
 #define MEDIA_BUS_FMT_SGRBG8_1X8		0x3002
@@ -126,6 +126,10 @@
 #define MEDIA_BUS_FMT_SGBRG14_1X14		0x301a
 #define MEDIA_BUS_FMT_SGRBG14_1X14		0x301b
 #define MEDIA_BUS_FMT_SRGGB14_1X14		0x301c
+#define MEDIA_BUS_FMT_SBGGR16_1X16		0x301d
+#define MEDIA_BUS_FMT_SGBRG16_1X16		0x301e
+#define MEDIA_BUS_FMT_SGRBG16_1X16		0x301f
+#define MEDIA_BUS_FMT_SRGGB16_1X16		0x3020
 
 /* JPEG compressed formats - next is	0x4002 */
 #define MEDIA_BUS_FMT_JPEG_1X8			0x4001
-- 
2.7.4

