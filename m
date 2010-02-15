Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58947 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0BOU3f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:29:35 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh7ZV-00008u-7m
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 21:29:33 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 21:29:33 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 21:29:33 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 21:29:10 +0100
Message-ID: <hlcaqk$q8$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org> <829197381002150927p5061d383k1267240bcafc0927@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:

> I would probably advise against using a cx23885 based design for
> analog under Linux right now.  There is *some* analog support in the
> driver, but it is not very mature and has a host of issues/bugs.
> Also, there is currently no analog audio support in the driver, so if
> you do not have an encoder then it will not work.
>

Well, I don't need audio, just video. A raw stream is everything I need, as 
it is displayed by mplayer directly.

But you mean that this most probably wouldn't work as the analog support is 
not good enough for the time being?

> In other words, even if all you did need was to add another PCI ID,
> you would still be very likely to run into problems.
> 
> We (KernelLabs) have a handful of patches that can eventually get into
> the upstream driver, although right now progress is slow on that front
> and you certainly shouldn't buy hardware based on the expectation that
> the patches are forthcoming.
> 
Well, would these patches help me to get the card working for my purpose 
(raw video stream)? I don't mind patching the driver. I am no developer, but 
applying a patch and compiling the driver I should manage.

Otherwise do you know another mini-pci-express video capture card that is 
supported by the linux kernel?

Thanks for your help

Michael
> Devin
> 


