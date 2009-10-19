Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63958 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbZJSV4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 17:56:21 -0400
Received: by fxm18 with SMTP id 18so5641950fxm.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 14:56:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
	 <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
	 <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
	 <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>
Date: Mon, 19 Oct 2009 17:56:25 -0400
Message-ID: <829197380910191456g5c53f37bh82ae6d7359ae5d2e@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matteo Miraz <telegraph.road@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 19, 2009 at 5:51 PM, Matteo Miraz <telegraph.road@gmail.com> wrote:
> Devin,
>
> thanks for the support.
>
> In the meanwhile, can I try to force the "new" vendor id?
> Since I have another pinnacle USB device, I was thinking about
> creating a new vendor (something like USB_VID_PINNACLE2).
> Is it enough to add it just after the USB_VID_PINNACLE definition and
> change the 57th line to
>
> { USB_DEVICE(USB_VID_PINNACLE2, USB_PID_PINNACLE_PCTV73ESE) },
>
> or should I do something else?

You can definitely give that a try and see if it starts working.  I
would suggest you call it USB_VID_PCTVSYSTEMS though, since that is
the new name.  If it works, send in a patch and we'll merge it.

My speculation is that they got a new USB ID because of the Hauppauge
acquisition, and they started shipping the existing products with the
new ID (thereby we would need both USB ids in the driver).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
