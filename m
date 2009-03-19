Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63717 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbZCSBM0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 21:12:26 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Andy Walls <awalls@radix.net>
To: Corey Taylor <johnfivealive@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <954486.20343.qm@web56908.mail.re3.yahoo.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 21:12:48 -0400
Message-Id: <1237425168.3303.94.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-17 at 18:08 -0700, Corey Taylor wrote:
> Andy, thanks for writing back. Here's the info you asked for..
> 
> > Well, no.  It's more likely a system level issue.
> 
> > 1.  Can you provide the output of 
> > $ cat /proc/interrupts
> 
>            CPU0       
>   0:        104   IO-APIC-edge      timer
>   1:          2   IO-APIC-edge      i8042
>   4:          8   IO-APIC-edge    
>   7:          1   IO-APIC-edge      parport0
>   8:          0   IO-APIC-edge      rtc0
>   9:          0   IO-APIC-fasteoi   acpi
>  12:          4   IO-APIC-edge      i8042
>  14:     777839   IO-APIC-edge      pata_amd
>  15:          0   IO-APIC-edge      pata_amd
>  17:     760893   IO-APIC-fasteoi   EMU10K1
>  18:     189462   IO-APIC-fasteoi   cx18-0
>  19:    5936140   IO-APIC-fasteoi   nvidia
>  20:   19869131   IO-APIC-fasteoi   eth0
>  21:     158197   IO-APIC-fasteoi   sata_nv
>  22:          2   IO-APIC-fasteoi   ehci_hcd:usb2
>  23:        307   IO-APIC-fasteoi   ohci_hcd:usb1
> NMI:          0   Non-maskable interrupts
> LOC:    6194711   Local timer interrupts
> RES:          0   Rescheduling interrupts
> CAL:          0   function call interrupts
> TLB:          0   TLB shootdowns
> TRM:          0   Thermal event interrupts
> THR:          0   Threshold APIC interrupts
> SPU:          0   Spurious interrupts
> ERR:          1

OK.

Nothing's sharing the intterupt line with the cx18.  The cx18 IRQ is a
higher priority than, the apparently busy, nvidia and eth0 driver IRQs.

The paralled ATA (IDE) disk controller on IRQ 14 seems to be accessed a
lot.  Is that your system drive, or where recordings get stored, or
something else?



> > 2. To turn on debugging to /var/log/messages and save some memory, as
> > root, could you
> 
> > # service mythbackend stop    (or otherwise kill the backend)
> > # modprobe -r cx18
> > # modprobe cx18 debug=7 enc_ts_bufsize=32 enc_ts_bufs=64 \
> >    enc_yuv_bufs=0 enc_idx_bufs=0
> 
> > Please provide your /var/log/messages output to the list (or to me, if
> > it is too big).
> 
> I didn't test with mplayer, but I played some Live TV in MythTV and here is some debug output I got once I started watching. The video was still tearing and artifact-ing.
> 
> Mar 17 20:54:19 codebeast kernel: [96935.942665] cx18-0:  info: Start feed: pid = 0x1ffb index = 7
> Mar 17 20:55:41 codebeast kernel: [97017.160151] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:55:56 codebeast kernel: [97032.184180] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:55:56 codebeast kernel: [97032.280670] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:56:12 codebeast kernel: [97048.676352] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:56:30 codebeast kernel: [97066.160835] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:56:31 codebeast kernel: [97067.260070] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:57:17 codebeast kernel: [97113.900127] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:57:23 codebeast kernel: [97119.308397] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
> Mar 17 20:57:48 codebeast kernel: [97144.551274] cx18-0:  info: Stop feed: pid = 0x0 index = 0

First, I'm somewhat surprised you got only these.  I'll assume you were
able to turn the driver debugging on and this is all you got during a
single digital capture.

The messages are, well, normal.  That doesn't make them right, but they
do happen.  Here's how:

When an application, like MythTV, reads data from the cx18 driver, and
empties an internal driver buffer, the driver immediately tries to
return the buffer to them CX23418 firmware with a CX18_CPU_DE_SET_MDL
call and waits for an interrupt from the CX23418 to acknowledge the
command.

Most of the time, the CX23418 firmware immediately acknowledges the
buffer handover with an interrupt.  Then cx18 driver then goes back to
providing data to the application and eventually completes the
application's read() call and returns control to the application
(MythTV).

Some of the time the CX23418 firmware doesn't respond for a really long
time.  While the cx18 driver is waiting for the firmware to respond, the
driver "sleeps" (for up to 10 ms) in the application's (MythTV's) call
to read().  This means MythTV is getting suspended for up to 12 msec at
a time when this happens.  For a timing reference, an NTSC video field
happens every 17 mesc or an NTSC frame happens every 33 msec.


I don't know why the CX23418 firmware takes so long to respond with an
acknowledgement sometimes.  I picked the value 10 ms as a timeout,
because experiments had shown that gave enough time for all but the
worst outlyer delays to be acknowledged.  I suppose I could modify the
driver to give back buffers in a workhandler and not delay the
application (MythTV) call to read().


Looking at your data, these long timeouts occured at intervals of 82,
15, 0.096, 16, 18, 1.1, 47 and 5 seconds apart.  Do those intervals
correspond to about when you see the "tears" is the recorded video?



> Do I need a new motherboard?

First let me say, that most multimedia systems that I have seen (that
excludes HTPCs), have more than one processor or core.  The few extra
dollars make a lot of annoying problems a non-issue.  The does not mean
a single processor machine like yours can't do the job. 

Do you have to replce your motherboard?  I'm going to give you a
qualified "no".  Not until you take some steps to try and improve things
with what you have.


1.  Change line 567 in linux/drivers/media/video/cx18/cx18-mailbox.c
from

	timeout = msecs_to_jiffies((info->flags & API_FAST) ? 10 : 20);

to
	
	timeout = msecs_to_jiffies((info->flags & API_FAST) ? 2 : 20);

and recompile and reinstall the cx18 driver.  See if the artifacts are
less frequent.  You'll likely get more log messages about
CX18_CPU_DE_SET_MDL timing out, but they are just a warning.  The
firmware seems to get them OK anyway, despite not sending an
acknowledgement.


2.  Try modifying the enc_ts_bufsize module parameter from it's default
of 32 k, down to 4 k or up to 128 k.  With a smaller size, the loss of
any one buffer from the encoder will not have such a devastating effect
on the MPEG TS, but interrupts will happen more frequently.  With a
larger size, you're less likely to see the timeout errors in your logs,
and the interrupt rate will be lower.

Make sure you use enc_ts_bufs=64 when you set the buffer size small.


3.  Check if you system states it is using SWIOTLB in the dmesg
or /var/log/messages log.  This means that some DMA buffers on your
system *may* have to be copied around by the kernel with memcpy after
PCI hardware DMA's data into memory.  This is generally undesirable as
it consumes CPU that could be used for other things.


4.  Try and keep uneeded hardware devices (the ethernet controller,
other disks aside from where the data is being recorded) as "quiet" as
possible when capturing video.  The PCI bus is a shared bus between
devices and driver interrupt routines will disable the single CPU from
servicing interrupts.  This will mean less time on the bus from the
CX23418 hardware and/or delays in servicing interrupts from the
CX23418. 


5. Try and write the video recordings to the SATA disk drive, vs one
that is connected to the parallel IDE interface (ribbon cable).


6. Try recording video without watching it at the same time (a scheduled
recording).  When you watch it later, are the artifacts there?


> This board only has 2 PCI slots. The other one is populated with an SB
> Live 5.1 sound card. Should I try removing the sound card and put the
> TV card in its place? 

No.  The amount of data needed by the sound card over a given time
period is rather small.  If the linux driver for the EMU10K1 has a
sensible irq_handler that doesn't keep interrupts disabled for too long,
then I doubt it's a big factor.


> I can always use the on-board sound if the SB Live card is causing
> some sort of conflict or IRQ contention.

You can if you want.  But you're only trading one sound card and linux
driver for another.  The biggest difference would be which one has the
linux driver that has an irq_handler that keeps interrupts disabled for
the shortest amount of time. 


> What about tweaking my BIOS settings. Would messing with IRQ or
> HyperTransport settings make a difference?

The only thing I can think that might help there is having the IDE
devices connected to the parallel IDE interface run at the fastest mode
available.  That's usualy the BIOS default though.



>  Does my motherboard not have the bandwidth to keep up with this card?

I don't know.  I have very little details on it.  But...

A PCI bus is a PCI bus.  The PCI bus width is 32 bits and the clock
period is 30 ns.  Maximum IO bandwidth for any PCI bus motherboard with
the same mix of IO devices we be comparable.

CPU thoughput (MIPS) may be an issue.  Another core or CPU makes life
easier.

Interuupt processing latency may be an issue.  If linux drivers are
keeping interrupts disabled for too long in their irq_handlers, other
drivers suffer.  This has a larger impact on single processor
machines.  



> Thanks again!

You're welcome.

Regards,
Andy

