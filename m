Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:37711 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752889AbeFHVep (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:34:45 -0400
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
 <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <273d89f9-511b-0a30-836c-74a8c08ec19b@mentor.com>
Date: Fri, 8 Jun 2018 14:34:40 -0700
MIME-Version: 1.0
In-Reply-To: <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,


On 06/08/2018 02:29 PM, Kieran Bingham wrote:
> Hi Steve,
>
> Thankyou for the patch.
>
> On 08/06/18 18:43, Steve Longerbeam wrote:
>> The ADV748x CSI-2 subdevices are HMDI/AFE to MIPI CSI-2 bridges.
>>
> Reading the documentation for MEDIA_ENT_F_VID_IF_BRIDGE, this seems reasonable.
>
> Out of interest, have you stumbled across this as part of your other work on
> CSI2 drivers - or have you been looking to test the ADV748x with your CSI2
> receiver? I'd love to know if the driver works with other (non-renesas) platforms!

This isn't really related to my other work on the i.MX CSI2 receiver driver
in imx-media. I've only tested this on Renesas (Salvator-X).

Steve

>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
>
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
