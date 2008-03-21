Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JcoCD-0008SF-9s
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 21:50:38 +0100
Message-ID: <47E41F92.4000503@gmail.com>
Date: Sat, 22 Mar 2008 00:50:26 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Timo Fager <tfager@gmail.com>
References: <9f6a68760803211320h9838b7dl9aa6461848fbfd9c@mail.gmail.com>
In-Reply-To: <9f6a68760803211320h9838b7dl9aa6461848fbfd9c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy C PCI again
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

Timo Fager wrote:
> Hi,
> 
> This is regarding a previous thread concerning Terratec Cinergy C PCI:
> 
> http://marc.info/?l=linux-dvb&m=120059268408703&w=2
> 
> I also purchased the Terratec Cinergy C PCI card, and installed
> the mantis driver, but to my surprise it didn't recognize the
> card at all. The reason turned out to be that the PCI ID is
> just a bit different (0x4c35 instead of 0x4e35)
> 
> lspci -vvn:
> 
> 00:0f.0 0480: 1822:4c35 (rev 01)
>         Subsystem: 153b:1178
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR+ <PERR+
>         Latency: 64 (2000ns min, 63250ns max)
>         Interrupt: pin A routed to IRQ 5
>         Region 0: Memory at cddff000 (32-bit, prefetchable) [size=4K]
> 
> Then I was courageous enough to simply change the ID in the source code.
> This caused the whole computer to hang immediately after inserting the
> module.
> However, during bootup the driver actually tried to recognize the card,
> with these results:
> 
> kern.log:
> 
> Mar 12 21:00:23 hawk kernel: [   51.359517] ACPI: PCI Interrupt 0000:00:0f.0[A]
> -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
> Mar 12 21:00:23 hawk kernel: [   51.366388] irq: 5, latency: 64
> Mar 12 21:00:23 hawk kernel: [   51.366391]  memory: 0xcddff000, mmio:
> 0xf8864000
> Mar 12 21:00:23 hawk kernel: [   51.366398] found a VP-2040 PCI DVB-C device
> on (00:0f.0),
> Mar 12 21:00:23 hawk kernel: [   51.366404]     Mantis Rev 1 [153b:1178],
> irq: 5, latency: 64
> Mar 12 21:00:23 hawk kernel: [   51.366410]     memory: 0xcddff000, mmio:
> 0xf8864000
> Mar 12 21:00:23 hawk kernel: [   51.432789]     MAC
> Address=[ff:ff:ff:ff:ff:ff]
> Mar 12 21:00:23 hawk kernel: [   51.432926] mantis_alloc_buffers (0):
> DMA=0x33f10000 cpu=0xf3f10000 size=65536
> Mar 12 21:00:23 hawk kernel: [   51.432937] mantis_alloc_buffers (0):
> RISC=0x33ef9000 cpu=0xf3ef9000 size=1000
> Mar 12 21:00:23 hawk kernel: [   51.432945] DVB: registering new adapter
> (Mantis dvb adapter)
> Mar 12 21:00:23 hawk kernel: [   51.895885] input: PC Speaker as
> /class/input/input5
> Mar 12 21:00:23 hawk kernel: [   51.949954] mantis_frontend_init (0):
> Probing for CU1216 (DVB-C)
> Mar 12 21:00:23 hawk kernel: [   51.952061] mantis_frontend_init (0): !!! NO
> Frontends found !!!
> 
> The frontend, however, didn't match. At this point I don't easily see a
> solution,
> do you have any suggestions? Is it possible that there's another version of
> the card with different components? I can look for product codes in the card
> if
> that is helpful.
> 

Does manually attaching the TDA10021 frontend help, instead of the
TDA10023 ? (in mantis_dvb.c)


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
