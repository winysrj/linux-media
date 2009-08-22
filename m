Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49370 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932977AbZHVWf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 18:35:29 -0400
Subject: Re: x3m_HPC2000
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel Senftleben <danprem@gmx.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200908221231.30130.danprem@gmx.net>
References: <200908221231.30130.danprem@gmx.net>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 00:33:21 +0200
Message-Id: <1250980401.5983.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Am Samstag, den 22.08.2009, 12:31 +0200 schrieb Daniel Senftleben:
[snip]
> 
> G'day all
> 
> I've bought myself the "HPC2000 hybrid tv pci card" for one reason because x3m 
> said it supports linux.. well, it never worked for me (now I'm at Suse 11.1 
> 64bit and I used to use the prior Suse versions) and now I stumbled across 
> your wiki and saw my card under the "Currently Unsupported DVB-T PCI cards"..  
> way to go :-/ So now I subscribed to the list to help get this card working! 
> How can I help?
> (but please be easy on me - it's the first time I try help "officials" ;-))
> 

I'm not very close to that card currently, but from the wiki it seems
your best chance is to try with recent mercurial v4l-dvb cx88xx card=63.

Devin had some important regression fixes about three weeks back.

The wiki link to the x3m linux driver doesn't work currently, so I had
only a look at the Geniatech stuff.

There seem to be already several revisions of that card and clones.
The X3M with version 1.11.
http://www.linuxtv.org/wiki/images/3/37/Hpc2000.jpg

And LifeView with a revision 1.00 calling it "not only TV".
http://www.lifeview.hk/dbimages/document/12%5Clv3h_all.jpg

Here we seem to see it with a sticker "LV3H" over the revision printing.
That one has the same PCI subsystem like the Geniatech X8000 MT.
http://www.lowlevel.cz/log/pivot/entry.php?id=117

Always try to provide links, even to our own wiki and at least relevant
parts of "dmesg" for all card related stuff.

I honestly had no idea in the beginning about what you might be talking
at all, just some decent echos in memory.

Good Luck,
Hermann




