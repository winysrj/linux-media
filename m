Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:35536 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0AYH6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 02:58:20 -0500
Received: by fxm7 with SMTP id 7so1714770fxm.28
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 23:58:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100125021118.GA8756@i.jbohm.dk>
References: <20100125021118.GA8756@i.jbohm.dk>
Date: Mon, 25 Jan 2010 08:58:17 +0100
Message-ID: <d9def9db1001242358v36abe530v8ef33efc8da4a5c4@mail.gmail.com>
Subject: Re: More details on Hauppauge 930C
From: Markus Rechberger <mrechberger@gmail.com>
To: Jakob Bohm <saotowjokkoujuxlot@jbohm.dk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2010 at 3:11 AM, Jakob Bohm <saotowjokkoujuxlot@jbohm.dk> wrote:
> So far all the posts I have been able to find about this device on
> wiki.linuxtv.org and in the archives of the linux-tv, linux-dvb
> and linux-media mailing lists have been unconfirmed guesswork of
> the form "I think", "Isn't that" etc.  I actually have this device
> (it was the first DVB-C device to hit the market in Denmark after
> our biggest cable TV provider offered unencrypted access to their
> basic packages in DVB-C format for anyone with a paid physical
> connection to their network).
>
> Ok, first the bad news:
>
> When looking inside the device I see two Micronas chips,
> thus *apparantly* confirming the rumors about this device being
> based on the Micronas chips for which Micronas lawyers blocked
> release of an already written FOSS driver back in 2008.
> But to be sure these are the "banned" chips, someone in the know
> should look closely at the photos I have taken of the actual chips
> in the 930C.
>
> Second bad news: When asking Hauppauge all the response I got was
> "You need to post on the www.linuxtv.org site, that's where the
> devlopers are" (and thats all the e-mail said, including the
> spelling mistake in "devlopers").
>
> Now the observable facts:
>
> 1. Product name is Hauppauge 930C, model 16009 LF Rev B1F0, USB ID
> 2040:1605 .  Retail package includes device, a short video cable
> adapter for the minisocket on the device, an IR remote, a small
> table-top retractable antenna and a CD with MS-Windows software
> and drivers.
>
> 2. Device is a combined DVB-C/DVB-T receiver with additional
> inputs for raw analog video as S-VHS or composite (either with
> separate analog stereo sound).  I do not recall if the device has
> support for analog TV reception too.
>
> 3. Device is not yet listed in the device tables at linuxtv.org
> with any status (not even "doesn't work").
>
> 4. Device is a large (= wide body) USB stick, with a standard size
> coaxial antenna input at the back, two indicator LEDs and an IR
> receiver on the right and a proprietary mini-socket for analog
> video/audio input on the left.  The underside has a sticker with
> bar code, model number and MAC address.
>
> 4. I have taken close up photos of the device with and without the
> covers off.  The inside of the device holds two circuit boards
> with some components hidden between them, I have taken photos
> or the outward facing sides of the two boards.
>
> I have posted the photos at these URLs:
>
> <http://www.jbohm.org/930C/frontAndCable.jpg>
> <http://www.jbohm.org/930C/back.jpg>
> <http://www.jbohm.org/930C/boardFront.jpg>
> <http://www.jbohm.org/930C/boardBack.jpg>
>
> (Please copy the photos to your own archives, these are temporary
> URLs).
>
> And finally something worth investigating:
>
> Some time has passed since Micronas Lawyers blocked the release of
> the FOSS driver for their chipset, maybe they have cooled down now
> and someone from the linuxtv project could approach Hauppauge or
> Pinacle (who seem FOSS-friendly) to put business pressure on their
> chipset supplier Micronas to reverse their decision and permit the
> release of the FOSS driver that was previously developped in
> cooperation between Pinacle, Micronas techs and Devin Heitmueller
> (one of the linuxtv developers).
>
>

It hasn't been in Micronas hands for a long time anymore. Micronas had
financial trouble
and sold this devision to Trident.
So far we (Sundtek) found an agreement to publish their propriertary
work under closed source but with support for
opensource applications in Linux in userspace not affecting the kernel.

Best Regards,
Markus
