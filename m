Return-path: <linux-media-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.68.41]:34312 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZGFMHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2009 08:07:51 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.69)
	(envelope-from <mh+linux-media@zugschlus.de>)
	id 1MNm9V-0000vm-QK
	for linux-media@vger.kernel.org; Mon, 06 Jul 2009 13:14:29 +0200
Date: Mon, 6 Jul 2009 13:14:29 +0200
From: Marc Haber <mh+linux-media@zugschlus.de>
To: linux-media@vger.kernel.org
Subject: tua6100_sleep: i2c error when trying to tune saa7146 based  DVB
	card
Message-ID: <20090706111429.GE21161@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

one box of mine which I seldomly use has recently begun to refuse
using the DVB-S interface, logging "tua6100_sleep: i2c error" to syslog
when I try scanning the satellite:
$ sudo scan /usr/share/dvb/dvb-s/Astra-19.2E
[sudo] password for mh on weave:
scanning /usr/share/dvb/dvb-s/Astra-19.2E
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

The box has a saa7146 equipped budget DVB-S card which used to work
fine previously.

I can reproduce this behavior with kernels 2.6.30.1, 2.6.29.3 and
2.6.28.8. Older kernels (tried with 2.6.26.8) seem to be unable to
open the dm-crypt/LUKS volumes ("Error allocating crypto tfm"), so I
am at a loss about how to try that.

lspci:
00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333] [1106:3099]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333 AGP] [1106:b099]
00:0c.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
00:10.0 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:5237] (rev 03)
00:10.1 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:5237] (rev 03)
00:10.2 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:5237] (rev 03)
00:10.3 USB Controller [0c03]: ALi Corporation USB 2.0 Controller [10b9:5239] (rev 01)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8233 PCI to ISA Bridge [1106:3074] (rev 03)
00:11.1 IDE interface [0101]: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev 06)
00:11.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 1b)
00:11.3 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 1b)
00:11.4 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 1b)
00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 10)
00:14.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)
01:00.0 VGA compatible controller [0300]: nVidia Corporation NV34 [GeForce FX 5200] [10de:0322] (rev a1)

lsmod:
Module                  Size  Used by
nvidia               7089736  24
binfmt_misc             7780  1
ppdev                   7136  0
lp                      8932  0
ipv6                  257844  18
i2c_nforce2             6364  0
tua6100                 2524  1
stv0299                 9444  1
snd_via82xx            21936  2
snd_ac97_codec         99612  1 snd_via82xx
ac97_bus                1404  1 snd_ac97_codec
snd_pcm_oss            37408  0
snd_mixer_oss          14460  1 snd_pcm_oss
snd_pcm                71584  3 snd_via82xx,snd_ac97_codec,snd_pcm_oss
snd_page_alloc          8548  2 snd_via82xx,snd_pcm
snd_mpu401_uart         6780  1 snd_via82xx
budget_av              24252  0
saa7146_vv             45276  1 budget_av
snd_seq_dummy           2400  0
snd_seq_oss            26784  0
videodev               36416  1 saa7146_vv
snd_seq_midi            5952  0
videobuf_dma_sg        12000  1 saa7146_vv
snd_rawmidi            20960  2 snd_mpu401_uart,snd_seq_midi
videobuf_core          17280  2 saa7146_vv,videobuf_dma_sg
snd_seq_midi_event      6716  2 snd_seq_oss,snd_seq_midi
usblp                  11516  0
snd_seq                48816  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
budget_core             9504  1 budget_av
dvb_core               84928  3 stv0299,budget_av,budget_core
snd_timer              20228  2 snd_pcm,snd_seq
snd_seq_device          6696  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
saa7146                17380  3 budget_av,saa7146_vv,budget_core
ttpci_eeprom            1948  1 budget_core
snd                    53540  15 snd_via82xx,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_mpu401_uart,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
parport_pc             26052  1
soundcore               6944  1 snd
i2c_core               23632  7 nvidia,i2c_nforce2,tua6100,stv0299,budget_av,budget_core,ttpci_eeprom
parport                23168  3 ppdev,lp,parport_pc
rtc_cmos               10060  0
rtc_core               16120  1 rtc_cmos
rtc_lib                 2716  1 rtc_core
ext3                  117892  5
jbd                    48112  1 ext3
mbcache                 7360  1 ext3
sha256_generic         11324  0
aes_i586                8028  10
aes_generic            27388  1 aes_i586
dm_crypt               12256  5
dm_mirror              13120  0
dm_region_hash         10588  1 dm_mirror
dm_log                  9120  2 dm_mirror,dm_region_hash
dm_snapshot            21316  0
dm_mod                 50596  35 dm_crypt,dm_mirror,dm_log,dm_snapshot
sg                     27696  3
sr_mod                 14756  0
cdrom                  34176  1 sr_mod
sd_mod                 27736  3
ata_generic             4448  0
usbhid                 26080  0
uhci_hcd               22088  0
pata_via                9028  4
ohci_hcd               22892  0
libata                171628  2 ata_generic,pata_via
ehci_hcd               34056  0
8139too                23648  0
mii                     5020  1 8139too

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190

Bitte beachten Sie, daß dem [m.E. grundgesetzwidrigen] Gesetz zur
Vorratsdatenspeicherung zufolge, seit dem 1. Januar 2008 jeglicher
elektronische Kontakt (E-Mail, Telefongespräche, SMS, Internet-
Telefonie, Mobilfunk, Fax) mit mir oder anderen Nutzern verdachts-
unabhängig für den automatisierten geheimen Zugriff durch Strafver-
folgungs- u. Polizeivollzugsbehörden, die Bundesanstalt für Finanz-
dienstleistungsaufsicht, Zollkriminal- und Zollfahndungsämter,die
Zollverwaltung zur Schwarzarbeitsbekämpfung, Notrufabfragestellen,
Verfassungsschutzbehörden, den Militärischen Abschirmdienst, Bundes-
nachrichtendienst sowie 52 Staaten wie beispielsweise Aserbeidschan
oder die USA sechs Monate lang gespeichert wird, einschließlich der
Kommunikation mit Berufsgeheimnisträgern wie Ärzten, Journalisten und
Anwälten. Mehr Infos zur totalen Protokollierung Ihrer Kommunikations-
daten auf www.vorratsdatenspeicherung.de. (leicht verändert übernommen
kopiert von www.lawblog.de)
