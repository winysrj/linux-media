Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48656 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2GLA1P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 20:27:15 -0400
Received: by yenl2 with SMTP id l2so1876383yen.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 17:27:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADR1r6is7yNaCLYmLuVB-QwJHjBaQJJAL-rnmn2ufE+Rt6_ezg@mail.gmail.com>
References: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
	<CAA7C2qi5w+22LX+5r_8fKjxOOtGHGRQfFivC3GG0UD1LWE_Txg@mail.gmail.com>
	<CADR1r6is7yNaCLYmLuVB-QwJHjBaQJJAL-rnmn2ufE+Rt6_ezg@mail.gmail.com>
Date: Wed, 11 Jul 2012 17:27:13 -0700
Message-ID: <CAA7C2qjLom0KRV-X8LgngmtTGQoUYhoGpWYiExUVZ_0P1FBFqQ@mail.gmail.com>
Subject: Re: Make menuconfig doesn't work anymore
From: VDR User <user.vdr@gmail.com>
To: Martin Herrman <martin.herrman@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 11, 2012 at 2:30 PM, Martin Herrman
<martin.herrman@gmail.com> wrote:
>> Actually I got the exact same error when compiling a new 3.4.4 kernel.
>
> It always feels good to know that you're not alone ;-)

Yes, it's a good thing usually!

>> I assume the api_version.patch is bad or needs to be updated. I simple
>> just commented out the "add api_version.patch" line in
>> backports/backports.txt and crossed my fingers the drivers I use still
>> worked -- which they did so all is well here (afaik). But, yeah it
>> does need a proper fix and I only recommend my cheap workaround with a
>> YMMV warning.
>
> thanks, this solved the first part of the problem. I can now do a make
> menuconfig, but the frontend modules I need cannot be selected,
> although the file
> /usr/src/media_build_experimental/linux/drivers/media/dvb/frontends/tda18212dd.c
> etc. do exist.
>
> I have also looked into the staging drivers and enabled drivers not
> supported by this kernel, but stil no luck.
>
> Did you have this problem as well?

No, the drivers I need were already there but I just checked my
menuconfig and I see:
Multimedia support -> Customize TV tuners -> NXP TDA18212 silicon tuner

Is that what you're looking for? If so, all you need, I think, is "DVB
for Linux" and "Customize analog and hybrid tuner modules to build" to
get the "Customize TV tuners" option.
