Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab0A2SlD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 13:41:03 -0500
Message-ID: <4B632BB8.3000904@redhat.com>
Date: Fri, 29 Jan 2010 16:40:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Walls <awalls@radix.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx18 fix patches
References: <4B60F901.20301@redhat.com>	 <1264731845.3095.16.camel@palomino.walls.org> <829197381001290922p69a68ce5k3f5192f427f4658a@mail.gmail.com>
In-Reply-To: <829197381001290922p69a68ce5k3f5192f427f4658a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> Hi Andy,
> 
> On Thu, Jan 28, 2010 at 9:24 PM, Andy Walls <awalls@radix.net> wrote:
>> Devin,
>>
>> I found interesting system interactions.  On my dual core x86_64 Fedora
>> 12 machine loading an HVR-1600 cold (no firmware has been loaded yet),
>> the pulseaudio daemon opens up a CX23418 ALSA node almost immediately
>> after it appears and has these effects:
>>
>> 1. Pulseaudio tries to perform some sort of op that starts a capture on
>> the PCM stream before the APU and CPU firmware has finished loading.
>> This results in error messages in the log and probably an undesirable
>> driver state, if there was never any firmware loaded prior - such as at
>> power up.
> 
> I'm a little surprised by that, since the cx18-alsa module is only
> initialized after the rest of the cx18 driver is loaded.

This is a problem that may affect all drivers: just after registering a
device, udev (and other userspace tools) may try to use it. I doubt that making
cx18-alsa part of cx18 would fix this issue. Also, it tends to became worse:
as the number of CPU cores are increasing, the probability for reaching such race
condition increases.

The proper solution is to lock the driver while it is not completely initialized,
or to delay the alsa registration to happen after having all firmware loaded.

>> 2. Pulseaudio grabs the ALSA control node for the CX23418 and won't let
>> go.  If I kill the Pulseaudio process that has the node open, it just
>> respawns and grabs the control node again.  This prevents unloading the
>> cx18-alsa and cx18 module.
> 
> As far as I know, this is one of those dumb Pulseaudio things.
> Doesn't it do this with all PCI cards that provide ALSA?

All cards that provide alsa support have this trouble, even without pulseaudio.
kmixer does the same thing: when a new mixer is detected, it holds the mixer opened,
preventing module unloading.

>> 3. If Pulseaudio also keeps the PCM analog stream going, then TV image
>> settings are fixed to the values at the time Pulseaudio started the
>> stream.  I don't think it does, but I'm not sure yet.
> 
> I know that Pulseaudio binds to the device, but as far as I know it
> does not actually open the PCM device for streaming.

Probably, it holds open just the mixer.

>> My off the cuff ideas for fixes are:
>>
>> 1. Integrate cx18-alsa functions into the driver and no longer have it
>> as a module, to better coordinate firmware loading with the ALSA nodes.
>> (The modular architecture appears to have been a bad choice on my part.)
> 
> I'm not against merging the two into a single module, although it's
> not clear to me that it will help with the issues you are seeing.

I doubt it would solve. IMO, having it modular is good, since you may not
need cx18 alsa on all devices.
 
-- 

Cheers,
Mauro
