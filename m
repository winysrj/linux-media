Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36896 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752932AbeCUUIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 16:08:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: v4l2-common: fix a compilation breakage
Date: Wed, 21 Mar 2018 16:08:29 -0400
Message-Id: <238f694e1b7f8297f1256c57e41f69c39576c9b4.1521662907.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clearly, changeset 95ce9c28601a ("media: v4l: common: Add a
function to obtain best size from a list") was never tested, as it
broke compilation with:

drivers/media/platform/vivid/vivid-vid-cap.c: In function ‘vivid_try_fmt_vid_cap’:
drivers/media/platform/vivid/vivid-vid-cap.c:565:34: error: macro "v4l2_find_nearest_size" requer 6 argumentos, mas apenas 5 foram fornecidos
             mp->width, mp->height);
                                  ^
drivers/media/platform/vivid/vivid-vid-cap.c:564:4: error: ‘v4l2_find_nearest_size’ undeclared (first use in this function); did you mean ‘__v4l2_find_nearest_size’?
    v4l2_find_nearest_size(webcam_sizes, width, height,
    ^~~~~~~~~~~~~~~~~~~~~~
    __v4l2_find_nearest_size
drivers/media/platform/vivid/vivid-vid-cap.c:564:4: note: each undeclared identifier is reported only once for each function it appears in
drivers/media/i2c/ov5670.c: In function ‘ov5670_set_pad_format’:
drivers/media/i2c/ov5670.c:2233:48: error: macro "v4l2_find_nearest_size" requer 6 argumentos, mas apenas 5 foram fornecidos
           fmt->format.width, fmt->format.height);
                                                ^
drivers/media/i2c/ov5670.c:2232:9: error: ‘v4l2_find_nearest_size’ undeclared (first use in this function); did you mean ‘__v4l2_find_nearest_size’?
  mode = v4l2_find_nearest_size(supported_modes, width, height,
         ^~~~~~~~~~~~~~~~~~~~~~
         __v4l2_find_nearest_size
drivers/media/i2c/ov13858.c: In function ‘ov13858_set_pad_format’:
drivers/media/i2c/ov13858.c:1379:48: error: macro "v4l2_find_nearest_size" requer 6 argumentos, mas apenas 5 foram fornecidos
           fmt->format.width, fmt->format.height);
                                                ^
drivers/media/i2c/ov13858.c:1378:9: error: ‘v4l2_find_nearest_size’ undeclared (first use in this function); did you mean ‘__v4l2_find_nearest_size’?
  mode = v4l2_find_nearest_size(supported_modes, width, height,
         ^~~~~~~~~~~~~~~~~~~~~~
         __v4l2_find_nearest_size
drivers/media/i2c/ov13858.c:1378:9: note: each undeclared identifier is reported only once for each function it appears in

Basically, v4l2_find_nearest_size() callers pass 5 arguments,
while its definition require 6 args.

Unfortunately, my build process was also broken, as it was reporting me that
the compilation went fine:

	$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='compile_checks' M=drivers/staging/media
	$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='compile_checks' M=drivers/media

	*** ERRORS ***

	*** WARNINGS ***
	compilation succeeded

That was due to a change here to use of linux-log-diff script that
provides a diffstat between the errors output. Somehow, the logic
was missing some fatal errors.

Fixes: 95ce9c28601a ("media: v4l: common: Add a function to obtain best size from a list")

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-common.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 160bca96d524..54b689247937 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -320,7 +320,6 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
  *	set of resolutions contained in an array of a driver specific struct.
  *
  * @array: a driver specific array of image sizes
- * @array_size: the length of the driver specific array of image sizes
  * @width_field: the name of the width field in the driver specific struct
  * @height_field: the name of the height field in the driver specific struct
  * @width: desired width.
@@ -333,13 +332,13 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
  *
  * Returns the best match or NULL if the length of the array is zero.
  */
-#define v4l2_find_nearest_size(array, array_size, width_field, height_field, \
+#define v4l2_find_nearest_size(array, width_field, height_field, \
 			       width, height)				\
 	({								\
 		BUILD_BUG_ON(sizeof((array)->width_field) != sizeof(u32) || \
 			     sizeof((array)->height_field) != sizeof(u32)); \
 		(typeof(&(*(array))))__v4l2_find_nearest_size(		\
-			(array), array_size, sizeof(*(array)),		\
+			(array), ARRAY_SIZE(array), sizeof(*(array)),	\
 			offsetof(typeof(*(array)), width_field),	\
 			offsetof(typeof(*(array)), height_field),	\
 			width, height);					\
-- 
2.14.3
