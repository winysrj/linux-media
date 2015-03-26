Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:32490 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbbCZVPy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 17:15:54 -0400
Date: Thu, 26 Mar 2015 22:10:00 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Florian Echtler <floe@butterbrot.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: input_polldev interval (was Re: [sur40] Debugging a race
 condition)?
Message-Id: <20150326221000.86b9c2181e699915ba91d009@ao2.it>
In-Reply-To: <5512C1E4.7060903@butterbrot.org>
References: <550FFFB2.9020400@butterbrot.org>
	<55103587.3080901@butterbrot.org>
	<43CDB224-5B10-4234-9054-7A7EC1EDA3BF@butterbrot.org>
	<DAFB1A9C-4AD7-4236-9945-6A456BEC7EDE@gmail.com>
	<5512C1E4.7060903@butterbrot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Mar 2015 15:10:44 +0100
Florian Echtler <floe@butterbrot.org> wrote:

> Hello Dmitry,
> 
> On 25.03.2015 14:23, Dmitry Torokhov wrote:
> > On March 24, 2015 11:52:54 PM PDT, Florian Echtler <floe@butterbrot.org> wrote:
> >> Currently, I'm setting the interval for input_polldev to 10 ms.
> >> However, with video data being retrieved at the same time, it's quite
> >> possible that one iteration of poll() will take longer than that. Could
> >> this ultimately be the reason? What happens if a new poll() call is
> >> scheduled before the previous one completes?
> > 
> > This can't happen as we schedule the next poll only after current one completes.
> > 
> Thanks - any other suggestions how to debug such a complete freeze? I
> have the following options enabled in my kernel config:
> 
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_EARLY_PRINTK_EFI=y
> 
> Unfortunately, even after the system is frozen for several minutes, I
> never get to see a panic message. Maybe it's there on the console
> somewhere, but the screen never switches away from X (and as mentioned
> earlier, I think this bug can only be triggered from within X). Network
> also freezes, so I don't think netconsole will help?
> 

PSTORE + some EFI/ACPI mechanism, maybe?
http://lwn.net/Articles/434821/

However I have never tried that myself and I don't know if all the
needed bits are in linux already.

JFTR, on some embedded system I worked on in the past the RAM content
was preserved across resets and, after a crash, we used to dump the RAM
from a second stage bootloader (i.e. before lading another linux
instance) and then scrape the dump to look for the kernel messages, but
AFAIK this is not going to be reliable —or even possible— on a more
complex system.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
