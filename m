Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50559 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0BOUl6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:41:58 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh7lV-00006t-1j
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 21:41:57 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 21:41:57 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 21:41:57 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 21:41:34 +0100
Message-ID: <hlcbhu$4s3$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org> <4B79803B.4070302@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth wrote:

> The hardware has no mpeg encoder, so if by digitizer you mean raw high
> bitrate video frames then yes, and if mplayer is capable of supporting the
> v4l mmap interfaces then yes. (I've have zero experience of mplayer with
> raw video - not sure if this works).

Well, I have mplayer working with a bttv based card sending rawyuv2, if I 
remember correctly. But this is on a different computer.

The board that I want to use has only mini-pci-express and the only card I 
found so far is this MPX-885.

> 
> It feels like a reach, the design looks like a 'same-old' cx23885/7/8
> which you could potentially use in tvtime - with some work.
> 

Well if tvtime runs then mplayer will most probably, too. The question is, 
what means "with some work" :-)

Michael

