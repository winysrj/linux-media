Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47452 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbIRJVa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 05:21:30 -0400
Subject: Re: [PATCH v3] media: atmel-isi: parse the DT parameters for
 vsync/hsync/pixclock polarity
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1438681069-16981-1-git-send-email-josh.wu@atmel.com>
 <3317317.RTpCstaHHn@avalon>
CC: Josh Wu <josh.wu@atmel.com>, <linux-arm-kernel@lists.infradead.org>
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <55FBD76C.1040303@atmel.com>
Date: Fri, 18 Sep 2015 11:20:44 +0200
MIME-Version: 1.0
In-Reply-To: <3317317.RTpCstaHHn@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 04/08/2015 13:22, Laurent Pinchart a écrit :
> Hi Josh,
> 
> Thank you for the patch.
> 
> On Tuesday 04 August 2015 17:37:49 Josh Wu wrote:
>> This patch will get the DT parameters of vsync/hsync/pixclock polarity, and
>> pass to driver.
>>
>> Also add a debug information for test purpose.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Guennadi, Mauro,

I don't see this patch in Linux-next and I'm not so used to
http://git.linuxtv.org but didn't find it either.

Well in fact it's just a lengthy version of "ping" ;-)

Bye,

>> ---
>>
>> Changes in v3:
>> - add embedded sync dt property support.
>>
>> Changes in v2:
>> - rewrite the debug message and add pix clock polarity setup thanks to
>>   Laurent.
>> - update the commit log.
>>
>>  drivers/media/platform/soc_camera/atmel-isi.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>> b/drivers/media/platform/soc_camera/atmel-isi.c index fead841..4efc939
>> 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -1061,6 +1061,11 @@ static int isi_camera_set_bus_param(struct
>> soc_camera_device *icd) if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>>  		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
>>
>> +	dev_dbg(icd->parent, "vsync active %s, hsync active %s, sampling on pix
>> clock %s edge\n", +		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" :
>> "high",
>> +		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
>> +		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "falling" : "rising");
>> +
>>  	if (isi->pdata.has_emb_sync)
>>  		cfg1 |= ISI_CFG1_EMB_SYNC;
>>  	if (isi->pdata.full_mode)
>> @@ -1148,6 +1153,16 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>>  		return -EINVAL;
>>  	}
>>
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
>> +		isi->pdata.hsync_act_low = true;
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
>> +		isi->pdata.vsync_act_low = true;
>> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>> +		isi->pdata.pclk_act_falling = true;
>> +
>> +	if (ep.bus_type == V4L2_MBUS_BT656)
>> +		isi->pdata.has_emb_sync = true;
>> +
>>  	return 0;
>>  }
> 


-- 
Nicolas Ferre
