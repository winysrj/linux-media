Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:62169 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab0CNUsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 16:48:31 -0400
Date: Sun, 14 Mar 2010 21:48:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Daro <ghost-rider@aster.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135  
 variants
Message-ID: <20100314214828.5e440058@hyperion.delvare>
In-Reply-To: <4B9D3A4A.7000803@aster.pl>
References: <E1Nl2po-000877-Di@services.gcu-squad.org>
	<20100312103835.79b26455@hyperion.delvare>
	<4B9C4C13.1010801@aster.pl>
	<20100314092635.63c4a1b3@hyperion.delvare>
	<4B9D3A4A.7000803@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 14 Mar 2010 20:34:34 +0100, Daro wrote:
> W dniu 14.03.2010 09:26, Jean Delvare pisze:
> > It will be easier with the kernel you compiled yourself. First of all,
> > download the patch from:
> > http://patchwork.kernel.org/patch/75883/raw/
> >
> > Then, move to the source directory of your 2.6.32.2 kernel and apply
> > the patch:
> >
> > $ cd ~/src/linux-2.6.32
> > $ patch -p2<  ~/download/saa7134-Fix-IR-support-of-some-ASUS-TV-FM-7135-variants.patch
> >
> > Adjust the path in each command to match your own setup. Then just
> > build and install the kernel:
> >
> > $ make
> > $ sudo make modules_install
> > $ sudo make install
> >
> > Or whatever method you use to install your self-compiled kernels. Then
> > reboot to kernel 2.6.32.2 and test that the remote control works even
> > when _not_ passing any card parameter to the driver.
> >
> > If you ever need to remove the patch, use:
> >
> > $ cd ~/src/linux-2.6.32
> > $ patch -p2 -R<  ~/download/saa7134-Fix-IR-support-of-some-ASUS-TV-FM-7135-variants.patch
> >
> > I hope my instructions are clear enough, if you have any problem, just
> > ask.
> >
> > Thanks,
> >    
> 
> Hi Jean!
> 
> It works!
> dmesg output is attached.

Thanks for reporting! Mauro, you can pick my (second) patch now and
apply it.

> However I will have to go back to "generic" kernel as under my 
> "self-built" kernels fglrx driver stops working and I did not manage to 
> solve it :(
> Or maybe you could give me a hint what to do with it?

I can't help you with that, sorry, I don't use binary drivers.

-- 
Jean Delvare
