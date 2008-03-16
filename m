Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JatsP-0001lS-7E
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 15:30:19 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Philip Pemberton <lists@philpem.me.uk>
In-Reply-To: <47DCFE62.6020405@philpem.me.uk>
References: <47DCFE62.6020405@philpem.me.uk>
Date: Sun, 16 Mar 2008 15:21:58 +0100
Message-Id: <1205677318.30122.14.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CX88 (HVR-3000) -- strange errors in dmesg
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Sonntag, den 16.03.2008, 11:02 +0000 schrieb Philip Pemberton:
> Hi,
>    I've just noticed an absolute ton of these messages in dmesg, can anyone 
> tell me what's going on, or what they mean?
> 
> [  123.404000] cx88[0]: irq pci [0x1000] brdg_err*
> [  123.404000] cx88[0]: irq pci [0x1000] brdg_err*
> [  123.412000] cx88[0]: irq pci [0x1000] brdg_err*
> [  123.412000] cx88[0]: irq pci [0x1000] brdg_err*
> 
> (repeat ad nauseum)
> 
> Kernel 2.6.22-14-generic, Hg 11fdae6654e8 with HVR-3000 patches from 
> dev.kewl.org/hauppauge merged in manually.
> 

looks like you need the last patches from Guennadi.
http://marc.info/?l=linux-video&r=1&b=200803&w=2

Most important is that one in the middle.
[PATCH] Fix left-overs from the videobuf-dma-sg.c conversion to generic
DMA

As a workaround there was also a patch from Mauro previously, reverting
videobuf-dma-sg back to PCI DMA until the bug is discovered.
http://www.spinics.net/lists/vfl/msg36025.html


Cheers,
Hermann







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
