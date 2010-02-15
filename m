Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57926 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab0BOPV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 10:21:59 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh2lq-0003OC-0G
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 16:21:58 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 16:21:57 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 16:21:57 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 16:21:33 +0100
Message-ID: <hlbopr$v7s$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth wrote:

>> Is this because the driver does not have the right capabilities or is it
>> "just" a PCI-id missing in the driver?
> 
> A mixture of both, analog support in the 885 driver is limited. Generally,
> yes - start by adding the PCI id.
> 

So, does this imply that you see a chance to get this card running? :-)

If so, I will order one card and try. There is not much I want to do with 
the card. It should simply digitize an external camera signal. I want to 
display it with mplayer. It should, however, be reliable and not crash the 
system or drop the stream or whatever.

So far, it seems that this is the only mini-pcie video digitizer card that 
exists. I would have taken a bttv based one instead, but as there is none...

Thanks

Michael

