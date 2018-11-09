Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39014 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbeKJD0y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 22:26:54 -0500
Received: by mail-wm1-f67.google.com with SMTP id u13-v6so2687896wmc.4
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 09:45:15 -0800 (PST)
Subject: Re: [PATCH 3/3] media: imx: lift CSI width alignment restriction
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
 <20181105152055.31254-3-p.zabel@pengutronix.de>
 <28564f76-1f87-d17e-88c8-b80a343bb649@gmail.com>
 <1541775017.4112.45.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1e3fee34-e8ad-7acf-97d7-f7e845ca28bb@gmail.com>
Date: Fri, 9 Nov 2018 09:45:11 -0800
MIME-Version: 1.0
In-Reply-To: <1541775017.4112.45.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/9/18 6:50 AM, Philipp Zabel wrote:
> On Thu, 2018-11-08 at 21:46 -0800, Steve Longerbeam wrote:
>> On 11/5/18 7:20 AM, Philipp Zabel wrote:
>>> The CSI subdevice shouldn't have to care about IDMAC line start
>>> address alignment. With compose rectangle support in the capture
>>> driver, it doesn't have to anymore.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> ---
>>>    drivers/staging/media/imx/imx-media-capture.c |  9 ++++-----
>>>    drivers/staging/media/imx/imx-media-csi.c     |  2 +-
>>>    drivers/staging/media/imx/imx-media-utils.c   | 15 ++++++++++++---
>>>    3 files changed, 17 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
>>> index 2d49d9573056..f87d6e8019e5 100644
>>> --- a/drivers/staging/media/imx/imx-media-capture.c
>>> +++ b/drivers/staging/media/imx/imx-media-capture.c
>>> @@ -204,10 +204,9 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
>>>    }
>>>    
>>>    static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
>>> -				     struct v4l2_subev_format *fmt_src,
>>> +				     struct v4l2_subdev_format *fmt_src,
>>>    				     struct v4l2_format *f)
>>>    {
>>> -	struct capture_priv *priv = video_drvdata(file);
>>>    	const struct imx_media_pixfmt *cc, *cc_src;
>>>    
>>>    	cc_src = imx_media_find_ipu_format(fmt_src->format.code, CS_SEL_ANY);
>>> @@ -250,7 +249,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
>>>    	if (ret)
>>>    		return ret;
>>>    
>>> -	return __capture_try_fmt(priv, &fmt_src, f);
>>> +	return __capture_try_fmt_vid_cap(priv, &fmt_src, f);
>>>    }
>>>    
>>>    static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>>> @@ -280,8 +279,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>>>    					      CS_SEL_ANY, true);
>>>    	priv->vdev.compose.left = 0;
>>>    	priv->vdev.compose.top = 0;
>>> -	priv->vdev.compose.width = fmt_src.width;
>>> -	priv->vdev.compose.height = fmt_src.height;
>>> +	priv->vdev.compose.width = fmt_src.format.width;
>>> +	priv->vdev.compose.height = fmt_src.format.height;
>>>    
>>>    	return 0;
>>>    }
>>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>>> index c4523afe7b48..d39682192a67 100644
>>> --- a/drivers/staging/media/imx/imx-media-csi.c
>>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>>> @@ -41,7 +41,7 @@
>>>    #define MIN_H       144
>>>    #define MAX_W      4096
>>>    #define MAX_H      4096
>>> -#define W_ALIGN    4 /* multiple of 16 pixels */
>>> +#define W_ALIGN    1 /* multiple of 2 pixels */
>>
>> This works for the IDMAC output pad because the channel's cpmem width
>> and stride can be rounded up, but width align at the CSI sink still
>> needs to be 8 pixels when directed to the IC via the CSI_SRC_PAD_DIRECT
>> pad, in order to support the 8x8 block rotator in the IC PRP, and
>> there's no way AFAIK to do the same trick of rounding up width and
>> stride for non-IDMAC direct paths through the IPU.
> Actually, this is not necessary at all. csi_try_crop takes care of this
> by setting:
> 	crop->width &= ~0x7;
> Which is then used to set compose rectangle and source pad formats.

Ah you are right, I had forgotten about that line.

>
> So this should be relaxed as well, if the SRC_DIRECT pad is not enabled.

Agreed, crop->width align can be relaxed but only if SRC_DIRECT pad
not enabled.

> And further, I think there is no reason to align crop->left to multiples
> of 4 pixels?

Honestly, I don't know the reason for that either. Along with crop->top 
this defines the CSI active image frame position (HSC/VSC fields in 
IPU_CSI_OUT_FRM_CTRL register), and I don't see any h/w restrictions on 
HSC in the ref manual. I do remember that this alignment exists in 
FSL/NXP BSP's though, so maybe it is an undocumented restriction.

Steve
