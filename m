Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43405 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbeHDVJ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 17:09:58 -0400
Subject: Re: [PATCH v3 02/14] gpu: ipu-csi: Check for field type alternate
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX"
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
 <1533150747-30677-3-git-send-email-steve_longerbeam@mentor.com>
 <1533202966.3516.9.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <46828b08-4866-6204-a0fe-0a8294450ad4@gmail.com>
Date: Sat, 4 Aug 2018 12:08:17 -0700
MIME-Version: 1.0
In-Reply-To: <1533202966.3516.9.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 08/02/2018 02:42 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Wed, 2018-08-01 at 12:12 -0700, Steve Longerbeam wrote:
>> When the CSI is receiving from a bt.656 bus, include a check for
>> field type 'alternate' when determining whether to set CSI clock
>> mode to CCIR656_INTERLACED or CCIR656_PROGRESSIVE.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/gpu/ipu-v3/ipu-csi.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
>> index caa05b0..5450a2d 100644
>> --- a/drivers/gpu/ipu-v3/ipu-csi.c
>> +++ b/drivers/gpu/ipu-v3/ipu-csi.c
>> @@ -339,7 +339,8 @@ static void fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
>>   		break;
>>   	case V4L2_MBUS_BT656:
>>   		csicfg->ext_vsync = 0;
>> -		if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field))
>> +		if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field) ||
>> +		    mbus_fmt->field == V4L2_FIELD_ALTERNATE)
>>   			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_INTERLACED;
>>   		else
>>   			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;
> this patch is already merged in v4.18-rc7.

Ah, I just noticed that after a fetch from kernel.org, thanks.

Steve
