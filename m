Return-path: <video4linux-list-bounces@redhat.com>
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Burns <linux-dvb@adslpipe.co.uk>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Gerd Hoffmann <kraxel@redhat.com>
In-Reply-To: <486BEC50.2080009@adslpipe.co.uk>
References: <486A6F0F.7090507@adslpipe.co.uk>
	<486B9630.1080100@adslpipe.co.uk>	<200807021712.53659.zzam@gentoo.org>
	<486BA03D.4040904@adslpipe.co.uk> <486BA3AE.1020808@adslpipe.co.uk>
	<1215031175.2624.7.camel@pc10.localdom.local>
	<486BEC50.2080009@adslpipe.co.uk>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 01:09:16 +0200
Message-Id: <1215126556.4278.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Linux DVB List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Mittwoch, den 02.07.2008, 22:00 +0100 schrieb Andy Burns:
> On 02/07/2008 21:39, hermann pitton wrote:
> 
> > We have some recent remotes sampling from IRQs triggered by a gpio pin
> > without any additional IR chip.
> > 
> > There are some reports that "pollirq" makes them unusable, since
> > sensible timings are lost.
> 
> Thanks for the info, not relevant for me though, the whole point of 
> virtualising my mythtv backend with xen is to stuff all the noisy bits 
> is a cupboard and have a separate frontend which does have a LiRC device.
> 
> > No such reports from xen stuff yet, but the same might happen with
> > shared IRQs and "pollirq" there too.
> 
> After I'd sorted the mmio mapping issue, the driver loaded under xen, 
> but crashed after 40 seconds or so due to shared interrupt routing, so I 
> added the pollirq, I understand this might cause performance issues as 
> IRQs have to be delivered to multiple drivers in different xen domains, 
> particularly one of my PCI slots shares with a PCI-X slot which has my 
> 8xSATA card in it, so I've avoided that slot for now, but would like to 
> have dual tuner again.
> 
> The driver is now working fairly well under xen, with a single tuner 
> mythbckend can record three concurrent streams from a mux, with under 
> 10% CPU.
> 
> I have one remaining issue, which I will try to track down, every now 
> and then I seem to get a DMA error causing a kernel panic, my feeling is 
> it happens when retuning;  perhaps some DMA transfer is in-flight when 
> something changes on the card and causes a problem? Or like the 
> ioremap() it might be something xen is more sensitive to than a 
> bare-metal machine.
> 
> Do I need to send my patch direct to Harmut Hackmann, or will he pick it 
> up from the list if he likes it?
> 

that depends on the time he has, but if you think you have something
proper, always send a copy directly to Hartmut and Mauro too.

I'm not within any xen, but Gerd, the saa7134 author, is on it since
then. If you think it is xen specific, you might try to reach him too.
(kraxel@redhat.com)

Can't tell, if he has time for it currently.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
