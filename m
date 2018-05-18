Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:58923 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbeERTwO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 15:52:14 -0400
Subject: Re: [PATCH] gpu: ipu-v3: Fix BT1120 interlaced CCIR codes
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20180407130428.24833-1-marex@denx.de>
 <1526658687.3948.15.camel@pengutronix.de>
From: Marek Vasut <marex@denx.de>
Message-ID: <cec007aa-d0b7-0802-d771-355a29751a2b@denx.de>
Date: Fri, 18 May 2018 18:21:56 +0200
MIME-Version: 1.0
In-Reply-To: <1526658687.3948.15.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/18/2018 05:51 PM, Philipp Zabel wrote:
> Hi Marek,
> 
> On Sat, 2018-04-07 at 15:04 +0200, Marek Vasut wrote:
>> The BT1120 interlaced CCIR codes are the same as BT656 ones
>> and different than BT656 progressive CCIR codes, fix this.
> 
> thank you for the patch, and sorry for the delay.
> 
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>> ---
>>  drivers/gpu/ipu-v3/ipu-csi.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
>> index caa05b0702e1..301a729581ce 100644
>> --- a/drivers/gpu/ipu-v3/ipu-csi.c
>> +++ b/drivers/gpu/ipu-v3/ipu-csi.c
>> @@ -435,12 +435,16 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
>>  		break;
>>  	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
>>  	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
>> -	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
>> -	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
>>  		ipu_csi_write(csi, 0x40030 | CSI_CCIR_ERR_DET_EN,
>>  				   CSI_CCIR_CODE_1);
>>  		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
>>  		break;
>> +	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
>> +	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
>> +		ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN, CSI_CCIR_CODE_1);
>> +		ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
>> +		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
> 
> If these are the same as BT656 codes (so this case would be for PAL?),
> could this just be moved up into the IPU_CSI_CLK_MODE_CCIR656_INTERLACED
> case? Would the NTSC CCIR codes be the same as well?

Dunno, I don't have any NTSC device to test. But the above was tested
with a PAL device I had.

I think the CCIR codes are different from BT656, although I might be wrong.

-- 
Best regards,
Marek Vasut
