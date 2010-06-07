Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:59666 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0FGVY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 17:24:56 -0400
Message-ID: <4C0D63AF.7090203@helmutauer.de>
Date: Mon, 07 Jun 2010 23:25:03 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>	<4C0CF124.4010103@redhat.com> <AANLkTinisZ5DtH1Izn6WZS8isrF_G3oFZuppoHuwhlUj@mail.gmail.com>
In-Reply-To: <AANLkTinisZ5DtH1Izn6WZS8isrF_G3oFZuppoHuwhlUj@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
> ...
>>> Another problem (after fixing the compile issues) is the IR Part of v4l-dvb which includes an Imon module.
>>> This module doesn't provide any lirc devices, so how can this oe be used as an IR device ?
>>
>> You don't need lirc to use imon, since it now provides a standard input/event interface. So, the driver
>> currently can be used with lirc event interface, or alone.
> 
> See http://wilsonet.com/jarod/imon_stuff/imon-devinput-lirc/ for the
> config I use w/my own imon hardware.
> 
Tanks for the hint !

>>> Til now I am using lirc_imon which fit all my needs.
>>
>> Lirc-dev patches are currently being discussed. There are just a few adjustments on it, in order to get it
>> finally merged. The kernel-userspace interface will likely need a few changes, so you'll likely need to update
>> lirc after the merge. Better to follow the IR threads at linux-media ML, in order to be in-tune with the changes.
> 
> I've considered adding lirc_dev support back to the imon driver when
> we get it merged, but it really doesn't make a whole lot of sense,
> given that the imon devices do all IR decoding in hardware. As long as
> the keymap is complete, there's no benefit to wiring up lirc_dev vs.
> just using lircd's devinput access method for imon devices.
> 
You're right, also inputlircd can do the job.

Is your imon driver fully compatible with the lirc_imon in the display part ?

It would be very helpful to add a parameter for disabling the IR Part, I have many users which
are using only the display part.

-- 
Helmut Auer, helmut@helmutauer.de
