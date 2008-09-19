Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s9.bay0.hotmail.com ([65.54.246.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefan_ell@hotmail.com>) id 1KgdR9-0000MX-Oy
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 12:42:10 +0200
Message-ID: <BAY108-W49816DC274A6E8D70E62DFE4E0@phx.gbl>
From: Stefan Ellenberger <stefan_ell@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Fri, 19 Sep 2008 12:41:32 +0200
MIME-Version: 1.0
Subject: [linux-dvb] =?windows-1256?q?_VP_1041_CAM=3A_dvb=5Fca_adapter_0?=
 =?windows-1256?q?=3A_Invalid_PC_card_inserted=FE?=
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


Hi list

If I attach the Common Interface to the card (Twinhan VP 1041) and reload the mantis modules dmesg output is the following:

[ 6979.969526] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 21
[ 6979.969562] irq: 21, latency: 32
[ 6979.969566]  memory: 0xd5100000, mmio: 0xf8c1c000
[ 6979.969573] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (01:06.0),
[ 6979.969576]     Mantis Rev 1 [1822:0031], irq: 21, latency: 32
[ 6979.969579]     memory: 0xd5100000, mmio: 0xf8c1c000
[ 6979.972276]     MAC Address=[00:08:ca:1c:3f:4c]
[ 6979.972312] mantis_alloc_buffers (0): DMA=0x2ef10000 cpu=0xeef10000 size=65536
[ 6979.972319] mantis_alloc_buffers (0): RISC=0x13ddc000 cpu=0xd3ddc000 size=1000
[ 6979.972323] DVB: registering new adapter (Mantis dvb adapter)
[ 6980.520344] stb0899_attach: Attaching STB0899
[ 6980.520353] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend @0x68
[ 6980.520362] stb6100_attach: Attaching STB6100
[ 6980.520715] DVB: registering frontend 0 (STB0899 Multistandard)...
[ 6980.520778] mantis_ca_init (0): Registering EN50221 device
[ 6980.522811] mantis_ca_init (0): Registered EN50221 device
[ 6980.522825] mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
[ 6981.528828] dvb_ca adapter 0: Invalid PC card inserted :(

Since it is the official Viaccess "red cam" (Rev 1.0) I don't understand the problem - this one worked just fine in any STB I ever used - I know I might have to update the CAMs firmware if I want to watch HD content, but nevertheless: shouldn't this work for any non HD content as it does on my STB?

Anyone has issues with the same CAM Revision and mantis cards?
_________________________________________________________________
Die neue Generation der Windows Live Services - jetzt downloaden!
http://get.live.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
