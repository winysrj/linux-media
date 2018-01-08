Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1682455182.outbound-mail.sendgrid.net ([168.245.5.182]:30942
        "EHLO o1682455182.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753960AbeAHR56 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 12:57:58 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Archit Taneja <architt@codeaurora.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] v4l: doc: Clarify v4l2_mbus_fmt height definition
Date: Mon, 08 Jan 2018 17:55:23 +0000 (UTC)
Message-Id: <1515434106-18747-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_mbus_fmt width and height corresponds directly with the
v4l2_pix_format definitions, yet the differences in documentation make
it ambiguous what to do in the event of field heights.

Clarify this using the same text as is provided for the v4l2_pix_format
which is explicit on the matter, and by matching the terminology of
'image height' rather than the misleading 'frame height'.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
v2:
 - Duplicated explicit text from v4l2_pix_format rather than
   referencing it.

 Documentation/media/uapi/v4l/subdev-formats.rst | 8 ++++++--
 include/uapi/linux/v4l2-mediabus.h              | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index b1eea44550e1..9fcabe7f9367 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -16,10 +16,14 @@ Media Bus Formats
 
     * - __u32
       - ``width``
-      - Image width, in pixels.
+      - Image width in pixels.
     * - __u32
       - ``height``
-      - Image height, in pixels.
+      - Image height in pixels. If ``field`` is one of ``V4L2_FIELD_TOP``,
+	``V4L2_FIELD_BOTTOM`` or ``V4L2_FIELD_ALTERNATE`` then height
+	refers to the number of lines in the field, otherwise it refers to
+	the number of lines in the frame (which is twice the field height
+	for interlaced formats).
     * - __u32
       - ``code``
       - Format code, from enum
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 6e20de63ec59..123a231001a8 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -18,8 +18,8 @@
 
 /**
  * struct v4l2_mbus_framefmt - frame format on the media bus
- * @width:	frame width
- * @height:	frame height
+ * @width:	image width
+ * @height:	image height
  * @code:	data format code (from enum v4l2_mbus_pixelcode)
  * @field:	used interlacing type (from enum v4l2_field)
  * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
-- 
2.7.4
