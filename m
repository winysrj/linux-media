Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56162 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2IWN1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 09:27:45 -0400
Received: by bkcjk13 with SMTP id jk13so452497bkc.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 06:27:43 -0700 (PDT)
Message-ID: <505F0E5E.4030303@googlemail.com>
Date: Sun, 23 Sep 2012 15:27:58 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] gspca_pac7302: add support for green balance adjustment
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com> <1347811240-4000-4-git-send-email-fschaefer.oss@googlemail.com> <5059FFF1.30104@googlemail.com> <505A2C52.4040001@redhat.com> <505A3112.10207@googlemail.com> <505ADD14.7070208@redhat.com> <505B03FC.3080707@googlemail.com>
In-Reply-To: <505B03FC.3080707@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 20.09.2012 13:54, schrieb Frank Schäfer:
> Hi,
>
> Am 20.09.2012 11:08, schrieb Hans de Goede:
>> Hi,
>>
>>>>> Hans, it seems like you didn't pick up these patches up yet...
>>>>> Is there anything wrong with them ?
>>>> I've somehow completely missed them. Can you resend the entire set
>>>> please?
>>> No problem, but I can't do that before weekend (I'm currently not at
>>> home).
>>> I've sent these 4 patches on last Sunday (16. Sept) evening.
>>> Maybe you can pick them up from patchwork ?
>>> http://patchwork.linuxtv.org/patch/14433/
>> Ah yes, patchwork, that will work. Unfortunately that only solves the
>> me having missed the patches problem.
>>
>> First of all thanks for working on this! I'm afraid you've managed to
>> find
>> one of the weak spots in the v4l2 API, namely how we deal with RGB gains.
> It seems like this is one of my talents... :(
>
>> Many webcams have RGB gains, but we don't have standard CID-s for these,
>> instead we've Blue and Red Balance. This has grown historically
>> because of
>> the bttv cards which actually have Blue and Red balance controls in
>> hardware,
>> rather then the usual RGB gain triplet. Various gspca drivers cope
>> with this
>> in different ways.
>>
>> If you look at the pac7302 driver before your latest 4 patches it has
>> a Red and Blue balance control controlling the Red and Blue gain, and a
>> Whitebalance control, which is not White balance at all, but simply
>> controls the green gain...
> Ok, so if I understand you right, red+green+blue balance = white balance.
> And because we already have defined red, blue and whitebalance controls
> for historical reasons, we don't need green balance ?
> Maybe that matches physics, but I don't think it's a sane approach for a
> user interface...
>
>
>> And as said other drivers have similar (albeit usually different) hacks.
>>
>> At a minimum I would like you to rework your patches to:
>> 1) Not add the new Green balance, and instead modify the existing
>> whitebalance
>> to control the new green gain you've found. Keeping things as broken as
>> they are, but not worse; and
> I prefer waiting for the results of the discussion you are proposing
> further down.
>
>> 2) Try to use both the page 0 reg 0x01 - 0x03 and page 0 reg 0xc5 - 0xc7
>> at the same time to get a wider ranged control. Maybe 0xc5 - 0xc7 are
>> simply the most significant bits of a wider ranged gain ?
> I don't think so. The windows driver does not use them.
> It even doesn't use the full range of registers 0x01-0x03.
> Of course, I have expermiented with the full range and it works, but it
> doesn't make much sense to use it.
>
> Experimenting with the device to determine the meaing of unknown
> registerts, you will notice, that there are several registert which
> affect RGB.
> But that doesn't mean that they are suitable for a user control...
>
>> Note that if you cannot control them both from a single control in such
>> a way that you get a smooth control range, then lets just fix
>> 0xc5 - 0xc7 at a value of 2 for all 3 and be done with it, but at least
>> we should try :)
> There is no need to fix registers 0xc5 and 0xc7.
> The Windows driver sets them to 1, which is exactly the value we are
> currently using as default value with the blue and red value controls.
>
>> As said the above is the minimum, what I would really like is a
>> discussion
>> on linux-media about adding proper RGB gain controls for all the cameras
>> which have these.
>>
>> Note this brings with itself the question should we export such lowlevel
>> controls at all ? In some drivers the per color gains are simply all
>> kept at the same level and controlled as part of the master gain control,
>> giving it a wider and/or more fine grained range, leading to better
>> autogain
>> behavior. Given how our sw autowhitebalance works (and that that works
>> reasonable well), their is not much added value in exporting them
>> separately,
>> while they do tend to improve the standard gain control when used as part
>> of it ...
> I would say, let the drivers decide how to do things. It also depends on
> the hardware design.
>
> Regards,
> Frank
>
>> So what we really need is a plan how to deal with these controls, and
>> then
>> send an RFC for this to the list.
>>
>> Regards,
>>
>> Hans
>>

Hans, I don't have the bandwidth to go through a long discussion in
which probably nobody is really interested.
So please just drop the last two patches which are related to the
V4L2_CID_GREEN_BALANCE issue.
I documented the registers and behavior of the Windows driver, so if you
one day come to the conclusion that such a control would be usefull, it
can be added easily at any time later.

But I would really like to see the first two patches getting applied for
3.7.
The first one is a documentation fix, the second one clearly improves
the behavior of the red and blue balance control (as explained above).
I will resend both patches.


Regards,
Frank
