Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:53641 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1FUL1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 07:27:34 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/3] s5p-tv: add drivers for TV on Samsung S5P platform
Date: Tue, 21 Jun 2011 13:26:54 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com> <201106101039.52431.hverkuil@xs4all.nl> <4E0078BD.8040902@samsung.com>
In-Reply-To: <4E0078BD.8040902@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106211326.54350.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 21, 2011 12:55:57 Tomasz Stanislawski wrote:
> Hi Hans,
> > On Thursday, June 09, 2011 18:18:47 Tomasz Stanislawski wrote:
> >   
> >> Hans Verkuil wrote:
> >>     
> >>> On Wednesday, June 08, 2011 14:03:31 Tomasz Stanislawski wrote:
> >>>
> >>> And now the mixer review...
> >>>   
> >>>       
> >> I'll separate patches. What is the proposed order of drivers?
> >>     
> >
> > HDMI+HDMIPHY, SDO, MIXER. That's easiest to review.
> >
> >   
> >>>   
> >>>       
> >>>> Add drivers for TV outputs on Samsung platforms from S5P family.
> >>>> - HDMIPHY - auxiliary I2C driver need by TV driver
> >>>> - HDMI    - generation and control of streaming by HDMI output
> >>>> - SDO     - streaming analog TV by Composite connector
> >>>> - MIXER   - merging images from three layers and passing result to the 
output
> >>>>
> >>>> Interface:
> >>>> - 3 video nodes with output queues
> >>>> - support for multi plane API
> >>>> - each nodes has up to 2 outputs (HDMI and SDO)
> >>>> - outputs are controlled by S_STD and S_DV_PRESET ioctls
> >>>>
> >>>> Drivers are using:
> >>>> - v4l2 framework
> >>>> - videobuf2
> >>>> - videobuf2-dma-contig as memory allocator
> >>>> - runtime PM
> >>>>
> >>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >>>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>>>         
> [snip]
> 
> >>>> +static int mxr_g_fmt(struct file *file, void *priv,
> >>>> +			     struct v4l2_format *f)
> >>>> +{
> >>>> +	struct mxr_layer *layer = video_drvdata(file);
> >>>> +
> >>>> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >>>> +
> >>>> +	f->fmt.pix.width	= layer->geo.src.full_width;
> >>>> +	f->fmt.pix.height	= layer->geo.src.full_height;
> >>>> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> >>>> +	f->fmt.pix.pixelformat	= layer->fmt->fourcc;
> >>>>     
> >>>>         
> >>> Colorspace is not set. The subdev drivers should set the colorspace and 
that
> >>> should be passed in here.
> >>>
> >>>   
> >>>       
> >> Which one should be used for formats in vp_layer and grp_layer?
> >>     
> Should I use V4L2_COLORSPACE_SRGB for RGB formats,
> and V4L2_COLORSPACE_JPEG for NV12(T) formats?
> The Mixer possesses no knowledge how pixel values are mapped to output 
> color.
> This is controlled by output driver (HDMI or SDO).

Good question, actually.

The spec says:

'This information supplements the pixelformat and must be set by the driver, 
see the section called “Colorspaces”.'

But does it make sense that the driver sets it for output? I think this should
be set by the application in that case. The driver sets it for input, the 
application sets it for output.

G_FMT should return some sensible default based on the pixelformat if the 
application left it to 0.

I think you should write up a small RFC proposing this change in the spec.

> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static inline struct mxr_crop *choose_crop_by_type(struct mxr_geometry 
*geo,
> >>>> +	enum v4l2_buf_type type)
> >>>> +{
> >>>> +	switch (type) {
> >>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >>>> +		return &geo->dst;
> >>>> +	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> >>>> +		return &geo->src;
> >>>>     
> >>>>         
> >>> Hmm, this is the only place where I see overlay. It's not set in 
QUERYCAP either.
> >>> And I suspect this is supposed to be OUTPUT_OVERLAY anyway since OVERLAY 
is for
> >>> capture.
> >>>
> >>>   
> >>>       
> >> Usage of OVERLAY is workaround for a lack of S_COMPOSE. This is 
> >> described in RFC.
> >>     
> >
> > Ah, now I understand.
> >
> > I don't like this hack to be honest. Can't this be done differently? I 
understand
> > from the RFC that the reason is that widths have to be a multiple of 64. 
So why
> > not use the bytesperline field in v4l2_pix_format(_mplane)? So you can set 
the
> > width to e.g. 1440 and bytesperline to 1472. That does very simple 
cropping, but
> > it seems that this is sufficient for your immediate needs.
> >   
> I do not like idea of using bytesperline for NV12T format.
> The data ordering in NV12T is very different from both single and 
> mutiplanar formats.

NV12T, I missed that fact.

> There is no good definition of bytesperline for this format.
> One could try to use analogy of this field based on NV12 format, that 
> bytesperline is equal
> to length in bytes of a single luminance line.
> However there is no control over offsets controlled by {left/top} in 
> cropping API.
> In my opinion, using bytesperline for a cropping purpose is also a hack.
> Cropping on an unused overlay buffer provides at least good and explicit 
> control over cropping.
> I think it is a good temporary solution until S_SELECTION emerge.

Hmm, this needs to be documented carefully and I think the driver needs to be 
marked EXPERIMENTAL in Kconfig. This makes it clear that the API will change.

> >   
> >>>> +	default:
> >>>> +		return NULL;
> >>>> +	}
> >>>> +}
> >>>> +
> >>>>         
> [snip]
> >>>> +
> >>>> +static int mxr_g_dv_preset(struct file *file, void *fh,
> >>>> +	struct v4l2_dv_preset *preset)
> >>>> +{
> >>>> +	struct mxr_layer *layer = video_drvdata(file);
> >>>> +	struct mxr_device *mdev = layer->mdev;
> >>>> +	int ret;
> >>>> +
> >>>> +	/* lock protects from changing sd_out */
> >>>>     
> >>>>         
> >>> Needs a check against n_output as well.
> >>>   
> >>>       
> >> Probably I use query_dv_preset wrong.
> >>     
> >
> > You mean g_dv_preset, right?
> >   
> Exactly, but v4l2_subdev misses g_dv_preset  callback.
> Should I add it like in g_tvnorms case?

Yes, I think you should. Currently there is only one subdev driver 
implementing s_dv_preset: tvp7002.c. It's trivial to add g_dv_preset to that 
driver.

Regards,

	Hans

> 
> Best regards,
> Tomasz Stanislawski
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
