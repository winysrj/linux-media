Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54582 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2GJXBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 19:01:20 -0400
Received: by gglu4 with SMTP id u4so630639ggl.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 16:01:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
References: <CADR1r6gQD-yQhzhfF0PUJq06Xw9Oq7YJHtRVWPXEEmwtR36k+Q@mail.gmail.com>
Date: Tue, 10 Jul 2012 16:01:18 -0700
Message-ID: <CAA7C2qi5w+22LX+5r_8fKjxOOtGHGRQfFivC3GG0UD1LWE_Txg@mail.gmail.com>
Subject: Re: Make menuconfig doesn't work anymore
From: VDR User <user.vdr@gmail.com>
To: Martin Herrman <martin.herrman@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 10, 2012 at 2:16 PM, Martin Herrman
<martin.herrman@gmail.com> wrote:
> make[2]: Entering directory `/usr/src/media_build_experimental/linux'
> Applying patches for kernel 3.5.0-rc6
> patch -s -f -N -p1 -i ../backports/api_version.patch
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/media/video/v4l2-ioctl.c.rej
> make[2]: *** [apply_patches] Error 1
> make[2]: Leaving directory `/usr/src/media_build_experimental/linux'
> make[1]: *** [Kconfig] Error 2
> make[1]: Leaving directory `/usr/src/media_build_experimental/v4l'
> make: *** [menuconfig] Error 2
>
> Make menuconfig *does* work when configuring a new kernel. I have also
> tried with kernel 3.2.22 and 3.4, but no succes either.

Actually I got the exact same error when compiling a new 3.4.4 kernel.

> Any ideas what is going wrong?

I assume the api_version.patch is bad or needs to be updated. I simple
just commented out the "add api_version.patch" line in
backports/backports.txt and crossed my fingers the drivers I use still
worked -- which they did so all is well here (afaik). But, yeah it
does need a proper fix and I only recommend my cheap workaround with a
YMMV warning.
