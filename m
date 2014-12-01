Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59766 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaLAUNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 15:13:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v4 03/10] v4l: Sort YUV formats of v4l2_mbus_pixelcode
Date: Mon,  1 Dec 2014 22:13:33 +0200
Message-Id: <1417464820-6718-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index 0cc3ca5..872ff89 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2239,11 +2239,15 @@
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
@@ -2252,6 +2256,16 @@
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
@@ -2265,7 +2279,11 @@
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
@@ -2274,6 +2292,16 @@
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
@@ -2283,11 +2311,15 @@
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
@@ -2296,6 +2328,16 @@
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
@@ -2309,7 +2351,11 @@
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
@@ -2318,6 +2364,16 @@
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
@@ -2327,11 +2383,15 @@
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
@@ -2340,6 +2400,16 @@
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
@@ -2353,7 +2423,11 @@
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
@@ -2362,6 +2436,16 @@
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
@@ -2371,11 +2455,15 @@
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
@@ -2384,6 +2472,16 @@
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
@@ -2397,29 +2495,11 @@
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
@@ -2428,28 +2508,16 @@
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
@@ -2459,57 +2527,11 @@
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
@@ -2518,8 +2540,6 @@
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2533,9 +2553,7 @@
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
@@ -2544,8 +2562,6 @@
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2555,13 +2571,11 @@
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
@@ -2570,8 +2584,6 @@
 	      <entry>v<subscript>2</subscript></entry>
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2585,9 +2597,7 @@
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
@@ -2596,8 +2606,6 @@
 	      <entry>u<subscript>2</subscript></entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
-	      <entry>y<subscript>9</subscript></entry>
-	      <entry>y<subscript>8</subscript></entry>
 	      <entry>y<subscript>7</subscript></entry>
 	      <entry>y<subscript>6</subscript></entry>
 	      <entry>y<subscript>5</subscript></entry>
@@ -2607,13 +2615,11 @@
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
@@ -2622,8 +2628,6 @@
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2637,9 +2641,7 @@
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
@@ -2648,8 +2650,6 @@
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2659,13 +2659,11 @@
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
@@ -2674,8 +2672,6 @@
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>v<subscript>9</subscript></entry>
-	      <entry>v<subscript>8</subscript></entry>
 	      <entry>v<subscript>7</subscript></entry>
 	      <entry>v<subscript>6</subscript></entry>
 	      <entry>v<subscript>5</subscript></entry>
@@ -2689,9 +2685,51 @@
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
@@ -2700,8 +2738,6 @@
 	      <entry>y<subscript>2</subscript></entry>
 	      <entry>y<subscript>1</subscript></entry>
 	      <entry>y<subscript>0</subscript></entry>
-	      <entry>u<subscript>9</subscript></entry>
-	      <entry>u<subscript>8</subscript></entry>
 	      <entry>u<subscript>7</subscript></entry>
 	      <entry>u<subscript>6</subscript></entry>
 	      <entry>u<subscript>5</subscript></entry>
@@ -2711,14 +2747,11 @@
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
@@ -2727,39 +2760,20 @@
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
@@ -2768,14 +2782,6 @@
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
@@ -2785,13 +2791,11 @@
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
@@ -2802,14 +2806,6 @@
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
@@ -2825,9 +2821,7 @@
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
@@ -2838,14 +2832,6 @@
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
@@ -2857,13 +2843,11 @@
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
@@ -2874,14 +2858,6 @@
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
@@ -2897,9 +2873,7 @@
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
@@ -2910,14 +2884,6 @@
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
@@ -2929,13 +2895,11 @@
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
@@ -2946,14 +2910,6 @@
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
@@ -2969,9 +2925,7 @@
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
@@ -2982,14 +2936,6 @@
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
@@ -3001,13 +2947,11 @@
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
@@ -3018,14 +2962,6 @@
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
@@ -3041,9 +2977,7 @@
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
@@ -3054,14 +2988,6 @@
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
@@ -3313,6 +3239,80 @@
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
2.0.4

