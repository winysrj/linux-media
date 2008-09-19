Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kgjt4-00041k-28
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 19:35:23 +0200
Received: from host-245-80.pubnet.pdx.edu
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7G0007HE5NURC0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 19 Sep 2008 13:34:37 -0400 (EDT)
Date: Fri, 19 Sep 2008 13:34:35 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <d77717b60809190029p4bdcdda6g55db6a9261673675@mail.gmail.com>
To: Bill McCartney <billmccartney@gmail.com>
Message-id: <48D3E2AB.9010701@linuxtv.org>
MIME-version: 1.0
References: <d77717b60809190029p4bdcdda6g55db6a9261673675@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 - can't find the card
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

Bill McCartney wrote:
> Well, I'm not sure if it is a DVB problem. The hvr-1800 shows up in my 
> lspci, but driver doesn't load. I have tried kernels version 2.26.24 and 
> 2.26.25.7 <http://2.26.25.7>, removed all other cards from the system - 
> and still have the same problem.
> 
> Output when I try to install the driver
> cx23885 driver version 0.0.1 loaded
> cx23885[0]: can't get MMIO memory @ 0x0
> CORE cx23885[0] No more PCIe resources for subsystem: 0070:7801
> cx23885: probe of 0000:03:00.0 failed with error -22
> 
> The output of my lspci -v (of the card)
> 03:00.0 Multimedia video controller: Conexant Unknown device 8880 (rev 0f)
>         Subsystem: Hauppauge computer works Inc. Unknown device 7801
>         Flags: bus master, fast devsel, latency 0, IRQ 10
>         Memory at <ignored> (64-bit, non-prefetchable)
>         Capabilities: [40] Express Endpoint IRQ 0
>         Capabilities: [80] Power Management version 2
>         Capabilities: [90] Vital Product Data
>         Capabilities: [a0] Message Signalled Interrupts: 64bit+ 
> Queue=0/0 Enable-
> 
> In my kernel logs I see this from the bootlogs:
> PCI: Cannot allocate resource region 0 of device 0000:03:00.0
> 
> I've tried several kernel options as far as pci configuration goes -- 
> does this mean that I have bad hardware? Should I just return it to the 
> store? Is it a conflict with my motherboard?

Returning this to the store isn't going to fix the problem. You have a 
limited about of memory allocated to PCI devices and you have no more 
free for the HVR1800.

 From memory the kernel allocates 512MB (?) for PCI address space, which 
gets allocated out to devices. The HVR1800 needs 64MB(?) of address 
space, and the kernel doesn't have that free. (My numbers are sketchy 
but the same principle stands).

Check lspci -vn and see which of your devices need large amounts of ram 
  (typically video cards).

For test purposes, removing another card to free some PCI space, this 
will allow you to test the hardware, loading the driver after this 
should be fine. (Again, for test purposes only).

Increasing the amount of PCI ram available for allocation may be a 
kernel boot-time setting. I haven't look to be honest, as I don't 
experience this issue.... although occasionally other user have (with 
different cards and different driver trees).

I'm traveling this week so I have very little access to source code and 
hardware numbers, so if anyone has better numbers or can increase the 
PCI allocation then I'd be interested to hear their comments.

Regards,

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
