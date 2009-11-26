Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40387 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZKZFiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 00:38:12 -0500
Date: Wed, 25 Nov 2009 21:38:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: IR raw input is not sutable for input system
Message-ID: <20091126053813.GF23244@core.coreip.homeip.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <1259105571.28219.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259105571.28219.20.camel@maxim-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 25, 2009 at 01:32:51AM +0200, Maxim Levitsky wrote:
> Folks, I really want to tell everyone that doing all the mapping from
> raw codes to keypresses in kernel is wrong.

Why is this wrong? Doing simple translation is easy and it does not
require having all the tables for all possible remotes in the kernel. We
have appropriate interfaces to load keymaps at runtime (for the devices
whose drivers support this feature).

> This idea keeps showing up, because many users think that remotes send
> some universal codes that you can just 'parse' and feed back to input
> system.
>

Well, they send some data that can be parsed and thus fed to whatever we
want to feed it.

 
> Its not the case.
> There are many protocols, I know that by experimenting with my universal
> remote. There are many receivers, and all have different accuracy.
> Most remotes aren't designed to be used with PC, thus user has to invent
> mapping between buttons and actions.
> Its is not possible to identify remotes accurately, many remotes send
> just a 8 bit integer that specifies the 'model' thus many remotes can
> share it.
> Some don't send anything.
> 
> There are some weird remotes that send whole packet of data will all
> kind of states.
> 
> Think about it, video capture device is also an input device, a scanner
> is an input device too, sound card can work as input device too.

You are stretching. There are no button presses involved with sound (not
unless you go all the way down to keys on a piano ;) )

> But we aren't doing any parsing, even we don't support deflating of many
> proprietary and standard video/image encoding formats.
> We let userspace do it.
> 
> Kernel job is to take the information from device and present it to
> userspace using uniform format, that is kernel does 1:1 translating, but
> doesn't parse the data.

Should we return to the times where we had raw PS/2 data streams sent to
userspace, separately from HID and other formats? I don't think it is a
good idea.

> Uniform format doesn't mean kernel always converts to one format, its
> not like sound card always recording in 32 bit 96000 Khz format, even if
> underlying device doesn't support that.
> 
> 
> So, device that decode IR code are presented to userspace as pure input
> devices. I agree that creating fake raw codes from that is bad.
> 
> But devices that send raw data pass it to lirc.
> lirc is well capable to decode it, and its not hard to add
> auto-detection based on existing configuration drivers, so IR devices
> will work with absolutely no configuration.
> All you will have to do is ensure that lirc is installed.
> Then udev can even start it automatically.
> Then as soon as you press a key, lirc can scan its config database, and
> find a config file to use. combine that with a GUI for unknown remotes
> and you get an awesome usability.
> 

Why can't the same be done in kernalspace though?

> Also don't forget that there are pure userspace drivers. They won't have
> access to in-kernel decoder so they will still have to parse protocols,
> so will have code duplication, and will still need lirc thus.
> 
> 
> So why to burden the kernel with protocols, etc..

We do burden it with TCP, shall we take it out?

-- 
Dmitry
