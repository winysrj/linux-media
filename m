Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1Kpu1n-0000mU-1B
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 02:14:16 +0200
From: Andy Walls <awalls@radix.net>
To: Tom Moore <htmoore@comcast.net>
In-Reply-To: <001501c92e56$a4903870$edb0a950$@net>
References: <001501c92e56$a4903870$edb0a950$@net>
Date: Tue, 14 Oct 2008 20:15:52 -0400
Message-Id: <1224029752.3248.34.camel@palomino.walls.org>
Mime-Version: 1.0
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

On Tue, 2008-10-14 at 18:43 -0500, Tom Moore wrote:
> I just bought two Hauppauge HVR-1600 cards and I'm trying to set them
> up in 
> 
> Mythdorra 5. I have the cx18 drivers installed but it is only
> initializing one 
> 
> card. I'm getting the following message when I do a dmesg | grep cx18.
> Has 
> 
> anyone ran accross this problem before with duel cards of the same
> model and if 
> 
> so, how do I fix it? Any help will be greatly appreciated.
> 
>  
> 
> Thanks,
> 
> Tom Moore
> 
> Houston, TX
> 
>  
> 
> dmesg | grep cx18
> 
> cx18:  Start initialization, version 1.0.1

> cx18-1: Initializing card #1
> 
> cx18-1: Autodetected Hauppauge card
> 
> cx18-1: Unreasonably low latency timer, setting to 64 (was 32)
> 
> cx18-1: ioremap failed, perhaps increasing __VMALLOC_RESERVE in page.h
> 
> cx18-1: or disabling CONFIG_HIGHMEM4G into the kernel would help
> 
> cx18-1: Error -12 on initialization
> 
> cx18: probe of 0000:02:04.0 failed with error -12
> 
> cx18:  End initialization
> 

You're out of vmalloc address space.  Each cx18 needs 64 MB of vmalloc
space for MMIO mappings.

Do this:

$ cat /proc/meminfo | grep Vmalloc

Edit your bootloader's config file to add a 'vmalloc=xxxM' option to
your kernel commandline.  Use a value that is 128M greater than your
current VmallocTotal. 


Regards,
Andy



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
