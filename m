Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59358 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932479AbeGDIP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 04:15:58 -0400
Subject: Re: [PATCH v6 10/10] media: rcar-vin: Add support for R-Car R8A77995
 SoC
To: jacopo mondi <jacopo@jmondi.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528796612-7387-11-git-send-email-jacopo+renesas@jmondi.org>
 <1fc42981-2269-d6f5-921d-6730661542c7@xs4all.nl> <20180704074946.GA1240@w540>
 <CAMuHMdWK-1q-gkCMRkWJPMoeYgn1RoJC=Xjey3TA+ipiQzmFpQ@mail.gmail.com>
 <20180704080822.GB1240@w540>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f7ea38e9-26b0-465c-6392-c55009e7e562@xs4all.nl>
Date: Wed, 4 Jul 2018 10:15:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180704080822.GB1240@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/18 10:08, jacopo mondi wrote:
> Hi Geert,
> 
> On Wed, Jul 04, 2018 at 10:00:56AM +0200, Geert Uytterhoeven wrote:
>> Hi Jacopo,
>>
>> On Wed, Jul 4, 2018 at 9:49 AM jacopo mondi <jacopo@jmondi.org> wrote:
>>> On Wed, Jul 04, 2018 at 09:36:34AM +0200, Hans Verkuil wrote:
>>>> On 12/06/18 11:43, Jacopo Mondi wrote:
>>>>> Add R-Car R8A77995 SoC to the rcar-vin supported ones.
>>>>>
>>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>>>> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>
>>>> Checkpatch reports:
>>>>
>>>> WARNING: DT compatible string "renesas,vin-r8a77995" appears un-documented -- check ./Documentation/devicetree/bindings/
>>>> #29: FILE: drivers/media/platform/rcar-vin/rcar-core.c:1150:
>>>> +               .compatible = "renesas,vin-r8a77995",
>>>>
>>>> I'll still accept this series since this compatible string is already used in
>>>> a dtsi, but if someone can document this for the bindings?
>>>
>>> A patch has been sent on May 21st for this
>>> https://patchwork.kernel.org/patch/10415587/
>>>
>>> Bindings documentation usually gets in a release later than bindings
>>> users, to give time to bindings to be changed eventually before
>>> being documented.
>>>
>>> Simon, Geert, is this correct?
>>
>> Hmm, not 100% ;-)
>>
>> Usually the binding update for a trivial one like this goes in _in parallel_
>> with its user in a .dtsi.  So it happens from time to time that the binding
>> update is delayed by one kernel release (or more).
>>
> 
> Thanks for clarifying
> 
>> This one is a bit special, as it seems a driver update is needed, too?
>> So I'd expect the binding update would be part of this series.
>> But that may be a bit too naive on my side, as I don't follow multimedia
>> development that closely.
> 
> I sent dts and driver updates in two different series, and this last
> patch is the only one that was not collected.
> https://patchwork.kernel.org/patch/10415587/

Weird, this patch does not appear to have been posted to the linux-media
mailinglist, but it should since we are typically responsible for applying
patches in bindings/media.

Why don't you post a v5, this time including linux-media and I'll pick it
up in my pull request.

Regards,

	Hans

> 
> Hans is taking care of taking the driver updates, should I notify you
> and Simon once those patches land on the media master branch ?
> 
> Thanks
>   j
> 
>>
>>>>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>>>>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>>>>> @@ -1045,6 +1045,18 @@ static const struct rvin_info rcar_info_r8a77970 = {
>>>>>     .routes = rcar_info_r8a77970_routes,
>>>>>  };
>>>>>
>>>>> +static const struct rvin_group_route rcar_info_r8a77995_routes[] = {
>>>>> +   { /* Sentinel */ }
>>>>> +};
>>>>> +
>>>>> +static const struct rvin_info rcar_info_r8a77995 = {
>>>>> +   .model = RCAR_GEN3,
>>>>> +   .use_mc = true,
>>>>> +   .max_width = 4096,
>>>>> +   .max_height = 4096,
>>>>> +   .routes = rcar_info_r8a77995_routes,
>>>>> +};
>>>>> +
>>>>>  static const struct of_device_id rvin_of_id_table[] = {
>>>>>     {
>>>>>             .compatible = "renesas,vin-r8a7778",
>>>>> @@ -1086,6 +1098,10 @@ static const struct of_device_id rvin_of_id_table[] = {
>>>>>             .compatible = "renesas,vin-r8a77970",
>>>>>             .data = &rcar_info_r8a77970,
>>>>>     },
>>>>> +   {
>>>>> +           .compatible = "renesas,vin-r8a77995",
>>>>> +           .data = &rcar_info_r8a77995,
>>>>> +   },
>>>>>     { /* Sentinel */ },
>>>>>  };
>>>>>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>>
>> Gr{oetje,eeting}s,
>>
>>                         Geert
>>
>> --
>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>>
>> In personal conversations with technical people, I call myself a hacker. But
>> when I'm talking to journalists I just say "programmer" or something like that.
>>                                 -- Linus Torvalds
