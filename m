Return-path: <mchehab@gaivota>
Received: from smtp12.mail.ru ([94.100.176.89]:39640 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0KFUt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Nov 2010 16:49:58 -0400
Date: Sat, 6 Nov 2010 23:53:38 +0300
From: Goga777 <goga777@bk.ru>
To: Emmanuel <eallaud@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Proftuners S2-8000 support
Message-ID: <20101106235338.33ba4e26@bk.ru>
In-Reply-To: <4CD559C6.7040106@gmail.com>
References: <AANLkTi=LedNdgYkBa2Si3dpnnMDqPv=zr=AVx3GkM3GD@mail.gmail.com>
	<4CD559C6.7040106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> > I have recently purchased Proftuners S2-8000 PCI-e card which consist of :
> >
> > * CX23885 pci-e interface
> > * STB6100 Frontend
> > * STV0900 Demodulator
> >
> > Vendor company supposed that card has Linux support via additional
> > patch in their support page. I applied patch to v4l-dvb and
> > s2-liplianin repositories. Patched source compiled and modules loaded
> > successfully, but it didn't work properly. I got mass of error
> > messages below, during launching VDR application.
> >
> > Insructions: http://www.proftuners.com/driver8000.html
> > Patch: http://www.proftuners.com/sites/default/files/prof8000.patch
> >
> >   
> 
> So... any news for support and 45Msps DVB-S2 capability?

the card is working with patch 
http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=17602#post17602

but why are you interesting so high SR for dvb-s2 ? For me the dvb-s2 channels with sr = 45 000 don't
exist 

Goga
