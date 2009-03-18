Return-path: <linux-media-owner@vger.kernel.org>
Received: from web56908.mail.re3.yahoo.com ([66.196.97.97]:47938 "HELO
	web56908.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754573AbZCRBIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 21:08:52 -0400
Message-ID: <954486.20343.qm@web56908.mail.re3.yahoo.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>  <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>  <63160.21731.qm@web56906.mail.re3.yahoo.com> <1237251478.3303.37.camel@palomino.walls.org>
Date: Tue, 17 Mar 2009 18:08:50 -0700 (PDT)
From: Corey Taylor <johnfivealive@yahoo.com>
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Andy, thanks for writing back. Here's the info you asked for..

> Well, no.  It's more likely a system level issue.

> 1.  Can you provide the output of 
> $ cat /proc/interrupts

           CPU0       
  0:        104   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  4:          8   IO-APIC-edge    
  7:          1   IO-APIC-edge      parport0
  8:          0   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 12:          4   IO-APIC-edge      i8042
 14:     777839   IO-APIC-edge      pata_amd
 15:          0   IO-APIC-edge      pata_amd
 17:     760893   IO-APIC-fasteoi   EMU10K1
 18:     189462   IO-APIC-fasteoi   cx18-0
 19:    5936140   IO-APIC-fasteoi   nvidia
 20:   19869131   IO-APIC-fasteoi   eth0
 21:     158197   IO-APIC-fasteoi   sata_nv
 22:          2   IO-APIC-fasteoi   ehci_hcd:usb2
 23:        307   IO-APIC-fasteoi   ohci_hcd:usb1
NMI:          0   Non-maskable interrupts
LOC:    6194711   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
SPU:          0   Spurious interrupts
ERR:          1

> 2. To turn on debugging to /var/log/messages and save some memory, as
> root, could you

> # service mythbackend stop    (or otherwise kill the backend)
> # modprobe -r cx18
> # modprobe cx18 debug=7 enc_ts_bufsize=32 enc_ts_bufs=64 \
>    enc_yuv_bufs=0 enc_idx_bufs=0

> Please provide your /var/log/messages output to the list (or to me, if
> it is too big).

I didn't test with mplayer, but I played some Live TV in MythTV and here is some debug output I got once I started watching. The video was still tearing and artifact-ing.

Mar 17 20:54:19 codebeast kernel: [96935.942665] cx18-0:  info: Start feed: pid = 0x1ffb index = 7
Mar 17 20:55:41 codebeast kernel: [97017.160151] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:55:56 codebeast kernel: [97032.184180] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:55:56 codebeast kernel: [97032.280670] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:56:12 codebeast kernel: [97048.676352] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:56:30 codebeast kernel: [97066.160835] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:56:31 codebeast kernel: [97067.260070] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:57:17 codebeast kernel: [97113.900127] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:57:23 codebeast kernel: [97119.308397] cx18-0:  warning: sending CX18_CPU_DE_SET_MDL timed out waiting 12 msecs for RPU acknowledgement
Mar 17 20:57:48 codebeast kernel: [97144.551274] cx18-0:  info: Stop feed: pid = 0x0 index = 0

Do I need a new motherboard?

This board only has 2 PCI slots. The other one is populated with an SB Live 5.1 sound card. Should I try removing the sound card and put the TV card in its place? I can always use the on-board sound if the SB Live card is causing some sort of conflict or IRQ contention.

What about tweaking my BIOS settings. Would messing with IRQ or HyperTransport settings make a difference? Does my motherboard not have the bandwidth to keep up with this card?

Thanks again!



      
