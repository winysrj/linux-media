Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44080 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2K1TJl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:41 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700D8GP82ZE60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:40 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:40 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 01/12] V4L: DocBook: Add V4L2_MBUS_FMT_YUV10_1X30 media bus
 pixel code
Date: Wed, 28 Nov 2012 20:09:18 +0100
Message-id: <1354129766-2821-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds definition of media bus code for YUV pixel format
transferred in 30-bit samples where each component has 10 bits width.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml |  718 ++++++--------------
 Documentation/DocBook/media_api.tmpl               |    1 +
 include/uapi/linux/v4l2-mediabus.h                 |    3 +-
 3 files changed, 196 insertions(+), 526 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index a0a9364..b0936f7 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -885,27 +885,37 @@
 	  <colspec colname="id" align="left" />
 	  <colspec colname="code" align="center"/>
 	  <colspec colname="bit" />
-	  <colspec colnum="4" colname="b19" align="center" />
-	  <colspec colnum="5" colname="b18" align="center" />
-	  <colspec colnum="6" colname="b17" align="center" />
-	  <colspec colnum="7" colname="b16" align="center" />
-	  <colspec colnum="8" colname="b15" align="center" />
-	  <colspec colnum="9" colname="b14" align="center" />
-	  <colspec colnum="10" colname="b13" align="center" />
-	  <colspec colnum="11" colname="b12" align="center" />
-	  <colspec colnum="12" colname="b11" align="center" />
-	  <colspec colnum="13" colname="b10" align="center" />
-	  <colspec colnum="14" colname="b09" align="center" />
-	  <colspec colnum="15" colname="b08" align="center" />
-	  <colspec colnum="16" colname="b07" align="center" />
-	  <colspec colnum="17" colname="b06" align="center" />
-	  <colspec colnum="18" colname="b05" align="center" />
-	  <colspec colnum="19" colname="b04" align="center" />
-	  <colspec colnum="20" colname="b03" align="center" />
-	  <colspec colnum="21" colname="b02" align="center" />
-	  <colspec colnum="22" colname="b01" align="center" />
-	  <colspec colnum="23" colname="b00" align="center" />
-	  <spanspec namest="b19" nameend="b00" spanname="b0" />
+	  <colspec colnum="4" colname="b29" align="center" />
+	  <colspec colnum="5" colname="b28" align="center" />
+	  <colspec colnum="6" colname="b27" align="center" />
+	  <colspec colnum="7" colname="b26" align="center" />
+	  <colspec colnum="8" colname="b25" align="center" />
+	  <colspec colnum="9" colname="b24" align="center" />
+	  <colspec colnum="10" colname="b23" align="center" />
+	  <colspec colnum="11" colname="b22" align="center" />
+	  <colspec colnum="12" colname="b21" align="center" />
+	  <colspec colnum="13" colname="b20" align="center" />
+	  <colspec colnum="14" colname="b19" align="center" />
+	  <colspec colnum="15" colname="b18" align="center" />
+	  <colspec colnum="16" colname="b17" align="center" />
+	  <colspec colnum="17" colname="b16" align="center" />
+	  <colspec colnum="18" colname="b15" align="center" />
+	  <colspec colnum="19" colname="b14" align="center" />
+	  <colspec colnum="20" colname="b13" align="center" />
+	  <colspec colnum="21" colname="b12" align="center" />
+	  <colspec colnum="22" colname="b11" align="center" />
+	  <colspec colnum="23" colname="b10" align="center" />
+	  <colspec colnum="24" colname="b09" align="center" />
+	  <colspec colnum="25" colname="b08" align="center" />
+	  <colspec colnum="26" colname="b07" align="center" />
+	  <colspec colnum="27" colname="b06" align="center" />
+	  <colspec colnum="28" colname="b05" align="center" />
+	  <colspec colnum="29" colname="b04" align="center" />
+	  <colspec colnum="30" colname="b03" align="center" />
+	  <colspec colnum="31" colname="b02" align="center" />
+	  <colspec colnum="32" colname="b01" align="center" />
+	  <colspec colnum="33" colname="b00" align="center" />
+	  <spanspec namest="b29" nameend="b00" spanname="b0" />
 	  <thead>
 	    <row>
 	      <entry>Identifier</entry>
@@ -917,6 +927,16 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry>Bit</entry>
+	      <entry>29</entry>
+	      <entry>28</entry>
+	      <entry>27</entry>
+	      <entry>26</entry>
+	      <entry>25</entry>
+	      <entry>24</entry>
+	      <entry>23</entry>
+	      <entry>22</entry>
+	      <entry>21</entry>
+	      <entry>10</entry>
 	      <entry>19</entry>
 	      <entry>18</entry>
 	      <entry>17</entry>
@@ -944,16 +964,8 @@
 	      <entry>V4L2_MBUS_FMT_Y8_1X8</entry>
 	      <entry>0x2001</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -969,16 +981,8 @@
 	      <entry>V4L2_MBUS_FMT_UYVY8_1_5X8</entry>
 	      <entry>0x2002</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -994,16 +998,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1019,16 +1015,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1044,16 +1032,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1069,16 +1049,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1094,16 +1066,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1119,16 +1083,8 @@
 	      <entry>V4L2_MBUS_FMT_VYUY8_1_5X8</entry>
 	      <entry>0x2003</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1144,16 +1100,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1169,16 +1117,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1194,16 +1134,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1219,16 +1151,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1244,16 +1168,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1269,16 +1185,8 @@
 	      <entry>V4L2_MBUS_FMT_YUYV8_1_5X8</entry>
 	      <entry>0x2004</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1294,16 +1202,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1319,16 +1219,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1344,16 +1236,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1369,16 +1253,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1394,16 +1270,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1419,16 +1287,8 @@
 	      <entry>V4L2_MBUS_FMT_YVYU8_1_5X8</entry>
 	      <entry>0x2005</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1444,16 +1304,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1469,16 +1321,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1494,16 +1338,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1519,16 +1355,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1544,16 +1372,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1569,16 +1389,8 @@
 	      <entry>V4L2_MBUS_FMT_UYVY8_2X8</entry>
 	      <entry>0x2006</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1594,16 +1406,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1615,20 +1419,12 @@
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1644,16 +1440,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1669,16 +1457,8 @@
 	      <entry>V4L2_MBUS_FMT_VYUY8_2X8</entry>
 	      <entry>0x2007</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1694,16 +1474,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1719,16 +1491,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1744,16 +1508,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1769,16 +1525,8 @@
 	      <entry>V4L2_MBUS_FMT_YUYV8_2X8</entry>
 	      <entry>0x2008</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1794,16 +1542,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1819,16 +1559,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1844,16 +1576,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1869,16 +1593,8 @@
 	      <entry>V4L2_MBUS_FMT_YVYU8_2X8</entry>
 	      <entry>0x2009</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1894,16 +1610,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -1919,16 +1627,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1944,16 +1644,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -1969,16 +1661,8 @@
 	      <entry>V4L2_MBUS_FMT_Y10_1X10</entry>
 	      <entry>0x200a</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -1994,16 +1678,8 @@
 	      <entry>V4L2_MBUS_FMT_YUYV10_2X10</entry>
 	      <entry>0x200b</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2019,16 +1695,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2044,16 +1712,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2069,16 +1729,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -2094,16 +1746,8 @@
 	      <entry>V4L2_MBUS_FMT_YVYU10_2X10</entry>
 	      <entry>0x200c</entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2119,16 +1763,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -2144,16 +1780,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2169,16 +1797,8 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
+	      &dash-ent-10;
+	      &dash-ent-10;
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2194,6 +1814,7 @@
 	      <entry>V4L2_MBUS_FMT_Y12_1X12</entry>
 	      <entry>0x2013</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2219,6 +1840,7 @@
 	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
 	      <entry>0x200f</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2244,6 +1866,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2269,6 +1892,7 @@
 	      <entry>V4L2_MBUS_FMT_VYUY8_1X16</entry>
 	      <entry>0x2010</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2294,6 +1918,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2319,6 +1944,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV8_1X16</entry>
 	      <entry>0x2011</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2344,6 +1970,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2369,6 +1996,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU8_1X16</entry>
 	      <entry>0x2012</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2394,6 +2022,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>-</entry>
 	      <entry>-</entry>
 	      <entry>-</entry>
@@ -2419,6 +2048,7 @@
 	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
 	      <entry>0x200d</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2444,6 +2074,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2469,6 +2100,7 @@
 	      <entry>V4L2_MBUS_FMT_YVYU10_1X20</entry>
 	      <entry>0x200e</entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2494,6 +2126,7 @@
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
+	      &dash-ent-10;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2515,6 +2148,41 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-YUV10-1X30">
+	      <entry>V4L2_MBUS_FMT_YUV10_1X30</entry>
+	      <entry>0x2014</entry>
+	      <entry></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
 	  </tbody>
 	</tgroup>
       </table>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index f2413ac..1f6593d 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -22,6 +22,7 @@
 
 <!-- LinuxTV v4l-dvb repository. -->
 <!ENTITY v4l-dvb		"<ulink url='http://linuxtv.org/repo/'>http://linuxtv.org/repo/</ulink>">
+<!ENTITY dash-ent-10            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 ]>
 
 <book id="media_api">
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 7d64e0e..dbbb956 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -47,7 +47,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
 
-	/* YUV (including grey) - next is 0x2014 */
+	/* YUV (including grey) - next is 0x2015 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
 	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
@@ -67,6 +67,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
+	V4L2_MBUS_FMT_YUV10_1X30 = 0x2014,
 
 	/* Bayer - next is 0x3015 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
-- 
1.7.9.5

