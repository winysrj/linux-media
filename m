Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:55549 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0IHVW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 17:22:59 -0400
Date: Wed, 8 Sep 2010 23:22:55 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: Brian Rogers <brian@xyzw.org>, jarod@wilsonet.com,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] ir-core: centralize sysfs raw decoder
 enabling/disabling
Message-ID: <20100908212255.GC13938@hardeman.nu>
References: <20100613202718.6044.29599.stgit@localhost.localdomain>
 <20100613202930.6044.97940.stgit@localhost.localdomain>
 <4C8797D3.1060606@xyzw.org>
 <20100908141613.GB22323@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100908141613.GB22323@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 10:16:13AM -0400, Jarod Wilson wrote:
> On Wed, Sep 08, 2010 at 07:04:03AM -0700, Brian Rogers wrote:
> > ir_dev->raw is also null. If I check these pointers before using
> > them, and bail out if both are null, then I get a working lircd, but
> > of course the file /sys/devices/virtual/rc/rc0/protocols no longer
> > does anything. On 2.6.35.4, the system never creates the
> > /sys/class/rc/rc0/current_protocol file. Is it the case that the
> > 'protocols' file should never appear, because my card can't support
> > this feature?
> 
> Hm... So protocols is indeed intended for hardware that handles raw IR, as
> its a list of raw IR decoders available/enabled/disabled for the receiver.
> But some devices that do onboard decoding and deal with scancodes still
> need to support changing protocols, as they can be told "decode rc5" or
> "decode nec", etc... My memory is currently foggy on how it was exactly
> that it was supposed to be donee though. :) (Yet another reason I really
> need to poke at the imon driver code again).

This, and a raft of similar bugreports was one of the reasons I wrote 
the rc_dev patch (which gets rid of ir_dev->props, the source of many 
oopses by now).

Hardware decoders should work with the same sysfs file, the driver 
should set ir_dev->props->change_protocol (current) or 
rc->change_protocol (future) and it'll get notified when userspace 
interacts with the sysfs file and the hardware can then react 
accordingly. So the answer is yes - all hardware should have the file.

-- 
David Härdeman
