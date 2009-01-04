Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LJcic-0003ht-1I
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 00:49:19 +0100
From: Andy Walls <awalls@radix.net>
To: Thomas Keil <tkeil@datacrystal.de>
In-Reply-To: <496121F3.6090300@datacrystal.de>
References: <495FA03F.7040208@datacrystal.de>
	<1231008480.4302.72.camel@palomino.walls.org>
	<496121F3.6090300@datacrystal.de>
Date: Sun, 04 Jan 2009 18:51:26 -0500
Message-Id: <1231113086.3117.26.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kernel oops loading cx88 drivers
	when	two	WinTV-HVR4000 cards present
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

On Sun, 2009-01-04 at 20:54 +0000, Thomas Keil wrote:
> Hello Andy,
> > You need to fix this.
> >
> > Check the output of
> >
> > $ cat /proc/meminfo
> >
> > and look for how much vmalloc space you have total to work with and how much is used and what is the largest chunk available.
> >
> > $ cat /proc/iomem
> >
> > and see what size of vmalloc allocations HVR4000 devices are claiming
> > for PCI MMIO mappings.
> >   
> Let's see.
> 
> /proc/memstat:
> VmallocTotal:   114680 kB
> VmallocUsed:    110756 kB
> VmallocChunk:     3868 kB
> 
> /proc/iomem
>   db000000-dbffffff : 0000:04:07.0
>     db000000-dbffffff : cx88[0]
>   dc000000-dcffffff : 0000:04:07.1
>     dc000000-dcffffff : cx88[0]
>   dd000000-ddffffff : 0000:04:07.2
>     dd000000-ddffffff : cx88[0]
>   de000000-deffffff : 0000:04:07.4
> 
> Am I right in the assumption that cx88 allocates full 16M?

Yes.  It needs them for registers (and maybe on-card memory) mappings
from the PCI bus into virtual memory.


> Starting with 112M and having just ~4M free it seems reasonable that
> loading the driver fails.

Yup.

> I added vmalloc=256M (less didn't work)

vmalloc space is used for PCI MMIO mappings, mapping physical pages for
loadable modules, and perhaps other allocations of physical memory.

Just make sure you've got some head room.


>  to the kernel parameters - and
> it worked :-)
> The driver loaded, both cards are present!

Great!  (Copying the list.  So others can see the result.)

> Thanks a lot!!


You're welcome.

Regards,
Andy

> Thomas
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
