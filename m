Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:35018 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab0BHQtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 11:49:31 -0500
Received: by fg-out-1718.google.com with SMTP id e21so45569fga.1
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 08:49:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002081656.41640.markus.moll@esat.kuleuven.be>
References: <201002081656.41640.markus.moll@esat.kuleuven.be>
Date: Mon, 8 Feb 2010 17:49:29 +0100
Message-ID: <d9def9db1002080849u123ae2d2r24f31276d1d46ff@mail.gmail.com>
Subject: Re: Terratec H5 / Micronas
From: Markus Rechberger <mrechberger@gmail.com>
To: Markus Moll <markus.moll@esat.kuleuven.be>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 8, 2010 at 4:56 PM, Markus Moll
<markus.moll@esat.kuleuven.be> wrote:
> Hi
>
> I have just bought one of these terratec usb sticks (without looking at the
> list of supported devices first, my fault, I know) and I guess I'm unable to
> return it. Before I give it away for free or sell it at a much lower price, I
> wanted to ask a few things. Let me recapitulate the story as I understood it.
> Devin Heitmueller once worked on a driver implementation using official
> Micronas data-sheets and their reference implementation. The Micronas legal
> department then denied publication in a very late stage. Meanwhile, Markus
> Rechberger wrote his own user-space closed-source driver, but has now stopped
> distributing that and instead founded his own company Sundtek. Furthermore,
> parts of Micronas have been bought by Trident Microsystems.
>
> I hope I'm correct up to here. I also saw an estimate of the amount of work
> required to write a reverse engineered driver, it ranged around 50hrs.

To write a driver with good quality it takes alot more than just 50
hours, it took us
around 1 year to have a certain quality now.
We now support Linux, FreeBSD and MacOSX with the same driver as well as
embedded ARM devices with bugged compilers.
Just having it work will result in alot signal problems with some
cable providers.
The Micronas drivers are probably the most complex drivers this entire
project has ever
seen.

> My question is, did the Micronas legal department intervene because the linux
> driver built on top of their reference implementation and they weren't willing
> to gpl that, or did they also oppose on using the data-sheets? If it was only
> the reference driver, wouldn't it be whorthwhile trying to again get the data
> sheets and build a driver based solely on these? I couldn't find any post that
> would clarify this.

it's an official statement, that they do not want to have their driver
opensourced.

>
> I would be willing to invest some time, play with the device and see if I can
> improve the situation, probably even if I really had to reverse engineer.
> However, I'm in no way an expert in v4l driver writing, so I don't know where
> this will lead to or if I'm going to brick the device on the very first
> occasion ;-) (btw: how easy is that, generally?)
>

it's the most difficult device.

> I know that the general advice is to dump these devices and buy something
> else, but as I said I'll have this hardware lying around anyway. So I'd like
> to know if I missed something, if there is any prior work (unaffected by the
> legal problems), or if I'm bound to fail because the task is just too big.
>

In case you're looking for something that works with Linux better
return it asap, or sell it

Best Regards,
Markus
