Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:47856 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab0CDJLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Mar 2010 04:11:07 -0500
Subject: Re: TBS 6980 Dual DVB-S2 PCIe card
From: hermann pitton <hermann-pitton@arcor.de>
To: Per Lundberg <perlun@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20100304T091408-554@post.gmane.org>
References: <loom.20100304T091408-554@post.gmane.org>
Content-Type: text/plain
Date: Thu, 04 Mar 2010 10:05:37 +0100
Message-Id: <1267693537.3190.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 04.03.2010, 08:19 +0000 schrieb Per Lundberg:
> Hi!
> 
> I read the old thread about this card, at
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg12753.html. I've also
> tried downloading the vendor-provided drivers from
> http://www.buydvb.net/download2/TBS6980/tbs6980linuxdriver2.6.32.rar
> 
> As someone has already indicated, it seems like TBS (TurboSight) have made their
> own fork of v4l where the drivers for this card is included. I've also
> understood that the card works fine, which is nice (I down own it yet but am
> considering getting one).
> 
> Has anyone done any attempt at contacting TBS to see if they can release their
> changes under the GPLv2? Ideally, they would provide a patch themselves, but it
> should be fairly simple to diff the linux/ trees from their provided
> linux-s2api-tbs6980.tar.bz2 file with the stock Linux 2.6.32 code... in fact, it
> could be that their patch is so trivial that we could just include it in the
> stock Linux kernel without asking them for license clarifications... but
> obviously, if we can get a green sign from them, it would be even better.
> --
> Best regards,
> Per Lundberg
> 

It is always the other way round.

In the end they need a green sign from us.

Cheers,
Hermann

BTW, the TBS dual seems to be fine on m$, but there are some mysterious
lockups without any trace, if used in conjunction with some prior
S2/HDTV cards. I can't tell yet, if that it is evenly distributed over
amd/ati and nvidia stuff or whatever on win7 ... , but people do spend
lifetime in vain on it.


