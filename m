Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:33486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1BPRob (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 12:44:31 -0500
Message-ID: <4D5C0CDD.3060403@infradead.org>
Date: Wed, 16 Feb 2011 15:43:57 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: VDR User <user.vdr@gmail.com>
CC: Jarod Wilson <jarod@redhat.com>, Stephen Wilson <wilsons@start.ca>,
	Andy Walls <awalls@md.metrocast.net>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rc: do not enable remote controller adapters
 by default.
References: <m3aahwa4ib.fsf@fibrous.localdomain>	<1297862209.2086.18.camel@morgan.silverblock.net>	<m3ei78j9s7.fsf@fibrous.localdomain>	<20110216152026.GA17102@redhat.com> <AANLkTikNKpo6aDVQVWC3FEiKFLv4JGFr=xPTC8Tu_2Sx@mail.gmail.com>
In-Reply-To: <AANLkTikNKpo6aDVQVWC3FEiKFLv4JGFr=xPTC8Tu_2Sx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-02-2011 15:25, VDR User escreveu:
> On Wed, Feb 16, 2011 at 7:20 AM, Jarod Wilson <jarod@redhat.com> wrote:
>>> It is not a need.  I simply observed that after the IR_ to RC_ rename
>>> there was another set of drivers being built which I did not ask for.
>>
>> So disable them. I think most people would rather have this support
>> enabled so that remotes Just Work if a DTV card or stand-alone IR receiver
>> is plugged in without having to hunt back through Kconfig options to
>> figure out why it doesn't...
> 
> Unfortunately _ALL_ the usb DVB devices are unavailable if you do not
> enable IR_CORE "Infrared remote controller adapters" in v4l.  This is
> a little annoying as the usb device I use doesn't even have IR
> capabilities.  It doesn't seem like something that should be forced on
> the user -- enable IR or you can't even compile the driver you need,
> which doesn't even use IR.
> 
> It's not the end of the world but I don't particularly appreciate the
> enable-everything approach.  It would be nice to at least have the
> option to trim the fat if you want.. Isn't that partially what Linux
> is supposed to be about in the first place?

Unfortunately, the way almost all drivers/media/[video|dvb] was made,
the IR (and input support on webcams) are tighted to the driver.

It would be possible to change it (and it is not that hard), but it requires 
people with enough time and skills to go into each driver that can support IR, 
split the IR code into a separate module and be sure that the driver will 
compile and work with or without IR support.

Cheers,
Mauro
