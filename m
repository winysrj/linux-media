Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46546
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752305AbdIVVrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:47:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/8] media: v4l2-common.h: document ancillary functions
Date: Fri, 22 Sep 2017 18:47:02 -0300
Message-Id: <e6a49003ba4d298a97c7887af38233b223174f0a.1506116720.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506116720.git.mchehab@s-opensource.com>
References: <cover.1506116720.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506116720.git.mchehab@s-opensource.com>
References: <cover.1506116720.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several ancillary functions that aren't documented.

Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-common.c |  14 -----
 include/media/v4l2-common.h           | 104 ++++++++++++++++++++++++++++++----
 2 files changed, 94 insertions(+), 24 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index fb9a2a3c1072..ac404d5083e0 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -320,20 +320,6 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
 	return x;
 }
 
-/* Bound an image to have a width between wmin and wmax, and height between
- * hmin and hmax, inclusive.  Additionally, the width will be a multiple of
- * 2^walign, the height will be a multiple of 2^halign, and the overall size
- * (width*height) will be a multiple of 2^salign.  The image may be shrunk
- * or enlarged to fit the alignment constraints.
- *
- * The width or height maximum must not be smaller than the corresponding
- * minimum.  The alignments must not be so high there are no possible image
- * sizes within the allowed bounds.  wmin and hmin must be at least 1
- * (don't use 0).  If you don't care about a certain alignment, specify 0,
- * as 2^0 is 1 and one byte alignment is equivalent to no alignment.  If
- * you only want to adjust downward, specify a maximum that's the same as
- * the initial value.
- */
 void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
 			   unsigned int walign,
 			   u32 *h, unsigned int hmin, unsigned int hmax,
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 7ae7840df068..d3f5f907d566 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -174,17 +174,43 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
  */
 unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd);
 
+/**
+ * enum v4l2_i2c_tuner_type - specifies the range of tuner address that
+ *	should be used when seeking for I2C devices.
+ *
+ * @ADDRS_RADIO:		Radio tuner addresses.
+ * 				Represent the following I2C addresses:
+ * 				0x10 (if compiled with tea5761 support)
+ *				and 0x60.
+ * @ADDRS_DEMOD:		Demod tuner addresses.
+ * 				Represent the following I2C addresses:
+ * 				0x42, 0x43, 0x4a and 0x4b.
+ * @ADDRS_TV:			TV tuner addresses.
+ * 				Represent the following I2C addresses:
+ * 				0x42, 0x43, 0x4a, 0x4b, 0x60, 0x61, 0x62,
+ *				0x63 and 0x64.
+ * @ADDRS_TV_WITH_DEMOD:	TV tuner addresses if demod is present, this
+ *				excludes addresses used by the demodulator
+ *				from the list of candidates.
+ * 				Represent the following I2C addresses:
+ * 				0x60, 0x61, 0x62, 0x63 and 0x64.
+ *
+ * NOTE: All I2C addresses above use the 7-bit notation.
+ */
 enum v4l2_i2c_tuner_type {
-	ADDRS_RADIO,	/* Radio tuner addresses */
-	ADDRS_DEMOD,	/* Demod tuner addresses */
-	ADDRS_TV,	/* TV tuner addresses */
-	/* TV tuner addresses if demod is present, this excludes
-	   addresses used by the demodulator from the list of
-	   candidates. */
+	ADDRS_RADIO,
+	ADDRS_DEMOD,
+	ADDRS_TV,
 	ADDRS_TV_WITH_DEMOD,
 };
-/* Return a list of I2C tuner addresses to probe. Use only if the tuner
-   addresses are unknown. */
+/**
+ * v4l2_i2c_tuner_addrs - Return a list of I2C tuner addresses to probe.
+ *
+ * @type: type of the tuner type to seek, as defined by
+ *	  &enum v4l2_i2c_tuner_type.
+ *
+ * NOTE: Use only if the tuner addresses are unknown.
+ */
 const unsigned short *v4l2_i2c_tuner_addrs(enum v4l2_i2c_tuner_type type);
 
 /* ------------------------------------------------------------------------- */
@@ -228,6 +254,9 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
  * FIXME: these remaining ioctls/structs should be removed as well, but they
  * are still used in tuner-simple.c (TUNER_SET_CONFIG) and cx18/ivtv (RESET).
  * To remove these ioctls some more cleanup is needed in those modules.
+ *
+ * It doesn't make much sense on documenting them, as what we really want is
+ * to get rid of them.
  */
 
 /* s_config */
@@ -243,17 +272,72 @@ struct v4l2_priv_tun_config {
 
 /* Miscellaneous helper functions */
 
-void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
+/**
+ * v4l_bound_align_image - adjust video dimensions according to
+ * 	a given criteria.
+ *
+ * @width:	pointer to width that will be adjusted if needed.
+ * @wmin:	minimum width.
+ * @wmax:	maximum width.
+ * @walign:	least significant bit on width.
+ * @height:	pointer to height that will be adjusted if needed.
+ * @hmin:	minimum height.
+ * @hmax:	maximum height.
+ * @halign:	least significant bit on width.
+ * @salign:	least significant bit for the image size (e. g.
+ *		:math:`width * height`).
+ *
+ * Bound an image to have @width between @wmin and @wmax, and @height between
+ * @hmin and @hmax, inclusive.
+ *
+ * Additionally, the @width will be a multiple of :math:`2^{walign}`,
+ * the @height will be a multiple of :math:`2^{halign}`, and the overall
+ * size :math:`width * height` will be a multiple of :math:`2^{salign}`.
+ *
+ * .. note::
+ *
+ *    #. The image may be shrunk or enlarged to fit the alignment constraints.
+ *    #. @wmax must not be smaller than @wmin.
+ *    #. @hmax must not be smaller than @hmin.
+ *    #. The alignments must not be so high there are no possible image
+ *       sizes within the allowed bounds.
+ *    #. @wmin and @hmin must be at least 1 (don't use 0).
+ *    #. For @walign, @halign and @salign, if you don't care about a certain
+ *       alignment, specify ``0``, as :math:`2^0 = 1` and one byte alignment
+ *       is equivalent to no alignment.
+ *    #. If you only want to adjust downward, specify a maximum that's the
+ *       same as the initial value.
+ */
+void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
 			   unsigned int wmax, unsigned int walign,
-			   unsigned int *h, unsigned int hmin,
+			   unsigned int *height, unsigned int hmin,
 			   unsigned int hmax, unsigned int halign,
 			   unsigned int salign);
 
+/**
+ * v4l2_find_nearest_format - find the nearest format size among a discrete
+ *	set of resolutions.
+ *
+ * @sizes: array with a pointer to & struct v4l2_frmsize_discrete image sizes.
+ * @num_sizes: size of @sizes array.
+ * @width: desired width.
+ * @height: desired heigth.
+ *
+ * Finds the closest resolution to minimize the width and height differences
+ * between what userspace requested and the supported resolutions.
+ */
 const struct v4l2_frmsize_discrete
 *v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
 			  const size_t num_sizes,
 			  s32 width, s32 height);
 
+/**
+ * v4l2_get_timestamp - ancillary routine to get a timestamp to be used when
+ *	filling streaming metadata. Internally, it uses ktime_get_ts(),
+ *	with is the recommended way to get it.
+ *
+ * @tv: pointer to &stuct timeval to be filled.
+ */
 void v4l2_get_timestamp(struct timeval *tv);
 
 #endif /* V4L2_COMMON_H_ */
-- 
2.13.5
