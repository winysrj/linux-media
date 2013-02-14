Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:57323 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab3BNT5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 14:57:33 -0500
Received: by mail-vb0-f43.google.com with SMTP id fs19so1712074vbb.16
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 11:57:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511D37FF.9070206@iki.fi>
References: <511CE2BF.8020905@tvdr.de>
	<511D085A.80009@iki.fi>
	<CAHFNz9JN_z5xa0eyaacdOKSdTJoOqAW87+jeLW+3AnARDVX41g@mail.gmail.com>
	<511D37FF.9070206@iki.fi>
Date: Fri, 15 Feb 2013 01:20:49 +0530
Message-ID: <CAHFNz9+1w2W0dc9ZrW7mewA7aB4YbuJW7QT5Pr7-m2Js9vpq8A@mail.gmail.com>
Subject: Re: DVB: EOPNOTSUPP vs. ENOTTY in ioctl(FE_READ_UNCORRECTED_BLOCKS)
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 15, 2013 at 12:46 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 02/14/2013 08:05 PM, Manu Abraham wrote:
>>
>> On Thu, Feb 14, 2013 at 9:22 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 02/14/2013 03:12 PM, Klaus Schmidinger wrote:
>>>>
>>>>
>>>> In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device
>>>> (using stb0899).
>>>> After this call I check 'errno' for EOPNOTSUPP to determine whether this
>>>> device supports this call. This used to work just fine, until a few
>>>> months
>>>> ago I noticed that my devices using stb0899 didn't display their signal
>>>> quality in VDR's OSD any more. After further investigation I found that
>>>> ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but
>>>> rather
>>>> ENOTTY. And since I stop getting the signal quality in case any unknown
>>>> errno value appears, this broke my signal quality query function.
>>>>
>>>> Is there a reason why this has been changed?
>>>
>>>
>>>
>>> I changed it in order to harmonize error codes. ENOTTY is correct error
>>> code
>>> for the case IOCTL is not implemented. What I think it is Kernel wide
>>> practice.
>>>
>>
>> By doing so, You BROKE User Space ABI. Whatever it is, we are not allowed
>> to
>> break User ABI. https://lkml.org/lkml/2012/12/23/75
>
>
> Yes, it will change API, that's clear. But the hell, how you will get
> anything fixed unless you change it? Introduce totally new API every-time
> when bug is found? You should also understand that changing that single
> error code on that place will not change all the drivers and there will be
> still some other error statuses returned by individual drivers.
>
> It is about 100% clear that ENOTTY is proper error code for unimplemented
> IOCTL. I remember maybe more than one discussion about that unimplemented
> IOCTL error code. It seems to be defined by POSIX [1] standard.


It could be. But what I stated is thus:

There existed commonality where all unimplemented IOCTL's returned
EOPNOTSUPP when the corresponding callback wasn't implemented.
So, this was kind of standardized though it was not the ideal thing,
though it was not a big issue, it just stated "socket" additionally.

You changed it to ENOTTY to make it fit for the idealistic world.
All applications that depended for ages, on those error are now broken.


Some drivers, have callbacks which are dummy as you state which
return different error codes ? It would have been easier, or correct to
fix those drivers, rather than blowing up all user applications.


> There is a lot of drivers implementing stub callbacks and returning own
> values. Likely much more than those which does not implement it at all.
>
>
>> How can a driver return an error code, for an IOCTL that is *not*
>> implemented ?
>> AFAICS, your statement is bogus. :-)
>
>
> Just implementing IOCTL and returning some value! Have you looked those
> drivers?) There is very many different errors returned, especially in cases
> where hardware is not able to provide asked value at the time, example
> sleeping.


When you implement an IOCTL callback, then you have an implemented
IOCTL. I still don't understand by what you state:

"ENOTTY is correct error code for the case IOCTL is not implemented."

in comparison to your above statement.

As i stated just above, it would be sensible to fix the drivers, rather than
causing even more confusion.


> Maybe the most common status is just to return 0 as status and some random
> numbers as data - but there has been some discussion it is bad idea too.
>
> It is just easy to fix back these few cases by implementing missing
> callbacks and return EOPNOTSUPP. But it will not "fix" all the drivers, only
> those which were totally without a callback.
>
> And I ran RFC before started harmonizing error codes. There was not too many
> people commenting how to standardize these error codes....


Just because no one commented, doesn't make it right to blow up userspace
applications.

Regards,
Manu
