Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34519 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345AbcCCU44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 15:56:56 -0500
Date: Thu, 3 Mar 2016 17:56:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] media: rc: nuvoton: support
 reading / writing wakeup sequence via sysfs
Message-ID: <20160303175650.33edd31c@recife.lan>
In-Reply-To: <56D88EFB.1090105@gmail.com>
References: <E1abRXi-00035h-0E@www.linuxtv.org>
	<56D87FE9.4000408@gmail.com>
	<20160303155200.43d4c5e7@recife.lan>
	<56D88EFB.1090105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 20:22:35 +0100
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> Am 03.03.2016 um 19:52 schrieb Mauro Carvalho Chehab:
> > Em Thu, 03 Mar 2016 19:18:17 +0100
> > Heiner Kallweit <hkallweit1@gmail.com> escreveu:
> >   
> >> Am 03.03.2016 um 12:28 schrieb Mauro Carvalho Chehab:  
> >>> This is an automatic generated email to let you know that the following patch were queued at the 
> >>> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> >>>
> >>> Subject: [media] media: rc: nuvoton: support reading / writing wakeup sequence via sysfs
> >>> Author:  Heiner Kallweit <hkallweit1@gmail.com>
> >>> Date:    Mon Feb 8 17:25:59 2016 -0200
> >>>
> >>> This patch adds a binary attribute /sys/class/rc/rc?/wakeup_data which
> >>> allows to read / write the wakeup sequence.
> >>>     
> >> When working on another module I was reminded not to forget updating Documentation/ABI.
> >> I think the same applies here. This patch introduces a new sysfs attribute that should
> >> be documented. I'll submit a patch for adding Documentation/ABI/testing/sysfs-class-rc-nuvoton  
> > 
> > Good point.
> > 
> > Another thing: wouldn't be better to use a text format? This would make
> > esier to import from LIRC's irrecord format:
> > 
> >       begin raw_codes
> > 
> >           name power
> >               850     900    1750    1800     850     900
> >               850     900    1750     900     850    1800
> >               850     900     850     900     850     900
> >              1750    1800     800
> > 
> >       end raw_codes
> > 
> > Regards,
> > Mauro
> >   
> Most likely this is possible, but it would mean that we need a parser / generator
> for this text format in the driver / kernel code. And I have my doubts that parsing
> an application-specific file format (that could change anytime) in kernel code is
> a good thing. Converting this format to raw binary data is better off in userspace
> I think. What's your opinion?

I'm not telling that it should parse irrecord format, but, instead, to
accept an ascii sequence of timings. The problem with raw binary data
is that the format varies on big endian and long endian architectures,
with doesn't seem to be nice to an API, as a data sequence recorded
on one machine may not work on some other one.

> 
> >>
> >> Rgds, Heiner
> >>  
> >>> In combination with the core extension for exposing the most recent raw
> >>> packet this allows to easily define and set a wakeup sequence.
> >>>
> >>> At least on my Zotac CI321 the BIOS resets the wakeup sequence at each boot
> >>> to a factory default. Therefore I use a udev rule
> >>> SUBSYSTEM=="rc", DRIVERS=="nuvoton-cir", ACTION=="add", RUN+="<script>"
> >>> with the script basically doing
> >>> cat <stored wakeup sequence> >/sys${DEVPATH}/wakeup_data
> >>>
> >>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>>
> >>>  drivers/media/rc/nuvoton-cir.c | 85 ++++++++++++++++++++++++++++++++++++++++++
> >>>  drivers/media/rc/nuvoton-cir.h |  3 ++
> >>>  2 files changed, 88 insertions(+)
> >>>
> >>> ---
> >>>
> >>> [...]  
> 


-- 
Thanks,
Mauro
