Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pih-relay05.plus.net ([212.159.14.132])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@adslpipe.co.uk>) id 1KE9Qw-0004wu-DK
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 23:00:13 +0200
Received: from [84.92.25.126] (helo=[192.168.1.100])
	by pih-relay05.plus.net with esmtp (Exim) id 1KE9Qp-00062Y-Rn
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 22:00:04 +0100
Message-ID: <486BEC50.2080009@adslpipe.co.uk>
Date: Wed, 02 Jul 2008 22:00:00 +0100
From: Andy Burns <linux-dvb@adslpipe.co.uk>
MIME-Version: 1.0
To: Linux DVB List <linux-dvb@linuxtv.org>
References: <486A6F0F.7090507@adslpipe.co.uk>	
	<486B9630.1080100@adslpipe.co.uk>	<200807021712.53659.zzam@gentoo.org>	
	<486BA03D.4040904@adslpipe.co.uk> <486BA3AE.1020808@adslpipe.co.uk>
	<1215031175.2624.7.camel@pc10.localdom.local>
In-Reply-To: <1215031175.2624.7.camel@pc10.localdom.local>
Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
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

On 02/07/2008 21:39, hermann pitton wrote:

> We have some recent remotes sampling from IRQs triggered by a gpio pin
> without any additional IR chip.
> 
> There are some reports that "pollirq" makes them unusable, since
> sensible timings are lost.

Thanks for the info, not relevant for me though, the whole point of 
virtualising my mythtv backend with xen is to stuff all the noisy bits 
is a cupboard and have a separate frontend which does have a LiRC device.

> No such reports from xen stuff yet, but the same might happen with
> shared IRQs and "pollirq" there too.

After I'd sorted the mmio mapping issue, the driver loaded under xen, 
but crashed after 40 seconds or so due to shared interrupt routing, so I 
added the pollirq, I understand this might cause performance issues as 
IRQs have to be delivered to multiple drivers in different xen domains, 
particularly one of my PCI slots shares with a PCI-X slot which has my 
8xSATA card in it, so I've avoided that slot for now, but would like to 
have dual tuner again.

The driver is now working fairly well under xen, with a single tuner 
mythbckend can record three concurrent streams from a mux, with under 
10% CPU.

I have one remaining issue, which I will try to track down, every now 
and then I seem to get a DMA error causing a kernel panic, my feeling is 
it happens when retuning;  perhaps some DMA transfer is in-flight when 
something changes on the card and causes a problem? Or like the 
ioremap() it might be something xen is more sensitive to than a 
bare-metal machine.

Do I need to send my patch direct to Harmut Hackmann, or will he pick it 
up from the list if he likes it?



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
