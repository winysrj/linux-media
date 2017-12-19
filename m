Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46240 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750737AbdLSLEB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:04:01 -0500
Date: Tue, 19 Dec 2017 09:03:55 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 15/24] media: v4l2-subdev: get rid of
 __V4L2_SUBDEV_MK_GET_TRY() macro
Message-ID: <20171219090355.6f9a36e2@vento.lan>
In-Reply-To: <20171219082450.csf4hwlhmpe52xly@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
        <63937cedcefd1c56b211ec115b717510c470bd1a.1507544011.git.mchehab@s-opensource.com>
        <20171009202355.ckhaf5xcba5z4tvh@valkosipuli.retiisi.org.uk>
        <20171218172704.57d250d0@vento.lan>
        <20171219082450.csf4hwlhmpe52xly@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Dec 2017 10:24:51 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Mon, Dec 18, 2017 at 05:27:04PM -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 9 Oct 2017 23:23:56 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > On Mon, Oct 09, 2017 at 07:19:21AM -0300, Mauro Carvalho Chehab wrote:  
> > > > The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
> > > > 3 functions that have the same arguments. The code of those
> > > > functions is simple enough to just declare them, de-obfuscating
> > > > the code.
> > > > 
> > > > While here, replace BUG_ON() by WARN_ON() as there's no reason
> > > > why to panic the Kernel if this fails.  
> > > 
> > > BUG_ON() might actually be a better idea as this will lead to memory
> > > corruption. I presume it's not been hit often.  
> > 
> > Well, let's then change the code to:
> > 
> >         if (WARN_ON(pad >= sd->entity.num_pads)) 
> >                 return -EINVAL;
> > 
> > This way, it won't try to use an invalid value. As those are default
> > handlers for ioctls, userspace should be able to handle it.  
> 
> Another approach would be to return the entry for a valid pad. Few if any
> drivers perform error handling on the value returned for the simple reason
> that they know how many pads their own entities have.

Well, they should check for errors on returned values :-)

Anyway, I guess that using pad=0 as a way to avoid Kernel crashes
is not a bad idea.

Patch enclosed. It replaces patch 6/8.

Thanks,
Mauro

[PATCH] media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro

The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
3 functions that have the same arguments. The code of those
functions is simple enough to just declare them, de-obfuscating
the code.

While here, replace BUG_ON() by WARN_ON() as there's no reason
why to panic the Kernel if this fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 71b8ff4b2e0e..443e5e019006 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -896,19 +896,35 @@ struct v4l2_subdev_fh {
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
-	static inline struct rtype *					\
-	fun_name(struct v4l2_subdev *sd,				\
-		 struct v4l2_subdev_pad_config *cfg,			\
-		 unsigned int pad)					\
-	{								\
-		BUG_ON(pad >= sd->entity.num_pads);			\
-		return &cfg[pad].field_name;				\
-	}
+static inline struct v4l2_mbus_framefmt
+*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    unsigned int pad)
+{
+	if (WARN_ON(pad >= sd->entity.num_pads))
+		pad = 0;
+	return &cfg[pad].try_fmt;
+}
+
+static inline struct v4l2_rect
+*v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  unsigned int pad)
+{
+	if (WARN_ON(pad >= sd->entity.num_pads))
+		pad = 0;
+	return &cfg[pad].try_crop;
+}
 
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
+static inline struct v4l2_rect
+*v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     unsigned int pad)
+{
+	if (WARN_ON(pad >= sd->entity.num_pads))
+		pad = 0;
+	return &cfg[pad].try_compose;
+}
 #endif
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
