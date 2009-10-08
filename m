Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56408 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZJHOkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2009 10:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <200910081050.02215.dl9pf@gmx.de>
References: <f326ee1a0910030539pd5e00e2xb9f6de9975b64b9b@mail.gmail.com>
	 <f326ee1a0910030602w2518f66q2d6e185c473d5ad@mail.gmail.com>
	 <20091005095343.6b9afa65@pedra.chehab.org>
	 <200910081050.02215.dl9pf@gmx.de>
Date: Thu, 8 Oct 2009 10:39:27 -0400
Message-ID: <829197380910080739h75ddba76pe7d28c60f47dd235@mail.gmail.com>
Subject: Re: TM6010 driver and firmware
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Jan=2DSimon_M=F6ller?= <dl9pf@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?ISO-8859-1?Q?D=EAnis_Goes?= <denishark@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 8, 2009 at 4:50 AM, Jan-Simon Möller <dl9pf@gmx.de> wrote:
> Hi !
>
> Using the 3.7 firmware on HVR900H, I get up to this point:
>
> http://pastebin.ca/1603643
>
> [...]
> Error during zl10353_attach!
> tm6000: couldn't attach the frontend!
> xc2028 4-0061: destroying instance
> tm6000: Error -1 while registering
> tm6000: probe of 1-5.1:1.0 failed with error -1
> usbcore: registered new interface driver tm6000
> Original value=255
>
>
> Best,
> Jan-Simon

I keep seeing people trying out that driver, apparently thinking that
they just need to compile the correct tree in order for their product
to work.  For the record, this driver is currently *TOTALLY BROKEN*.
Unless you are a developer who is prepared to reverse engineer the
wire protocol and debug the driver, then you should not be wasting
your time compiling the tree in the hope that it will work for you.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
