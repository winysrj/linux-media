Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33969 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbcAYAsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 19:48:32 -0500
Received: by mail-wm0-f41.google.com with SMTP id u188so47014393wmu.1
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2016 16:48:31 -0800 (PST)
Subject: Re: SV: PCTV 292e support
To: Russel Winder <russel@winder.org.uk>,
	=?UTF-8?Q?Peter_F=c3=a4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1453613292.2497.26.camel@winder.org.uk>
 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
 <1453615078.2497.29.camel@winder.org.uk>
 <1453618564.2497.51.camel@winder.org.uk>
 <1453625202.2497.54.camel@winder.org.uk> <56A4A262.1090708@gmail.com>
 <1453639842.2497.69.camel@winder.org.uk>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <56A570C7.5090107@gmail.com>
Date: Mon, 25 Jan 2016 00:48:07 +0000
MIME-Version: 1.0
In-Reply-To: <1453639842.2497.69.camel@winder.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russel Winder wrote:
> On Sun, 2016-01-24 at 10:07 +0000, Andy Furniss wrote:

> It finds all the physical channels, quite happily describes all the
> virtual channels in the T1 channels, fails to find anything in one
> of the T2 channels and finds unnamed channels in the other T2
> channel. The device itself is fine, as it gets all T1 and T2 channels
> on Windows. This implies something awry with it in a Linux context.

OK, I can't reproduce this on Tacoleneston which has three T2 muxes.

I am using some old git version (Jun 10), I'll try current as time allows.

One of the T2s only has 2 channels anyway and as is normal AFAIK
channels that aren't running at time of scan don't get audio/video pids
listed, but the rest of the info is there.

There is a timeout option eg -T 3 trebles the timeouts - maybe try that.


> The whole point of my activity is to rewrite Me TV. This is intended
> as a very lightweight DVB player. The idea is not to have MythTV,
> Kodi, etc. which are intended to be media centres. I just want a
> television window with EPG. Original Me TV was GTK+2, Xine, DVBv3
> with direct access to the kernel API. I am rewriting for libdvbv5,
> GStreamer, GTK+3.
>
> I am starting with scan and tune codes so as to set up dvr0 as the
> input source for the rendering. dvbv5-zap -p is an experimental tool
> to plug into a gst-launcher-1.0 script just to trial things. My code
> has the same problems dvbv5-zap has, describing my problem in terms
> of dvbv5-zap behaviour just means it isn't my code that is wrong,
> there is an issue somewhere in the libdvbv5 code or the device
> driver.

Interesting, so you know a lot more than me about this stuff :-)

Experience as a user of 292/290s - they do need some time/grace to tune
in/stop spewing "junk". IIRC I added 5sec somewhere in TVH in addition
to whatever it already uses.

I guess going from T to T2 is worse - and then factor in that some T2s
are much lower power than others.

It did seem in the thread that I started where EAGAIN worked around,
that the code was giving no grace at all and expecting to be able to
parse stream content straight away. I may mis-remember though!


