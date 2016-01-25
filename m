Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33934 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbcAYSYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 13:24:05 -0500
Received: by mail-wm0-f54.google.com with SMTP id u188so77166858wmu.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2016 10:24:03 -0800 (PST)
Subject: Re: SV: PCTV 292e support
To: Russel Winder <russel@winder.org.uk>,
	=?UTF-8?Q?Peter_F=c3=a4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1453613292.2497.26.camel@winder.org.uk>
 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
 <1453615078.2497.29.camel@winder.org.uk>
 <1453618564.2497.51.camel@winder.org.uk>
 <1453625202.2497.54.camel@winder.org.uk> <56A4A262.1090708@gmail.com>
 <1453639842.2497.69.camel@winder.org.uk> <56A570C7.5090107@gmail.com>
 <1453743221.15408.86.camel@winder.org.uk>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <56A6682A.3090007@gmail.com>
Date: Mon, 25 Jan 2016 18:23:38 +0000
MIME-Version: 1.0
In-Reply-To: <1453743221.15408.86.camel@winder.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russel Winder wrote:
> On Mon, 2016-01-25 at 00:48 +0000, Andy Furniss wrote:
>> Russel Winder wrote:
>>> On Sun, 2016-01-24 at 10:07 +0000, Andy Furniss wrote:
>>
>>> It finds all the physical channels, quite happily describes all
>>> the virtual channels in the T1 channels, fails to find anything
>>> in one of the T2 channels and finds unnamed channels in the
>>> other T2 channel. The device itself is fine, as it gets all T1
>>> and T2 channels on Windows. This implies something awry with it
>>> in a Linux context.
>>
>> OK, I can't reproduce this on Tacoleneston which has three T2
>> muxes.
>
> I have managed to get some proper T2 tuning. :-)
>
> Someone emailed me privately to tell me about:
>
> https://github.com/OpenELEC/dvb-firmware
>
> The 292e demod firmware in their is 8 bug fix release further on that
> the one I had. It looks like there was a crucial bug fix in there.

Ahh, that's good. I ought to get that myself, I am still using 4.0.4!

>> I am using some old git version (Jun 10), I'll try current as time
>>  allows.

FWIW I did build current git and it does work.

> I am finding locking behaviour to be very strange. Sometimes I get an
> immediate lock on a -50.0 signal, sometimes -35.0 signal fails to
> lock. I am not sure if this is just a timing/sampling thing or
> whether there is a quality of signal thing I am missing.

I've only really tested with a "real" aerial, but it did seem like
sometimes it took longer than others to lock.

> As I am focused on lightweight, I am working with non-fixed aerials
> so low signal strengths. Though for testing I have an aerial with
> powered high gain.

Random thoughts on player -

You'll need to handle AAC in LATM that switches between 2 and 5
channels. VLC falls down in this respect. Avoid FAAD as the release at
least had a bug that will cause volume issues with some content if it
has dynamic range control metadata. ffmpeg aacdec handles channel
switching and ignores DRC meta - so you get full range.

On V4l

As I leave mine plugged in a headless box I don't hit this, but I think
there's a chance that if you repeatedly plug and have fragmented memory
that it will eventually fail to allocate some buffers.
