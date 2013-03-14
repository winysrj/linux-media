Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:52712 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3CNQvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 12:51:42 -0400
Received: from relmlir1.idc.renesas.com ([10.200.68.151])
 by relmlor3.idc.renesas.com ( SJSMS)
 with ESMTP id <0MJN0026KTI4F600@relmlor3.idc.renesas.com> for
 linux-media@vger.kernel.org; Fri, 15 Mar 2013 01:51:40 +0900 (JST)
Received: from relmlac3.idc.renesas.com ([10.200.69.23])
 by relmlir1.idc.renesas.com (SJSMS)
 with ESMTP id <0MJN008VGTI4DD50@relmlir1.idc.renesas.com> for
 linux-media@vger.kernel.org; Fri, 15 Mar 2013 01:51:40 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1303081228050.24912@axis700.grange>
References: <1360834509-1228-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1303081228050.24912@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH] soc_camera: Add RGB666 & RGB888 formats
Message-id: <OFB47C6CBF.EF9CF8E0-ON80257B2E.005C1F03-80257B2E.005C9489@eu.necel.com>
Date: Thu, 14 Mar 2013 16:51:31 +0000
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> To: Phil Edworthy <phil.edworthy@renesas.com>, 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, 
linux-media@vger.kernel.org
> Date: 08/03/2013 13:30
> Subject: Re: [PATCH] soc_camera: Add RGB666 & RGB888 formats
> 
> Hi Phil
> 
> On Thu, 14 Feb 2013, Phil Edworthy wrote:
> 
> > Based on work done by Katsuya Matsubara.
> > 
> > Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> 
> Looks mostly good to me, but please also provide format descriptions for 

> Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml, also see a couple 

> of minor notes below

I had a look at the doc you pointed to, but it appears to only describe 
formats that can be accessed by userspace. I take it you meant 
Documentation/DocBook/media/v4l/subdev-formats.xml?

> > ---
> >  drivers/media/platform/soc_camera/soc_mediabus.c |   42 +++++++++
> +++++++++++++
> >  include/media/soc_camera.h                       |    6 +++-
> >  include/media/soc_mediabus.h                     |    3 ++
> >  include/uapi/linux/v4l2-mediabus.h               |    6 +++-
> >  4 files changed, 55 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/
> drivers/media/platform/soc_camera/soc_mediabus.c
> > index a397812..d8acfd3 100644
> > --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> > +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> > @@ -97,6 +97,42 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
> >        .layout         = SOC_MBUS_LAYOUT_PACKED,
> >     },
> >  }, {
> > +   .code = V4L2_MBUS_FMT_RGB666_1X18,
> > +   .fmt = {
> > +      .fourcc         = V4L2_PIX_FMT_RGB32,
> > +      .name         = "RGB666/32bpp",
> > +      .bits_per_sample   = 18,
> > +      .packing      = SOC_MBUS_PACKING_EXTEND32,
> > +      .order         = SOC_MBUS_ORDER_LE,
> > +   },
> > +}, {
> > +   .code = V4L2_MBUS_FMT_RGB888_1X24,
> > +   .fmt = {
> > +      .fourcc         = V4L2_PIX_FMT_RGB32,
> > +      .name         = "RGB888/32bpp",
> > +      .bits_per_sample   = 24,
> > +      .packing      = SOC_MBUS_PACKING_EXTEND32,
> > +      .order         = SOC_MBUS_ORDER_LE,
> > +   },
> > +}, {
> > +   .code = V4L2_MBUS_FMT_RGB888_2X12_BE,
> > +   .fmt = {
> > +      .fourcc         = V4L2_PIX_FMT_RGB32,
> > +      .name         = "RGB888/32bpp",
> > +      .bits_per_sample   = 12,
> > +      .packing      = SOC_MBUS_PACKING_EXTEND32,
> > +      .order         = SOC_MBUS_ORDER_BE,
> > +   },
> > +}, {
> > +   .code = V4L2_MBUS_FMT_RGB888_2X12_LE,
> > +   .fmt = {
> > +      .fourcc         = V4L2_PIX_FMT_RGB32,
> > +      .name         = "RGB888/32bpp",
> > +      .bits_per_sample   = 12,
> > +      .packing      = SOC_MBUS_PACKING_EXTEND32,
> > +      .order         = SOC_MBUS_ORDER_LE,
> > +   },
> > +}, {
> >     .code = V4L2_MBUS_FMT_SBGGR8_1X8,
> >     .fmt = {
> >        .fourcc         = V4L2_PIX_FMT_SBGGR8,
> > @@ -358,6 +394,10 @@ int soc_mbus_samples_per_pixel(const struct 
> soc_mbus_pixelfmt *mf,
> >        *numerator = 1;
> >        *denominator = 1;
> >        return 0;
> > +   case SOC_MBUS_PACKING_EXTEND32:
> > +      *numerator = 1;
> > +      *denominator = 1;
> > +      return 0;
> >     case SOC_MBUS_PACKING_2X8_PADHI:
> >     case SOC_MBUS_PACKING_2X8_PADLO:
> >        *numerator = 2;
> > @@ -395,6 +435,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const 
> struct soc_mbus_pixelfmt *mf)
> >        return width * 3 / 2;
> >     case SOC_MBUS_PACKING_VARIABLE:
> >        return 0;
> > +   case SOC_MBUS_PACKING_EXTEND32:
> > +      return width * 4;
> >     }
> >     return -EINVAL;
> >  }
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index 6442edc..c820be2 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -231,10 +231,14 @@ struct soc_camera_sense {
> >  #define SOCAM_DATAWIDTH_10   SOCAM_DATAWIDTH(10)
> 
> Didn't you forget to define SOCAM_DATAWIDTH_12 here?
Yes, I forgot this.

> >  #define SOCAM_DATAWIDTH_15   SOCAM_DATAWIDTH(15)
> >  #define SOCAM_DATAWIDTH_16   SOCAM_DATAWIDTH(16)
> > +#define SOCAM_DATAWIDTH_18   SOCAM_DATAWIDTH(18)
> > +#define SOCAM_DATAWIDTH_24   SOCAM_DATAWIDTH(24)
> > 
> >  #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | 
\
> >                 SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
> > -               SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_16)
> > +               SOCAM_DATAWIDTH_12 | SOCAM_DATAWIDTH_15 | \
> > +               SOCAM_DATAWIDTH_16 | SOCAM_DATAWIDTH_18 | \
> > +               SOCAM_DATAWIDTH_24)
> > 
> >  static inline void soc_camera_limit_side(int *start, int *length,
> >        unsigned int start_min,
> > diff --git a/include/media/soc_mediabus.h 
b/include/media/soc_mediabus.h
> > index 0dc6f46..eea98d1 100644
> > --- a/include/media/soc_mediabus.h
> > +++ b/include/media/soc_mediabus.h
> > @@ -26,6 +26,8 @@
> >   * @SOC_MBUS_PACKING_VARIABLE:   compressed formats with variable 
packing
> >   * @SOC_MBUS_PACKING_1_5X8:   used for packed YUV 4:2:0 formats, 
where 4
> >   *            pixels occupy 6 bytes in RAM
> > + * @SOC_MBUS_PACKING_EXTEND32:  sample width (e.g., 24 bits) has 
> to be extended
> 
> Please, use a TAB above
Of course.

Thanks
Phil
