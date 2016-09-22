Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33363 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755092AbcIVNSA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 09:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <3410700.SJlxHzK90c@avalon>
References: <20160916093942.17213-1-ulrich.hecht+renesas@gmail.com>
 <20160916093942.17213-3-ulrich.hecht+renesas@gmail.com> <3410700.SJlxHzK90c@avalon>
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Date: Thu, 22 Sep 2016 15:17:58 +0200
Message-ID: <CAO3366wMc9s6vH4rm=SAus46AUdPKQuKucv2=_ktMBLKONr4kQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: adv7604: automatic "default-input" selection
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: hans.verkuil@cisco.com,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        William Towle <william.towle@codethink.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 16, 2016 at 11:57 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Ulrich,
>
> Thank you for the patch.

Thanks for your review.

>
> On Friday 16 Sep 2016 11:39:42 Ulrich Hecht wrote:
>> Fall back to input 0 if "default-input" property is not present.
>>
>> Documentation states that the "default-input" property should reside
>> directly in the node for adv7612.
>
> Not just fo adv7612.
>
>> Hence, also adjust the parsing to make the implementation consistent with
>> this.
>>
>> Based on patch by William Towle <william.towle@codethink.co.uk>.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/i2c/adv7604.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 4003831..055c9df 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -3077,10 +3077,13 @@ static int adv76xx_parse_dt(struct adv76xx_state
>> *state)
>>       if (!of_property_read_u32(endpoint, "default-input", &v))
>
> Should this be removed if the property has to be in the device node and not in
> the endpoint ?

Probably, considering it's not used anywhere yet.

>
>>               state->pdata.default_input = v;
>>       else
>> -             state->pdata.default_input = -1;
>> +             state->pdata.default_input = 0;
>
> What was the use case for setting it to -1 ? Is it safe to change that ?

Not sure. Might as well leave it at -1, we define the default in the DT anyway.

CU
Uli
