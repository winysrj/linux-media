Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.orange.nl ([193.252.22.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1Kve8F-0007nC-Sx
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 21:28:41 +0100
Message-ID: <490A18D5.3070500@verbraak.org>
Date: Thu, 30 Oct 2008 21:28:05 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@tut.by>, linux-dvb@linuxtv.org
References: <412bdbff0810220607x588735f2v780104a5cafc3b8a@mail.gmail.com>	<48FF5C43.9090309@linuxtv.org>
	<200810230300.43637.liplianin@tut.by>
In-Reply-To: <200810230300.43637.liplianin@tut.by>
Subject: Re: [linux-dvb] stb0899 drivers
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

Igor M. Liplianin schreef:
> Hi Steven and Mauro
>
> As I understand, now we all waiting (again!) for Manu Abraham to commit?
> Truly his code are huge and needs long time to clean up, but I made 
> http://mercurial.intuxication.org/hg/s2-liplianin 
> in order to help to convert it.
> Right now I state the code is stable and works absolutely of no difference with multiproto 
> version.
> I mean it locks all channels, which multiproto version locks, but without any modifications to 
> current DVB API.
> What can I do now?
>
> Igor
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Igor,

I have tested your tree and can confirm the following. This is tested 
with a Technisat HD2 (0x0003 version).

Card is detected:
Oct 29 20:05:55 recorder kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> 
GSI 21 (level, low) -> IRQ 21
Oct 29 20:05:55 recorder kernel: irq: 21, latency: 64
Oct 29 20:05:55 recorder kernel:  memory: 0xf1bff000, mmio: 0xf89fe000
Oct 29 20:05:55 recorder kernel: found a VP-1041 PCI DSS/DVB-S/DVB-S2 
device on (02:09.0),
Oct 29 20:05:55 recorder kernel:     Mantis Rev 1 [1ae4:0003], irq: 21, 
latency: 64
Oct 29 20:05:55 recorder kernel:     memory: 0xf1bff000, mmio: 0xf89fe000
Oct 29 20:05:55 recorder kernel:     MAC Address=[00:08:c9:e0:3c:de]
Oct 29 20:05:55 recorder kernel: mantis_alloc_buffers (0): 
DMA=0x34b10000 cpu=0xf4b10000 size=65536
Oct 29 20:05:55 recorder kernel: mantis_alloc_buffers (0): 
RISC=0x36e95000 cpu=0xf6e95000 size=1000
Oct 29 20:05:55 recorder kernel: DVB: registering new adapter (Mantis 
dvb adapter)
Oct 29 20:05:55 recorder kernel: stb0899_attach: Attaching STB0899
Oct 29 20:05:55 recorder kernel: mantis_frontend_init (0): found STB0899 
DVB-S/DVB-S2 frontend @0x68
Oct 29 20:05:55 recorder kernel: stb6100_attach: Attaching STB6100
Oct 29 20:05:55 recorder kernel: DVB: registering adapter 6 frontend 0 
(STB0899 Multistandard)...
Oct 29 20:05:55 recorder kernel: mantis_ca_init (0): Registering EN50221 
device
Oct 29 20:05:55 recorder kernel: mantis_ca_init (0): Registered EN50221 
device
Oct 29 20:05:55 recorder kernel: mantis_hif_init (0): Adapter(0) 
Initializing Mantis Host Interface

Scanning with scan-s2 works but not all channels are found. Tested on 
Astra 28.2 (839 channels found) and Astra 19.2 (896 channels found). On 
the 28.2 I'm missing BBC 1 to 4 for example and on Astra 19.2 the Dutch 
channels. This is probably not a problem of scan-s2 but the driver.

Zapping with szap-s2 works for the channels found by scan-s2. I get data 
on vdr0 and it can be viewed by xine or mplayer. I can even get a lock 
on "BBC London 1" with manual set settings, not found by scan-s2, but I 
do not get any data on vdr0 device. This is logged in /var/log/messages

Oct 30 21:21:25 recorder kernel: mantis start feed & dma
Oct 30 21:21:25 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:25 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:25 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:26 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:26 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:26 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:27 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:27 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:27 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:27 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:28 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:28 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:28 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:28 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:29 recorder kernel: stb6100_set_bandwidth: Bandwidth=51610000
Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:29 recorder kernel: stb6100_set_frequency: Frequency=1023000
Oct 30 21:21:29 recorder kernel: stb6100_get_frequency: Frequency=1022994
Oct 30 21:21:29 recorder kernel: stb6100_get_bandwidth: Bandwidth=52000000
Oct 30 21:21:36 recorder kernel: mantis stop feed and dma

I have a rotor connected and it can be controlled by the normal diseqc 
commands. I have my own application which worked with the old api and it 
does still work. So I'm able to rotate it.

I can confirm that it partially works but the only problem for me is 
that it does not find all the channels on the satellites.

Regards,

Michel.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
