Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:37404 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752442Ab1LIX5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 18:57:42 -0500
Message-ID: <4EE2A06D.7070901@gmx.de>
Date: Sat, 10 Dec 2011 00:57:33 +0100
From: Ninja <Ninja15@gmx.de>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: Mantis CAM not SMP safe / Activating CAM on Technisat Skystar
 HD2 (DVB-S2)
References: <4EC052CE.1080002@gmx.de>
In-Reply-To: <4EC052CE.1080002@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

has anyone an idea how the SMP problems could be fixed?
I did some further investigation. When comparing the number of 
interrupts with all cores enabled and the interrupts with only one core 
enabled it seems like only the IRQ0 changed, the other IRQs and the 
total number stays quite the same:

4 Cores:
All IRQ/sec: 493
Masked IRQ/sec: 400
Unknown IRQ/sec: 0
DMA/sec: 400
IRQ-0/sec: 143
IRQ-1/sec: 0
OCERR/sec: 0
PABRT/sec: 0
RIPRR/sec: 0
PPERR/sec: 0
FTRGT/sec: 0
RISCI/sec: 258
RACK/sec: 0

1 Core:
All IRQ/sec: 518
Masked IRQ/sec: 504
Unknown IRQ/sec: 0
DMA/sec: 504
IRQ-0/sec: 246
IRQ-1/sec: 0
OCERR/sec: 0
PABRT/sec: 0
RIPRR/sec: 0
PPERR/sec: 0
FTRGT/sec: 0
RISCI/sec: 258
RACK/sec: 0

So, where might be the problem?
I don't think the IRQ gets lost on the way from the device to the 
driver, because only IRQ0 is affected.
I don't think the device or the driver is to slow because it works fine 
with only one Core and it also works with
SMP when ignoring the timeout and just read the data at the time the IRQ 
should have fired.
Maybe the (cam) locking is faulty (looks fine to me...).
Maybe the IRQ handler gets executed parallel on two cores which leads to 
the problem. But then I think this
should be fixed when setting IRQ affinity to only core, but it didn't 
help with the problem.

I hope somebody can help, because I think we are very close to a fully 
functional CAM here.
I ran out of things to test to get closer to the solution :(
Btw: Is there any documentation available for the mantis PCI bridge?

Manuel








