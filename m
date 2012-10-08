Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39795 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2JHUlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 16:41:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement .get_frame_desc subdev callback
Date: Mon, 08 Oct 2012 22:42 +0200
Message-ID: <2290105.hTRlMPSUYP@avalon>
In-Reply-To: <50704D26.9020201@hoogenraad.net>
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com> <1348674853-24596-6-git-send-email-s.nawrocki@samsung.com> <50704D26.9020201@hoogenraad.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

When did the {get,set}_frame_desc subdev operations reach mainline ? Last I 
knew is that they were an RFC, and they're now suddenly in, without even one 
ack from an embedded v4l developer :-S I'm not totally happy with that.

On Saturday 06 October 2012 17:24:22 Jan Hoogenraad wrote:
> On my ubuntu 10.4 system
> 
> Linux 2.6.32-43-generic-pae #97-Ubuntu SMP Wed Sep 5 16:59:17 UTC 2012
> i686 GNU/Linux
> 
> this patch breaks compilation of media_build.
> The constant SZ_1M is not defined in the includes on my system
> 
> Do you know what can be done about this ?
> 
> ---
> 
> /home/jhh/dvb/media_build/v4l/m5mols_core.c: In function
> 'm5mols_set_frame_desc':
> /home/jhh/dvb/media_build/v4l/m5mols_core.c:636: error: 'SZ_1M'
> undeclared (first use in this function)
> /home/jhh/dvb/media_build/v4l/m5mols_core.c:636: error: (Each undeclared
> identifier is reported only once
> /home/jhh/dvb/media_build/v4l/m5mols_core.c:636: error: for each
> function it appears in.)
> 
> Sylwester Nawrocki wrote:
> > .get_frame_desc can be used by host interface driver to query
> > properties of captured frames, e.g. required memory buffer size.
> > 
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > 
> >  drivers/media/i2c/m5mols/m5mols.h         |  9 ++++++
> >  drivers/media/i2c/m5mols/m5mols_capture.c |  3 ++
> >  drivers/media/i2c/m5mols/m5mols_core.c    | 47
> >  +++++++++++++++++++++++++++++++ drivers/media/i2c/m5mols/m5mols_reg.h   
> >   |  1 +
> >  4 files changed, 60 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/m5mols/m5mols.h
> > b/drivers/media/i2c/m5mols/m5mols.h index 15d3a4f..de3b755 100644
> > --- a/drivers/media/i2c/m5mols/m5mols.h
> > +++ b/drivers/media/i2c/m5mols/m5mols.h
> > @@ -19,6 +19,13 @@
> > 
> >  #include <media/v4l2-subdev.h>
> >  #include "m5mols_reg.h"
> > 
> > +
> > +/* An amount of data transmitted in addition to the value
> > + * determined by CAPP_JPEG_SIZE_MAX register.
> > + */
> > +#define M5MOLS_JPEG_TAGS_SIZE		0x20000
> > +#define M5MOLS_MAIN_JPEG_SIZE_MAX	(5 * SZ_1M)
> > +
> > 
> >  extern int m5mols_debug;
> >  
> >  enum m5mols_restype {
> > 
> > @@ -67,12 +74,14 @@ struct m5mols_exif {
> > 
> >  /**
> >  
> >   * struct m5mols_capture - Structure for the capture capability
> >   * @exif: EXIF information
> > 
> > + * @buf_size: internal JPEG frame buffer size, in bytes
> > 
> >   * @main: size in bytes of the main image
> >   * @thumb: size in bytes of the thumb image, if it was accompanied
> >   * @total: total size in bytes of the produced image
> >   */
> >  
> >  struct m5mols_capture {
> >  
> >  	struct m5mols_exif exif;
> > 
> > +	unsigned int buf_size;
> > 
> >  	u32 main;
> >  	u32 thumb;
> >  	u32 total;
> > 
> > diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c
> > b/drivers/media/i2c/m5mols/m5mols_capture.c index cb243bd..ab34cce 100644
> > --- a/drivers/media/i2c/m5mols/m5mols_capture.c
> > +++ b/drivers/media/i2c/m5mols/m5mols_capture.c
> > @@ -105,6 +105,7 @@ static int m5mols_capture_info(struct m5mols_info
> > *info)> 
> >  int m5mols_start_capture(struct m5mols_info *info)
> >  {
> > 
> > +	unsigned int framesize = info->cap.buf_size - M5MOLS_JPEG_TAGS_SIZE;
> > 
> >  	struct v4l2_subdev *sd = &info->sd;
> >  	int ret;
> > 
> > @@ -121,6 +122,8 @@ int m5mols_start_capture(struct m5mols_info *info)
> > 
> >  	if (!ret)
> >  	
> >  		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, info->resolution);
> >  	
> >  	if (!ret)
> > 
> > +		ret = m5mols_write(sd, CAPP_JPEG_SIZE_MAX, framesize);
> > +	if (!ret)
> > 
> >  		ret = m5mols_set_mode(info, REG_CAPTURE);
> >  	
> >  	if (!ret)
> >  	
> >  		/* Wait until a frame is captured to ISP internal memory */
> > 
> > diff --git a/drivers/media/i2c/m5mols/m5mols_core.c
> > b/drivers/media/i2c/m5mols/m5mols_core.c index 933014f..c780689 100644
> > --- a/drivers/media/i2c/m5mols/m5mols_core.c
> > +++ b/drivers/media/i2c/m5mols/m5mols_core.c
> > @@ -599,6 +599,51 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd,
> > struct v4l2_subdev_fh *fh,> 
> >  	return ret;
> >  
> >  }
> > 
> > +static int m5mols_get_frame_desc(struct v4l2_subdev *sd, unsigned int
> > pad,
> > +				 struct v4l2_mbus_frame_desc *fd)
> > +{
> > +	struct m5mols_info *info = to_m5mols(sd);
> > +
> > +	if (pad != 0 || fd == NULL)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&info->lock);
> > +	/*
> > +	 * .get_frame_desc is only used for compressed formats,
> > +	 * thus we always return the capture frame parameters here.
> > +	 */
> > +	fd->entry[0].length = info->cap.buf_size;
> > +	fd->entry[0].pixelcode = info->ffmt[M5MOLS_RESTYPE_CAPTURE].code;
> > +	mutex_unlock(&info->lock);
> > +
> > +	fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
> > +	fd->num_entries = 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int m5mols_set_frame_desc(struct v4l2_subdev *sd, unsigned int
> > pad,
> > +				 struct v4l2_mbus_frame_desc *fd)
> > +{
> > +	struct m5mols_info *info = to_m5mols(sd);
> > +	struct v4l2_mbus_framefmt *mf = &info->ffmt[M5MOLS_RESTYPE_CAPTURE];
> > +
> > +	if (pad != 0 || fd == NULL)
> > +		return -EINVAL;
> > +
> > +	fd->entry[0].flags = V4L2_MBUS_FRAME_DESC_FL_LEN_MAX;
> > +	fd->num_entries = 1;
> > +	fd->entry[0].length = clamp_t(u32, fd->entry[0].length,
> > +				      mf->width * mf->height,
> > +				      M5MOLS_MAIN_JPEG_SIZE_MAX);
> > +	mutex_lock(&info->lock);
> > +	info->cap.buf_size = fd->entry[0].length;
> > +	mutex_unlock(&info->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +
> > 
> >  static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
> >  
> >  				 struct v4l2_subdev_fh *fh,
> >  				 struct v4l2_subdev_mbus_code_enum *code)
> > 
> > @@ -615,6 +660,8 @@ static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
> > 
> >  	.enum_mbus_code	= m5mols_enum_mbus_code,
> >  	.get_fmt	= m5mols_get_fmt,
> >  	.set_fmt	= m5mols_set_fmt,
> > 
> > +	.get_frame_desc	= m5mols_get_frame_desc,
> > +	.set_frame_desc	= m5mols_set_frame_desc,
> > 
> >  };
> >  
> >  /**
> > 
> > diff --git a/drivers/media/i2c/m5mols/m5mols_reg.h
> > b/drivers/media/i2c/m5mols/m5mols_reg.h index 14d4be7..58d8027 100644
> > --- a/drivers/media/i2c/m5mols/m5mols_reg.h
> > +++ b/drivers/media/i2c/m5mols/m5mols_reg.h
> > @@ -310,6 +310,7 @@
> > 
> >  #define REG_JPEG		0x10
> >  
> >  #define CAPP_MAIN_IMAGE_SIZE	I2C_REG(CAT_CAPT_PARM, 0x01, 1)
> > 
> > +#define CAPP_JPEG_SIZE_MAX	I2C_REG(CAT_CAPT_PARM, 0x0f, 4)
> > 
> >  #define CAPP_JPEG_RATIO		I2C_REG(CAT_CAPT_PARM, 0x17, 1)
> >  
> >  #define CAPP_MCC_MODE		I2C_REG(CAT_CAPT_PARM, 0x1d, 1)
-- 
Regards,

Laurent Pinchart

