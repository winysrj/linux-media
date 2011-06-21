Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33818 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1FUK4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 06:56:05 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LN400BL0ZPFLR@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Jun 2011 11:56:03 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LN400LWKZPENA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Jun 2011 11:56:02 +0100 (BST)
Date: Tue, 21 Jun 2011 12:55:57 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/3] s5p-tv: add drivers for TV on Samsung S5P platform
In-reply-to: <201106101039.52431.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4E0078BD.8040902@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-15; format=flowed
Content-transfer-encoding: 7BIT
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com>
 <201106091219.26272.hansverk@cisco.com> <4DF0F267.4010001@samsung.com>
 <201106101039.52431.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,
> On Thursday, June 09, 2011 18:18:47 Tomasz Stanislawski wrote:
>   
>> Hans Verkuil wrote:
>>     
>>> On Wednesday, June 08, 2011 14:03:31 Tomasz Stanislawski wrote:
>>>
>>> And now the mixer review...
>>>   
>>>       
>> I'll separate patches. What is the proposed order of drivers?
>>     
>
> HDMI+HDMIPHY, SDO, MIXER. That's easiest to review.
>
>   
>>>   
>>>       
>>>> Add drivers for TV outputs on Samsung platforms from S5P family.
>>>> - HDMIPHY - auxiliary I2C driver need by TV driver
>>>> - HDMI    - generation and control of streaming by HDMI output
>>>> - SDO     - streaming analog TV by Composite connector
>>>> - MIXER   - merging images from three layers and passing result to the output
>>>>
>>>> Interface:
>>>> - 3 video nodes with output queues
>>>> - support for multi plane API
>>>> - each nodes has up to 2 outputs (HDMI and SDO)
>>>> - outputs are controlled by S_STD and S_DV_PRESET ioctls
>>>>
>>>> Drivers are using:
>>>> - v4l2 framework
>>>> - videobuf2
>>>> - videobuf2-dma-contig as memory allocator
>>>> - runtime PM
>>>>
>>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>>         
[snip]

>>>> +static int mxr_g_fmt(struct file *file, void *priv,
>>>> +			     struct v4l2_format *f)
>>>> +{
>>>> +	struct mxr_layer *layer = video_drvdata(file);
>>>> +
>>>> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
>>>> +
>>>> +	f->fmt.pix.width	= layer->geo.src.full_width;
>>>> +	f->fmt.pix.height	= layer->geo.src.full_height;
>>>> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
>>>> +	f->fmt.pix.pixelformat	= layer->fmt->fourcc;
>>>>     
>>>>         
>>> Colorspace is not set. The subdev drivers should set the colorspace and that
>>> should be passed in here.
>>>
>>>   
>>>       
>> Which one should be used for formats in vp_layer and grp_layer?
>>     
Should I use V4L2_COLORSPACE_SRGB for RGB formats,
and V4L2_COLORSPACE_JPEG for NV12(T) formats?
The Mixer possesses no knowledge how pixel values are mapped to output 
color.
This is controlled by output driver (HDMI or SDO).

>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static inline struct mxr_crop *choose_crop_by_type(struct mxr_geometry *geo,
>>>> +	enum v4l2_buf_type type)
>>>> +{
>>>> +	switch (type) {
>>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>>> +		return &geo->dst;
>>>> +	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>>>> +		return &geo->src;
>>>>     
>>>>         
>>> Hmm, this is the only place where I see overlay. It's not set in QUERYCAP either.
>>> And I suspect this is supposed to be OUTPUT_OVERLAY anyway since OVERLAY is for
>>> capture.
>>>
>>>   
>>>       
>> Usage of OVERLAY is workaround for a lack of S_COMPOSE. This is 
>> described in RFC.
>>     
>
> Ah, now I understand.
>
> I don't like this hack to be honest. Can't this be done differently? I understand
> from the RFC that the reason is that widths have to be a multiple of 64. So why
> not use the bytesperline field in v4l2_pix_format(_mplane)? So you can set the
> width to e.g. 1440 and bytesperline to 1472. That does very simple cropping, but
> it seems that this is sufficient for your immediate needs.
>   
I do not like idea of using bytesperline for NV12T format.
The data ordering in NV12T is very different from both single and 
mutiplanar formats.
There is no good definition of bytesperline for this format.
One could try to use analogy of this field based on NV12 format, that 
bytesperline is equal
to length in bytes of a single luminance line.
However there is no control over offsets controlled by {left/top} in 
cropping API.
In my opinion, using bytesperline for a cropping purpose is also a hack.
Cropping on an unused overlay buffer provides at least good and explicit 
control over cropping.
I think it is a good temporary solution until S_SELECTION emerge.
>   
>>>> +	default:
>>>> +		return NULL;
>>>> +	}
>>>> +}
>>>> +
>>>>         
[snip]
>>>> +
>>>> +static int mxr_g_dv_preset(struct file *file, void *fh,
>>>> +	struct v4l2_dv_preset *preset)
>>>> +{
>>>> +	struct mxr_layer *layer = video_drvdata(file);
>>>> +	struct mxr_device *mdev = layer->mdev;
>>>> +	int ret;
>>>> +
>>>> +	/* lock protects from changing sd_out */
>>>>     
>>>>         
>>> Needs a check against n_output as well.
>>>   
>>>       
>> Probably I use query_dv_preset wrong.
>>     
>
> You mean g_dv_preset, right?
>   
Exactly, but v4l2_subdev misses g_dv_preset  callback.
Should I add it like in g_tvnorms case?

Best regards,
Tomasz Stanislawski

