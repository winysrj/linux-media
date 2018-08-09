Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46043 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbeHIQRO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 12:17:14 -0400
Date: Thu, 9 Aug 2018 15:52:05 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: mchehab@kernel.org, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, javierm@redhat.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 06/22] [media] tvp5150: add FORMAT_TRY support for
 get/set selection handlers
Message-ID: <20180809135205.drqolr752nbv7bug@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-7-m.felsch@pengutronix.de>
 <20180730210123.7f1f2b57@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180730210123.7f1f2b57@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

during my work for a v2 series, I prepared two patches which fix this in a
common way. The first will fix the compiler break and the second will
fix a missing dependency, since those helper functions require the
media_entity which is only available if MEDIA_CONTROLLER is enabled.

I attached both inline as an RFC, can give me your feedback?

I removed the devicetree guys to aviod noise.

On 18-07-30 21:01, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Jun 2018 18:20:38 +0200
> Marco Felsch <m.felsch@pengutronix.de> escreveu:
> 
> > Since commit 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
> > the 'which' field for set/get_selection must be FORMAT_ACTIVE. There is
> > no way to try different selections. The patch adds a helper function to
> > select the correct selection memory space (sub-device file handle or
> > driver state) which will be set/returned.
> > 
> > The TVP5150 AVID will be updated if the 'which' field is FORMAT_ACTIVE
> > and the requested selection rectangle differs from the already set one.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  drivers/media/i2c/tvp5150.c | 107 ++++++++++++++++++++++++------------
> >  1 file changed, 73 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index d150487cc2d1..29eaf8166f25 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -18,6 +18,7 @@
> >  #include <media/v4l2-ctrls.h>
> >  #include <media/v4l2-fwnode.h>
> >  #include <media/v4l2-mc.h>
> > +#include <media/v4l2-rect.h>
> >  
> >  #include "tvp5150_reg.h"
> >  
> > @@ -846,20 +847,38 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
> >  	}
> >  }
> >  
> > +static struct v4l2_rect *
> > +__tvp5150_get_pad_crop(struct tvp5150 *decoder,
> > +		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
> > +		       enum v4l2_subdev_format_whence which)
> > +{
> > +	switch (which) {
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +		return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);
> 
> This is not ok. It causes compilation breakage if the subdev API is not
> selected:
> 
> drivers/media/i2c/tvp5150.c: In function ‘__tvp5150_get_pad_crop’:
> drivers/media/i2c/tvp5150.c:857:10: error: implicit declaration of function ‘v4l2_subdev_get_try_crop’; did you mean ‘v4l2_subdev_has_op’? [-Werror=implicit-function-declaration]
>    return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);
>           ^~~~~~~~~~~~~~~~~~~~~~~~
>           v4l2_subdev_has_op
> drivers/media/i2c/tvp5150.c:857:10: warning: returning ‘int’ from a function with return type ‘struct v4l2_rect *’ makes pointer from integer without a cast [-Wint-conversion]
>    return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The logic should keep working both with and without subdev API.
> 

[ snip ]

>From d87554df5d1c6d609e44852a1cb998a6f5d99601 Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Wed, 8 Aug 2018 14:27:46 +0200
Subject: [RFC] [media] v4l2-subdev: add stubs for v4l2_subdev_get_try_*

In case of missing CONFIG_VIDEO_V4L2_SUBDEV_API those helpers aren't
available. So each driver have to add ifdefs around those helpers or
add the CONFIG_VIDEO_V4L2_SUBDEV_API as dependcy.

Make these helpers available in case of CONFIG_VIDEO_V4L2_SUBDEV_API
isn't set to avoid ifdefs. This approach is less error prone too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 include/media/v4l2-subdev.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9102d6ca566e..ce48f1fcf295 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -912,8 +912,6 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
-#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-
 /**
  * v4l2_subdev_get_try_format - ancillary routine to call
  *	&struct v4l2_subdev_pad_config->try_fmt
@@ -927,9 +925,13 @@ static inline struct v4l2_mbus_framefmt
 			    struct v4l2_subdev_pad_config *cfg,
 			    unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_fmt;
+#else
+	return NULL;
+#endif
 }
 
 /**
@@ -945,9 +947,13 @@ static inline struct v4l2_rect
 			  struct v4l2_subdev_pad_config *cfg,
 			  unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_crop;
+#else
+	return NULL;
+#endif
 }
 
 /**
@@ -963,11 +969,14 @@ static inline struct v4l2_rect
 			     struct v4l2_subdev_pad_config *cfg,
 			     unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_compose;
-}
+#else
+	return NULL;
 #endif
+}
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
-- 
2.18.0

>From 6abc7599fe6bdb2b8bef84fd90417d69aafb4a33 Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Wed, 8 Aug 2018 14:47:44 +0200
Subject: [RFC] [media] v4l2-subdev: fix v4l2_subdev_get_try_* dependency

These helpers make us of the media-controller entity which is only
available if the CONFIG_MEDIA_CONTROLLER is enabled.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 include/media/v4l2-subdev.h | 100 ++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index ce48f1fcf295..79c066934ad2 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -912,6 +912,56 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
+extern const struct v4l2_file_operations v4l2_subdev_fops;
+
+/**
+ * v4l2_set_subdevdata - Sets V4L2 dev private device data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @p: pointer to the private device data to be stored.
+ */
+static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
+{
+	sd->dev_priv = p;
+}
+
+/**
+ * v4l2_get_subdevdata - Gets V4L2 dev private device data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ *
+ * Returns the pointer to the private device data to be stored.
+ */
+static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
+{
+	return sd->dev_priv;
+}
+
+/**
+ * v4l2_set_subdev_hostdata - Sets V4L2 dev private host data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @p: pointer to the private data to be stored.
+ */
+static inline void v4l2_set_subdev_hostdata(struct v4l2_subdev *sd, void *p)
+{
+	sd->host_priv = p;
+}
+
+/**
+ * v4l2_get_subdev_hostdata - Gets V4L2 dev private data
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ *
+ * Returns the pointer to the private host data to be stored.
+ */
+static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
+{
+	return sd->host_priv;
+}
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+
 /**
  * v4l2_subdev_get_try_format - ancillary routine to call
  *	&struct v4l2_subdev_pad_config->try_fmt
@@ -978,56 +1028,6 @@ static inline struct v4l2_rect
 #endif
 }
 
-extern const struct v4l2_file_operations v4l2_subdev_fops;
-
-/**
- * v4l2_set_subdevdata - Sets V4L2 dev private device data
- *
- * @sd: pointer to &struct v4l2_subdev
- * @p: pointer to the private device data to be stored.
- */
-static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
-{
-	sd->dev_priv = p;
-}
-
-/**
- * v4l2_get_subdevdata - Gets V4L2 dev private device data
- *
- * @sd: pointer to &struct v4l2_subdev
- *
- * Returns the pointer to the private device data to be stored.
- */
-static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
-{
-	return sd->dev_priv;
-}
-
-/**
- * v4l2_set_subdev_hostdata - Sets V4L2 dev private host data
- *
- * @sd: pointer to &struct v4l2_subdev
- * @p: pointer to the private data to be stored.
- */
-static inline void v4l2_set_subdev_hostdata(struct v4l2_subdev *sd, void *p)
-{
-	sd->host_priv = p;
-}
-
-/**
- * v4l2_get_subdev_hostdata - Gets V4L2 dev private data
- *
- * @sd: pointer to &struct v4l2_subdev
- *
- * Returns the pointer to the private host data to be stored.
- */
-static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
-{
-	return sd->host_priv;
-}
-
-#ifdef CONFIG_MEDIA_CONTROLLER
-
 /**
  * v4l2_subdev_link_validate_default - validates a media link
  *
-- 
2.18.0

Kind regards,
Marco
