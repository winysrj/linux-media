Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56470 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbbCBBtD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 20:49:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v5 3/8] v4l: Sort YUV formats of v4l2_mbus_pixelcode
Date: Mon,  2 Mar 2015 03:48:40 +0200
Message-Id: <1425260925-12064-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hyun Kwon <hyun.kwon@xilinx.com>

Keep the formats sorted by type, bus_width, bits per component, samples
per pixel and order of subsamples, in that order.

Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 600 ++++++++++-----------
 include/uapi/linux/media-bus-format.h              |  12 +-
 2 files changed, 306 insertions(+), 306 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index d253e8f..9bfd468 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2255,11 +2255,15 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-UYVY8-1X16">
-	      <entry>MEDIA_BUS_FMT_UYVY8_1X16</entry>
-	      <entry>0x200f</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY12-2X12">
+	      <entry>MEDIA_BUS_FMT_UYVY12_2X12</entry>
+	      <entry>0x201c</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2268,6 +2272,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2281,7 +2295,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2290,6 +2308,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2299,11 +2327,15 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-VYUY8-1X16">
-	      <entry>MEDIA_BUS_FMT_VYUY8_1X16</entry>
-	      <entry>0x2010</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY12-2X12">
+	      <entry>MEDIA_BUS_FMT_VYUY12_2X12</entry>
+	      <entry>0x201d</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2312,6 +2344,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2325,7 +2367,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2334,6 +2380,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2343,11 +2399,15 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YUYV8-1X16">
-	      <entry>MEDIA_BUS_FMT_YUYV8_1X16</entry>
-	      <entry>0x2011</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV12-2X12">
+	      <entry>MEDIA_BUS_FMT_YUYV12_2X12</entry>
+	      <entry>0x201e</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2356,6 +2416,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2369,7 +2439,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2378,6 +2452,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2387,11 +2471,15 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YVYU8-1X16">
-	      <entry>MEDIA_BUS_FMT_YVYU8_1X16</entry>
-	      <entry>0x2012</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU12-2X12">
+	      <entry>MEDIA_BUS_FMT_YVYU12_2X12</entry>
+	      <entry>0x201f</entry>
 	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2400,6 +2488,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2413,29 +2511,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
-	      <entry>y<subscript>7</subscript></entry>
-	      <entry>y<subscript>6</subscript></entry>
-	      <entry>y<subscript>5</subscript></entry>
-	      <entry>y<subscript>4</subscript></entry>
-	      <entry>y<subscript>3</subscript></entry>
-	      <entry>y<subscript>2</subscript></entry>
-	      <entry>y<subscript>1</subscript></entry>
-	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>7</subscript></entry>
-	      <entry>u<subscript>6</subscript></entry>
-	      <entry>u<subscript>5</subscript></entry>
-	      <entry>u<subscript>4</subscript></entry>
-	      <entry>u<subscript>3</subscript></entry>
-	      <entry>u<subscript>2</subscript></entry>
-	      <entry>u<subscript>1</subscript></entry>
-	      <entry>u<subscript>0</subscript></entry>
-	    </row>
-	    <row id="MEDIA-BUS-FMT-YDYUYDYV8-1X16">
-	      <entry>MEDIA_BUS_FMT_YDYUYDYV8_1X16</entry>
-	      <entry>0x2014</entry>
-	      <entry></entry>
-	      &dash-ent-16;
+	      &dash-ent-20;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2444,28 +2524,16 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
 	    </row>
 	    <row>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-16;
-	      <entry>y<subscript>7</subscript></entry>
-	      <entry>y<subscript>6</subscript></entry>
-	      <entry>y<subscript>5</subscript></entry>
-	      <entry>y<subscript>4</subscript></entry>
-	      <entry>y<subscript>3</subscript></entry>
-	      <entry>y<subscript>2</subscript></entry>
-	      <entry>y<subscript>1</subscript></entry>
-	      <entry>y<subscript>0</subscript></entry>
+	      &dash-ent-20;
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2475,57 +2543,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-16;
-	      <entry>y<subscript>7</subscript></entry>
-	      <entry>y<subscript>6</subscript></entry>
-	      <entry>y<subscript>5</subscript></entry>
-	      <entry>y<subscript>4</subscript></entry>
-	      <entry>y<subscript>3</subscript></entry>
-	      <entry>y<subscript>2</subscript></entry>
-	      <entry>y<subscript>1</subscript></entry>
-	      <entry>y<subscript>0</subscript></entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	      <entry>d</entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
+	    <row id="MEDIA-BUS-FMT-UYVY8-1X16">
+	      <entry>MEDIA_BUS_FMT_UYVY8_1X16</entry>
+	      <entry>0x200f</entry>
 	      <entry></entry>
 	      &dash-ent-16;
-	      <entry>y<subscript>7</subscript></entry>
-	      <entry>y<subscript>6</subscript></entry>
-	      <entry>y<subscript>5</subscript></entry>
-	      <entry>y<subscript>4</subscript></entry>
-	      <entry>y<subscript>3</subscript></entry>
-	      <entry>y<subscript>2</subscript></entry>
-	      <entry>y<subscript>1</subscript></entry>
-	      <entry>y<subscript>0</subscript></entry>
-	      <entry>v<subscript>7</subscript></entry>
-	      <entry>v<subscript>6</subscript></entry>
-	      <entry>v<subscript>5</subscript></entry>
-	      <entry>v<subscript>4</subscript></entry>
-	      <entry>v<subscript>3</subscript></entry>
-	      <entry>v<subscript>2</subscript></entry>
-	      <entry>v<subscript>1</subscript></entry>
-	      <entry>v<subscript>0</subscript></entry>
-	    </row>
-	    <row id="MEDIA-BUS-FMT-UYVY10-1X20">
-	      <entry>MEDIA_BUS_FMT_UYVY10_1X20</entry>
-	      <entry>0x201a</entry>
-	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2534,8 +2556,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2549,9 +2569,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
+	      &dash-ent-16;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2560,8 +2578,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2571,13 +2587,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-VYUY10-1X20">
-	      <entry>MEDIA_BUS_FMT_VYUY10_1X20</entry>
-	      <entry>0x201b</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY8-1X16">
+	      <entry>MEDIA_BUS_FMT_VYUY8_1X16</entry>
+	      <entry>0x2010</entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
+	      &dash-ent-16;
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2586,8 +2600,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2601,9 +2613,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
+	      &dash-ent-16;
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2612,8 +2622,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2623,13 +2631,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YUYV10-1X20">
-	      <entry>MEDIA_BUS_FMT_YUYV10_1X20</entry>
-	      <entry>0x200d</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV8-1X16">
+	      <entry>MEDIA_BUS_FMT_YUYV8_1X16</entry>
+	      <entry>0x2011</entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2638,8 +2644,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2653,9 +2657,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2664,8 +2666,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2675,13 +2675,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YVYU10-1X20">
-	      <entry>MEDIA_BUS_FMT_YVYU10_1X20</entry>
-	      <entry>0x200e</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU8-1X16">
+	      <entry>MEDIA_BUS_FMT_YVYU8_1X16</entry>
+	      <entry>0x2012</entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2690,8 +2688,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2705,9 +2701,51 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-12;
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
+	      &dash-ent-16;
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-YDYUYDYV8-1X16">
+	      <entry>MEDIA_BUS_FMT_YDYUYDYV8_1X16</entry>
+	      <entry>0x2014</entry>
+	      <entry></entry>
+	      &dash-ent-16;
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2716,8 +2754,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2727,14 +2763,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YUV10-1X30">
-	      <entry>MEDIA_BUS_FMT_YUV10_1X30</entry>
-	      <entry>0x2016</entry>
+	    <row>
 	      <entry></entry>
-	      <entry>-</entry>
-	      <entry>-</entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2743,39 +2776,20 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
-	      <entry>u<subscript>7</subscript></entry>
-	      <entry>u<subscript>6</subscript></entry>
-	      <entry>u<subscript>5</subscript></entry>
-	      <entry>u<subscript>4</subscript></entry>
-	      <entry>u<subscript>3</subscript></entry>
-	      <entry>u<subscript>2</subscript></entry>
-	      <entry>u<subscript>1</subscript></entry>
-	      <entry>u<subscript>0</subscript></entry>
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
-	      <entry>v<subscript>7</subscript></entry>
-	      <entry>v<subscript>6</subscript></entry>
-	      <entry>v<subscript>5</subscript></entry>
-	      <entry>v<subscript>4</subscript></entry>
-	      <entry>v<subscript>3</subscript></entry>
-	      <entry>v<subscript>2</subscript></entry>
-	      <entry>v<subscript>1</subscript></entry>
-	      <entry>v<subscript>0</subscript></entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
+	      <entry>d</entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-AYUV8-1X32">
-	      <entry>MEDIA_BUS_FMT_AYUV8_1X32</entry>
-	      <entry>0x2017</entry>
+	    <row>
 	      <entry></entry>
-	      <entry>a<subscript>7</subscript></entry>
-	      <entry>a<subscript>6</subscript></entry>
-	      <entry>a<subscript>5</subscript></entry>
-	      <entry>a<subscript>4</subscript></entry>
-	      <entry>a<subscript>3</subscript></entry>
-	      <entry>a<subscript>2</subscript></entry>
-	      <entry>a<subscript>1</subscript></entry>
-	      <entry>a<subscript>0</subscript></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-16;
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2784,14 +2798,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>7</subscript></entry>
-	      <entry>u<subscript>6</subscript></entry>
-	      <entry>u<subscript>5</subscript></entry>
-	      <entry>u<subscript>4</subscript></entry>
-	      <entry>u<subscript>3</subscript></entry>
-	      <entry>u<subscript>2</subscript></entry>
-	      <entry>u<subscript>1</subscript></entry>
-	      <entry>u<subscript>0</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2801,13 +2807,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-UYVY12-2X12">
-	      <entry>MEDIA_BUS_FMT_UYVY12_2X12</entry>
-	      <entry>0x201c</entry>
+	    <row id="MEDIA-BUS-FMT-UYVY10-1X20">
+	      <entry>MEDIA_BUS_FMT_UYVY10_1X20</entry>
+	      <entry>0x201a</entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>u<subscript>11</subscript></entry>
-	      <entry>u<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2818,14 +2822,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2841,9 +2837,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>v<subscript>11</subscript></entry>
-	      <entry>v<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -2854,14 +2848,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2873,13 +2859,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-VYUY12-2X12">
-	      <entry>MEDIA_BUS_FMT_VYUY12_2X12</entry>
-	      <entry>0x201d</entry>
+	    <row id="MEDIA-BUS-FMT-VYUY10-1X20">
+	      <entry>MEDIA_BUS_FMT_VYUY10_1X20</entry>
+	      <entry>0x201b</entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>v<subscript>11</subscript></entry>
-	      <entry>v<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -2890,14 +2874,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2913,9 +2889,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>u<subscript>11</subscript></entry>
-	      <entry>u<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2926,14 +2900,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2945,13 +2911,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YUYV12-2X12">
-	      <entry>MEDIA_BUS_FMT_YUYV12_2X12</entry>
-	      <entry>0x201e</entry>
+	    <row id="MEDIA-BUS-FMT-YUYV10-1X20">
+	      <entry>MEDIA_BUS_FMT_YUYV10_1X20</entry>
+	      <entry>0x200d</entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2962,14 +2926,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>u<subscript>11</subscript></entry>
-	      <entry>u<subscript>10</subscript></entry>
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -2985,9 +2941,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -2998,14 +2952,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>v<subscript>11</subscript></entry>
-	      <entry>v<subscript>10</subscript></entry>
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -3017,13 +2963,11 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
-	    <row id="MEDIA-BUS-FMT-YVYU12-2X12">
-	      <entry>MEDIA_BUS_FMT_YVYU12_2X12</entry>
-	      <entry>0x201f</entry>
+	    <row id="MEDIA-BUS-FMT-YVYU10-1X20">
+	      <entry>MEDIA_BUS_FMT_YVYU10_1X20</entry>
+	      <entry>0x200e</entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -3034,14 +2978,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>v<subscript>11</subscript></entry>
-	      <entry>v<subscript>10</subscript></entry>
 	      <entry>v<subscript>9</subscript></entry>
 	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
@@ -3057,9 +2993,7 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry></entry>
 	      <entry></entry>
 	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>y<subscript>11</subscript></entry>
-	      <entry>y<subscript>10</subscript></entry>
+	      &dash-ent-12;
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
@@ -3070,14 +3004,6 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	    </row>
-	    <row>
-	      <entry></entry>
-	      <entry></entry>
-	      <entry></entry>
-	      &dash-ent-20;
-	      <entry>u<subscript>11</subscript></entry>
-	      <entry>u<subscript>10</subscript></entry>
 	      <entry>u<subscript>9</subscript></entry>
 	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
@@ -3329,6 +3255,80 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="MEDIA-BUS-FMT-YUV10-1X30">
+	      <entry>MEDIA_BUS_FMT_YUV10_1X30</entry>
+	      <entry>0x2016</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="MEDIA-BUS-FMT-AYUV8-1X32">
+	      <entry>MEDIA_BUS_FMT_AYUV8_1X32</entry>
+	      <entry>0x2017</entry>
+	      <entry></entry>
+	      <entry>a<subscript>7</subscript></entry>
+	      <entry>a<subscript>6</subscript></entry>
+	      <entry>a<subscript>5</subscript></entry>
+	      <entry>a<subscript>4</subscript></entry>
+	      <entry>a<subscript>3</subscript></entry>
+	      <entry>a<subscript>2</subscript></entry>
+	      <entry>a<subscript>1</subscript></entry>
+	      <entry>a<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
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
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index b585bb3..363a30f 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -67,6 +67,10 @@
 #define MEDIA_BUS_FMT_YUYV10_2X10		0x200b
 #define MEDIA_BUS_FMT_YVYU10_2X10		0x200c
 #define MEDIA_BUS_FMT_Y12_1X12			0x2013
+#define MEDIA_BUS_FMT_UYVY12_2X12		0x201c
+#define MEDIA_BUS_FMT_VYUY12_2X12		0x201d
+#define MEDIA_BUS_FMT_YUYV12_2X12		0x201e
+#define MEDIA_BUS_FMT_YVYU12_2X12		0x201f
 #define MEDIA_BUS_FMT_UYVY8_1X16		0x200f
 #define MEDIA_BUS_FMT_VYUY8_1X16		0x2010
 #define MEDIA_BUS_FMT_YUYV8_1X16		0x2011
@@ -76,16 +80,12 @@
 #define MEDIA_BUS_FMT_VYUY10_1X20		0x201b
 #define MEDIA_BUS_FMT_YUYV10_1X20		0x200d
 #define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
-#define MEDIA_BUS_FMT_YUV10_1X30		0x2016
-#define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
-#define MEDIA_BUS_FMT_UYVY12_2X12		0x201c
-#define MEDIA_BUS_FMT_VYUY12_2X12		0x201d
-#define MEDIA_BUS_FMT_YUYV12_2X12		0x201e
-#define MEDIA_BUS_FMT_YVYU12_2X12		0x201f
 #define MEDIA_BUS_FMT_UYVY12_1X24		0x2020
 #define MEDIA_BUS_FMT_VYUY12_1X24		0x2021
 #define MEDIA_BUS_FMT_YUYV12_1X24		0x2022
 #define MEDIA_BUS_FMT_YVYU12_1X24		0x2023
+#define MEDIA_BUS_FMT_YUV10_1X30		0x2016
+#define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
 
 /* Bayer - next is	0x3019 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
-- 
2.0.5

