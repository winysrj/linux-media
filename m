Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:52033 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753487AbbCRPSz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 11:18:55 -0400
Message-ID: <55099753.5010405@logicpd.com>
Date: Wed, 18 Mar 2015 10:18:43 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/3] omap3isp: Defer probing when subdev isn't available
References: <1426015494-16799-1-git-send-email-tim.nordell@logicpd.com> <1426015494-16799-2-git-send-email-tim.nordell@logicpd.com> <3275472.GjEQv8ASR0@avalon>
In-Reply-To: <3275472.GjEQv8ASR0@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent -

Agreed.  This is a stop gap for this, but I guess by the time this patch 
could possibly get incorporated we'd be off to device tree anyways.

- Tim

(Sorry for the repeat - my e-mail client sent out an HTML message so it 
didn't get through to the mailing list.)

On 03/18/15 10:15, Laurent Pinchart wrote:
> Hi Tim,
>
> Thank you for the patch.
>
> The OMAP3 ISP driver is moving to DT, hopefully in time for v4.1. See "[PATCH
> 00/15] omap3isp driver DT support" posted to the list on Monday. I'd rather go
> for proper DT support instead of custom deferred probing.
>
> On Tuesday 10 March 2015 14:24:52 Tim Nordell wrote:
>> If the subdev isn't available just yet, defer probing of
>> the system.  This is useful if the omap3isp comes up before
>> the I2C subsystem does.
>>
>> Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
>> ---
>>   drivers/media/platform/omap3isp/isp.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isp.c
>> b/drivers/media/platform/omap3isp/isp.c index 51c2129..a361c40 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -1811,7 +1811,7 @@ isp_register_subdev_group(struct isp_device *isp,
>>   				"device %s\n", __func__,
>>   				board_info->i2c_adapter_id,
>>   				board_info->board_info->type);
>> -			continue;
>> +			return ERR_PTR(-EPROBE_DEFER);
>>   		}
>>
>>   		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
>> @@ -1898,6 +1898,10 @@ static int isp_register_entities(struct isp_device
>> *isp) unsigned int i;
>>
>>   		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
>> +		if (IS_ERR(sensor)) {
>> +			ret = PTR_ERR(sensor);
>> +			goto done;
>> +		}
>>   		if (sensor == NULL)
>>   			continue;
