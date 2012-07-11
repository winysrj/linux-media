Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34804 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2GKVa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 17:30:58 -0400
Received: by ghrr11 with SMTP id r11so1757093ghr.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 14:30:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qi5w+22LX+5r_8fKjxOOtGHGRQfFivC3GG0UD1LWE_Txg@mail.gmail.com>
References: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
	<CAA7C2qi5w+22LX+5r_8fKjxOOtGHGRQfFivC3GG0UD1LWE_Txg@mail.gmail.com>
Date: Wed, 11 Jul 2012 23:30:57 +0200
Message-ID: <CADR1r6is7yNaCLYmLuVB-QwJHjBaQJJAL-rnmn2ufE+Rt6_ezg@mail.gmail.com>
Subject: Re: Make menuconfig doesn't work anymore
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/7/11 VDR User <user.vdr@gmail.com>:

> Actually I got the exact same error when compiling a new 3.4.4 kernel.

It always feels good to know that you're not alone ;-)

> I assume the api_version.patch is bad or needs to be updated. I simple
> just commented out the "add api_version.patch" line in
> backports/backports.txt and crossed my fingers the drivers I use still
> worked -- which they did so all is well here (afaik). But, yeah it
> does need a proper fix and I only recommend my cheap workaround with a
> YMMV warning.

thanks, this solved the first part of the problem. I can now do a make
menuconfig, but the frontend modules I need cannot be selected,
although the file
/usr/src/media_build_experimental/linux/drivers/media/dvb/frontends/tda18212dd.c
etc. do exist.

I have also looked into the staging drivers and enabled drivers not
supported by this kernel, but stil no luck.

Did you have this problem as well?
