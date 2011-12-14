Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:27121 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab1LNPW6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 10:22:58 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, snjw23@gmail.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: [RFC 1/3] v4l: Add pixel clock to struct v4l2_mbus_framefmt
Date: Wed, 14 Dec 2011 17:22:25 +0200
Message-Id: <1323876147-18107-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111201143044.GI29805@valkosipuli.localdomain>
References: <20111201143044.GI29805@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pixel clock is an essential part of the image data parameters. Add this.
Together, the current parameters also define the frame rate.

Sensors do not have a concept of frame rate; pixel clock is much more
meaningful in this context. Also, it is best to combine the pixel clock with
the other format parameters since there are dependencies between them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml |    9 ++++++++-
 include/linux/v4l2-mediabus.h                      |    4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 49c532e..b4591ef 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -35,7 +35,14 @@
 	</row>
 	<row>
 	  <entry>__u32</entry>
-	  <entry><structfield>reserved</structfield>[7]</entry>
+	  <entry><structfield>pixel_clock</structfield></entry>
+	  <entry>Pixel clock in kHz. This clock is the maximum rate at
+	  which pixels are transferred on the bus. The pixel_clock
+	  field is read-only.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>reserved</structfield>[6]</entry>
 	  <entry>Reserved for future extensions. Applications and drivers must
 	  set the array to zero.</entry>
 	</row>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..76a0df2 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -101,6 +101,7 @@ enum v4l2_mbus_pixelcode {
  * @code:	data format code (from enum v4l2_mbus_pixelcode)
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
+ * @pixel_clock: pixel clock, in kHz
  */
 struct v4l2_mbus_framefmt {
 	__u32			width;
@@ -108,7 +109,8 @@ struct v4l2_mbus_framefmt {
 	__u32			code;
 	__u32			field;
 	__u32			colorspace;
-	__u32			reserved[7];
+	__u32			pixel_clock;
+	__u32			reserved[6];
 };
 
 #endif
-- 
1.7.2.5

