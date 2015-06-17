Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33744 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbbFQW7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 18:59:46 -0400
Received: by qkhu186 with SMTP id u186so35002389qkh.0
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2015 15:59:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3b967113dc16d6edc8d8dd7df9be8b80@hardeman.nu>
References: <20150519203851.GC18036@hardeman.nu>
	<CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
	<20150520182901.GB13624@hardeman.nu>
	<CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
	<20150520204557.GB15223@hardeman.nu>
	<CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
	<32cae92aa099067315d1a13c7302957f@hardeman.nu>
	<CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
	<db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
	<CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
	<20150521194034.GB19532@hardeman.nu>
	<CAKv9HNbsCK_1XbYMgO3Monui9JnHc7knJL3yon9FUMJ_MCLppg@mail.gmail.com>
	<5418c2397b8a8dab54bfbcfe9ed3df1d@hardeman.nu>
	<CAKv9HNbGAta3BDSk=xjsviUuqMP7TBGtf4PhdfNn8B7N-Gz_dg@mail.gmail.com>
	<3b967113dc16d6edc8d8dd7df9be8b80@hardeman.nu>
Date: Thu, 18 Jun 2015 01:59:45 +0300
Message-ID: <CAKv9HNZVy_ASbLhuNkJs+8R83Hg+wCyhFDmsygfZTNvER4WepA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14 June 2015 at 02:44, David Härdeman <david@hardeman.nu> wrote:

> One idea that I've had in the back of my head for a long time is to use the
> "flags" member of "struct rc_keymap_entry" in the new EVIOC[GS]KEYCODE_V2
> ioctl variant (see http://www.spinics.net/lists/linux-media/msg88452.html).
>
> If a RC_POWERON flag was defined, it could be used for that purpose...
>

Ooh, that approach would indeed provide a cleaner api for setting the
wakeup scancode. I like the idea though I haven't really had the
chance to try it out.

> ...
>>
>> I'm sorry that the encoding functionality clashes with your intentions
>> of improving the rc-core. I guess Mauro likes encoders more than
>> improving rc-core fundamentals :)
>> Kidding aside the fact that this series got merged might suggest that
>> you and Mauro don't necessarily share the same views about the future
>> and possible api breaks of rc-core.
>
>
> If you've followed the development of rc-core during the last few years it
> should be pretty clear that Mauro has little to no long-term plan,
> understanding of the current issues or willingness to fix them. I wouldn't
> read too much into the fact that the code was merged.
>
>> Tell you what, I'll agree to reverting the series. In exchange I would
>> hope that you and Mauro mutually agree and let me know on:
>>  - What are the issues that need to be fixed in the encoding series
>> prefarably with how to fix them (e.g. module load order ambiquity,
>> whether a new api is needed, or switching to a more limited
>> functionality is desired like you suggested then so be it etc.)
>>  - When is a good chance to re-submit the series (e.g. after
>> ioctl/scancode/whatever api break is done or some pending series is
>> merged or some other core refactoring work is finished etc.)
>>
>> Deal?
>
>
> Mauro....wake up? I hope you're not planning to push the current code
> upstream???
>

Yeah, I'm also inclined to target for a longer term solution with this
so the current patches can be reverted.

I think I now also have enough information to go and respin the
patches to utilize the new EVIOCSKEYCODE_V2 if and when that gets
included in the rc-core.

-- 
Antti
