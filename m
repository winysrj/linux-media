Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46203 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbeEWJat (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 05:30:49 -0400
Message-ID: <1527067847.6875.3.camel@pengutronix.de>
Subject: Re: [PATCH] media: video-mux: fix compliance failures
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Rui Miguel Silva <rui.silva@linaro.org>, kernel@pengutronix.de
Date: Wed, 23 May 2018 11:30:47 +0200
In-Reply-To: <322fa7c6-451e-bb81-eaa6-8677350b64ee@xs4all.nl>
References: <20180522162925.16854-1-p.zabel@pengutronix.de>
         <16e0879d-2db3-951b-fd96-636b9615a3f2@xs4all.nl>
         <1527065278.6875.1.camel@pengutronix.de>
         <322fa7c6-451e-bb81-eaa6-8677350b64ee@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-05-23 at 10:53 +0200, Hans Verkuil wrote:
> On 23/05/18 10:47, Philipp Zabel wrote:
> > Hi Hans,
> > 
> > thank you for the review comments.
> > 
> > On Tue, 2018-05-22 at 19:47 +0200, Hans Verkuil wrote:
> > > On 22/05/18 18:29, Philipp Zabel wrote:
> > > > Limit frame sizes to the [1, UINT_MAX-1] interval, media bus formats to
> > > > the available list of formats, and initialize pad and try formats.
> > > > 
> > > > Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
> > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > > ---
> > > >  drivers/media/platform/video-mux.c | 110 +++++++++++++++++++++++++++++
> > > >  1 file changed, 110 insertions(+)
> > > > 
> > > > diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> > > > index 1fb887293337..ade1dae706aa 100644
> > > > --- a/drivers/media/platform/video-mux.c
> > > > +++ b/drivers/media/platform/video-mux.c
> > > > @@ -180,6 +180,87 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
> > > >  	if (!source_mbusformat)
> > > >  		return -EINVAL;
> > > >  
> > > > +	/* No size limitations except V4L2 compliance requirements */
> > > > +	v4l_bound_align_image(&sdformat->format.width, 1, UINT_MAX - 1, 0,
> > > > +			      &sdformat->format.height, 1, UINT_MAX - 1, 0, 0);
> > > 
> > > This is a bit dubious. I would pick more realistic min/max values like 16 and
> > 
> > Why 16? A grayscale or RGB sensor could crop down to 1x1, see mt9v032
> > for example.
> 
> Was that ever tested? Just because the software allows it, doesn't mean it actually
> works.

I don't know. I'll test this when I get access to a sensor that could
support such low cropping.

I'd just prefer this artificial limit not to be imposed by the generic
video mux driver, as a mux doesn't care about framing.

For example the i.MX media driver currently has an (also artificial)
limit to 16 pixel aligned frame sizes in the CSI subdev anyway.

regards
Philipp
