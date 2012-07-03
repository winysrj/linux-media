Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43035 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2GCIIS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jul 2012 04:08:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Sly9h-0000J3-BT
	for linux-media@vger.kernel.org; Tue, 03 Jul 2012 10:08:17 +0200
Received: from cgx52.neoplus.adsl.tpnet.pl ([83.30.251.52])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2012 10:08:17 +0200
Received: from acc.for.news by cgx52.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2012 10:08:17 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Tue, 03 Jul 2012 09:46:00 +0200
Message-ID: <oikac9-mbk.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF1CD63.10003@nexusuk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FF1CD63.10003@nexusuk.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.07.2012 18:33, Steve Hill wrote:
> Can anyone give me any pointers that might help? I've searched and
> searched and all I can see if people saying that it won't work since the
> DVB-S2 code was integrated into the kernel tree, but I've not seen
> anyone try to figure out _why_ it won't work.

I'm on the same boat.
I have 3 DVB-S2 cards, one of them is pctv452e, and none of them works 
reliable. Yes, it's very frustrating that card which claims linux 
support has this support broken. The problem is that community which 
uses DVB cards is much smaller then those using other equipment. So 
there are no test of every device in each kernel release.
I'm reading this list for some time and often see patches which refactor 
some drivers, but the only check is compilation check.
"totally rewritten DVB-USB-framework" will not help to have more drivers 
too. Makers of dvb cards often don't provide linux driver, or provide 
only once in form of patches. You will not apply such patch into new DVB 
stack. Makers must constantly refactor their drivers to suit new 
kernels, and there are only a few which do this. I don't know why they 
simply don't join this list and push drivers into kernel and then 
provide support.

I don't know what's future of DVB stack, but I see that changes in DVB 
stack causes meany problems with drivers. Often driver is written once 
and later unsupported - changes make it non-functional and there is 
nobody who can fix it. Exactly like with pctv452e driver.
Marx

Ps. Steve, could you please give me full version of kernel which works 
with pctv452e?


