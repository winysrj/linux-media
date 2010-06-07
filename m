Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33910 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0FGNtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 09:49:09 -0400
Received: by wwe15 with SMTP id 15so407609wwe.19
        for <linux-media@vger.kernel.org>; Mon, 07 Jun 2010 06:49:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C0CF124.4010103@redhat.com>
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>
	<4C0CF124.4010103@redhat.com>
Date: Mon, 7 Jun 2010 09:49:07 -0400
Message-ID: <AANLkTinisZ5DtH1Izn6WZS8isrF_G3oFZuppoHuwhlUj@mail.gmail.com>
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: vdr@helmutauer.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 7, 2010 at 9:16 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 07-06-2010 08:27, vdr@helmutauer.de escreveu:
...
>> Another problem (after fixing the compile issues) is the IR Part of v4l-dvb which includes an Imon module.
>> This module doesn't provide any lirc devices, so how can this oe be used as an IR device ?
>
> You don't need lirc to use imon, since it now provides a standard input/event interface. So, the driver
> currently can be used with lirc event interface, or alone.

See http://wilsonet.com/jarod/imon_stuff/imon-devinput-lirc/ for the
config I use w/my own imon hardware.

>> Til now I am using lirc_imon which fit all my needs.
>
> Lirc-dev patches are currently being discussed. There are just a few adjustments on it, in order to get it
> finally merged. The kernel-userspace interface will likely need a few changes, so you'll likely need to update
> lirc after the merge. Better to follow the IR threads at linux-media ML, in order to be in-tune with the changes.

I've considered adding lirc_dev support back to the imon driver when
we get it merged, but it really doesn't make a whole lot of sense,
given that the imon devices do all IR decoding in hardware. As long as
the keymap is complete, there's no benefit to wiring up lirc_dev vs.
just using lircd's devinput access method for imon devices.


-- 
Jarod Wilson
jarod@wilsonet.com
