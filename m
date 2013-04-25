Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3DYNrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 09:47:42 -0400
Date: Thu, 25 Apr 2013 15:47:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: phil.edworthy@renesas.com
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] soc_camera: Add V4L2_MBUS_FMT_YUYV10_2X10 format
In-Reply-To: <OF94EFCFB7.8EC190E4-ON80257B58.00450077-80257B58.0049B035@eu.necel.com>
Message-ID: <Pine.LNX.4.64.1304251535590.21045@axis700.grange>
References: <1366202619-4511-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1304242249410.16970@axis700.grange>
 <OF975E3643.061D9EDC-ON80257B58.003660C1-80257B58.00379495@eu.necel.com>
 <Pine.LNX.4.64.1304251241430.21045@axis700.grange>
 <OF94EFCFB7.8EC190E4-ON80257B58.00450077-80257B58.0049B035@eu.necel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 25 Apr 2013, phil.edworthy@renesas.com wrote:

> Hi Guennadi,
> 
> > > > On Wed, 17 Apr 2013, Phil Edworthy wrote:
> > > > 
> > > > > The V4L2_MBUS_FMT_YUYV10_2X10 format has already been added to 
> > > mediabus, so
> > > > > this patch just adds SoC camera support.
> > > > > 
> > > > > Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> > > > > ---
> > > > >  drivers/media/platform/soc_camera/soc_mediabus.c |   15 
> > > +++++++++++++++
> > > > >  include/media/soc_mediabus.h                     |    3 +++
> > > > >  2 files changed, 18 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/
> > > > drivers/media/platform/soc_camera/soc_mediabus.c
> > > > > index 7569e77..be47d41 100644
> > > > > --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> > > > > +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> > > > > @@ -57,6 +57,15 @@ static const struct soc_mbus_lookup mbus_fmt[] 
> = {
> > > > >        .layout         = SOC_MBUS_LAYOUT_PACKED,
> > > > >     },
> > > > >  }, {
> > > > > +   .code = V4L2_MBUS_FMT_YUYV10_2X10,
> > > > > +   .fmt = {
> > > > > +      .fourcc         = V4L2_PIX_FMT_YUYV,
> > > > > +      .name         = "YUYV",
> > > > > +      .bits_per_sample   = 10,
> > > > > +      .packing      = SOC_MBUS_PACKING_2X10_PADHI,
> > > > 
> > > > Wow, what kind of host can pack two 10-bit samples into 3 bytes and 
> > > write 
> > > > 3-byte pixels to memory?
> > > I think I might have misunderstood how this is used. From my 
> > > understanding, the MBUS formats are used to describe the hardware 
> > > interfaces to cameras, i.e. 2 samples of 10 bits. I guess that the 
> fourcc 
> > > field also determines what v4l2 format is required to capture this. 
> > 
> > No, not quite. This table describes default "pass-through" capture of 
> > video data on a media bus to memory. E.g. the first entry in the table 
> > means, that if you get the V4L2_MBUS_FMT_YUYV8_2X8 format on the bus, 
> you 
> > sample 8 bits at a time, and store the samples 1-to-1 into RAM, you get 
> > the V4L2_PIX_FMT_YUYV format in your buffer. It can also describe some 
> > standard operations with the sampled data, like swapping the order, 
> > filling missing high bits (e.g. if you sample 10 bits but store 16 bits 
> > per sample with high 6 bits nullified). The table also specifies which 
> > bits are used for padding in the original data, e.g. 
> > V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE has SOC_MBUS_PACKING_2X8_PADLO, 
> whereas 
> > V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE has SOC_MBUS_PACKING_2X8_PADHI, which 
> 
> > means, that out of 16 bits of data, that you get when you sample an 
> 8-bit 
> > bus twice, either low or high 6 bits are invalid and should be 
> discarded.
> 
> Ok, I see. However, is it necessary to provide a default pass-through v4l2 
> format?

No, it's not. If no (soc-camera) host camera driver is willing to use this 
pass-through conversion, then it's not required.

> I can't see a suitable v4l2 format! For the hardware I have been 
> working on, there is always the option of converting the data to another 
> format, so this is not really needed. I doubt that it makes sense to add 
> yet another v4l2 format for userspace, when typical uses would involve the 
> host hardware converting the format to something else, e.g. 
> V4L2_PIX_FMT_RGB32.

Up to you, really. If you don't need this default conversion, don't add 
it.

> > > However, I am not sure how the two relate to each other. How does the 
> > > above code imply 3 bytes?
> > 
> > Not the above code, but your entry in the soc_mbus_bytes_per_line() 
> > function below, where you multiply width * 3.
> 
> It looks like hosts use soc_mbus_bytes_per_line() to report the size of 
> video buffers needed. Shouldn't the hosts report the buffer metrics for 
> the v4l2 format, since that is what will be output? What has this to do 
> with the MBUS specifics?

struct soc_mbus_pixelfmt describes a conversion from an MBUS code to a 
pixel format in memory. Camera host drivers call that function with a 
_suitable_ conversion descriptor (either a standard or a special one) and 
the function calculates the number of bytes.

> > > > > +      .order         = SOC_MBUS_ORDER_LE,
> > > > > +   },
> > > > > +}, {
> > > > >     .code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > > > >     .fmt = {
> > > > >        .fourcc         = V4L2_PIX_FMT_RGB555,
> > > > > @@ -403,6 +412,10 @@ int soc_mbus_samples_per_pixel(const struct 
> > > > soc_mbus_pixelfmt *mf,
> > > > >        *numerator = 2;
> > > > >        *denominator = 1;
> > > > >        return 0;
> > > > > +   case SOC_MBUS_PACKING_2X10_PADHI:
> > > > > +      *numerator = 3;
> > > > > +      *denominator = 1;
> > > > 
> > > > Why 3? it's 2 samples per pixel, right? Should be *numerator = 2 
> above?
> > > Not sure why I thought it should be 3, I think I had it in my head 
> that 
> > > this was the number of bytes needed per pixel. Clearly this is not the 
> 
> > > case!
> > > 
> > > > > +      return 0;
> > > > >     case SOC_MBUS_PACKING_1_5X8:
> > > > >        *numerator = 3;
> > > > >        *denominator = 2;
> > > > > @@ -428,6 +441,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const 
> > > > struct soc_mbus_pixelfmt *mf)
> > > > >     case SOC_MBUS_PACKING_2X8_PADLO:
> > > > >     case SOC_MBUS_PACKING_EXTEND16:
> > > > >        return width * 2;
> > > > > +   case SOC_MBUS_PACKING_2X10_PADHI:
> > > > > +      return width * 3;
> > > > >     case SOC_MBUS_PACKING_1_5X8:
> > > > >        return width * 3 / 2;
> > > > >     case SOC_MBUS_PACKING_VARIABLE:
> > > > > diff --git a/include/media/soc_mediabus.h 
> > > b/include/media/soc_mediabus.h
> > > > > index d33f6d0..b131a47 100644
> > > > > --- a/include/media/soc_mediabus.h
> > > > > +++ b/include/media/soc_mediabus.h
> > > > > @@ -21,6 +21,8 @@
> > > > >   * @SOC_MBUS_PACKING_2X8_PADHI:   16 bits transferred in 2 8-bit 
> > > > samples, in the
> > > > >   *            possibly incomplete byte high bits are padding
> > > > >   * @SOC_MBUS_PACKING_2X8_PADLO:   as above, but low bits are 
> padding
> > > > > + * @SOC_MBUS_PACKING_2X10_PADHI:20 bits transferred in 2 10-bit 
> > > > samples. The
> > > > 
> > > > A TAB is missing after ":"?
> > > Ok.
> 
> I just came to make this changes, however the text for 
> SOC_MBUS_PACKING_2X10_PADHI is in line with the surrounding text. Would 
> you like all of the other comments to be indented with another tab?

Ah right, sorry, no, then please don't.

Thanks
Guennadi

> > > > > + *            high bits are padding
> > > > >   * @SOC_MBUS_PACKING_EXTEND16:   sample width (e.g., 10 bits) has
> > > > to be extended
> > > > >   *            to 16 bits
> > > > >   * @SOC_MBUS_PACKING_VARIABLE:   compressed formats with variable 
> 
> > > packing
> > > > > @@ -33,6 +35,7 @@ enum soc_mbus_packing {
> > > > >     SOC_MBUS_PACKING_NONE,
> > > > >     SOC_MBUS_PACKING_2X8_PADHI,
> > > > >     SOC_MBUS_PACKING_2X8_PADLO,
> > > > > +   SOC_MBUS_PACKING_2X10_PADHI,
> > > > >     SOC_MBUS_PACKING_EXTEND16,
> > > > >     SOC_MBUS_PACKING_VARIABLE,
> > > > >     SOC_MBUS_PACKING_1_5X8,
> > > > > -- 
> > > > > 1.7.5.4
> 
> Thanks
> Phil
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
