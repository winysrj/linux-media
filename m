Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44079 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GLHlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 03:41:05 -0400
Received: by yhmm54 with SMTP id m54so2411254yhm.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 00:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qjLom0KRV-X8LgngmtTGQoUYhoGpWYiExUVZ_0P1FBFqQ@mail.gmail.com>
References: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
	<CAA7C2qi5w+22LX+5r_8fKjxOOtGHGRQfFivC3GG0UD1LWE_Txg@mail.gmail.com>
	<CADR1r6is7yNaCLYmLuVB-QwJHjBaQJJAL-rnmn2ufE+Rt6_ezg@mail.gmail.com>
	<CAA7C2qjLom0KRV-X8LgngmtTGQoUYhoGpWYiExUVZ_0P1FBFqQ@mail.gmail.com>
Date: Thu, 12 Jul 2012 09:41:04 +0200
Message-ID: <CADR1r6ichNqYUQNjtJ33zsrjPYfGFhS4EVEvgFk=rSH3GbGbCg@mail.gmail.com>
Subject: Re: Make menuconfig doesn't work anymore
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/7/12 VDR User <user.vdr@gmail.com>:

> No, the drivers I need were already there but I just checked my
> menuconfig and I see:
> Multimedia support -> Customize TV tuners -> NXP TDA18212 silicon tuner
>
> Is that what you're looking for? If so, all you need, I think, is "DVB
> for Linux" and "Customize analog and hybrid tuner modules to build" to
> get the "Customize TV tuners" option.

Thanks for the input, but that's not the driver I need. I need the
ddbridge compatible (?) driver, NXP TDA18212 DD

[*] DVB/ATSC adapters
                    <M> Digital Devices bridge support
                    [*] Customse the frontend modules to build
                    Customize DVB Frontends →
                        STV 0367 (DD)
                        NXP TDA18212 silicon tuner (DD)
