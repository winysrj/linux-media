Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34698 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbeFHVjv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:39:51 -0400
Received: by mail-qk0-f193.google.com with SMTP id q70-v6so9678455qke.1
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 14:39:51 -0700 (PDT)
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
 <94861795-e8ac-7c61-dee4-410083d7d388@ideasonboard.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <61ae5ddf-bcf2-b045-19e8-01badc7fd971@gmail.com>
Date: Fri, 8 Jun 2018 14:39:48 -0700
MIME-Version: 1.0
In-Reply-To: <94861795-e8ac-7c61-dee4-410083d7d388@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/08/2018 02:39 PM, Kieran Bingham wrote:
> Hi Steve,
>
> On 08/06/18 18:43, Steve Longerbeam wrote:
>> The ADV748x CSI-2 subdevices are HMDI/AFE to MIPI CSI-2 bridges.
> Just spotted this :D
>
> s/HMDI/HDMI/

Sigh, sending v2.
Steve

>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
>> index 820b44e..469be87 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
>> @@ -284,7 +284,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
>>   	adv748x_csi2_set_virtual_channel(tx, 0);
>>   
>>   	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
>> -			    MEDIA_ENT_F_UNKNOWN,
>> +			    MEDIA_ENT_F_VID_IF_BRIDGE,
>>   			    is_txa(tx) ? "txa" : "txb");
>>   
>>   	/* Ensure that matching is based upon the endpoint fwnodes */
>>
