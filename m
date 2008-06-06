Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeno.zoli@gmail.com>) id 1K4ZA8-0003Xg-RT
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 12:27:13 +0200
Received: by gv-out-0910.google.com with SMTP id n29so436674gve.16
	for <linux-dvb@linuxtv.org>; Fri, 06 Jun 2008 03:27:09 -0700 (PDT)
Message-ID: <45e226e50806060327s7e3ecf86wb9141ee394e854d1@mail.gmail.com>
Date: Fri, 6 Jun 2008 12:27:08 +0200
From: "Zeno Zoli" <zeno.zoli@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy S2 PCI HD ioctl DVBFE_GET_INFO failed:
	Operation not supported
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0449337491=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0449337491==
Content-Type: multipart/alternative;
	boundary="----=_Part_1067_13648524.1212748028828"

------=_Part_1067_13648524.1212748028828
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I'm new to DVB on linux, but have some linux experience. I have trouble to
get my new Terratec Cinergy S2 PCI HD to work properly. I have followed the
guide here:
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI

I get "ioctl DVBFE_GET_INFO failed: Operation not supported"
when I try to ./scan -vv dvb-s/Thor-1.0W ( more info below)

Could it be related to my choice of Ubuntu 2.6.24-16-server?
Thanks for your help.

Zeno.


uname -a
Linux htpc 2.6.24-16-server #1 SMP i686 GNU/Linux

/home/htpc/scan# ./scan -vv dvb-s/Thor-1.0W
scanning dvb-s/Thor-1.0W
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 11247000 V 24500000 24500000
initial transponder 11293000 H 24500000 24500000
initial transponder 11325000 H 24500000 24500000
initial transponder 12054000 H 28000000 28000000
initial transponder 12169000 H 28000000 28000000
initial transponder 12226000 V 28000000 28000000
ioctl DVBFE_GET_INFO failed: Operation not supported
ioctl DVBFE_GET_INFO failed: Operation not supported
ioctl DVBFE_GET_INFO failed: Operation not supported
ioctl DVBFE_GET_INFO failed: Operation not supported
ioctl DVBFE_GET_INFO failed: Operation not supported
ioctl DVBFE_GET_INFO failed: Operation not supported
ERROR: initial tuning failed
dumping lists (0 services)

lsmod

lnbp21                  3200  1 mantis
mb86a16                21632  1 mantis
stb6100                 8836  1 mantis
tda10021                7684  1 mantis
tda10023                7300  1 mantis
stb0899                36224  1 mantis
stv0299                11528  1 mantis
dvb_core               89212  2 mantis,stv0299


dmesg

 36.793511] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (02:09.0),
[   36.793513]     Mantis Rev 1 [153b:1179], irq: 20, latency: 64
[   36.793515]     memory: 0xfddff000, mmio: 0xf8a54000
[   36.796981]     MAC Address=[00:08:ca:1c:a8:e9]
[   36.797011] mantis_alloc_buffers (0): DMA=0x37560000 cpu=0xf7560000
size=65536
[   36.797061] mantis_alloc_buffers (0): RISC=0x37501000 cpu=0xf7501000
size=1000
[   36.797107] DVB: registering new adapter (Mantis dvb adapter)
[   37.345712] stb0899_get_dev_id: Device ID=[8], Release=[2]
[   37.358369] stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
[   37.371023] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
[   37.371074] stb0899_attach: Attaching STB0899
[   37.371076] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend
@0x68
[   37.371135] stb6100_attach: Attaching STB6100
[   37.371491] DVB: registering frontend 0 (STB0899 Multistandard)...
[   37.371523] mantis_ca_init (0): Registering EN50221 device
[   37.372914] mantis_ca_init (0): Registered EN50221 device
[   37.372973] mantis_hif_init (0): Adapter(0) Initializing Mantis Host
Interface

lspci -v
02:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1179
        Flags: bus master, medium devsel, latency 64, IRQ 20
        Memory at fddff000 (32-bit, prefetchable) [size=4K]

------=_Part_1067_13648524.1212748028828
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br>I&#39;m new to DVB on linux, but have some linux experience. I have trouble to get my new Terratec Cinergy S2 PCI HD to work properly. I have followed the guide here:<br><a href="http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI">http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI</a><br>
<br>I get &quot;ioctl DVBFE_GET_INFO failed: Operation not supported&quot;<br>when I try to ./scan -vv dvb-s/Thor-1.0W ( more info below)<br><br>Could it be related to my choice of Ubuntu 2.6.24-16-server?<br>Thanks for your help.<br>
<br>Zeno.<br><br><br>uname -a<br>Linux htpc 2.6.24-16-server #1 SMP i686 GNU/Linux<br><br>/home/htpc/scan# ./scan -vv dvb-s/Thor-1.0W <br>scanning dvb-s/Thor-1.0W<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>
initial transponder 11247000 V 24500000 24500000<br>initial transponder 11293000 H 24500000 24500000<br>initial transponder 11325000 H 24500000 24500000<br>initial transponder 12054000 H 28000000 28000000<br>initial transponder 12169000 H 28000000 28000000<br>
initial transponder 12226000 V 28000000 28000000<br>ioctl DVBFE_GET_INFO failed: Operation not supported<br>ioctl DVBFE_GET_INFO failed: Operation not supported<br>ioctl DVBFE_GET_INFO failed: Operation not supported<br>ioctl DVBFE_GET_INFO failed: Operation not supported<br>
ioctl DVBFE_GET_INFO failed: Operation not supported<br>ioctl DVBFE_GET_INFO failed: Operation not supported<br>ERROR: initial tuning failed<br>dumping lists (0 services)<br><br>lsmod<br><br>lnbp21&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3200&nbsp; 1 mantis<br>
mb86a16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 21632&nbsp; 1 mantis<br>stb6100&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8836&nbsp; 1 mantis<br>tda10021&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7684&nbsp; 1 mantis<br>tda10023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7300&nbsp; 1 mantis<br>stb0899&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 36224&nbsp; 1 mantis<br>stv0299&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11528&nbsp; 1 mantis<br>
dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 89212&nbsp; 2 mantis,stv0299<br><br><br>dmesg<br><br>&nbsp;36.793511] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (02:09.0),<br>[&nbsp;&nbsp; 36.793513]&nbsp;&nbsp;&nbsp;&nbsp; Mantis Rev 1 [153b:1179], irq: 20, latency: 64<br>[&nbsp;&nbsp; 36.793515]&nbsp;&nbsp;&nbsp;&nbsp; memory: 0xfddff000, mmio: 0xf8a54000<br>
[&nbsp;&nbsp; 36.796981]&nbsp;&nbsp;&nbsp;&nbsp; MAC Address=[00:08:ca:1c:a8:e9]<br>[&nbsp;&nbsp; 36.797011] mantis_alloc_buffers (0): DMA=0x37560000 cpu=0xf7560000 size=65536<br>[&nbsp;&nbsp; 36.797061] mantis_alloc_buffers (0): RISC=0x37501000 cpu=0xf7501000 size=1000<br>
[&nbsp;&nbsp; 36.797107] DVB: registering new adapter (Mantis dvb adapter)<br>[&nbsp;&nbsp; 37.345712] stb0899_get_dev_id: Device ID=[8], Release=[2]<br>[&nbsp;&nbsp; 37.358369] stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]<br>[&nbsp;&nbsp; 37.371023] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]<br>
[&nbsp;&nbsp; 37.371074] stb0899_attach: Attaching STB0899 <br>[&nbsp;&nbsp; 37.371076] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend @0x68<br>[&nbsp;&nbsp; 37.371135] stb6100_attach: Attaching STB6100 <br>[&nbsp;&nbsp; 37.371491] DVB: registering frontend 0 (STB0899 Multistandard)...<br>
[&nbsp;&nbsp; 37.371523] mantis_ca_init (0): Registering EN50221 device<br>[&nbsp;&nbsp; 37.372914] mantis_ca_init (0): Registered EN50221 device<br>[&nbsp;&nbsp; 37.372973] mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface<br><br>lspci -v<br>
02:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: TERRATEC Electronic GmbH Unknown device 1179<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 64, IRQ 20<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Memory at fddff000 (32-bit, prefetchable) [size=4K]<br>

------=_Part_1067_13648524.1212748028828--


--===============0449337491==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0449337491==--
