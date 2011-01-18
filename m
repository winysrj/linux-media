Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:50436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1ARRam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 12:30:42 -0500
Date: Tue, 18 Jan 2011 18:30:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: soc-camera jpeg support?
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2EF@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1101181811590.19950@axis700.grange>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101171826340.16051@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2EF@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for the code! With it at hand it is going to be easier to 
understand and evaluate changes, that you propose to the generic modules.

On Mon, 17 Jan 2011, Qing Xu wrote:

> Hi, Guennadi,
> 
> Oh, yes, I agree with you, you are right, it is really not that simple, 
> JPEG is always a headache,:(, as it is quite different from original 
> yuv/rgb format, it has neither fixed bits-per-sample, nor fixed 
> packing/bytes-per-line/per-frame, so when coding, I just hack value of 
> .bits_per_sample and .packing, in fact, you will see in our host driver, 
> if we find it is JPEG, will ignore bytes-per-line value, for example, in 
> pxa955_videobuf_prepare(), for jpeg, we always allocate fixed buffer 
> size for it (or, a better method is to allocate buffer size = 
> width*height/jpeg-compress-ratio).
> 
> I have 2 ideas:
> 1) Do you think it is reasonable to add a not-fixed define into soc_mbus_packing:
> enum soc_mbus_packing {
>         SOC_MBUS_PACKING_NOT_FIXED,
>         ...
> };
> And then, .bits_per_sample      = 0, /* indicate that sample bits is not-fixed*/
> And, in function:
> s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
> {
>         switch (mf->packing) {
>                 case SOC_MBUS_PACKING_NOT_FIXED:
>                         return 0;
>                 case SOC_MBUS_PACKING_NONE:
>                         return width * mf->bits_per_sample / 8;
>                 ...
>         }
>         return -EINVAL;
> }
> 
> 2) Or, an workaround in sensor(ov5642.c), is to implement:
> int (*try_fmt)(struct v4l2_subdev *sd, struct v4l2_format *fmt);
> use the member (fmt->pix->pixelformat == V4L2_PIX_FMT_JPEG) to find out 
> if it is jpeg. And in host driver, it calls try_fmt() into sensor. In 
> this way, no need to change soc-camera common code, but I feel that it 
> goes against with your xxx_mbus_xxx design purpose, right?

I actually prefer this one, but with an addition of V4L2_MBUS_FMT_JPEG_1X8 
as per your additional üatch, but, please, also add a new packing, e.g., 
SOC_MBUS_PACKING_COMPRESSED (or SOC_MBUS_PACKING_VARIABLE?). So, that we 
can cleanly translate between V4L2_MBUS_FMT_JPEG_1X8 and 
V4L2_PIX_FMT_JPEG, but host drivers, that want to support this, will have 
to know to calculate frame sizes in some special way, not just aborting, 
if soc_mbus_bytes_per_line() returned an error. We might also consider 
returning a different error code for this case, e.g., we could change the 
general error case to return -ENOENT, and use -EINVAL for cases like JPEG, 
where data is valid, but no valid calculation is possible.

Thanks
Guennadi

> What do you think?
> 
> Please check the attachment, it is our host camera controller driver and sensor.
> 
> Thanks a lot!
> -Qing
> 
> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: 2011Äê1ÔÂ18ÈÕ 1:39
> To: Qing Xu
> Cc: Laurent Pinchart; Linux Media Mailing List
> Subject: Re: soc-camera jpeg support?
> 
> On Mon, 17 Jan 2011, Qing Xu wrote:
> 
> > Hi,
> >
> > Many of our sensors support directly outputting JPEG data to camera
> > controller, do you feel it's reasonable to add jpeg support into
> > soc-camera? As it seems that there is no define in v4l2-mediabus.h which
> > is suitable for our case.
> 
> In principle I have nothing against this, but, I'm afraid, it is not quite
> that simple. I haven't worked with such sensors myself, but, AFAIU, the
> JPEG image format doesn't have fixed bytes-per-line and bytes-per-frame
> values. If you add it like you propose, this would mean, that it just
> delivers "normal" 8 bits per pixel images. OTOH, soc_mbus_bytes_per_line()
> would just return -EINVAL for your JPEG format, so, unsupporting drivers
> would just error out, which is not all that bad. When the first driver
> decides to support JPEG, they will have to handle that error. But maybe
> we'll want to return a special error code for it.
> 
> But, in fact, that is in a way my problem with your patches: you propose
> extensions to generic code without showing how this is going to be used in
> specific drivers. Could you show us your host driver, please? I don't
> think this is still the pxa27x driver, is it?
> 
> Thanks
> Guennadi
> 
> >
> > Such as:
> > --- a/drivers/media/video/soc_mediabus.c
> > +++ b/drivers/media/video/soc_mediabus.c
> > @@ -130,6 +130,13 @@ static const struct soc_mbus_pixelfmt mbus_fmt[] = {
> >                 .packing                = SOC_MBUS_PACKING_2X8_PADLO,
> >                 .order                  = SOC_MBUS_ORDER_BE,
> >         },
> > +       [MBUS_IDX(JPEG_1X8)] = {
> > +               .fourcc                 = V4L2_PIX_FMT_JPEG,
> > +               .name                   = "JPEG",
> > +               .bits_per_sample        = 8,
> > +               .packing                = SOC_MBUS_PACKING_NONE,
> > +               .order                  = SOC_MBUS_ORDER_LE,
> > +       },
> >  };
> >
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -41,6 +41,7 @@ enum v4l2_mbus_pixelcode {
> >         V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> >         V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> >         V4L2_MBUS_FMT_SGRBG8_1X8,
> > +       V4L2_MBUS_FMT_JPEG_1X8,
> >  };
> >
> > Any ideas will be appreciated!
> > Thanks!
> > Qing Xu
> >
> > Email: qingx@marvell.com
> > Application Processor Systems Engineering,
> > Marvell Technology Group Ltd.
> >
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
