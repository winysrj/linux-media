Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1JmaSC-0000uh-39
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 22:11:32 +0200
Message-ID: <4807AEEC.5040104@kolumbus.fi>
Date: Thu, 17 Apr 2008 23:11:24 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: bas@kompasmedia.nl
References: <da94aba5e3e1f0c3c823a33d94b32f9b@localhost>
In-Reply-To: <da94aba5e3e1f0c3c823a33d94b32f9b@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis 2033: tuning still fails
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

You could first try to use nonencrypted channels only by removing the CA,
to verify that it works without the CA.

Twinhan 2033 works for me wit jusst.de sources, although I haven't
tested the latest revision.

There exists remote control code also for 2033 although it hasn't been
applied into jusst.de.

Regards,
Marko Ristola

Bas v.d. Wiel wrote:
> Hello all,
> Slowly my Twinhan card is coming to life. Sadly though, tuning fails on all
> frequencies. I saw a post on this subject from a few weeks ago. Changing
> the tuner from tda10021 to tda10023 helped a lot in that case, but I have
> absolutely no idea how to do this. I looked over a lot of source code to
> see if I could find where the tuner chip gets determined, but to no avail.
> My C skills aren't good enough I fear.. The output of dmesg shows this:
>
> ACPI: PCI interrupt for device 0000:01:09.0 disabled
> ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC2] -> GSI 17 (level, low)
> -> IRQ 20
> irq: 20, latency: 32
>  memory: 0xfdeff000, mmio: 0xde8c4000
> found a VP-2033 PCI DVB-C device on (01:09.0),
>     Mantis Rev 1 [1822:0008], irq: 20, latency: 32
>     memory: 0xfdeff000, mmio: 0xde8c4000
>     MAC Address=[00:08:ca:1b:e8:b8]
> mantis_alloc_buffers (0): DMA=0x1d700000 cpu=0xdd700000 size=65536
> mantis_alloc_buffers (0): RISC=0x1cd56000 cpu=0xdcd56000 size=1000
> DVB: registering new adapter (Mantis dvb adapter)
> mantis_frontend_init (0): Probing for CU1216 (DVB-C)
> TDA10021: i2c-addr = 0x0c, id = 0x7d
> mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10021) @
> 0x0c
> mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach
> success
> DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
> CA: Registering Mantis Adapter(0) Slot(0)
>
> Any help would be greatly appreciated!
>
> Bas
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
