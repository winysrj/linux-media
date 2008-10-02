Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KlXSz-00051F-7P
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 01:20:18 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Matthias Schwarzott <zzam@gentoo.org>
In-Reply-To: <200810021915.40147.zzam@gentoo.org>
References: <48E35E38.9040909@gmail.com>
	<1222900908.2706.18.camel@pc10.localdom.local>
	<48E4A4A4.8030003@gmail.com> <200810021915.40147.zzam@gentoo.org>
Date: Fri, 03 Oct 2008 01:14:09 +0200
Message-Id: <1222989249.3724.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
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

Am Donnerstag, den 02.10.2008, 19:15 +0200 schrieb Matthias Schwarzott:
> On Donnerstag, 2. Oktober 2008, Plantain wrote:
> >
> > Hey,
> >
> > I'm not actually able to code in C, but I've spent the last 24 hours
> > puddling around trying to get somewhere. I believe I've added everything
> > that is needed for the card to be detected, but it's not detecting it,
> > even if I specify it with card=152 (the ID I've added). I have got the
> > code to compile at least, which I'm pretty proud of :)
> >
> > I managed to get regspy to work (needed to revert 64bit vista to 32bit
> > XP), but the viewing software that came with the card just crashes on
> > 32bit XP. I've built a small wiki page (with highres images) detailing
> > my progress, but I've really just hit a brick wall. Wikipage at
> > http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S
> >
> > Short of learning C (which I am very slowly doing), I don't see anyway
> > forwards under my direction, so I've attached my efforts in the hope
> > someone else can take this forwards. From my limited understanding I've
> > provided all the necessary information for someone to finish it, and if
> > not I'll happily dig up anything else needed. I'm not familiar with any
> > version control system/patching, so I've just hg diff > file.diff, I
> > hope this is adequate.
> >
> > I'm on #linuxtv @ freenode IRC for a significant portion of the day if
> > anyone has pointers for me/wants to ask questions about the card.
> >
> 
> Looking at your regspy output
> 109.     SAA7134_GPIO_GPMODE:             82000000   (10000010 00000000 
> 00000000 00000000)                
> 110.     SAA7134_GPIO_GPSTATUS:           02132054   (00000010 00010011 
> 00100000 01010100)         
> 
> I suggest you change your gpio code like this:
> 
>                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x82000000, 
> 0x82000000);
>                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x02000000, 
> 0x02000000);
> 
> So this at least sets the directions of gpios as used in windows, and outputs 
> the same values on the gpios configured as output. That should work better 
> than your copy-and-pasted numbers from another card.
> 
> But it still can be you need to pull some pins high or low for some time at 
> init to get parts reset.
> 
> You also could try adding a small wait time after writing gpio values.
> e.g. msleep(500);
> 
> Good luck
> Matthias

yes, that is likely the most solid start we can have from the analog
side so far. The card should be auto detectable as well.

Thanks,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
