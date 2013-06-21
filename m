Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:52388 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FUJkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 05:40:14 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so6920694lab.0
        for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 02:40:12 -0700 (PDT)
Message-ID: <51C41F66.1060300@cogentembedded.com>
Date: Fri, 21 Jun 2013 13:39:50 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Katsuya MATSUBARA <matsu@igel.co.jp>
CC: sergei.shtylyov@cogentembedded.com, g.liakhovetski@gmx.de,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201305240211.29665.sergei.shtylyov@cogentembedded.com>	<20130621.134659.460987965.matsu@igel.co.jp>	<51C40974.600@cogentembedded.com> <20130621.180932.452518378.matsu@igel.co.jp>
In-Reply-To: <20130621.180932.452518378.matsu@igel.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi  Matsubara-san,

Katsuya MATSUBARA wrote:
> Hi Vladimir,
>
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Date: Fri, 21 Jun 2013 12:06:12 +0400
>
>   
>> Hi  Matsubara-san,
>>
>> Katsuya MATSUBARA wrote:
>>     
>>> Hi Sergei and Valadmir,
>>>
>>> From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>> Date: Fri, 24 May 2013 02:11:28 +0400
>>>
>>> (snip)
>>>   
>>>       
>>>> +/* Similar to set_crop multistage iterative algorithm */
>>>> +static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>>>> +			    struct v4l2_format *f)
>>>> +{
>>>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>>>> +	struct rcar_vin_priv *priv = ici->priv;
>>>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>>> +	struct rcar_vin_cam *cam = icd->host_priv;
>>>> +	struct v4l2_pix_format *pix = &f->fmt.pix;
>>>> +	struct v4l2_mbus_framefmt mf;
>>>> +	struct device *dev = icd->parent;
>>>> +	__u32 pixfmt = pix->pixelformat;
>>>> +	const struct soc_camera_format_xlate *xlate;
>>>> +	unsigned int vin_sub_width = 0, vin_sub_height = 0;
>>>> +	int ret;
>>>> +	bool can_scale;
>>>> +	enum v4l2_field field;
>>>> +	v4l2_std_id std;
>>>> +
>>>> +	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
>>>> +		pixfmt, pix->width, pix->height);
>>>> +
>>>> +	switch (pix->field) {
>>>> +	default:
>>>> +		pix->field = V4L2_FIELD_NONE;
>>>> +		/* fall-through */
>>>> +	case V4L2_FIELD_NONE:
>>>> +	case V4L2_FIELD_TOP:
>>>> +	case V4L2_FIELD_BOTTOM:
>>>> +	case V4L2_FIELD_INTERLACED_TB:
>>>> +	case V4L2_FIELD_INTERLACED_BT:
>>>> +		field = pix->field;
>>>> +		break;
>>>> +	case V4L2_FIELD_INTERLACED:
>>>> + /* Query for standard if not explicitly mentioned _TB/_BT */
>>>> +		ret = v4l2_subdev_call(sd, video, querystd, &std);
>>>> +		if (ret < 0)
>>>> +			std = V4L2_STD_625_50;
>>>> +
>>>> + field = std & V4L2_STD_625_50 ? V4L2_FIELD_INTERLACED_TB :
>>>> +						V4L2_FIELD_INTERLACED_BT;
>>>> +		break;
>>>> +	}
>>>>     
>>>>         
>>> I have tested your VIN driver with NTSC video input
>>> with the following two boards;
>>>
>>> 1. Marzen (R-CarH1 SoC and ADV7180 video decoder)
>>> 2. BOCK-W (R-CarM1A SoC and ML86V7667 video decoder)
>>>
>>> As a result, I have got strange captured images in the BOCK-W
>>> environment. The image looks that the top and bottom fields
>>> have been combined in wrong order.
>>> However, in case of Marzen, it works fine with correct images
>>> captured. I made sure that the driver chose the
>>> V4L2_FIELD_INTERLACED_BT flag for the NTSC standard video
>>> in the both environments.
>>>
>>> Have you seen such an iusse with the ML86V7667 driver?
>>> I think there may be some mismatch between the VIN
>>> and the ML86V7667 settings.
>>>   
>>>       
>> Unfortunately, I had ability to test decoder only with PAL camera. And
>> I've made the fake tests for NTSC standard reported by video decoders
>> to validate the difference on captured image.
>> The interlace on bock-w was correct for PAL standard in accordance to
>> above tests.
>>
>> I have been able to see incorrect mix up of _TB/_BT only in case of
>> i2c transaction fails during subdevice V4L2_STD runtime query.
>>     
>
> I have slightly investigated the issue on bock-w.
>
> I have not seen such i2c errors during capturing and booting.
> But I have seen that querystd() in the ml86v7667 driver often
> returns V4L2_STD_UNKNOWN, although the corresponding function
>   
could you try Hans's fix:
https://patchwork.kernel.org/patch/2640701/
> in the adv7180 driver always returns V4L2_STD_525_60 for NTSC video.
> The driver also chose '_BT' for V4L2_STD_UNKNOWN, so even in this
> case the display should be fine for NTSC video.
> I have confirmed that the driver always selects '_BT' for NTSC
> video even if I repeat it several times in my environment.
>
> Thanks,
> ---
>  Katsuya Matsubara / IGEL Co., Ltd
>  matsu@igel.co.jp
>
>   

