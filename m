Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51633 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaBYNkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 08:40:11 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so3275098lbv.19
        for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 05:40:10 -0800 (PST)
Message-ID: <530C9D37.8070909@cogentembedded.com>
Date: Tue, 25 Feb 2014 17:40:07 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Phil Edworthy <phil.edworthy@renesas.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add support for 10-bit YUV
 cameras
References: <1393256945-12781-1-git-send-email-phil.edworthy@renesas.com> <2516843.7QqJLHtUZT@avalon>
In-Reply-To: <2516843.7QqJLHtUZT@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2014 10:38 PM, Laurent Pinchart wrote:
> Hi Phil,
>
> Thank you for the patch.
>
> On Monday 24 February 2014 15:49:05 Phil Edworthy wrote:
>> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
>> ---
>>   drivers/media/platform/soc_camera/rcar_vin.c |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>> b/drivers/media/platform/soc_camera/rcar_vin.c index 3b1c05a..9929375
>> 100644
>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -68,6 +68,8 @@
>>   #define VNMC_YCAL		(1 << 19)
>>   #define VNMC_INF_YUV8_BT656	(0 << 16)
>>   #define VNMC_INF_YUV8_BT601	(1 << 16)
>> +#define VNMC_INF_YUV10_BT656	(2 << 16)
>> +#define VNMC_INF_YUV10_BT601	(3 << 16)
>>   #define VNMC_INF_YUV16		(5 << 16)
>>   #define VNMC_VUP		(1 << 10)
>>   #define VNMC_IM_ODD		(0 << 3)
>> @@ -275,6 +277,10 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>>   		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>>   		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
>>   			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
>
> Aren't you missing a break here ?
>
>> +	case V4L2_MBUS_FMT_YUYV10_2X10:
>> +		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
>> +		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
>> +			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
>
> You should add one here as well. Although not strictly necessary, it would
> help to avoid making the same mistake again.
>
> The rest looks good to me, but I'm not familiar with the hardware, so I'll let
> Valentine have the last word.

Thanks, looks good to me.

>
>>   	default:
>>   		break;
>>   	}
>> @@ -1003,6 +1009,7 @@ static int rcar_vin_get_formats(struct
>> soc_camera_device *icd, unsigned int idx, switch (code) {
>>   	case V4L2_MBUS_FMT_YUYV8_1X16:
>>   	case V4L2_MBUS_FMT_YUYV8_2X8:
>> +	case V4L2_MBUS_FMT_YUYV10_2X10:
>>   		if (cam->extra_fmt)
>>   			break;
>

