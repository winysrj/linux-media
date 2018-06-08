Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38466 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbeFHVja (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 17:39:30 -0400
Received: by mail-qk0-f195.google.com with SMTP id y4-v6so9660937qka.5
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2018 14:39:30 -0700 (PDT)
Subject: Re: [PATCH] media: i2c: adv748x: csi2: set entity function to video
 interface bridge
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1528479785-5193-1-git-send-email-steve_longerbeam@mentor.com>
 <011af984-e447-8640-4173-4bf20919905b@ideasonboard.com>
 <273d89f9-511b-0a30-836c-74a8c08ec19b@mentor.com>
 <ca7f36a4-209a-5882-3757-918dc35518ac@ideasonboard.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <25a36111-5631-f280-dfe8-e2f076698845@gmail.com>
Date: Fri, 8 Jun 2018 14:39:26 -0700
MIME-Version: 1.0
In-Reply-To: <ca7f36a4-209a-5882-3757-918dc35518ac@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/08/2018 02:37 PM, Kieran Bingham wrote:
> Hi Steve,
>
> On 08/06/18 22:34, Steve Longerbeam wrote:
>> Hi Kieran,
>>
>>
>> On 06/08/2018 02:29 PM, Kieran Bingham wrote:
>>> Hi Steve,
>>>
>>> Thankyou for the patch.
>>>
>>> On 08/06/18 18:43, Steve Longerbeam wrote:
>>>> The ADV748x CSI-2 subdevices are HMDI/AFE to MIPI CSI-2 bridges.
>>>>
>>> Reading the documentation for MEDIA_ENT_F_VID_IF_BRIDGE, this seems reasonable.
>>>
>>> Out of interest, have you stumbled across this as part of your other work on
>>> CSI2 drivers - or have you been looking to test the ADV748x with your CSI2
>>> receiver? I'd love to know if the driver works with other (non-renesas)
>>> platforms!
>> This isn't really related to my other work on the i.MX CSI2 receiver driver
>> in imx-media. I've only tested this on Renesas (Salvator-X).
> No problem. I was just curious :D
> And this will get rid of that annoying warning message that I've been ignoring!

Yeah, darn those pesky warnings :)

Steve

>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>> Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>>
>>>> ---
>>>>    drivers/media/i2c/adv748x/adv748x-csi2.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c
>>>> b/drivers/media/i2c/adv748x/adv748x-csi2.c
>>>> index 820b44e..469be87 100644
>>>> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
>>>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
>>>> @@ -284,7 +284,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct
>>>> adv748x_csi2 *tx)
>>>>        adv748x_csi2_set_virtual_channel(tx, 0);
>>>>          adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
>>>> -                MEDIA_ENT_F_UNKNOWN,
>>>> +                MEDIA_ENT_F_VID_IF_BRIDGE,
>>>>                    is_txa(tx) ? "txa" : "txb");
>>>>          /* Ensure that matching is based upon the endpoint fwnodes */
>>>>
