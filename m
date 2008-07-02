Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wp024.webpack.hosteurope.de ([80.237.132.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sebastian@ygriega.de>) id 1KE9PJ-0004Nn-IH
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 22:58:32 +0200
From: Sebastian Wolf <sebastian@ygriega.de>
To: linux-dvb@linuxtv.org
Date: Wed, 2 Jul 2008 22:57:55 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Tv+aIuF1Se5Y7Xr"
Message-Id: <200807022257.55589.sebastian@ygriega.de>
Subject: [linux-dvb] "Slave RACK Fail" on Technisat CableStar HD2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_Tv+aIuF1Se5Y7Xr
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

some days ago I bought the DVB-C Card 'Technisat CableStar HD2'. After I've 
installed it I did a short test on Win XP SP3 - the card is working properly 
there. 

In order to make it work under Linux, I compiled and installed the latest 
mantis sources (downloaded from http://jusst.de/hg/mantis). The compilation 
was successful after I've patched the sources with 
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/fix-jdelvare-i2c-i2c-constify-client-address-data.patch 
and after I've deactivated the option KS0127.

The modes are now loaded successfully (at least it seems so) during boot. 
However, a channel search is never successful, no matter which transponder 
list or frontend application (or directly dvbscan) I use. 

dmesg shows after the failed scan:

mantis_ack_wait (0): Slave RACK Fail !

I did a search and only found a few comments and linux-dvb mails on the web, 
but no solution to this problem, so I'm contacting you directly.

Here is some information about my system:

- openSUSE 11.0
- uname -r: 2.6.25.5-1.1-pae

dmesg shows (on module load):

ACPI: PCI Interrupt 0000:02:07.0[A] -> GSI 22 (level, low) -> IRQ 22
irq: 22, latency: 64
 memory: 0xf8fff000, mmio: 0xf9652000
found a VP-2040 PCI DVB-C device on (02:07.0),
    Mantis Rev 1 [1ae4:0002], irq: 22, latency: 64
    memory: 0xf8fff000, mmio: 0xf9652000
    MAC Address=[00:08:c9:d0:11:98]
mantis_alloc_buffers (0): DMA=0x36810000 cpu=0xf6810000 size=65536
mantis_alloc_buffers (0): RISC=0x37f94000 cpu=0xf7f94000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 
0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface

/dev/dvb/adapter0 contains:
-ca0
-demux0
-dvr0
-frontend0
-net0

lsmod output is attached...

If I can provide more information in order to solve the problem, I will 
definitely do so, just give me some hints. ;-)

Thanks in advance and best regards,

Sebastian

--Boundary-00=_Tv+aIuF1Se5Y7Xr
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lsmod"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsmod"

Module                  Size  Used by
iptable_filter         19840  0
ip_tables              30224  1 iptable_filter
snd_pcm_oss            64256  0
snd_mixer_oss          33408  1 snd_pcm_oss
snd_seq_midi           26112  0
ip6table_filter        19712  0
ip6_tables             31376  1 ip6table_filter
snd_emu10k1_synth      24832  0
x_tables               33668  2 ip_tables,ip6_tables
snd_emux_synth         54272  1 snd_emu10k1_synth
ipv6                  281064  22
snd_seq_virmidi        23680  1 snd_emux_synth
snd_seq_midi_event     23936  2 snd_seq_midi,snd_seq_virmidi
snd_seq_midi_emul      22784  1 snd_emux_synth
snd_seq                73664  5 snd_seq_midi,snd_emux_synth,snd_seq_virmidi,snd_seq_midi_event,snd_seq_midi_emul
af_packet              38656  0
cpufreq_conservative    24456  0
cpufreq_userspace      22660  0
cpufreq_powersave      18176  0
powernow_k8            31748  0
sha256_generic         28800  0
aes_i586               24704  2
aes_generic            44072  1 aes_i586
cbc                    20736  1
uhci_hcd               40848  0
dm_crypt               32132  1
crypto_blkcipher       36356  3 cbc,dm_crypt
fuse                   66332  3
loop                   35332  0
dm_mod                 78676  3 dm_crypt
snd_emu10k1           162948  3 snd_emu10k1_synth
snd_rawmidi            42496  3 snd_seq_midi,snd_seq_virmidi,snd_emu10k1
firmware_class         25984  1 snd_emu10k1
snd_ac97_codec        120868  1 snd_emu10k1
mantis                 59396  0
ac97_bus               18304  1 snd_ac97_codec
lnbp21                 18560  1 mantis
snd_pcm               100100  3 snd_pcm_oss,snd_emu10k1,snd_ac97_codec
mb86a16                36096  1 mantis
snd_seq_device         25100  6 snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq,snd_emu10k1,snd_rawmidi
stb6100                24196  1 mantis
tda10021               22788  1 mantis
snd_timer              40712  3 snd_seq,snd_emu10k1,snd_pcm
tda10023               22788  1 mantis
snd_page_alloc         27400  2 snd_emu10k1,snd_pcm
i2c_piix4              25484  0
snd_util_mem           21632  2 snd_emux_synth,snd_emu10k1
stb0899                52352  1 mantis
usbhid                 60260  0
8139too                43008  0
stv0299                27016  1 mantis
rtc_cmos               27168  0
snd_hwdep              26372  2 snd_emux_synth,snd_emu10k1
8139cp                 39808  0
dvb_core              104296  2 mantis,stv0299
nvidia               7121088  24
sr_mod                 33320  0
ati_agp                25484  0
snd                    79544  20 snd_pcm_oss,snd_mixer_oss,snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq,snd_emu10k1,snd_rawmidi,snd_ac97_codec,snd_pcm,snd_seq_device,snd_timer,snd_util_mem,snd_hwdep
rtc_core               37148  1 rtc_cmos
ohci1394               48432  0
hid                    53708  1 usbhid
emu10k1_gp             20224  0
ieee1394              107016  1 ohci1394
rtc_lib                19328  1 rtc_core
gameport               31500  2 emu10k1_gp
cdrom                  50588  1 sr_mod
button                 25360  0
mii                    21888  2 8139too,8139cp
i2c_core               41108  10 mantis,lnbp21,mb86a16,stb6100,tda10021,tda10023,i2c_piix4,stb0899,stv0299,nvidia
agpgart                50868  2 nvidia,ati_agp
soundcore              24264  1 snd
ff_memless             21896  1 usbhid
sg                     52020  0
ehci_hcd               52492  0
ohci_hcd               39940  0
sd_mod                 45208  5
usbcore               164684  5 uhci_hcd,usbhid,ehci_hcd,ohci_hcd
edd                    26440  0
ext3                  155784  2
mbcache                25348  1 ext3
jbd                    73376  1 ext3
fan                    22660  0
ahci                   45960  4
pata_atiixp            24320  0
libata                176220  2 ahci,pata_atiixp
scsi_mod              168308  4 sr_mod,sg,sd_mod,libata
dock                   27536  1 libata
thermal                39452  0
processor              67504  2 powernow_k8,thermal

--Boundary-00=_Tv+aIuF1Se5Y7Xr
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Tv+aIuF1Se5Y7Xr--
