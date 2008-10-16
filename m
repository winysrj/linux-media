Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <htmoore@comcast.net>) id 1KqIam-0004c0-B9
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 04:28:01 +0200
From: "Tom Moore" <htmoore@comcast.net>
To: "'Andy Walls'" <awalls@radix.net>
References: <001501c92e56$a4903870$edb0a950$@net>	
	<1224029752.3248.34.camel@palomino.walls.org>	
	<003101c92e68$fe5e5000$fb1af000$@net>
	<1224067873.5059.15.camel@morgan.walls.org>
In-Reply-To: <1224067873.5059.15.camel@morgan.walls.org>
Date: Wed, 15 Oct 2008 21:26:52 -0500
Message-ID: <001501c92f36$a7112d30$f5338790$@net>
MIME-Version: 1.0
Content-Language: en-us
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Duel Hauppauge HVR-1600
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



-----Original Message-----
From: Andy Walls [mailto:awalls@radix.net] 
Sent: Wednesday, October 15, 2008 5:51 AM
To: Tom Moore
Cc: linux-dvb@linuxtv.org
Subject: RE: [linux-dvb] Duel Hauppauge HVR-1600

Tom,

Just a note: please don't top post.  Per list convention, please just
respond in-line.

On Tue, 2008-10-14 at 20:54 -0500, Tom Moore wrote:
> Thanks Andy for the reply.
> 
> I did what you said and now I'm getting an memory error message when
booting
> 
> 
> The message reads:
> Initrd extends beyond end of memory (0x37fef23a > 0x30000000)

Well, that's a new one on me.

> I tried lowering the amount but anything over 128M and I get the error
> message.

So since vmalloc addresses are used for dynamic kernel mappings for
things like loadable module code and for IO mappings, 128 MB of
addresses will never be sufficient to support two cards that want 64 MB
of addresses each, along with other kernel vmalloc needs.

So until this problem is resolved, you won't get the second card
running.  The good news is, the problem appears to be fixable with the
proper kernel configuration.

The driver did make some suggestions in it's original error message:


> > cx18-1: ioremap failed, perhaps increasing __VMALLOC_RESERVE in page.h
> > 
> > cx18-1: or disabling CONFIG_HIGHMEM4G into the kernel would help
> > 
> > cx18-1: Error -12 on initialization

both of which you could try.  They involve building a custom kernel.

There may be other ways, but I'm no expert in Linux memory management.
I suspect someone over on the LKML is.

To help solve your problem, people will likely need to see the output of
'cat /proc/meminfo' and 'dmesg' for your system.  If I had that info, I
could try to help, I'm not sure I'd be able to help effectively.


Regards,
Andy


> Here is my config file:
> # grub.conf generated by anaconda
> #
> # Note that you do not have to rerun grub after making changes to this
file
> # NOTICE:  You have a /boot partition.  This means that
> #          all kernel and initrd paths are relative to /boot/, eg.
> #          root (hd0,0)
> #          kernel /vmlinuz-version ro root=/dev/VolGroup00/LogVol00
> #          initrd /initrd-version.img
> #boot=/dev/sda
> default=0
> timeout=5
> splashimage=(hd0,0)/grub/splash.xpm.gz
> hiddenmenu
> title MythDora (2.6.24.4-64.fc8)
> 	root (hd0,0)
> 	kernel /vmlinuz-2.6.24.4-64.fc8 ro root=/dev/VolGroup00/LogVol00
> rhgb quiet vmalloc=256M
> 	initrd /initrd-2.6.24.4-64.fc8.img
> 
> -----Original Message-----
> From: Andy Walls [mailto:awalls@radix.net] 
> Sent: Tuesday, October 14, 2008 7:16 PM
> To: Tom Moore
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Duel Hauppauge HVR-1600
> 
> On Tue, 2008-10-14 at 18:43 -0500, Tom Moore wrote:
> > I just bought two Hauppauge HVR-1600 cards and I'm trying to set them
> > up in 
> > 
> > Mythdorra 5. I have the cx18 drivers installed but it is only
> > initializing one 
> > 
> > card. I'm getting the following message when I do a dmesg | grep cx18.
> > Has 
> > 
> > anyone ran accross this problem before with duel cards of the same
> > model and if 
> > 
> > so, how do I fix it? Any help will be greatly appreciated.
> > 
> >  
> > 
> > Thanks,
> > 
> > Tom Moore
> > 
> > Houston, TX
> > 
> >  
> > 
> > dmesg | grep cx18
> > 
> > cx18:  Start initialization, version 1.0.1
> 
> > cx18-1: Initializing card #1
> > 
> > cx18-1: Autodetected Hauppauge card
> > 
> > cx18-1: Unreasonably low latency timer, setting to 64 (was 32)
> > 
> > cx18-1: ioremap failed, perhaps increasing __VMALLOC_RESERVE in page.h
> > 
> > cx18-1: or disabling CONFIG_HIGHMEM4G into the kernel would help
> > 
> > cx18-1: Error -12 on initialization
> > 
> > cx18: probe of 0000:02:04.0 failed with error -12
> > 
> > cx18:  End initialization
> > 
> 
> You're out of vmalloc address space.  Each cx18 needs 64 MB of vmalloc
> space for MMIO mappings.
> 
> Do this:
> 
> $ cat /proc/meminfo | grep Vmalloc
> 
> Edit your bootloader's config file to add a 'vmalloc=xxxM' option to
> your kernel commandline.  Use a value that is 128M greater than your
> current VmallocTotal. 
> 
> 
> Regards,
> Andy
> 
> 
Andy,
> Thanks Andy for all your help. Instead of headache of TRYING to build a
custom kernel, I swopped-out hard drives and installed Mythbuntu. After
installing the cx18 drivers it also only initialized one card. I then
modified the bootloader with "vmalloc=256M" and it worked like a champ. I
think I will put my other hard drive back in and try to update the kernel in
Mythdora 5 (even though the docs recommend against it). Anyway I posted at
the bottom as you said and I REALLY appreciate you taking the time to help
me. Maybe one day I can return the favor.

Have a great day,
Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
