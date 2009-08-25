Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZHYQBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 12:01:16 -0400
Date: Tue, 25 Aug 2009 13:01:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: lotway@nildram.co.uk
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: PVR-150, NMI causes reboot in expansion chassis
Message-ID: <20090825130112.32f274d7@pedra.chehab.org>
In-Reply-To: <4A93FE64.9060002@nildram.co.uk>
References: <4A93FE64.9060002@nildram.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2009 16:08:20 +0100
Lou Otway <lotway@nildram.co.uk> escreveu:

> Hi,
> 
> I've been running Hauppauge PVR-150 cards in an expansion chassis and 
> seeing this kind of thing:
> 
> kernel: Uhhuh. NMI received for unknown reason 30 on CPU 0.
> kernel: Do you have a strange power saving mode enabled?
> kernel: Dazed and confused, but trying to continue
> 
> Or, on a different hardware type:
> 
> kernel: Uhhuh. NMI received for unknown reason b1 on CPU 0.
> kernel: You have some hardware problem, likely on the PCI bus.
> kernel: Dazed and confused, but trying to continue
> 
> When the cards are installed on a motherboard slot they're fine, but in 
> expansion chassis they really don't work well. 	
> 
> The theory is that the DMA controller has some problems.
> 
> Is there anyone seeing similar issues? Suggestions for things to try to 
> fix it would be most welcome.

The drivers/media drivers don't touch at the NMI controller, so I suspect that
it is something at the PCI controller or at NMI level. 

If you are using a distro-patched kernel, maybe the better is to open a ticket
with your distribution ticket tracking system, since they may have some patches
applied on their kernel that may have some patches touching at NMI and/or PCI.

If you are otherwise using the upstream kernel, the better is to upgrade to the
latest 2.6.30 kernel and test it again. In this case, if, with the latest
kernel you're still suffering troubles, I suggest you to open a ticket at
kernel.bugzilla.org and/or sending an email to LKML. Please report there enough
details about your hardware and the kernel version you're using.




Cheers,
Mauro
