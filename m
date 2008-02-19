Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33104.mail.mud.yahoo.com ([209.191.69.134])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JRWxU-0003xh-IM
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 19:12:48 +0100
Date: Tue, 19 Feb 2008 10:11:57 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Gernot Pansy <pansyg@gmx.at>, linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <694662.3577.qm@web33104.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD
	SP400 rebadge)
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

Hi Gernot,

I can confirm that I have similar experience to yours.
By the way do you know if one can control from the soft side (register or some other means)
the max current output for the card. I am having a problem when trying to tune with a rotor.
On the Linux side the current seems to be capped at 300 mA as on the XP I see it goes to
about 440 mA. I was still surprised that this card can supply less current than the 102g but
we take what we get ...

Thanks for the help,
Simeon

----- Original Message ----
From: Gernot Pansy <pansyg@gmx.at>
To: linux-dvb@linuxtv.org
Sent: Monday, February 18, 2008 1:08:59 PM
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD SP400 rebadge)

hy,

the wiki is not up2date. 

Twinhan VP-1041 support is now in the mantis tree (inkl. multiproto)

hg clone http://jusst.de/hg/mantis

but for me, the old initialization parameters works much better. with the new 
ones i get only a destructed picture (unwatchable).  

gernot

On Monday 18 February 2008 20:05:03 Tim Hewett wrote:
> I'm trying to get a new Technisat Skystar HD2 working. It looks like
> it is a Twinhan VP-1041/Azurewave AD SP400 rebadge.
>
> The card hardware and satellite feed has been confirmed to work ok
> under Windows using Technisat's software.
>
> I am using the current multiproto DVB drivers, downloaded today. These
> were patched, built and installed successfully as described for the
> Azurewave AD SP400 in the linuxdvb wiki, but the card was not
> recognised on bootup even though it was allocated a DVB adaptor
> number. This appeared in dmesg:
>
> [   57.359723] found a UNKNOWN PCI UNKNOWN device on (01:06.0),
> [   57.359802]     Mantis Rev 1 [1ae4:0001], irq: 16, latency: 32
> [   57.359858]     memory: 0xe5100000, mmio: 0xffffc200000fc000
> [   57.363015]     MAC Address=[00:08:c9:e0:26:92]
> [   57.363133] mantis_alloc_buffers (0): DMA=0x1b7a0000
> cpu=0xffff81001b7a0000 size=65536
> [   57.363242] mantis_alloc_buffers (0): RISC=0x1ae24000
> cpu=0xffff81001ae24000 size=1000
> [   57.363348] DVB: registering new adapter (Mantis dvb adapter)
>
>
> This is the output of lspci -vvn:
>
> 01:06.0 0480: 1822:4e35 (rev 01)
>     Subsystem: 1ae4:0001
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 32 (2000ns min, 63750ns max)
>     Interrupt: pin A routed to IRQ 16
>     Region 0: Memory at e5100000 (32-bit, prefetchable) [size=4K]
>
> This is the output of lsusb -vv:
>
> 01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
> PCI Bridge Controller [Ver 1.0] (rev 01)
>     Subsystem: Unknown device 1ae4:0001
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 32 (2000ns min, 63750ns max)
>     Interrupt: pin A routed to IRQ 16
>     Region 0: Memory at e5100000 (32-bit, prefetchable) [size=4K]
>
> Note that subsystem IDs 1ae4:0001 are different to those listed in the
> wiki for the Azurewave (1822:0031).
>
> I changed #define MANTIS_VP_1041_DVB_S2    in linux/drivers/media/dvb/
> mantis/mantis_vp1041.h from 0x0031 to 0x0001, which changed the dmesg
> output on reboot to this:
>
> [   59.546375] found a VP-1041 PCI DVB-S/DVB-S2 device on (01:06.0),
> [   59.546456]     Mantis Rev 1 [1ae4:0001], irq: 16, latency: 32
> [   59.546512]     memory: 0xe5100000, mmio: 0xffffc200000fc000
> [   59.549609]     MAC Address=[00:08:c9:e0:26:92]
> [   59.549719] mantis_alloc_buffers (0): DMA=0x1b7b0000
> cpu=0xffff81001b7b0000 size=65536
> [   59.549827] mantis_alloc_buffers (0): RISC=0x1af43000
> cpu=0xffff81001af43000 size=1000
> [   59.549933] DVB: registering new adapter (Mantis dvb adapter)
> [   60.137583] stb0899_attach: Attaching STB0899
> [   60.137665] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2
> frontend @0x68
> [   60.152161] stb6100_attach: Attaching STB6100
> [   60.168021] DVB: registering frontend 3 (STB0899 Multistandard)...
>
> So that change seemed to cause the card to be recognised.
>
> Then I tried the replacement scan and szap as suggested by the
> Azurewave wiki, but the card will not tune.
>
> So it appears to be almost working, but I'm not sure what tests to try
> or changes to make to see if it will work.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb





      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
