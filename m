Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:37286 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3DYKMk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 06:12:40 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor1.idc.renesas.com ( SJSMS)
 with ESMTP id <0MLT00FCX2SRYY90@relmlor1.idc.renesas.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 19:07:39 +0900 (JST)
Received: from relmlac2.idc.renesas.com ([10.200.69.22])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MLT00MLE2SN6GE0@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 19:07:39 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1304242249410.16970@axis700.grange>
References: <1366202619-4511-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1304242249410.16970@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH] soc_camera: Add V4L2_MBUS_FMT_YUYV10_2X10 format
Message-id: <OF975E3643.061D9EDC-ON80257B58.003660C1-80257B58.00379495@eu.necel.com>
Date: Thu, 25 Apr 2013 11:07:02 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the review!

> On Wed, 17 Apr 2013, Phil Edworthy wrote:
> 
> > The V4L2_MBUS_FMT_YUYV10_2X10 format has already been added to 
mediabus, so
> > this patch just adds SoC camera support.
> > 
> > Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> > ---
> >  drivers/media/platform/soc_camera/soc_mediabus.c |   15 
+++++++++++++++
> >  include/media/soc_mediabus.h                     |    3 +++
> >  2 files changed, 18 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/
> drivers/media/platform/soc_camera/soc_mediabus.c
> > index 7569e77..be47d41 100644
> > --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> > +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> > @@ -57,6 +57,15 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
> >        .layout         = SOC_MBUS_LAYOUT_PACKED,
> >     },
> >  }, {
> > +   .code = V4L2_MBUS_FMT_YUYV10_2X10,
> > +   .fmt = {
> > +      .fourcc         = V4L2_PIX_FMT_YUYV,
> > +      .name         = "YUYV",
> > +      .bits_per_sample   = 10,
> > +      .packing      = SOC_MBUS_PACKING_2X10_PADHI,
> 
> Wow, what kind of host can pack two 10-bit samples into 3 bytes and 
write 
> 3-byte pixels to memory?
I think I might have misunderstood how this is used. From my 
understanding, the MBUS formats are used to describe the hardware 
interfaces to cameras, i.e. 2 samples of 10 bits. I guess that the fourcc 
field also determines what v4l2 format is required to capture this. 
However, I am not sure how the two relate to each other. How does the 
above code imply 3 bytes?

> > +      .order         = SOC_MBUS_ORDER_LE,
> > +   },
> > +}, {
> >     .code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> >     .fmt = {
> >        .fourcc         = V4L2_PIX_FMT_RGB555,
> > @@ -403,6 +412,10 @@ int soc_mbus_samples_per_pixel(const struct 
> soc_mbus_pixelfmt *mf,
> >        *numerator = 2;
> >        *denominator = 1;
> >        return 0;
> > +   case SOC_MBUS_PACKING_2X10_PADHI:
> > +      *numerator = 3;
> > +      *denominator = 1;
> 
> Why 3? it's 2 samples per pixel, right? Should be *numerator = 2 above?
Not sure why I thought it should be 3, I think I had it in my head that 
this was the number of bytes needed per pixel. Clearly this is not the 
case!

> > +      return 0;
> >     case SOC_MBUS_PACKING_1_5X8:
> >        *numerator = 3;
> >        *denominator = 2;
> > @@ -428,6 +441,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const 
> struct soc_mbus_pixelfmt *mf)
> >     case SOC_MBUS_PACKING_2X8_PADLO:
> >     case SOC_MBUS_PACKING_EXTEND16:
> >        return width * 2;
> > +   case SOC_MBUS_PACKING_2X10_PADHI:
> > +      return width * 3;
> >     case SOC_MBUS_PACKING_1_5X8:
> >        return width * 3 / 2;
> >     case SOC_MBUS_PACKING_VARIABLE:
> > diff --git a/include/media/soc_mediabus.h 
b/include/media/soc_mediabus.h
> > index d33f6d0..b131a47 100644
> > --- a/include/media/soc_mediabus.h
> > +++ b/include/media/soc_mediabus.h
> > @@ -21,6 +21,8 @@
> >   * @SOC_MBUS_PACKING_2X8_PADHI:   16 bits transferred in 2 8-bit 
> samples, in the
> >   *            possibly incomplete byte high bits are padding
> >   * @SOC_MBUS_PACKING_2X8_PADLO:   as above, but low bits are padding
> > + * @SOC_MBUS_PACKING_2X10_PADHI:20 bits transferred in 2 10-bit 
> samples. The
> 
> A TAB is missing after ":"?
Ok.
 
> > + *            high bits are padding
> >   * @SOC_MBUS_PACKING_EXTEND16:   sample width (e.g., 10 bits) has
> to be extended
> >   *            to 16 bits
> >   * @SOC_MBUS_PACKING_VARIABLE:   compressed formats with variable 
packing
> > @@ -33,6 +35,7 @@ enum soc_mbus_packing {
> >     SOC_MBUS_PACKING_NONE,
> >     SOC_MBUS_PACKING_2X8_PADHI,
> >     SOC_MBUS_PACKING_2X8_PADLO,
> > +   SOC_MBUS_PACKING_2X10_PADHI,
> >     SOC_MBUS_PACKING_EXTEND16,
> >     SOC_MBUS_PACKING_VARIABLE,
> >     SOC_MBUS_PACKING_1_5X8,
> > -- 
> > 1.7.5.4

Thanks
Phil
