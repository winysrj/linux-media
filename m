Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:2971 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbbHDGWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 02:22:21 -0400
Message-ID: <55C059F9.6070906@atmel.com>
Date: Tue, 4 Aug 2015 14:21:45 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] media: atmel-isi: parse the DT parameters for vsync/hsync
 polarity
References: <1438338812-22329-1-git-send-email-josh.wu@atmel.com> <1896672.nsMcFlgNH5@avalon>
In-Reply-To: <1896672.nsMcFlgNH5@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent

On 8/1/2015 5:11 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> Thank you for the patch.
>
> On Friday 31 July 2015 18:33:32 Josh Wu wrote:
>> This patch will get the DT parameters of vsync/hsync polarity, and pass to
>> the platform data.
>>
>> Also add a debug information for test purpose.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>
>>   drivers/media/platform/soc_camera/atmel-isi.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index fe9247a..a7de55c
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -811,6 +811,11 @@ static int isi_camera_set_bus_param(struct
>> soc_camera_device *icd) if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>>   		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
>>
>> +	dev_dbg(icd->parent, "vsync is active %s, hsyc is active %s, pix clock is
>> sampling %s\n",
> s/hsyc/hsync/
>
> I'd write it as "vsync active %s, hsync active %s, sampling on pix clock %s
> edge\n" with "falling" and "rising" instead of "fall" and "rise".

Thanks, I'll correct it.

>
>> +		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" : "high",
>> +		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
>> +		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "fall" : "rise");
>> +
>>   	if (isi->pdata.has_emb_sync)
>>   		cfg1 |= ISI_CFG1_EMB_SYNC;
>>   	if (isi->pdata.full_mode)
>> @@ -898,6 +903,11 @@ static int atmel_isi_probe_dt(struct atmel_isi *isi,
>>   		goto err_probe_dt;
>>   	}
>>
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
>> +		isi->pdata.hsync_act_low = true;
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
>> +		isi->pdata.vsync_act_low = true;
> While you're at it, how about setting has_emb_sync based on ep.bus_type and
> pclk_act_falling from flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ?

I will add the pclk_act_falling handling code as well. And rebase this 
patch on top of your dt modifications.

Best Regards
Josh Wu
>
>>   err_probe_dt:
>>   	of_node_put(np);

