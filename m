Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58213 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0KJXNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 18:13:11 -0500
Received: by wyb36 with SMTP id 36so1248460wyb.19
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 15:13:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	<AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
	<20101110222418.6098a92a.ospite@studenti.unina.it>
	<AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
Date: Thu, 11 Nov 2010 00:13:09 +0100
Message-ID: <AANLkTim4hzoTg4t-jHFUCrpQwQ9Pj2sbJAH=iuawrK7E@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
From: Markus Rechberger <mrechberger@gmail.com>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 10, 2010 at 11:48 PM, Mohamed Ikbel Boulabiar
<boulabiar@gmail.com> wrote:
> On Wed, Nov 10, 2010 at 10:24 PM, Antonio Ospite
> <ospite@studenti.unina.it> wrote:
>> If there are arguments against a kernel driver I can't see them yet.
>
> +1
> This device is a webcam+(other things), it should be handled similar
> to other webcams already supported inside the kernel.
> If we make an exception now, we should make many special hacks for
> this only case to support it through the other libraries and layers of
> the system.
>
> If I want to use this device, I will add many userspace code to create
> the skeleton model and that need much computation. Kernel Module adds
> performance to my other code.

just some experience from our side, we do have fully working
video4linux1/2 drivers
in userspace, the only exception we have is a very thin layered
kernelmodule in order
to improve the datatransfer. BUT on the other side someone also has to think
about the bandwidth - this is the main consideration why we only use
this for low bandwidth
DVB. Is it worth to optimize any datatransfer that already requires >150 mbit
for embedded devices? (most of them cannot handle analog TV/high
bandwidth cameras due
that high bandwidth requirement).
There's definitely a point speed VS userfriendlyness.
Due high bandwidth need it's kinda obsolete to focus on high
optimizations for this, thus it's better
to focus on higher compatibility (this shall work with what you have
done now already).

I've seen alot projects failing due not having enough users
If it should mainly remain a hacker only project then a kernel module
should be fine.

Aside of that libusb has been ported to BSD and OSX as well, so it
widens the possibilities to other
operating systems. Also think about you update your work and it can
immediately be tested with all
systems without too much work, getting the right kernel sources,
kernel module etc.

But of course it's up to the developer :-) I just want to give some
ideas, since we already went through
with some projects that and I can tell it works.

BR,
Markus

>
> i
>
