Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33457 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbbEZPC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 11:02:26 -0400
Received: by wgez8 with SMTP id z8so99896119wge.0
        for <linux-media@vger.kernel.org>; Tue, 26 May 2015 08:02:11 -0700 (PDT)
Date: Tue, 26 May 2015 17:02:06 +0200
From: "Piotr S. Staszewski" <p.staszewski@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2] staging: media: omap4iss: Reformat overly long lines
Message-ID: <20150526150206.GA30383@swordfish>
References: <20150526085418.GA22775@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150526085418.GA22775@swordfish>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reformats lines that were previously above 80 characters long,
improving readability and making checkpatch.pl happier.

Signed-off-by: Piotr S. Staszewski <p.staszewski@gmail.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c    | 18 +++++++++++------
 drivers/staging/media/omap4iss/iss_ipipe.c   | 30 ++++++++++++++++++----------
 drivers/staging/media/omap4iss/iss_ipipeif.c | 10 ++++++----
 drivers/staging/media/omap4iss/iss_resizer.c |  8 +++++---
 4 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index d7ff769..bc83f82 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -828,8 +828,10 @@ static const struct iss_video_operations csi2_issvideo_ops = {
  */
 
 static struct v4l2_mbus_framefmt *
-__csi2_get_format(struct iss_csi2_device *csi2, struct v4l2_subdev_pad_config *cfg,
-		  unsigned int pad, enum v4l2_subdev_format_whence which)
+__csi2_get_format(struct iss_csi2_device *csi2,
+		  struct v4l2_subdev_pad_config *cfg,
+		  unsigned int pad,
+		  enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
 		return v4l2_subdev_get_try_format(&csi2->subdev, cfg, pad);
@@ -838,8 +840,10 @@ __csi2_get_format(struct iss_csi2_device *csi2, struct v4l2_subdev_pad_config *c
 }
 
 static void
-csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_pad_config *cfg,
-		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+csi2_try_format(struct iss_csi2_device *csi2,
+		struct v4l2_subdev_pad_config *cfg,
+		unsigned int pad,
+		struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
 	u32 pixelcode;
@@ -967,7 +971,8 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+static int csi2_get_format(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
@@ -988,7 +993,8 @@ static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+static int csi2_set_format(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index eaa82da..f94a592 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -24,8 +24,10 @@
 #include "iss_ipipe.h"
 
 static struct v4l2_mbus_framefmt *
-__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config *cfg,
-		  unsigned int pad, enum v4l2_subdev_format_whence which);
+__ipipe_get_format(struct iss_ipipe_device *ipipe,
+		   struct v4l2_subdev_pad_config *cfg,
+		   unsigned int pad,
+		   enum v4l2_subdev_format_whence which);
 
 static const unsigned int ipipe_fmts[] = {
 	MEDIA_BUS_FMT_SGRBG10_1X10,
@@ -176,8 +178,10 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_mbus_framefmt *
-__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config *cfg,
-		  unsigned int pad, enum v4l2_subdev_format_whence which)
+__ipipe_get_format(struct iss_ipipe_device *ipipe,
+		   struct v4l2_subdev_pad_config *cfg,
+		   unsigned int pad,
+		   enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
 		return v4l2_subdev_get_try_format(&ipipe->subdev, cfg, pad);
@@ -193,9 +197,11 @@ __ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config
  * @fmt: Format
  */
 static void
-ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config *cfg,
-		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
-		enum v4l2_subdev_format_whence which)
+ipipe_try_format(struct iss_ipipe_device *ipipe,
+		 struct v4l2_subdev_pad_config *cfg,
+		 unsigned int pad,
+		 struct v4l2_mbus_framefmt *fmt,
+		 enum v4l2_subdev_format_whence which)
 {
 	struct v4l2_mbus_framefmt *format;
 	unsigned int width = fmt->width;
@@ -306,8 +312,9 @@ static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
+static int ipipe_get_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
@@ -329,8 +336,9 @@ static int ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_confi
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
+static int ipipe_set_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 530ac84..c0da13d 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -518,8 +518,9 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
+static int ipipeif_get_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
@@ -541,8 +542,9 @@ static int ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_con
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
+static int ipipeif_set_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 5f69012..5030cf3 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -580,8 +580,9 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
+static int resizer_get_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_format *fmt)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
@@ -603,7 +604,8 @@ static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_con
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
+static int resizer_set_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
-- 
2.4.1


-- 
Piotr S. Staszewski                              http://www.drbig.one.pl
dRbiG at FreeNode, IRCNet
                         But all's one level plain he hunts for flowers.
