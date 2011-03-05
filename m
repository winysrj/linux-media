Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56793 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1CEPuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 10:50:15 -0500
Received: by bwz15 with SMTP id 15so2825711bwz.19
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 07:50:13 -0800 (PST)
Date: Sat, 5 Mar 2011 16:43:09 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Helmut Auer <vdr@helmutauer.de>, linux-media@vger.kernel.org,
	abraham.manu@gmail.com
Subject: Re: Patches an media build tree
Message-ID: <20110305164309.1796daad@grobi>
In-Reply-To: <4D333AF2.8070806@redhat.com>
References: <4D31A520.2050703@helmutauer.de>
	<4D333AF2.8070806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 16 Jan 2011 16:37:38 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 15-01-2011 11:46, Helmut Auer escreveu:
> > Hello List
> > 
> > How long does it usually take til patches are integrated into the
> > media build tree ( after posting these here ) ? I'm just wondering
> > because I miss some patches posted here.
> 
> It takes as much it needs for the driver maintainer to look into it,
> and for me to have time to handle them.
> 
> The pending patches are always at:
> 
> 	https://patchwork.kernel.org/project/linux-media/list/
> 
> Please note that, by default, Patchwork filters the patches to
> display only the ones marked as New or Under Review. If you want to
> see all patches, you need to change the state filter to show all
> patches:
> https://patchwork.kernel.org/project/linux-media/list/?state=*
> 
> If the patch you're waiting are marked as Under Review, you should
> ping the driver maintainer, as I'm waiting for his review. If it is
> new, that means that I didn't have time yet to dig into it.

Can you please check these patches ? 
What is missing ? Something to be corrected ? 

What happens to orphaned drivers ? Manu are you still working on this ? 

Manu , Mauro please comment ! Thanks !

Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function
	2010-08-07 	Marko Ristola 		Under Review
Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
	2010-08-07 	Marko Ristola 		Under Review
[v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod
	2010-10-10 	Tuxoholic 		Under Review
