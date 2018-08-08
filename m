Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58950 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeHHPLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 11:11:24 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH] media: dt: adv7604: Fix slave map documentation
To: =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180807155452.797-1-kieran.bingham@ideasonboard.com>
 <505904fb-7bfc-c455-740e-b72a14731eb9@ysoft.com>
 <b5b25641-f898-577b-7762-d72dd64272cf@ideasonboard.com>
 <5273911.bCJl0SVgzf@avalon> <bc69dca9-89c7-2df7-3dea-d6ee6651677e@ysoft.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <4e8e3546-21f0-33c2-42b2-db0bbe9ed11d@ideasonboard.com>
Date: Wed, 8 Aug 2018 13:51:44 +0100
MIME-Version: 1.0
In-Reply-To: <bc69dca9-89c7-2df7-3dea-d6ee6651677e@ysoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michal,

On 08/08/18 13:33, Michal Vokáč wrote:
> On 8.8.2018 12:25, Laurent Pinchart wrote:
>> Hi Kieran,
>>
>> On Wednesday, 8 August 2018 13:23:32 EEST Kieran Bingham wrote:
>>> Hi Michal,
>>>
>>> Thank you for your review.
>>>
>>> +Rob, +Mark, +Laurent asking for opinions if anyone has any on prefixes
>>> through media tree.
>>>
>>> On 08/08/18 08:48, Michal Vokáč wrote:
>>>> On 7.8.2018 17:54, Kieran Bingham wrote:
>>>> Hi Kieran,
>>>>
>>>>> The reg-names property in the documentation is missing an '='. Add it.
>>>>>
>>>>> Fixes: 9feb786876c7 ("media: dt-bindings: media: adv7604: Extend
>>>>> bindings to allow specifying slave map addresses")
>>>>
>>>> "dt-bindings: media: " is preferred for the subject.
>>>
>>> This patch will go through the media-tree as far as I am aware, and
>>> Mauro prefixes all commits through the media tree with "media:" if they
>>> are not already prefixed.
> 
> OK, I did not know about that practice with the prefix.

It's media specific. It used to be [media], but now changed to "media:"


> Anyway, why should this patch go through media-tree when it is a single
> patch affecting device tree binding only? I would expect it to be picked
> by Rob or Mark.


My change 9feb786876c7 went through the media tree, because it directly
affected a media driver. This change affects the same thing, so I
assumed it's a media-tree patch, but I could be wrong. I'll await to be
told :)



>>> Thus this would then become "media: dt-bindings: media: adv7604: ...."
>>> as per my commit: 9feb786876c7 which seems a bit redundant.
> 
> Agree that this seems redundant. Absolutely no offense, just a curious
> newbee question - why is the "media:" prefix added later on to *all* the
> patches at all?

Mauro's tree style choice as far as I know.


> I understand that each subsystem has it own convenience what subject
> prefix to use. Given that all patches are propperly formated after
> the review process is finished I do not see a reason why the subject
> should be changed.
> 
> So patches to "drivers/media/xxx" should land as "media: xxx: ..." and
> patches to "Documentation/devicetree/bindings/xxx" should land as
> "dt-bindings: media: xxx".
> 
> This allows easier git log browsing.
>>>
>>> Is it still desired ? If so I'll send a V2. (perhaps needed anyway, as I
>>> seem to have erroneously shortened dt-bindings: to just dt: which wasn't
>>> intentional.
> 
> I do not know. Some time ago I tripped over a patch from Rob explaining
> how to properly format dt-binding related patches. I also read a bunch
> of his replies to emails that were kind of "out of bounds" in this regard.
> So I got an impression that he is starting to be upset that people still
> make the same mistakes and do not read
> devicetree/bindings/submitting-patches.txt

Well - I didn't know that existed :) So I've learnt something new.

Seems we now have three "submitting-patches" files to read:

find | grep submitting-patches
./Documentation/process/submitting-patches.rst
./Documentation/hwmon/submitting-patches
./Documentation/devicetree/bindings/submitting-patches.txt


Perhaps adding some rules into checkpatch.pl is the way forward to
enforce prefixes where necessary ?

> I deeply memorized that "rules" and once a while I go through the DT list
> and reply to some emails that does not fit. Just because I am sure
> that all maintainers are overloaded and surely have something more useful
> to do than commenting on trivial mistakes.
Absolutely! I believe that is a worthwhile thing to do :) and certainly
eases the strain on maintainers.


> Next time I will choose more wisely what emails I reply to :)
>>>
>>>> I think you should also add device tree maintainers to the recipients.
>>>
>>> Added to this mail to ask opinions on patch prefixes above.
>>>
>>> Originally, I believed the list was sufficient as this is a trivial
>>> patch, and it goes through the media tree.
>>>
>>> But, it turned out to be more controversial :)
>>>
>>> Rob, Mark, should I add you to all patches affecting DT? Or is the list
>>> sufficient?
>>
>> Given the insane amount of patches received by DT maintainers, I
>> personally
>> try to use common sense and only disturb them when needed. Such a typo
>> fix
>> doesn't qualify for a full CC list in my opinion.
> 
> OK, sorry you spent your time discussing such a trivial thing folks.
> I am still learning how to efficiently contribute and I still very much
> depend on get_maintainers.pl output and other great tools others created ;)

Yes, the difficulty is having so many lists, and subsystems with
different preferences. I've been told off for blindly including all
recipients from get_maintainers. Otherwise I'd just always use
 "git send-email --cc-cmd ./scripts/get_maintainers.pl ..."


> Thank you for your time,

And yours :)

> Michal

Kieran


> 
>>>>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>>>> ---
>>>>>    Documentation/devicetree/bindings/media/i2c/adv7604.txt | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>>> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>>> index dcf57e7c60eb..b3e688b77a38 100644
>>>>> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>>> @@ -66,7 +66,7 @@ Example:
>>>>>             * other maps will retain their default addresses.
>>>>>             */
>>>>>            reg = <0x4c>, <0x66>;
>>>>> -        reg-names "main", "edid";
>>>>> +        reg-names = "main", "edid";
>>>>>              reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
>>>>>            hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
>>
> 

-- 
Regards
--
Kieran
