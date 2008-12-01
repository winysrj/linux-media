Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L7HOZ-0007rl-9I
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 23:37:38 +0100
Received: from [192.168.105.214] (ap-dustin.bobrnet.cz [10.109.8.38])
	by mailserver.bobrnet.net (8.13.8/8.13.8/Debian-3) with ESMTP id
	mB1MbVDY019629
	for <linux-dvb@linuxtv.org>; Mon, 1 Dec 2008 23:37:31 +0100
Message-ID: <49346726.7010303@insite.cz>
Date: Mon, 01 Dec 2008 23:37:26 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technisat HD2 cannot szap/scan
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

Hello,


I have studied many pages, tried to make the card work. I can tune and 
view programs in windows.

My setup:

Ubuntu 8.04, P4 32bit, Technisat HD2 connected to dual LNB, A heading to 
Astra 19.2E, B heading to Astra 23.5E

uname -a:
Linux htpc 2.6.24-19-generic #1 SMP


lspci -v:
05:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
Bridge Controller [Ver 1.0] (rev 01)
         Subsystem: Unknown device 1ae4:0003
         Flags: bus master, medium devsel, latency 32, IRQ 22
         Memory at 92000000 (32-bit, prefetchable) [size=4K]


I fetched latest mantis from  http://jusst.de/hg/mantis, changed
#define TECHNISAT_SKYSTAR_HD2  0x0003

make, make install, modprobe mantis

This made the frontend0 appear.

Dec  1 23:11:50 htpc kernel: [13344.143330] ACPI: PCI Interrupt 
0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
Dec  1 23:11:50 htpc kernel: [13344.143365] irq: 22, latency: 32
Dec  1 23:11:50 htpc kernel: [13344.143367]  memory: 0x92000000, mmio: 
0xf8aa8000
Dec  1 23:11:50 htpc kernel: [13344.143372] found a VP-1041 PCI 
DSS/DVB-S/DVB-S2 device on (05:01.0),
Dec  1 23:11:50 htpc kernel: [13344.143375]     Mantis Rev 1 
[1ae4:0003], irq: 22, latency: 32
Dec  1 23:11:50 htpc kernel: [13344.143379]     memory: 0x92000000, 
mmio: 0xf8aa8000
Dec  1 23:11:50 htpc kernel: [13344.147448]     MAC 
Address=[00:08:c9:e0:28:9f]
Dec  1 23:11:50 htpc kernel: [13344.147478] mantis_alloc_buffers (0): 
DMA=0x34350000 cpu=0xf4350000 size=65536
Dec  1 23:11:50 htpc kernel: [13344.147485] mantis_alloc_buffers (0): 
RISC=0x36e5e000 cpu=0xf6e5e000 size=1000
Dec  1 23:11:50 htpc kernel: [13344.147489] DVB: registering new adapter 
(Mantis dvb adapter)
Dec  1 23:11:50 htpc NetworkManager: <debug> [1228169510.540071] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/pci_1822_4e35_dvb').
Dec  1 23:11:50 htpc NetworkManager: <debug> [1228169510.555304] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/pci_1822_4e35_dvb_0').
Dec  1 23:11:50 htpc NetworkManager: <debug> [1228169510.569578] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/pci_1822_4e35_dvb_1').
Dec  1 23:11:51 htpc kernel: [13344.695812] stb0899_attach: Attaching 
STB0899
Dec  1 23:11:51 htpc kernel: [13344.695822] mantis_frontend_init (0): 
found STB0899 DVB-S/DVB-S2 frontend @0x68
Dec  1 23:11:51 htpc kernel: [13344.695830] stb6100_attach: Attaching 
STB6100
Dec  1 23:11:51 htpc kernel: [13344.697324] DVB: registering frontend 0 
(STB0899 Multistandard)...
Dec  1 23:11:51 htpc kernel: [13344.697749] mantis_ca_init (0): 
Registering EN50221 device
Dec  1 23:11:51 htpc kernel: [13344.698963] mantis_ca_init (0): 
Registered EN50221 device
Dec  1 23:11:51 htpc kernel: [13344.698980] mantis_hif_init (0): 
Adapter(0) Initializing Mantis Host Interface
Dec  1 23:11:51 htpc NetworkManager: <debug> [1228169511.091606] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/pci_1822_4e35_dvb_2').
Dec  1 23:11:51 htpc NetworkManager: <debug> [1228169511.106802] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/pci_1822_4e35_dvb_3').





I fetched latest dvb-apps from  http://linuxtv.org/hg/dvb-apps, compiled.

pavel@htpc:~/install/dvb-apps/test$ ./szap2 -l UNIVERSAL -t 2 -x -n 1
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 1 'Das Erste':
sat 0, frequency = 11837 MHz H, symbolrate 27500000, vpid = 0x0065, apid 
= 0x0066 sid = 0x0001
Delivery system=DVB-S2
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

do_tune: API version=3, delivery system = 2
do_tune: Frequency = 1237000, Srate = 27500000
do_tune: Frequency = 1237000, Srate = 27500000


status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |


While dmesg:
Dec  1 23:28:27 htpc kernel: [14339.714321] dvb_frontend_ioctl: 
FESTATE_RETUNE: fepriv->state=2
Dec  1 23:28:27 htpc kernel: [14339.714841] mantis start feed & dma
Dec  1 23:28:27 htpc kernel: [14339.739756] stb6100_set_bandwidth: 
Bandwidth=47125000
Dec  1 23:28:27 htpc kernel: [14339.743937] stb6100_get_bandwidth: 
Bandwidth=48000000
Dec  1 23:28:27 htpc kernel: [14339.821984] stb6100_set_frequency: 
Frequency=1237000
Dec  1 23:28:27 htpc kernel: [14339.826165] stb6100_get_frequency: 
Frequency=1236990
Dec  1 23:28:28 htpc kernel: [14341.017545] stb6100_set_bandwidth: 
Bandwidth=47125000
Dec  1 23:28:28 htpc kernel: [14341.021727] stb6100_get_bandwidth: 
Bandwidth=48000000
Dec  1 23:28:28 htpc kernel: [14341.096774] stb6100_set_frequency: 
Frequency=1237000
Dec  1 23:28:28 htpc kernel: [14341.100954] stb6100_get_frequency: 
Frequency=1236990
Dec  1 23:28:29 htpc kernel: [14341.789441] mantis stop feed and dma


Trying DVB-S:
pavel@htpc:~/install/dvb-apps/test$ ./szap2 -l UNIVERSAL  -x -n 1
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 1 'Das Erste':
sat 0, frequency = 11837 MHz H, symbolrate 27500000, vpid = 0x0065, apid 
= 0x0066 sid = 0x0001
Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1237000, Srate = 27500000
do_tune: Frequency = 1237000, Srate = 27500000


status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe

dmesg:
Dec  1 23:29:07 htpc kernel: [14379.949139] newfec_to_oldfec: 
Unsupported FEC 9
Dec  1 23:29:07 htpc kernel: [14379.949149] dvb_frontend_ioctl: 
FESTATE_RETUNE: fepriv->state=2
Dec  1 23:29:07 htpc kernel: [14379.949181] mantis start feed & dma
Dec  1 23:29:07 htpc kernel: [14379.976564] stb6100_set_bandwidth: 
Bandwidth=61262500
Dec  1 23:29:07 htpc kernel: [14379.980749] stb6100_get_bandwidth: 
Bandwidth=62000000
Dec  1 23:29:07 htpc kernel: [14380.003351] stb6100_get_bandwidth: 
Bandwidth=62000000
Dec  1 23:29:07 htpc kernel: [14380.071824] stb6100_set_frequency: 
Frequency=1237000
Dec  1 23:29:07 htpc kernel: [14380.076009] stb6100_get_frequency: 
Frequency=1236990
Dec  1 23:29:07 htpc kernel: [14380.087985] stb6100_get_bandwidth: 
Bandwidth=62000000
Dec  1 23:29:08 htpc kernel: [14380.803778] stb6100_set_bandwidth: 
Bandwidth=61262500
Dec  1 23:29:08 htpc kernel: [14380.807963] stb6100_get_bandwidth: 
Bandwidth=62000000
Dec  1 23:29:08 htpc kernel: [14380.830631] stb6100_get_bandwidth: 
Bandwidth=62000000


Trying to scan:
pavel@htpc:~/install/dvb-apps/util/scan$ ./scan  dvb-s/Astra-19.2E
scanning dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
 >>> tune to: 12551:v:0:22000
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
 >>> tune to: 12551:v:0:22000 (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

dmesg:
Dec  1 23:31:39 htpc kernel: [14531.884391] stb6100_set_bandwidth: 
Bandwidth=51610000
Dec  1 23:31:39 htpc kernel: [14531.888577] stb6100_get_bandwidth: 
Bandwidth=52000000
Dec  1 23:31:39 htpc kernel: [14531.911186] stb6100_get_bandwidth: 
Bandwidth=52000000
Dec  1 23:31:39 htpc kernel: [14531.979598] stb6100_set_frequency: 
Frequency=1951500
Dec  1 23:31:39 htpc kernel: [14531.983782] stb6100_get_frequency: 
Frequency=1951488
Dec  1 23:31:39 htpc kernel: [14531.995765] stb6100_get_bandwidth: 
Bandwidth=52000000
Dec  1 23:31:40 htpc kernel: [14532.840476] stb6100_set_bandwidth: 
Bandwidth=51610000
Dec  1 23:31:40 htpc kernel: [14532.844658] stb6100_get_bandwidth: 
Bandwidth=52000000


Please what are the next steps I should perform to make the card work? 
Such as the success report 
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29608.html


I can post verbose=5 messages for stb0899/stb6100 if needed. Thank you 
very much for your help and suggestions.

Regards,

Pavel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
