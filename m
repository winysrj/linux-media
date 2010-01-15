Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60232 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab0AOXIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 18:08:48 -0500
Received: by fxm25 with SMTP id 25so675673fxm.21
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 15:08:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001160000.31965@orion.escape-edv.de>
References: <4B4F39BB.2060605@motama.com> <4B4F3FD5.5000603@motama.com>
	 <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
	 <201001160000.31965@orion.escape-edv.de>
Date: Sat, 16 Jan 2010 03:08:47 +0400
Message-ID: <1a297b361001151508h42d3a4c9wdbc09b6199319c2a@mail.gmail.com>
Subject: Re: Order of dvb devices
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andreas Besse <besse@motama.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 16, 2010 at 3:00 AM, Oliver Endriss <o.endriss@gmx.de> wrote:
> Devin Heitmueller wrote:
>> On Thu, Jan 14, 2010 at 11:01 AM, Andreas Besse <besse@motama.com> wrote:
>> > yes if there are different drivers I already observed the behaviour that
>> > the ordering gets flipped after reboot.
>> >
>> > But if I assume, that there is only *one* driver that is loaded (e.g.
>> > budget_av) for all dvb cards in the system, how is the ordering of these
>> > devices determined? How does the driver "search" for available dvb cards?
>
> The driver does not 'search' for a card. The driver registers the ids of
> all supported cards with the pci subsystem of the kernel.
>
> When the pci subsystem detects a new card, it calls the 'probe' routine
> of the driver (for example saa7146_init_one for saa7146-based cards).
> So the ordering is determined by the pci subsystem.
>
>> I believe your assumption is incorrect.  I believe the enumeration
>> order is not deterministic even for multiple instances of the same
>> driver.  It is not uncommon to hear mythtv users complain that "I have
>> two PVR-150 cards installed in my PC and the order sometimes get
>> reversed on reboot".
>
> Afaik the indeterministic behaviour is caused by udev, not by the
> kernel. We never had these problems before udev was introduced.


True, the ordering is not exactly the same everytime. One will need to
provide PCI Bus related info also to a practical udev configuration to
get things sorted out in a sane way, rather than anything else.



Regards,
Manu
