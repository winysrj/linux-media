Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f145.mail.ru ([194.67.57.138])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1K4ZRH-0004dR-JM
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 12:44:56 +0200
Received: from mail by f145.mail.ru with local id 1K4ZQk-000ARd-00
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 14:44:22 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Fri, 06 Jun 2008 14:44:22 +0400
References: <45e226e50806060327s7e3ecf86wb9141ee394e854d1@mail.gmail.com>
In-Reply-To: <45e226e50806060327s7e3ecf86wb9141ee394e854d1@mail.gmail.com>
Message-Id: <E1K4ZQk-000ARd-00.goga777-bk-ru@f145.mail.ru>
Subject: Re: [linux-dvb]
	=?koi8-r?b?VGVycmF0ZWMgQ2luZXJneSBTMiBQQ0kgSEQgaW9j?=
	=?koi8-r?b?dGwgRFZCRkVfR0VUX0lORk8gZmFpbGVkOk9wZXJhdGlvbiBub3Qg?=
	=?koi8-r?b?c3VwcG9ydGVk?=
Reply-To: Goga777 <goga777@bk.ru>
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

which scan version do you use ? does it support the multiproto api ?




> I'm new to DVB on linux, but have some linux experience. I have trouble to
> get my new Terratec Cinergy S2 PCI HD to work properly. I have followed the
> guide here:
> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI
> 
> I get "ioctl DVBFE_GET_INFO failed: Operation not supported"
> when I try to ./scan -vv dvb-s/Thor-1.0W ( more info below)
> 
> Could it be related to my choice of Ubuntu 2.6.24-16-server?
> Thanks for your help.
> 
> Zeno.
> 
> 
> uname -a
> Linux htpc 2.6.24-16-server #1 SMP i686 GNU/Linux
> 
> /home/htpc/scan# ./scan -vv dvb-s/Thor-1.0W
> scanning dvb-s/Thor-1.0W
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 11247000 V 24500000 24500000
> initial transponder 11293000 H 24500000 24500000
> initial transponder 11325000 H 24500000 24500000
> initial transponder 12054000 H 28000000 28000000
> initial transponder 12169000 H 28000000 28000000
> initial transponder 12226000 V 28000000 28000000
> ioctl DVBFE_GET_INFO failed: Operation not supported
> ioctl DVBFE_GET_INFO failed: Operation not supported
> ioctl DVBFE_GET_INFO failed: Operation not supported
> ioctl DVBFE_GET_INFO failed: Operation not supported
> ioctl DVBFE_GET_INFO failed: Operation not supported
> ioctl DVBFE_GET_INFO failed: Operation not supported
> ERROR: initial tuning failed
> dumping lists (0 services)
> 
> lsmod
> 
> lnbp21                  3200  1 mantis
> mb86a16                21632  1 mantis
> stb6100                 8836  1 mantis
> tda10021                7684  1 mantis
> tda10023                7300  1 mantis
> stb0899                36224  1 mantis
> stv0299                11528  1 mantis
> dvb_core               89212  2 mantis,stv0299
> 
> 
> dmesg
> 
>  36.793511] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (02:09.0),
> [   36.793513]     Mantis Rev 1 [153b:1179], irq: 20, latency: 64
> [   36.793515]     memory: 0xfddff000, mmio: 0xf8a54000
> [   36.796981]     MAC Address=[00:08:ca:1c:a8:e9]
> [   36.797011] mantis_alloc_buffers (0): DMA=0x37560000 cpu=0xf7560000
> size=65536
> [   36.797061] mantis_alloc_buffers (0): RISC=0x37501000 cpu=0xf7501000
> size=1000
> [   36.797107] DVB: registering new adapter (Mantis dvb adapter)
> [   37.345712] stb0899_get_dev_id: Device ID=[8], Release=[2]
> [   37.358369] stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
> [   37.371023] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
> [   37.371074] stb0899_attach: Attaching STB0899
> [   37.371076] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend
> @0x68
> [   37.371135] stb6100_attach: Attaching STB6100
> [   37.371491] DVB: registering frontend 0 (STB0899 Multistandard)...
> [   37.371523] mantis_ca_init (0): Registering EN50221 device
> [   37.372914] mantis_ca_init (0): Registered EN50221 device
> [   37.372973] mantis_hif_init (0): Adapter(0) Initializing Mantis Host
> Interface
> 
> lspci -v
> 02:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
> Bridge Controller [Ver 1.0] (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Unknown device 1179
>         Flags: bus master, medium devsel, latency 64, IRQ 20
>         Memory at fddff000 (32-bit, prefetchable) [size=4K]

> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
