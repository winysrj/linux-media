Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52901 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2GOH3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 03:29:38 -0400
Received: by obbuo13 with SMTP id uo13so7584688obb.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jul 2012 00:29:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADR1r6ichNqYUQNjtJ33zsrjPYfGFhS4EVEvgFk=rSH3GbGbCg@mail.gmail.com>
References: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
	<CAA7C2qi5w+22LX+5r_8fKjxOOtGHGRQfFivC3GG0UD1LWE_Txg@mail.gmail.com>
	<CADR1r6is7yNaCLYmLuVB-QwJHjBaQJJAL-rnmn2ufE+Rt6_ezg@mail.gmail.com>
	<CAA7C2qjLom0KRV-X8LgngmtTGQoUYhoGpWYiExUVZ_0P1FBFqQ@mail.gmail.com>
	<CADR1r6ichNqYUQNjtJ33zsrjPYfGFhS4EVEvgFk=rSH3GbGbCg@mail.gmail.com>
Date: Sun, 15 Jul 2012 09:29:37 +0200
Message-ID: <CADR1r6i1axOp1v7SbTrNY9wprCpnB3mNiUj0VAiWgX5SNLvw2A@mail.gmail.com>
Subject: Re: Make menuconfig doesn't work anymore
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/7/12 Martin Herrman <martin.herrman@gmail.com>:
> 2012/7/12 VDR User <user.vdr@gmail.com>:
>
>> No, the drivers I need were already there but I just checked my
>> menuconfig and I see:
>> Multimedia support -> Customize TV tuners -> NXP TDA18212 silicon tuner
>>
>> Is that what you're looking for? If so, all you need, I think, is "DVB
>> for Linux" and "Customize analog and hybrid tuner modules to build" to
>> get the "Customize TV tuners" option.
>
> Thanks for the input, but that's not the driver I need. I need the
> ddbridge compatible (?) driver, NXP TDA18212 DD
>
> [*] DVB/ATSC adapters
>                     <M> Digital Devices bridge support
>                     [*] Customse the frontend modules to build
>                     Customize DVB Frontends →
>                         STV 0367 (DD)
>                         NXP TDA18212 silicon tuner (DD)

Problem solved: although I cannot select the drivers, they are build
during 'make'. Done a make install and reboot and card is detected :-)
