Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54202 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0A2CZh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 21:25:37 -0500
Subject: Re: cx18 fix patches
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B60F901.20301@redhat.com>
References: <4B60F901.20301@redhat.com>
Content-Type: text/plain
Date: Thu, 28 Jan 2010 21:24:05 -0500
Message-Id: <1264731845.3095.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-01-28 at 00:40 -0200, Mauro Carvalho Chehab wrote:
> Hi Andy,
> 
> I've made two fix patches to solve the issues with cx18 compilation.
> My original intention were to send you an email for your ack.
> 
> Unfortunately, those got added at the wrong branch and went upstream.
> 
> That proofs that my scripts aren't reliable yet, and that I need
> an independent tree for such patches... I hope I have enough disk for all
> those trees...
> 
> As we can't rebase the -git tree without breaking the replicas,
> I'd like you to review the patches:
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=701ca4249401fe9705a66ad806e933f15cb42489
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=dd01705f6a6f732ca95d20959a90dd46482530df
> 
> If a committed patch is bad, the remaining solution is to write a patch reverting
> it, and generating some dirty at the git logs.
> 
> So, I hope both patches are ok...

Mauro,

By visual inspection, compilation test, and module loading test on a
kernel configured to be modular the patches are OK.

I did not test with them statically recompiled in the kernel, but by
inspection, they should be OK.


Devin,

I found interesting system interactions.  On my dual core x86_64 Fedora
12 machine loading an HVR-1600 cold (no firmware has been loaded yet),
the pulseaudio daemon opens up a CX23418 ALSA node almost immediately
after it appears and has these effects:

1. Pulseaudio tries to perform some sort of op that starts a capture on
the PCM stream before the APU and CPU firmware has finished loading.
This results in error messages in the log and probably an undesirable
driver state, if there was never any firmware loaded prior - such as at
power up.

2. Pulseaudio grabs the ALSA control node for the CX23418 and won't let
go.  If I kill the Pulseaudio process that has the node open, it just
respawns and grabs the control node again.  This prevents unloading the
cx18-alsa and cx18 module.

3. If Pulseaudio also keeps the PCM analog stream going, then TV image
settings are fixed to the values at the time Pulseaudio started the
stream.  I don't think it does, but I'm not sure yet.


My off the cuff ideas for fixes are:

1. Integrate cx18-alsa functions into the driver and no longer have it
as a module, to better coordinate firmware loading with the ALSA nodes.
(The modular architecture appears to have been a bad choice on my part.)

2. Add a module option to disable setting up the cx18-alsa device nodes.


I'll try to work on these this Friday and Saturday.

Regards,
Andy

