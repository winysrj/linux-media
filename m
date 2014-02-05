Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBEQls (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 05/47] v4l: Add 12-bit YUV 4:2:2 media bus pixel codes
Date: Wed,  5 Feb 2014 17:41:56 +0100
Message-Id: <1391618558-5580-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 240 +++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                 |   6 +-
 2 files changed, 245 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index a0fa7e0..b2d5a03 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -3006,6 +3006,246 @@
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-UYVY12-1X24">
+	      <entry>V4L2_MBUS_FMT_UYVY12_1X24</entry>
+	      <entry>0x2020</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
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
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
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
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	    </row>
+	    <row id="V4L2-MBUS-FMT-VYUY12-1X24">
+	      <entry>V4L2_MBUS_FMT_VYUY12_1X24</entry>
+	      <entry>0x2021</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
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
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
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
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YUYV12-1X24">
+	      <entry>V4L2_MBUS_FMT_YUYV12_1X24</entry>
+	      <entry>0x2022</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
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
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
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
+	    <row id="V4L2-MBUS-FMT-YVYU12-1X24">
+	      <entry>V4L2_MBUS_FMT_YVYU12_1X24</entry>
+	      <entry>0x2023</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	      <entry>v<subscript>11</subscript></entry>
+	      <entry>v<subscript>10</subscript></entry>
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
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>y<subscript>11</subscript></entry>
+	      <entry>y<subscript>10</subscript></entry>
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
+	      <entry>u<subscript>11</subscript></entry>
+	      <entry>u<subscript>10</subscript></entry>
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
+	    </row>
 	  </tbody>
 	</tgroup>
       </table>
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 70a732b..1445e85 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -52,7 +52,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
 	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
 
-	/* YUV (including grey) - next is 0x2020 */
+	/* YUV (including grey) - next is 0x2024 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
@@ -84,6 +84,10 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_VYUY12_2X12 = 0x201d,
 	V4L2_MBUS_FMT_YUYV12_2X12 = 0x201e,
 	V4L2_MBUS_FMT_YVYU12_2X12 = 0x201f,
+	V4L2_MBUS_FMT_UYVY12_1X24 = 0x2020,
+	V4L2_MBUS_FMT_VYUY12_1X24 = 0x2021,
+	V4L2_MBUS_FMT_YUYV12_1X24 = 0x2022,
+	V4L2_MBUS_FMT_YVYU12_1X24 = 0x2023,
 
 	/* Bayer - next is 0x3019 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
-- 
1.8.3.2

