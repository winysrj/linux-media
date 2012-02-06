Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:45880 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2BFNf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 08:35:27 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=junior)
	by mail81.extendcp.com with esmtpa (Exim 4.77)
	id 1RuOj2-0007RP-HQ
	for linux-media@vger.kernel.org; Mon, 06 Feb 2012 13:35:22 +0000
Date: Mon, 6 Feb 2012 13:35:20 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: TBS 6920 remote
Message-ID: <20120206133520.788eeb3f@junior>
In-Reply-To: <CAH4Ag-BL3V2th8tu78iE3toCo2SxbRHVpNzMB6jEfs2C5iuzBQ@mail.gmail.com>
References: <20120203171250.52278c25@junior>
	<CAH4Ag-BZ+Csasy=yk5sNt7_Q5maFuxga2PqeXtJrRYvVLa8zzA@mail.gmail.com>
	<20120205185233.3ca5024a@tiber>
	<CAH4Ag-BL3V2th8tu78iE3toCo2SxbRHVpNzMB6jEfs2C5iuzBQ@mail.gmail.com>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Feb 2012 11:48:43 +0000
Simon Jones <sijones2010@gmail.com> wrote:

> > Thanks. It seems that there was a bug in their driver which
> > prevented some keys from working, but AFIACT it's fixed now. The
> > code is GPL so is it just lack of interest/demand that's stopped it
> > from going into the main kernel?
> 
> They have an NDA with a chip supplier so can't release the full
> source, I think there is a binary blob somewhere that makes it so you
> can't include them.

The 6920 uses a Conexant chipset and everything except the remote works
with a standard kernel, but I did have to install the firmware manually.
Is the binary part for the remote? I would have thought it was only for
other chipsets.

> > I think I'll pass on having to maintain a 3rd party driver whenever
> > the Debian kernel upgrades. The remote is missing some quite
> > important keys like Play, so they seem to have only considered it
> > for live viewing, not for PVRs. I'll probably end up buying a
> > separate USB remote or continuing to use a portable keyboard.
> 
> I have an MCE remote, ebay has HP remote and receiver cheap enough,
> they are also rc6 encoding so you can use one-for-all remote etc easy
> enough, and drivers are in kernel so only a manor change to lirc to
> get it working.

Ah yes, those HP ones look serviceable and affordable, thanks.

> You don't have to use lirc but I couldn't be bothered trying to map
> the keys in X.

It would be better if more applications had a nice frontend to "train"
them to use certain keys, either as the remote appearing as a keyboard,
or by reading input events (which is very easy).
