Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.48.104]:47324 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030902AbeBNVUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 16:20:08 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8487A13E53
        for <linux-media@vger.kernel.org>; Wed, 14 Feb 2018 14:57:33 -0600 (CST)
Subject: Re: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and
 PTR_ERR
To: Steve Longerbeam <slongerbeam@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20180124004340.GA25212@embeddedgus>
 <5e53d6d8-d336-da37-fe12-0638904e1799@gmail.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <4305212e-5946-0bb3-1624-ec23a0f37708@embeddedor.com>
Date: Wed, 14 Feb 2018 14:57:31 -0600
MIME-Version: 1.0
In-Reply-To: <5e53d6d8-d336-da37-fe12-0638904e1799@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I was just wondering about the status of this patch.

Thanks
--
Gustavo

On 01/24/2018 06:14 PM, Steve Longerbeam wrote:
> Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> 
> 
> On 01/23/2018 04:43 PM, Gustavo A. R. Silva wrote:
>> Fix inconsistent IS_ERR and PTR_ERR in vdic_get_ipu_resources.
>> The proper pointer to be passed as argument is ch.
>>
>> This issue was detected with the help of Coccinelle.
>>
>> Fixes: 0b2e9e7947e7 ("media: staging/imx: remove confusing 
>> IS_ERR_OR_NULL usage")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/staging/media/imx/imx-media-vdic.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-vdic.c 
>> b/drivers/staging/media/imx/imx-media-vdic.c
>> index 433474d..ed35684 100644
>> --- a/drivers/staging/media/imx/imx-media-vdic.c
>> +++ b/drivers/staging/media/imx/imx-media-vdic.c
>> @@ -177,7 +177,7 @@ static int vdic_get_ipu_resources(struct vdic_priv 
>> *priv)
>>           priv->vdi_in_ch = ch;
>>           ch = ipu_idmac_get(priv->ipu, IPUV3_CHANNEL_MEM_VDI_NEXT);
>> -        if (IS_ERR(priv->vdi_in_ch_n)) {
>> +        if (IS_ERR(ch)) {
>>               err_chan = IPUV3_CHANNEL_MEM_VDI_NEXT;
>>               ret = PTR_ERR(ch);
>>               goto out_err_chan;
> 
