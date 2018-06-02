Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35003 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeFBRdG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 13:33:06 -0400
Received: by mail-pf0-f181.google.com with SMTP id x9-v6so13958539pfm.2
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2018 10:33:06 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: Philipp Zabel <pza@pengutronix.de>
Cc: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        linux-media@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
References: <e7485d6e-d8e7-8111-c318-083228bf2a5c@gmail.com>
 <1527229949.4938.1.camel@pengutronix.de> <m3y3g8p5j3.fsf@t19.piap.pl>
 <1e11fa9a-8fa6-c746-7ee1-a64666bfc44e@gmail.com> <m3lgc2q5vl.fsf@t19.piap.pl>
 <06b9dd3d-3b7d-d34d-5263-411c99ab1a8b@gmail.com> <m38t81plry.fsf@t19.piap.pl>
 <4f49cf44-431d-1971-e5c5-d66381a6970e@gmail.com> <m336y9ouc4.fsf@t19.piap.pl>
 <6923fcd4-317e-d6a6-7975-47a8c712f8f9@gmail.com>
 <20180531062911.pkl2pracmyvhsldz@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3db739a8-8482-688c-e26d-69095087444a@gmail.com>
Date: Sat, 2 Jun 2018 10:33:03 -0700
MIME-Version: 1.0
In-Reply-To: <20180531062911.pkl2pracmyvhsldz@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/30/2018 11:29 PM, Philipp Zabel wrote:
> On Wed, May 30, 2018 at 01:56:34PM -0700, Steve Longerbeam wrote:
>>
>> On 05/30/2018 11:46 AM, Krzysztof Hałasa wrote:
>>> Steve Longerbeam <slongerbeam@gmail.com> writes:
>>>
>>>>> but it should be possible for the user to explicitly request the field
>>>>> order on CSI output (I can make a patch I guess).
>>>> If you think that is the correct behavior, I will remove the override
>>>> code. I suppose it makes sense to allow user to select field order even
>>>> if that order does not make sense given the input standard. I'm fine
>>>> either way, Philipp what is your opinion? I'll go with the popular vote :)
>>> I think it should be up to the user.
>>> Actually, PAL and NTSC aren't valid names in the digital world. Their
>>> meaning ends in the ADV7180 (or equivalent). I don't know if PAL and/or
>>> NTSC specify the field order in the analog frame (meaningful when
>>> someone hooks a camera with progressive sensor and analog, interlaced
>>> output), but the digital YUV422 from ADV to CSI isn't NTSC/PAL anymore.
>>> It's just WxH @ framerate + possible interlacing, sequential fields,
>>> top-bottom or otherwise, etc. The analog standard names could be used
>>> here but just as defaults.
>>>
>>> If we were strict (and we don't want to force it), then we should set
>>> NTSC/PAL thing on ADV7180 input, 720x480@29.97i (or 720x576@50i, or
>>> 704x... etc) on the input parts of the CSI/IPU (where there are no video
>>> frames yet), and 720x480@29.97i B-T or T-B (or default, or separate
>>> fields - whatever suits the user) on the output from CSI.
>>>
>>> I remember the reversed field order was sometimes needed - for example,
>>> PAL DV (the casette camcorder thing) produced B-T frames (same as NTSC),
>>> and to avoid (slight) additional quality loss one had to process it
>>> (up to e.g. .MP4, DVD, and then to HDMI, SCART etc) as B-T.
>>> It wasn't a problem in otherwise-PAL-centric environment.
>> I tend to agree, I've found conflicting info out there regarding
>> PAL vs. NTSC field order. And I've never liked having to guess
>> at input analog standard based on input # lines. I will go ahead
>> and remove the field order override code.
> Note that the code in ipu_csi_init_interface currently hard-codes field
> order depending on frame size. It could be that selecting opposite field
> order is as easy as switching the relevant parts of writes to registers
> CCIR_CODE_2 and _3, but we'd have to pass the desired output field order
> to this function. I'd welcome if somebody would verify that this works.

As I said in the other thread, I think we should put this off to some
other time, and remove the code in ipu_csi_init_interface() that
inverts field order according to frame size. This way, CSI will not
be lying to userspace when we tell it the order is BT but the CSI
has actually inverted that to TB.

Also I have concerns about the CSI capturing field 1 _before_ field
0 for NTSC. Doesn't that mean the CSI will drop the B-field in the
first captured frame on stream on, and thereafter mix fields from
different adjacent frames?

Steve
