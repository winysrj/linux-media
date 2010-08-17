Return-path: <mchehab@pedra>
Received: from mx34.mail.ru ([94.100.176.48]:52022 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab0HQRCZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 13:02:25 -0400
Received: from [78.36.177.34] (port=28449 helo=localhost.localdomain)
	by mx34.mail.ru with psmtp
	id 1OlPYM-000HH0-00
	for linux-media@vger.kernel.org; Tue, 17 Aug 2010 21:02:23 +0400
Date: Tue, 17 Aug 2010 21:10:27 +0400
From: Goga777 <goga777@list.ru>
To: linux-media@vger.kernel.org
Subject: Re: SkyStar S2 on an embedded Linux
Message-ID: <20100817211027.1ffee6ea@list.ru>
In-Reply-To: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
References: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> I've got a TechniSat SkyStar S2 card. The Linux driver provided at
> vendor's website isn't suitable for recent kernels (2.6.34, in my
> case). So I use s2-liplianin which works fine and I don't have any
> problem with it.

seems your card has revision 2

[  289.613148] flexcop-pci: card revision 2

did you patch something ?
did you test your card with dvb-s2 channels ?


> Well, I'm building a Linux embedded system using Busybox and Linux
> kernel 2.6.34 to capture a satellite transponder. Normally when we
> want a device to work, we identify the kernel modules needed for it
> and then we copy them to the target system's filesystem. But it
> doesn't work. I even desperately copied all the modules located in the
> /lib/modules/2.6.34/ directory to the target system, but nothing
> changed.
> 
> # modprobe b2c2-flexcop-pci
> [  289.593984] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
> receiver chip loaded successfully
