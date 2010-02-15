Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44868 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0BORdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:33:10 -0500
Received: by bwz5 with SMTP id 5so1254056bwz.1
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 09:33:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <hlbopr$v7s$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org>
	 <1266238446.3075.13.camel@palomino.walls.org>
	 <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com>
	 <hlbopr$v7s$1@ger.gmane.org>
Date: Mon, 15 Feb 2010 12:27:54 -0500
Message-ID: <829197381002150927p5061d383k1267240bcafc0927@mail.gmail.com>
Subject: Re: cx23885
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2010 at 10:21 AM, Michael <auslands-kv@gmx.de> wrote:
> So, does this imply that you see a chance to get this card running? :-)
>
> If so, I will order one card and try. There is not much I want to do with
> the card. It should simply digitize an external camera signal. I want to
> display it with mplayer. It should, however, be reliable and not crash the
> system or drop the stream or whatever.
>
> So far, it seems that this is the only mini-pcie video digitizer card that
> exists. I would have taken a bttv based one instead, but as there is none...

I would probably advise against using a cx23885 based design for
analog under Linux right now.  There is *some* analog support in the
driver, but it is not very mature and has a host of issues/bugs.
Also, there is currently no analog audio support in the driver, so if
you do not have an encoder then it will not work.

In other words, even if all you did need was to add another PCI ID,
you would still be very likely to run into problems.

We (KernelLabs) have a handful of patches that can eventually get into
the upstream driver, although right now progress is slow on that front
and you certainly shouldn't buy hardware based on the expectation that
the patches are forthcoming.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
