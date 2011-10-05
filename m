Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1JEVQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 17:16:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 7/9] V4L: soc-camera: add a Media Controller wrapper
Date: Wed, 5 Oct 2011 23:15:59 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deepthy Ravi <deepthy.ravi@ti.com>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de> <201110032244.22764.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1110041741220.28955@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1110041741220.28955@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110052316.00009.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 04 October 2011 19:34:36 Guennadi Liakhovetski wrote:
> On Mon, 3 Oct 2011, Laurent Pinchart wrote:
> > On Monday 03 October 2011 17:29:23 Guennadi Liakhovetski wrote:
> > > On Mon, 3 Oct 2011, Laurent Pinchart wrote:
> > > > On Thursday 29 September 2011 18:18:55 Guennadi Liakhovetski wrote:
> > > > > This wrapper adds a Media Controller implementation to soc-camera
> > > > > drivers. To really benefit from it individual host drivers should
> > > > > implement support for values of enum soc_camera_target other than
> > > > > SOCAM_TARGET_PIPELINE in their .set_fmt() and .try_fmt() methods.
> > > > 
> > > > [snip]
> > > > 
> > > > > diff --git a/drivers/media/video/soc_entity.c
> > > > > b/drivers/media/video/soc_entity.c new file mode 100644
> > > > > index 0000000..3a04700
> > > > > --- /dev/null
> > > > > +++ b/drivers/media/video/soc_entity.c
> > > > > @@ -0,0 +1,284 @@
> > > > 
> > > > [snip]
> > > > 
> > > > > +static int bus_sd_pad_g_fmt(struct v4l2_subdev *sd, struct
> > > > > v4l2_subdev_fh *fh,
> > > > > +			    struct v4l2_subdev_format *sd_fmt)
> > > > > +{
> > > > > +	struct soc_camera_device *icd = v4l2_get_subdevdata(sd);
> > > > > +	struct v4l2_mbus_framefmt *f = &sd_fmt->format;
> > > > > +
> > > > > +	if (sd_fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > > > > +		sd_fmt->format = *v4l2_subdev_get_try_format(fh, sd_fmt->pad);
> > > > > +		return 0;
> > > > > +	}
> > > > > +
> > > > > +	if (sd_fmt->pad == SOC_HOST_BUS_PAD_SINK) {
> > > > > +		f->width	= icd->host_input_width;
> > > > > +		f->height	= icd->host_input_height;
> > > > > +	} else {
> > > > > +		f->width	= icd->user_width;
> > > > > +		f->height	= icd->user_height;
> > > > > +	}
> > > > > +	f->field	= icd->field;
> > > > > +	f->code		= icd->current_fmt->code;
> > > > > +	f->colorspace	= icd->colorspace;
> > > > 
> > > > Can soc-camera hosts perform format conversion ? If so you will
> > > > likely need to store the mbus code for the input and output
> > > > separately, possibly in v4l2_mbus_format fields. You could then
> > > > simplify the [gs]_fmt functions by implementing similar to the
> > > > __*_get_format functions in the OMAP3 ISP driver.
> > > 
> > > They can, yes. But, under soc-camera conversions are performed between
> > > mediabus codes and fourcc formats. Upon pipeline construction (probing)
> > > a table of format conversions is built, where hosts generate one or
> > > more translation entries for all client formats, that they support.
> > > The only example of a more complex translations so far is MIPI CSI-2,
> > > but even there we have decided to identify CSI-2 formats using the
> > > same media-bus codes, as what you "get" "between" the CSI-2 block and
> > > the DMA engine. For the only CSI-2 capable soc-camera host so far -
> > > the CEU driver - this is also a very natural representation, because
> > > there the CSI-2 block is indeed an additional pipeline stage, uniquely
> > > translating CSI-2 to media-bus codes, that are then fed to the CEU
> > > parallel port.
> > 
> > How does that work with the MC API then ? If the bridge can, let's say,
> > convert between raw bayer and YUV, shouldn't the format at the bridge
> > input be raw bayer and at the bridge output YUV ?
> 
> Doesn't it depend on your definition? I define the conversion as taking
> place on the "DMA-engine entity." I.e., a media-bus code is transferred
> unchanged all the way down to that entity and there it gets converted to
> one of fourcc formats for storage in the memory. Isn't what you are
> suggesting some kind of a t2o-stage conversion: first you convert one
> media-bus code to another one, then you convert the latter one to some
> fourcc, which is also not a one-to-one conversion.

t2o ?

An mbus code is converted to a fourcc by the DMA engine, but can't the bridge 
subdev also perform conversion, such as interpolating raw bayer to RGB, and 
possibly converting that to YUV ? In that case the bridge sink and source pads 
would have different mbus formats.

-- 
Regards,

Laurent Pinchart
