Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab2IXOGI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:06:08 -0400
Message-ID: <50606920.5050304@redhat.com>
Date: Mon, 24 Sep 2012 16:07:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] gspca_pac7302: add support for green balance adjustment
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com> <1347811240-4000-4-git-send-email-fschaefer.oss@googlemail.com> <5059FFF1.30104@googlemail.com> <505A2C52.4040001@redhat.com> <505A3112.10207@googlemail.com> <505ADD14.7070208@redhat.com> <505B03FC.3080707@googlemail.com> <50603A52.3040208@redhat.com> <506061E4.1030701@googlemail.com>
In-Reply-To: <506061E4.1030701@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/24/2012 03:36 PM, Frank Schäfer wrote:
> Hi Hans,
>
> Am 24.09.2012 12:47, schrieb Hans de Goede:
>> Hi,
>>
>> Sorry for the slow response ...
>>
>> On 09/20/2012 01:54 PM, Frank Schäfer wrote:
>>> Hi,
>>>
>>> Am 20.09.2012 11:08, schrieb Hans de Goede:
>>
>> <snip>
>>
>>>> Many webcams have RGB gains, but we don't have standard CID-s for
>>>> these,
>>>> instead we've Blue and Red Balance. This has grown historically
>>>> because of
>>>> the bttv cards which actually have Blue and Red balance controls in
>>>> hardware,
>>>> rather then the usual RGB gain triplet. Various gspca drivers cope
>>>> with this
>>>> in different ways.
>>>>
>>>> If you look at the pac7302 driver before your latest 4 patches it has
>>>> a Red and Blue balance control controlling the Red and Blue gain, and a
>>>> Whitebalance control, which is not White balance at all, but simply
>>>> controls the green gain...
>>>
>>> Ok, so if I understand you right, red+green+blue balance = white
>>> balance.
>>> And because we already have defined red, blue and whitebalance controls
>>> for historical reasons, we don't need green balance ?
>>> Maybe that matches physics, but I don't think it's a sane approach for a
>>> user interface...
>>
>> No what I was trying to say is that the balance controls are for hardware
>> which actually has balance controls and not per color gains (such as the
>> bt87x chips), but they are being abused by many drivers to add support
>> for
>> per color gains. And then you miss one control. And in the case of the
>> pac7302
>> driver the "original" route was taken of using whitebalance to control
>> the green gain. Which is wrong IMHO, but it is what the driver does know.
>>
>> A proper fix would be to introduce new controls for all 3 gains, and use
>> those instead of using the balance controls + adding a 3th balance
>> control
>> being discussed in the thread titled:
>> "Gain controls in v4l2-ctrl framework".
>
> Ok, it seems I'm misunderstanding the meaning of color "gain" and
> "balance"...
>
> Anyway, I would say that it makes sense to have per color AND global
> controls, so a V4L2_CID_GREEN_BALANCE would be missing.
> Weather it makes sense to use them at the same time is a different question.
>
> And why do you think the controls in question are gain controls instead
> of balance controls ?

"Balance" suggest balancing it against some fixed value, where as once
there are 3 for all of r, g and b, there is no fixed value, then the registers
are just controlling an amplification factor (which could be less then 1.0)
and that is normally called a gain.

If you look in most sensor datasheets they talk about color gains not
balance controls ...

Anyways this is mostly just semantics. We are working on defining standard
controls for per color gains, and once we have those we can map them to
reg 0x01 - 0x03.

> The Windows driver calls them balance controls, too (which could of
> course also be a Windows driver or API issue...).
>
>
>>
>>>> And as said other drivers have similar (albeit usually different)
>>>> hacks.
>>>>
>>>> At a minimum I would like you to rework your patches to:
>>>> 1) Not add the new Green balance, and instead modify the existing
>>>> whitebalance
>>>> to control the new green gain you've found. Keeping things as broken as
>>>> they are, but not worse; and
>>>
>>> I prefer waiting for the results of the discussion you are proposing
>>> further down.
>>>
>>
>> I see in your next mail that you've changed your mind. So I would like to
>> move forward with this by adding your 2 patches + 1 more patch to also
>> make the whitebalance control (which really is the green gain control)
>> use 0x02 rather then 0xc6. To do this we must make sure that 0xc6 has
>> a proper fixed / default setting. So what does the windows driver use
>> for this? 1 like with 0xc5 and 0xc7 ?
>>
>> And can you do a 3th patch to make the whitebalance control control
>> 0x02 rather then 0xc6 like you did for red and blue balance?
>
> No, we shouldn't do that.
> Reg 0xc6 (currently called "white balance temperature") definitely works
> different compared to register 0x02.
> Whatever it does exactly, it's not green gain or balance adjustment.
> Will try to figure out next time.
> The Windows driver doesn't use this register for an (user settable)
> image control. It just sets its value to 55, which I fixed with one of
> the patches from my previous patch series, so we have the correct
> default value now.

Ah, interesting!

> 0xc6 is also different from regs 0xc5 and 0xc7: settable values are
> 0-255 compared to 0-3.

True, I should have noticed that.

> So let's not touch 0xc6 / "white balance" until we know its real meaning
> and just apply the first 2 patches.

OK, will do.

Regards,

Hans
