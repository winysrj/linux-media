Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35565 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab1BWRzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 12:55:17 -0500
Received: by eyx24 with SMTP id 24so1395322eyx.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 09:55:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298483143.1967.482.camel@ares>
References: <1298479744.2698.41.camel@acropora>
	<AANLkTimz43G5kEtjEFK9jxRg=hs5y_fwUdva7DbhcUoH@mail.gmail.com>
	<1298483143.1967.482.camel@ares>
Date: Wed, 23 Feb 2011 12:55:15 -0500
Message-ID: <AANLkTikPs==qcfiNm=DYYX8=uAo0kWAfxEwz_KgXDjBg@mail.gmail.com>
Subject: Re: PCTV nanoStick T2 in stock - Driver work?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Kerrison <steve@stevekerrison.com>
Cc: Nicolas Will <nico@youplala.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 23, 2011 at 12:45 PM, Steve Kerrison
<steve@stevekerrison.com> wrote:
> That would be me :)
>
> I have indeed, but don't have much to speak of seeing as when I started
> I'd never touched Linux kernel-space driver development.
>
> At the moment I have hardware and usb data from myself and others. I'm
> hoping to publish some code that at least initialises the device with
> the Sony demod code stub'd so that I and whoever wants to join me, can
> attempt to get the demod to spit out some transport streams :)
>
> Donations won't get sony to give me the datasheet, so none requested
> right now.
>
> I actually have a free weekend coming up (a rare occurrence) in which I
> hope to make some further progress...
>
> Or the short answer: No hardware/donations needed, but things might take
> a while!

I could probably get it bootstrapped but without a signal source it
would be very annoying (and I am not really willing to spend the three
grand to pick up a T2 generator).

That said, if you have any issues with the em2874 driver or questions
about the hardware layout (I probably have the schematic kicking
around here somewhere), let me know.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
