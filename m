Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:55865 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZJSTSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 15:18:35 -0400
Received: by qyk32 with SMTP id 32so3364777qyk.4
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 12:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
Date: Mon, 19 Oct 2009 15:18:39 -0400
Message-ID: <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matteo Miraz <telegraph.road@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 18, 2009 at 5:41 PM, Matteo Miraz <telegraph.road@gmail.com> wrote:
> Hi,
>
> I've just bought a new DVB USB card, but it seems that the current
> version of linux tv does not recognize it at all.
> I tried both the ubuntu kernel (9.04 and 9.10) and the latest drivers
> downloaded with mercurial from http://linuxtv.org/hg/v4l-dvb
>
> The card is a PCTV nanoStick Solo, and chip seems to be a "73E SE".
> Looking at the lsusb output (reported below), it seems that it is not
> a pinnacle, but a new brand (the Vendor ID is different from the
> pinnacle's one).
>
> Can you help me?
>
> Thanks,
> Matteo

As far as I can see, support for the PCTV 73E-SE (usb id 2013:0245)
was introduced in hg rev 12886 on September 2nd.  This would have been
too late to make it for the Karmic release.

You can get the device working in your environment by installing the
latest v4l-dvb tree.  You can find directions here:

http://linuxtv.org/repo

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
