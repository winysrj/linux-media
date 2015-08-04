Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:19236 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbHDIly (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 04:41:54 -0400
Message-ID: <55C07AC9.70700@atmel.com>
Date: Tue, 4 Aug 2015 16:41:45 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] media: atmel-isi: parse the DT parameters for vsync/hsync/pixclock
 polarity
References: <1438670828-19845-1-git-send-email-josh.wu@atmel.com> <1733630.bVGppG7AmL@avalon>
In-Reply-To: <1733630.bVGppG7AmL@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 8/4/2015 4:33 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Tuesday 04 August 2015 14:47:07 Josh Wu wrote:
>> This patch will get the DT parameters of vsync/hsync/pixclock polarity, and
>> pass to driver.
>>
>> Also add a debug information for test purpose.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>> Changes in v2:
>> - rewrite the debug message and add pix clock polarity setup thanks to
>>    Laurent.
>> - update the commit log.
>>
>>   drivers/media/platform/soc_camera/atmel-isi.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index fead841..d6f8def
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -1061,6 +1061,11 @@ static int isi_camera_set_bus_param(struct
>> soc_camera_device *icd) if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>>   		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
>>
>> +	dev_dbg(icd->parent, "vsync active %s, hsync active %s, sampling on pix
>> clock %s\n",
> You forgot " edge" right before "\n" :-)

oops, I missed the word.

>
>> +		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" : "high",
>> +		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
>> +		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "falling" : "rising");
>> +
>>   	if (isi->pdata.has_emb_sync)
>>   		cfg1 |= ISI_CFG1_EMB_SYNC;
>>   	if (isi->pdata.full_mode)
>> @@ -1148,6 +1153,13 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>>   		return -EINVAL;
>>   	}
>>
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
>> +		isi->pdata.hsync_act_low = true;
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
>> +		isi->pdata.vsync_act_low = true;
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>> +		isi->pdata.pclk_act_falling = true;
>> +
> How about has_emb_sync, which can be set from ep.bus_type ?

yes, right. I forgot this as well.
I'll generate a new version of this patch soon. Thanks for the catching.

Best Regards,
Josh Wu

>
>>   	return 0;
>>   }

