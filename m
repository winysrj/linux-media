Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55938 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbaCJTeq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 15:34:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [FINAL PATCH 1/6] v4l: rename v4l2_format_sdr to v4l2_sdr_format
Date: Mon, 10 Mar 2014 21:34:07 +0200
Message-Id: <1394480052-6003-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename v4l2_format_sdr to v4l2_sdr_format in order to keep it in
line with other formats.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-sdr.xml | 2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c        | 2 +-
 include/uapi/linux/videodev2.h              | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
index ac9f1af..524b9c4 100644
--- a/Documentation/DocBook/media/v4l/dev-sdr.xml
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -78,7 +78,7 @@ of the data format.
     </para>
 
     <table pgwide="1" frame="none" id="v4l2-format-sdr">
-      <title>struct <structname>v4l2_format_sdr</structname></title>
+      <title>struct <structname>v4l2_sdr_format</structname></title>
       <tgroup cols="3">
         &cs-str;
         <tbody valign="top">
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 95dd4f1..e6e86a2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -246,7 +246,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_vbi_format *vbi;
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
-	const struct v4l2_format_sdr *sdr;
+	const struct v4l2_sdr_format *sdr;
 	unsigned i;
 
 	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index d3187d8..5f10ed9 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1714,10 +1714,10 @@ struct v4l2_pix_format_mplane {
 } __attribute__ ((packed));
 
 /**
- * struct v4l2_format_sdr - SDR format definition
+ * struct v4l2_sdr_format - SDR format definition
  * @pixelformat:	little endian four character code (fourcc)
  */
-struct v4l2_format_sdr {
+struct v4l2_sdr_format {
 	__u32				pixelformat;
 	__u8				reserved[28];
 } __attribute__ ((packed));
@@ -1740,7 +1740,7 @@ struct v4l2_format {
 		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
 		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
 		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
-		struct v4l2_format_sdr		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
+		struct v4l2_sdr_format		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
 		__u8	raw_data[200];                   /* user-defined */
 	} fmt;
 };
-- 
1.8.5.3

