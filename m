Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:32851 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3FUAvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 20:51:07 -0400
Received: by mail-la0-f42.google.com with SMTP id eb20so6319570lab.29
        for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 17:51:04 -0700 (PDT)
Message-ID: <51C3A363.5090206@cogentembedded.com>
Date: Fri, 21 Jun 2013 04:50:43 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201305240211.29665.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1306131245420.31976@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306131245420.31976@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Sorry for the response delay and thank you for new review.

Guennadi Liakhovetski wrote:
>> +	/* output format */
>> +	switch (icd->current_fmt->host_fmt->fourcc) {
>> +	case V4L2_PIX_FMT_NV16:
>> +		iowrite32(ALIGN(cam->width * cam->height, 0x80),
>> +			  priv->base + VNUVAOF_REG);
>> +		dmr = VNDMR_DTMD_YCSEP;
>> +		output_is_yuv = true;
>> +		break;
>> +	case V4L2_PIX_FMT_YUYV:
>> +		dmr = VNDMR_BPSM;
>> +		output_is_yuv = true;
>> +		break;
>> +	case V4L2_PIX_FMT_UYVY:
>> +		dmr = 0;
>> +		output_is_yuv = true;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB555X:
>> +		dmr = VNDMR_DTMD_ARGB1555;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB565:
>> +		dmr = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB32:
>> +		if (priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
>> +			dmr = VNDMR_EXRGB;
>> +			break;
>> +		}
>> +	default:
>> +		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
>> +			 icd->current_fmt->host_fmt->fourcc);
>>     
>
> I'll put a marker here for now: I don't understand the logic - either you 
> don't support this case, then you should either fail somehow or switch to 
> a supported case, or you do support it, then you don't need a warning
>   
Yes, the default case is not supported.
Don't you think the current logic should be replaced with BUG() callback?

> [snip]
>
>   
>> +static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	unsigned long size;
>> +	int bytes_per_line;
>> +
>> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +						 icd->current_fmt->host_fmt);
>> +	if (bytes_per_line < 0)
>> +		goto error;
>> +
>> +	size = icd->user_height * bytes_per_line;
>>     
>
> You haven't fixed this
>   
Sorry for the miss. Will replace with icd->sizeimage.

>> +static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
>> +	{
>> +		.fourcc			= V4L2_PIX_FMT_NV16,
>> +		.name			= "NV16",
>> +		.bits_per_sample	= 16,
>> +		.packing		= SOC_MBUS_PACKING_NONE,
>> +		.order			= SOC_MBUS_ORDER_LE,
>> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
>>     
>
> This should be SOC_MBUS_LAYOUT_PLANAR_Y_C
>   
Shouldn't the ".packing"  be changed here to SOC_MBUS_PACKING_2X8_PADHI ?

>> +	if (!icd->host_priv) {
>> +		struct v4l2_mbus_framefmt mf;
>> +		struct v4l2_rect rect;
>> +		struct device *dev = icd->parent;
>> +		int shift;
>> +
>> +		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		/* Cache current client geometry */
>> +		ret = soc_camera_client_g_rect(sd, &rect);
>> +		if (ret < 0) {
>> +			/* Sensor driver doesn't support cropping */
>>     
>
> I don't think it's right. soc_camera_client_g_rect() should only return an 
> error, if the subdevice driver implements g_crop or cropcap and returns an 
> error from them. If those methods are just unimplemented, you get a 0 
> back. Do you see anything different?
>   
No.
In case the subdevice drivers does not implement cropping (i.e there is 
no both methods g_crop and cropcap) then the return value is -ENOIOCTLCMD.
Don't you suggest to continue for (ret == -ENOIOCTLCMD) and return for 
other (ret < 0) ?

>> +	switch (pixfmt) {
>> +	case V4L2_PIX_FMT_NV16:
>> +		can_scale = false;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB32:
>> +		can_scale = priv->chip != RCAR_E1;
>> +		break;
>> +	default:
>> +		can_scale = true;
>>     
>
> You also get here in the pass-through mode, right? I don't think you can 
> scale then.
>   
Yes, thank you for pointing to this. I will add only supported formats 
for scaling capability.

>   
>> +		break;
>> +	}
>> +
>> +	dev_dbg(dev, "request camera output %ux%u\n", mf.width, mf.height);
>> +
>> +	ret = soc_camera_client_scale(icd, &cam->rect, &cam->subrect,
>> +				      &mf, &vin_sub_width, &vin_sub_height,
>> +				      can_scale, 12);
>> +
>> +	/* Done with the camera. Now see if we can improve the result */
>> +	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
>> +		ret, mf.width, mf.height, pix->width, pix->height);
>> +
>> +	if (ret < 0)
>> +		dev_dbg(dev, "Sensor doesn't support cropping\n");
>>     
>
> Are you sure this print is correct?
>   
Probably it should be the same like above for the case if subdevice 
driver does not support cropping (see soc_scale_crop.c -> client_s_fmt() ).

Regards,
Vladimir

