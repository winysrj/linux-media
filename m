Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANFnRK0019424
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 10:49:27 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANFnEbY000786
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 10:49:15 -0500
Received: by ug-out-1314.google.com with SMTP id j30so557949ugc.13
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 07:49:14 -0800 (PST)
Message-Id: <4BB0779B-E72E-4611-B35E-40977F0FC4CF@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1227454285.3105.63.camel@palomino.walls.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Sun, 23 Nov 2008 10:49:10 -0500
References: <1227071437.3117.42.camel@palomino.walls.org>
	<C76A9A84-CC2C-4384-8B4D-5435DD2D3F57@tvwhere.com>
	<1227454285.3105.63.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] cx18: Extensive interrupt and buffer handling
	changes need test
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


On Nov 23, 2008, at 10:31 AM, Andy Walls wrote:
>
> Brandon,
>
> [culling out and reorganizing interesting stuff:]
>
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 7427) while processing
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 9372) while processing
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 10914) while processing
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 12855)
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 12978) while processing
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 13012)
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 14966)
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 17100)
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 17405) while processing
> cx18-2 warning: Possibly falling behind: CPU self-ack'ed our  
> incoming CPU to EPU mailbox (sequence no. 17422) while processing
>
> This is all OK.  They are all pretty far apart.  The ones with "while
> processing" on the end are really no big deal, as we're sure we got a
> good copy of the mailbox data on those.  And there are no messages  
> about
> detecting buffers to have fallen out of rotation and being being put
> back, so you're actually not loosing buffers (that's why the message
> says "Possibly").  You're in good shape.
>
>
> I would note that only "cx18-2" is experiencing trouble in meeting  
> it's
> IRQ handling timeline imposed by it's firmware.  There's either:
>
> a. some piece of hardware sharing an interrupt with this cx18-2 board
> and it's IRq handling routine is causing delays in invoking the cx18  
> ISR
> routine for this board.
>
> b. the PCI bus MMIO to cx18-2 is slow because latency timer settings  
> on
> other devices are set really, really long.
>
> c. You've got 3 boards in an only dual core machine, and the other  
> cx18
> board IRQ handling routines have interrupts disabled on both the other
> cores when the IRQ for cx18-2 comes in.
>
> d. anything else you can dream up for why the time form hardware
> interrupt line being asserted to cx18_irq_handler() is longer than the
> other boards. :)
>
>
>
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-2: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-2: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-1: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
> [snip]
> cx18-0: sending CX18_CPU_DE_SET_MDL timed out waiting 10 msecs for  
> RPU acknowledgement
>
> These are no big deal.  We get impatient with the firmware and move on
> when it doesn't respond to our command - we can't spend forever  
> sleeping
> for something that has little corrective action when it fails.  Since
> you got no "stuck mailbox" messages, the outgoing command likely did
> complete. Even if the SET_MDL command actually fails on occasion, the
> "buffer fallen out of rotation" detection logic will pick it up later
> and send it again.
>
>
> It's somewhat annoying that the firmware wants response times on the
> order of 100's of usecs (I think) for it's data to be ack'ed, but it
> makes us wait over 10 msecs for it to ack us at times.  The 10 msec  
> was
> an empirical number on a single board machine.  I may have to up the
> timeout length or just quiet the message to a debug level.
>
>
>
>
> All in all you're in good shape.  Your system appears to have low  
> enough
> interrupt service latency to meet the demands of the firmware.  (At
> least one ivtv-users list user has a system that is having real  
> trouble
> meeting the interrupt service latency timeline of the firmware.  I may
> have to add a polled mailbox IO mode to the driver for these systems  
> to
> use.)
>
>
> Again a lot of this was going on previously, it's just that the cx18
> driver never bothered to look for it on incoming DMA done  
> notifications,
> report the precise condition in the logs, or correct for it very well.
>
> Thanks for the testing and providing data!
>
> Regards,
> Andy
>
>> Brandon
>
>
Andy,

A couple of points to note:
1)  cx18-2 was the only board making use of analog and hd recordings.  
The other devices were only performing HD OTA captures.
2)  cx18-2 shares irqs with: ls /proc/irq/18/ cx18-2 ehci_hcd:usb4   
smp_affinity  spurious  uhci_hcd:usb3  uhci_hcd:usb7. Can I use irq17?  
nothing seems to be on this.
3) This is actually a quad core cpu.

Thanks,

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
