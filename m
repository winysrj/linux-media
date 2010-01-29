Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34873 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0A2RWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 12:22:25 -0500
Received: by bwz27 with SMTP id 27so1641632bwz.21
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 09:22:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264731845.3095.16.camel@palomino.walls.org>
References: <4B60F901.20301@redhat.com>
	 <1264731845.3095.16.camel@palomino.walls.org>
Date: Fri, 29 Jan 2010 12:22:23 -0500
Message-ID: <829197381001290922p69a68ce5k3f5192f427f4658a@mail.gmail.com>
Subject: Re: cx18 fix patches
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Thu, Jan 28, 2010 at 9:24 PM, Andy Walls <awalls@radix.net> wrote:
> Devin,
>
> I found interesting system interactions.  On my dual core x86_64 Fedora
> 12 machine loading an HVR-1600 cold (no firmware has been loaded yet),
> the pulseaudio daemon opens up a CX23418 ALSA node almost immediately
> after it appears and has these effects:
>
> 1. Pulseaudio tries to perform some sort of op that starts a capture on
> the PCM stream before the APU and CPU firmware has finished loading.
> This results in error messages in the log and probably an undesirable
> driver state, if there was never any firmware loaded prior - such as at
> power up.

I'm a little surprised by that, since the cx18-alsa module is only
initialized after the rest of the cx18 driver is loaded.

> 2. Pulseaudio grabs the ALSA control node for the CX23418 and won't let
> go.  If I kill the Pulseaudio process that has the node open, it just
> respawns and grabs the control node again.  This prevents unloading the
> cx18-alsa and cx18 module.

As far as I know, this is one of those dumb Pulseaudio things.
Doesn't it do this with all PCI cards that provide ALSA?

> 3. If Pulseaudio also keeps the PCM analog stream going, then TV image
> settings are fixed to the values at the time Pulseaudio started the
> stream.  I don't think it does, but I'm not sure yet.

I know that Pulseaudio binds to the device, but as far as I know it
does not actually open the PCM device for streaming.

> My off the cuff ideas for fixes are:
>
> 1. Integrate cx18-alsa functions into the driver and no longer have it
> as a module, to better coordinate firmware loading with the ALSA nodes.
> (The modular architecture appears to have been a bad choice on my part.)

I'm not against merging the two into a single module, although it's
not clear to me that it will help with the issues you are seeing.

> 2. Add a module option to disable setting up the cx18-alsa device nodes.

I can see some value in such an option in general for debugging
purposes, although I don't think it provides a whole lot of value for
regular users who would not normally have it enabled.

>
> I'll try to work on these this Friday and Saturday.

I will be out of town this weekend, but if you send me email I will
try to respond as promptly as possible.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
