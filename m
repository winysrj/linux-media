Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tfager@gmail.com>) id 1JcnjW-00053k-LW
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 21:21:02 +0100
Received: by wf-out-1314.google.com with SMTP id 28so1599137wfa.17
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 13:20:54 -0700 (PDT)
Message-ID: <9f6a68760803211320h9838b7dl9aa6461848fbfd9c@mail.gmail.com>
Date: Fri, 21 Mar 2008 22:20:54 +0200
From: "Timo Fager" <tfager@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy C PCI again
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1685898372=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1685898372==
Content-Type: multipart/alternative;
	boundary="----=_Part_10033_9085111.1206130854285"

------=_Part_10033_9085111.1206130854285
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is regarding a previous thread concerning Terratec Cinergy C PCI:

http://marc.info/?l=linux-dvb&m=120059268408703&w=2

I also purchased the Terratec Cinergy C PCI card, and installed
the mantis driver, but to my surprise it didn't recognize the
card at all. The reason turned out to be that the PCI ID is
just a bit different (0x4c35 instead of 0x4e35)

lspci -vvn:

00:0f.0 0480: 1822:4c35 (rev 01)
        Subsystem: 153b:1178
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR+
        Latency: 64 (2000ns min, 63250ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at cddff000 (32-bit, prefetchable) [size=4K]

Then I was courageous enough to simply change the ID in the source code.
This caused the whole computer to hang immediately after inserting the
module.
However, during bootup the driver actually tried to recognize the card,
with these results:

kern.log:

Mar 12 21:00:23 hawk kernel: [   51.359517] ACPI: PCI Interrupt 0000:00:0f.0[A]
-> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
Mar 12 21:00:23 hawk kernel: [   51.366388] irq: 5, latency: 64
Mar 12 21:00:23 hawk kernel: [   51.366391]  memory: 0xcddff000, mmio:
0xf8864000
Mar 12 21:00:23 hawk kernel: [   51.366398] found a VP-2040 PCI DVB-C device
on (00:0f.0),
Mar 12 21:00:23 hawk kernel: [   51.366404]     Mantis Rev 1 [153b:1178],
irq: 5, latency: 64
Mar 12 21:00:23 hawk kernel: [   51.366410]     memory: 0xcddff000, mmio:
0xf8864000
Mar 12 21:00:23 hawk kernel: [   51.432789]     MAC
Address=[ff:ff:ff:ff:ff:ff]
Mar 12 21:00:23 hawk kernel: [   51.432926] mantis_alloc_buffers (0):
DMA=0x33f10000 cpu=0xf3f10000 size=65536
Mar 12 21:00:23 hawk kernel: [   51.432937] mantis_alloc_buffers (0):
RISC=0x33ef9000 cpu=0xf3ef9000 size=1000
Mar 12 21:00:23 hawk kernel: [   51.432945] DVB: registering new adapter
(Mantis dvb adapter)
Mar 12 21:00:23 hawk kernel: [   51.895885] input: PC Speaker as
/class/input/input5
Mar 12 21:00:23 hawk kernel: [   51.949954] mantis_frontend_init (0):
Probing for CU1216 (DVB-C)
Mar 12 21:00:23 hawk kernel: [   51.952061] mantis_frontend_init (0): !!! NO
Frontends found !!!

The frontend, however, didn't match. At this point I don't easily see a
solution,
do you have any suggestions? Is it possible that there's another version of
the card with different components? I can look for product codes in the card
if
that is helpful.

Thanks in advance,

Timo

------=_Part_10033_9085111.1206130854285
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>This is regarding a previous thread concerning Terratec Cinergy C PCI:<br><br><a href="http://marc.info/?l=linux-dvb&amp;m=120059268408703&amp;w=2" target="_blank">http://marc.info/?l=linux-dvb&amp;m=120059268408703&amp;w=2</a><br>

<br>I also purchased the Terratec Cinergy C PCI card, and installed<br>the mantis driver, but to my surprise it didn&#39;t recognize the<br>card at all. The reason turned out to be that the PCI ID is<br>
just a bit different (0x4c35 instead of 0x4e35)<br><br>lspci -vvn:<br><br>00:0f.0 0480: 1822:4c35 (rev 01)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: 153b:1178<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-<br>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast &gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR+ &lt;PERR+<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Latency: 64 (2000ns min, 63250ns max)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Region 0: Memory at cddff000 (32-bit, prefetchable) [size=4K]<br>


<br>Then I was courageous enough to simply change the ID in the source code.<br>This caused the whole computer to hang immediately after inserting the module.<br>However, during bootup the driver actually tried to recognize the card,<br>


with these results:<br><br>kern.log:<br><br>Mar
12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.359517] ACPI: PCI Interrupt
0000:00:0f.0[A] -&gt; Link [LNKD] -&gt; GSI 5 (level, low) -&gt; IRQ 5<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.366388] irq: 5, latency: 64<br>
Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.366391]&nbsp; memory: 0xcddff000, mmio: 0xf8864000<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.366398] found a VP-2040 PCI DVB-C device on (00:0f.0),<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.366404]&nbsp;&nbsp;&nbsp;&nbsp; Mantis Rev 1 [153b:1178], irq: 5, latency: 64<br>


Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.366410]&nbsp;&nbsp;&nbsp;&nbsp; memory: 0xcddff000, mmio: 0xf8864000<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.432789]&nbsp;&nbsp;&nbsp;&nbsp; MAC Address=[ff:ff:ff:ff:ff:ff]<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.432926] mantis_alloc_buffers (0): DMA=0x33f10000 cpu=0xf3f10000 size=65536<br>


Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.432937] mantis_alloc_buffers (0): RISC=0x33ef9000 cpu=0xf3ef9000 size=1000<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.432945] DVB: registering new adapter (Mantis dvb adapter)<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.895885] input: PC Speaker as /class/input/input5<br>


Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.949954] mantis_frontend_init (0): Probing for CU1216 (DVB-C)<br>Mar 12 21:00:23 hawk kernel: [&nbsp;&nbsp; 51.952061] mantis_frontend_init (0): !!! NO Frontends found !!!<br><br>The frontend, however, didn&#39;t match. At this point I don&#39;t easily see a solution,<br>


do you have any suggestions? Is it possible that there&#39;s another version of<br>the card with different components? I can look for product codes in the card if<br>that is helpful.<br><br>Thanks in advance,<br><font color="#888888"><font color="#888888"><br>

Timo </font></font>

------=_Part_10033_9085111.1206130854285--


--===============1685898372==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1685898372==--
