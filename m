Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAC230x7018937
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 21:03:00 -0500
Received: from smtp107.rog.mail.re2.yahoo.com (smtp107.rog.mail.re2.yahoo.com
	[68.142.225.205])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAC22jHV020996
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 21:02:45 -0500
Message-ID: <491A3937.80304@rogers.com>
Date: Tue, 11 Nov 2008 21:02:31 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: larrykathy3@verizon.net, linux-dvb@linuxtv.org,
	V4L <video4linux-list@redhat.com>
References: <912472.64545.qm@web84108.mail.mud.yahoo.com>
In-Reply-To: <912472.64545.qm@web84108.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: [linux-dvb] Geniatech x8000 thriller
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

Ruth Fernandez wrote:
> Thanks a lot, some success. Here is the lspci -vn. I added the dmesg.
> As you see the modprobe alsa is not working(no sound).
>
>
> 00:0c.0 0400: 14f1:8800 (rev 05)
>     Subsystem: 14f1:1419
>     Flags: bus master, medium devsel, latency 32, IRQ 19
>     Memory at f4000000 (32-bit, non-prefetchable) [size=16M]
>     Capabilities: [44] Vital Product Data
>     Capabilities: [4c] Power Management version 2
>
> 00:0c.1 0480: 14f1:8811 (rev 05)
>     Subsystem: 14f1:1419
>     Flags: bus master, medium devsel, latency 32, IRQ 11
>     Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
>     Capabilities: [4c] Power Management version 2
>
> 00:0c.2 0480: 14f1:8802 (rev 05)
>     Subsystem: 14f1:1419
>     Flags: bus master, medium devsel, latency 32, IRQ 19
>     Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
>     Capabilities: [4c] Power Management version 2
>
>
>   44.882700] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> [   44.882945] cx88[0]: subsystem: 14f1:1419, board: Kworld PlusTV HD
> PCI 120 (ATSC 120) [card=67,insmod option], frontend(s): 1
> [   44.882949] cx88[0]: TV tuner type 71, Radio tuner type 1
> [   44.990981] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> [   45.040857] ACPI: Power Button (CM) [PWRB]
> [   45.168278] tuner' 1-0061: chip found @ 0xc2 (cx88[0])
> [   45.655484] cx88_alsa: disagrees about version of symbol
> videobuf_dma_free
> [   45.655491] cx88_alsa: Unknown symbol videobuf_dma_free
> [   45.655574] cx88_alsa: disagrees about version of symbol cx88_core_put
> [   45.655578] cx88_alsa: Unknown symbol cx88_core_put
> [   45.655720] cx88_alsa: Unknown symbol videobuf_pci_alloc
> [   45.655783] cx88_alsa: disagrees about version of symbol cx88_core_irq
> [   45.655787] cx88_alsa: Unknown symbol cx88_core_irq
> [   45.655861] cx88_alsa: disagrees about version of symbol cx88_core_get
> [   45.655865] cx88_alsa: Unknown symbol cx88_core_get
> [   45.656160] cx88_alsa: disagrees about version of symbol
> btcx_riscmem_free
> [   45.656165] cx88_alsa: Unknown symbol btcx_riscmem_free
> [   45.656381] cx88_alsa: disagrees about version of symbol
> videobuf_dma_init
> [   45.656385] cx88_alsa: Unknown symbol videobuf_dma_init
> [   45.656508] cx88_alsa: disagrees about version of symbol
> cx88_sram_channel_dump
> [   45.656512] cx88_alsa: Unknown symbol cx88_sram_channel_dump
> [   45.656588] cx88_alsa: disagrees about version of symbol
> cx88_sram_channel_setup
> [   45.656592] cx88_alsa: Unknown symbol cx88_sram_channel_setup
> [   45.656662] cx88_alsa: disagrees about version of symbol
> videobuf_dma_init_kernel
> [   45.656667] cx88_alsa: Unknown symbol videobuf_dma_init_kernel
> [   45.656781] cx88_alsa: Unknown symbol videobuf_pci_dma_unmap
> [   45.656907] cx88_alsa: Unknown symbol videobuf_pci_dma_map
> [   45.656980] cx88_alsa: disagrees about version of symbol
> cx88_risc_databuffer
> [   45.656984] cx88_alsa: Unknown symbol cx88_risc_databuffer
> [   45.657041] cx88_alsa: disagrees about version of symbol
> videobuf_to_dma
> [   45.657045] cx88_alsa: Unknown symbol videobuf_to_dma
> [   45.782372] tuner-simple 1-0061: creating new instance
> [   45.782378] tuner-simple 1-0061: type set to 1 (Philips PAL_I
> (FI1246 and compatibles))
> [   45.783204] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
> [   45.783219] cx88[0]/2: cx2388x 8802 Driver Manager
> [   45.783248] ACPI: PCI Interrupt 0000:00:0c.2[A] -> GSI 16 (level,
> low) -> IRQ 19
> [   45.783264] cx88[0]/2: found at 0000:00:0c.2, rev: 5, irq: 19,
> latency: 32, mmio: 0xf6000000
> [   45.783288] cx8802_probe() allocating 1 frontend(s)
> [   45.783566] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level,
> low) -> IRQ 19
> [   45.783582] cx88[0]/0: found at 0000:00:0c.0, rev: 5, irq: 19,
> latency: 32, mmio: 0xf4000000
> [   45.783656] cx88[0]/0: registered device video0 [v4l2]
> [   45.783709] cx88[0]/0: registered device vbi0
> [   45.783743] cx88[0]/0: registered device radio0
> [   45.844799] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
> [   46.042785] cx88/2: cx2388x dvb driver version 0.0.6 loaded
> [   46.042792] cx88/2: registering cx8802 driver, type: dvb access: shared
> [   46.042798] cx88[0]/2: subsystem: 14f1:1419, board: Kworld PlusTV
> HD PCI 120 (ATSC 120) [card=67]
> [   46.042803] cx88[0]/2: cx2388x based DVB/ATSC card
> [   46.452168] xc2028 1-0061: creating new instance
> [   46.452181] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [   46.452187] cx88[0]/2: xc3028 attached
> [   46.453497] DVB: registering new adapter (cx88[0])
> [   46.453506] DVB: registering adapter 0 frontend 0 (Samsung S5H1409
> QAM/8VSB Frontend)...
> [   46.503575] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level,
> low) -> IRQ 20
> [   46.503738] PCI: Setting latency timer of device 0000:00:11.5 to 64
>
>
> --- On *Sat, 11/8/08, CityK /<cityk@rogers.com>/* wrote:
>
>     From: CityK <cityk@rogers.com>
>     Subject: Re: [linux-dvb] Geniatech x8000 thriller
>     To: larrykathy3@verizon.net
>     Cc: linux-dvb@linuxtv.org
>     Date: Saturday, November 8, 2008, 11:19 PM
>
>
>     Ruth Fernandez wrote:
>     > I have a Geniatech x8000 thriller ATSC card. The only way Ubuntu will
>     > see it is with the ismod option in the etc/modprobe.d/option file. The
>     > ATSC part is not recognized. Plus there is no sound. Can you help.
>     > Larry -dmesg below
>     >
>     >  44.901324] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
>     > [   44.901560] cx88[0]: subsystem: 14f1:1419, board: Geniatech
>     > X8000-MT DVBT [card=63,insmod option], frontend(s): 1
>     >
>
>     Wrong card option; card 63 is for the DVB-T version of the card and,
>     consequently,
>      explains why the wrong components are being loaded.  Use
>     card=67 instead.  There may be further info for you in: 
>     http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120
>
>     Can you report your success on the matter and also supply the output of
>     "lspci -vn" (to see what the PCI subsystem ID for the card is, and as
>     to
>     whether it differs from the KWorld card).  Thanks.
>               
>

Hi Ruth,

Please make sure to copy the lists in, so that everyone can share in
with the info (I've added them back in and included your reply).

I started up a page in the wiki for the card:
http://www.linuxtv.org/wiki/index.php/Geniatech_HDTV_Thriller_X8000A
if you would like to contribute anything to it please feel free.

If you'd like to get native support for the card added into the kernel
(thus benefiting all users), you could submit a patch -- likely a very
simple copy and paste/adjustment of the info for the KWorld 120 -- see
the diffs from here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99e09eac25f752b25f65392da7bd747b77040fea

So, just so we're clear, I take it that your success  was that both
analog and ATSC worked, but you weren't successful with analog audio?



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
