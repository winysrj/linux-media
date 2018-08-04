Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37048 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbeHDV1H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 17:27:07 -0400
Subject: Re: [PATCH v3 05/14] gpu: ipu-v3: Allow negative offsets for
 interlaced scanning
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX"
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
 <1533150747-30677-6-git-send-email-steve_longerbeam@mentor.com>
 <1533203182.3516.12.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <786e7eb0-a81c-a4e8-3ddc-7edd0bc08cd9@gmail.com>
Date: Sat, 4 Aug 2018 12:25:20 -0700
MIME-Version: 1.0
In-Reply-To: <1533203182.3516.12.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 08/02/2018 02:46 AM, Philipp Zabel wrote:
> On Wed, 2018-08-01 at 12:12 -0700, Steve Longerbeam wrote:
>> From: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> The IPU also supports interlaced buffers that start with the bottom field.
>> To achieve this, the the base address EBA has to be increased by a stride
>> length and the interlace offset ILO has to be set to the negative stride.
>>
>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/gpu/ipu-v3/ipu-cpmem.c | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
>> index e68e473..8cd9e37 100644
>> --- a/drivers/gpu/ipu-v3/ipu-cpmem.c
>> +++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
>> @@ -269,9 +269,20 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
>>   
>>   void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
>>   {
>> +	u32 ilo, sly;
>> +
>> +	if (stride < 0) {
>> +		stride = -stride;
>> +		ilo = 0x100000 - (stride / 8);
>> +	} else {
>> +		ilo = stride / 8;
>> +	}
>> +
>> +	sly = (stride * 2) - 1;
>> +
>>   	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
>> -	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
>> -	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
>> +	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
>> +	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, sly);
>>   };
>>   EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
> This patch is merged in drm-next: 4e3c5d7e05be ("gpu: ipu-v3: Allow
> negative offsets for interlaced scanning")

I don't see it in drm-next, but I see it in linux-next/master. Thanks.

Steve
