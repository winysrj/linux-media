Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:27400 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbZJSUlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 16:41:23 -0400
Received: by gv-out-0910.google.com with SMTP id r4so510058gve.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 13:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
	 <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
Date: Mon, 19 Oct 2009 16:41:26 -0400
Message-ID: <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matteo Miraz <telegraph.road@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 19, 2009 at 4:28 PM, Matteo Miraz <telegraph.road@gmail.com> wrote:
> in the changeset 12886:ba22a9decfab was added a device called
> USB_PID_PINNACLE_PCTV73ESE, with id 0245
>
> However, the vendor is USB_VID_PINNACLE ( 0x2304 ) instead of 0x2013 (
> as reported for my usb dvb by lsusb )
>
> How can I fix it? How can I create a new vendor with the correct ID,
> and try if the module works? I'm new to the kernel development, so I'm
> afraid to make mistakes!

I've sent some email to the engineer I know over at PCTV Systems, and
will report back when I know more.  My suspicion is that they changed
the USB ID and we just need to update the driver to allow for either
USB ID to be associated with the device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
