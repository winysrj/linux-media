Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:64013 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0CNI0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 04:26:40 -0400
Date: Sun, 14 Mar 2010 09:26:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Daro <ghost-rider@aster.pl>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135  
 variants
Message-ID: <20100314092635.63c4a1b3@hyperion.delvare>
In-Reply-To: <4B9C4C13.1010801@aster.pl>
References: <E1Nl2po-000877-Di@services.gcu-squad.org>
	<20100312103835.79b26455@hyperion.delvare>
	<4B9C4C13.1010801@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daro,

On Sun, 14 Mar 2010 03:38:11 +0100, Daro wrote:
> Hi Jean,
> 
> I am back and ready to go :)
> As I am not much experienced Linux user I would apprieciate some more 
> details:
> 
> I have few linux kernels installed; which one should I test or it does 
> not matter?
> 2.6.31-14-generic
> 2.6.31-16-generic
> 2.6.31-17-generic
> 2.6.31-19-generic
> 2.6.31-20-generic
> 
> and one I compiled myself
> 2.6.32.2
> 
> I assume that to proceed with a test I should patch the certain version 
> of kernel and compile it or could it be done other way?

It will be easier with the kernel you compiled yourself. First of all,
download the patch from:
http://patchwork.kernel.org/patch/75883/raw/

Then, move to the source directory of your 2.6.32.2 kernel and apply
the patch:

$ cd ~/src/linux-2.6.32
$ patch -p2 < ~/download/saa7134-Fix-IR-support-of-some-ASUS-TV-FM-7135-variants.patch

Adjust the path in each command to match your own setup. Then just
build and install the kernel:

$ make
$ sudo make modules_install
$ sudo make install

Or whatever method you use to install your self-compiled kernels. Then
reboot to kernel 2.6.32.2 and test that the remote control works even
when _not_ passing any card parameter to the driver.

If you ever need to remove the patch, use:

$ cd ~/src/linux-2.6.32
$ patch -p2 -R < ~/download/saa7134-Fix-IR-support-of-some-ASUS-TV-FM-7135-variants.patch

I hope my instructions are clear enough, if you have any problem, just
ask.

Thanks,
-- 
Jean Delvare
