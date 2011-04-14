Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51741 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab1DNAiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 20:38:51 -0400
Received: by yxs7 with SMTP id 7so491632yxs.19
        for <linux-media@vger.kernel.org>; Wed, 13 Apr 2011 17:38:51 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Apr 2011 02:38:51 +0200
Message-ID: <BANLkTin7iY81OSJfq=0m0TxZSE8CsNxxxA@mail.gmail.com>
Subject: KNC ONE DVB-C [1894:0022] can't find any channels, PAT/SDT/NIT filter timeout
From: Frantisek Augusztin <faugusztin@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

i'm having problems with my new DVB-C device on UPC DVB-C network
(Bratislava, Slovakia, encrypted using Conax CAM module inserted in CI
slot connected to the DVB-C card):

05:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7146
[1131:7146] (rev 01)
       Subsystem: KNC One Device [1894:0022]
       Flags: bus master, medium devsel, latency 64, IRQ 16
       Memory at ff700000 (32-bit, non-prefetchable) [size=512]
       Kernel driver in use: budget_av
       Kernel modules: budget-av

As you can see, the device is detected and modules loaded :

# ls -l /dev/dvb/adapter0
total 0
crw-rw---- 1 root video 212, 6 Apr 13 23:58 ca0
crw-rw---- 1 root video 212, 4 Apr 13 23:58 demux0
crw-rw---- 1 root video 212, 5 Apr 13 23:58 dvr0
crw-rw---- 1 root video 212, 3 Apr 13 23:58 frontend0
crw-rw---- 1 root video 212, 7 Apr 13 23:58 net0


# lsmod (i did cut out the unnecessary bits)
Module                  Size  Used by
sbs                     8885  0
sbshc                   2712  1 sbs
ipv6                  244116  33
tda10023                5443  1
i915                  515809  1
budget_av              18830  0
saa7146_vv             38879  1 budget_av
drm_kms_helper         23711  1 i915
videodev               72530  1 saa7146_vv
drm                   144199  2 i915,drm_kms_helper
videobuf_dma_sg         6848  1 saa7146_vv
videobuf_core          13183  2 saa7146_vv,videobuf_dma_sg
budget_core             5956  1 budget_av
i2c_algo_bit            4304  1 i915
i2c_i801                6866  0
dvb_core               75119  2 budget_av,budget_core
saa7146                12490  3 budget_av,saa7146_vv,budget_core
serio_raw               3358  0
ttpci_eeprom            1364  1 budget_core
r8169                  34246  0
i2c_core               15854  11
lm75,tda10023,i915,budget_av,drm_kms_helper,videodev,drm,budget_core,i2c_algo_bit,i2c_i801,ttpci_eeprom

dmesg: http://pastebin.com/uJDtLGYm

The problem is that i can't even successfully scan for channels.To
rule out hardware issue, first i tried to use it first with my Windows
PC, it worked flawlessly (SD absolutely no problems, HD channels had
some minor dropouts due the high bitrate). The result of scan for
channels using GlobeTV (the Windows app) was this :
http://pastebin.com/XNHvjAfb .

Because i'm using a cable operator not listed in /usr/share/dvb files,
i need to use w_scan and the result is something like this :
http://pastebin.com/0fUS6Tzx .

Because of those filter timeouts, it finds no channels using the same
cable and card which had no problems on Windows and using the same
cable which has no problems with the provided set top box from the
cable operator.

You might suggest me to use dvbsnoop, but only two commands which work
are the signal and feinfo. pidscan returns nothing :
# dvbsnoop -s signal
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

---------------------------------------------------------
Transponder/Frequency signal strength statistics...
---------------------------------------------------------
cycle: 1  d_time: 0.001 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 2  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 3  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 4  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 5  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 6  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 7  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 8  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 9  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791  UBLK:
-1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 10  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 11  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 12  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 13  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 14  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 15  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 16  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 17  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 18  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 19  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 20  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 21  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 22  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 23  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 24  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 25  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 26  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 27  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 28  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 29  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 30  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 31  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 32  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 33  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 34  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 35  d_time: 0.008 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
cycle: 36  d_time: 0.007 s  Sig: 65535  SNR: 65535  BER: 1019791
UBLK: -1886417009  Stat: 0x1f [SIG CARR VIT SYNC LOCK ]
...

# dvbsnoop -s feinfo
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

---------------------------------------------------------
FrontEnd Info...
---------------------------------------------------------

Device: /dev/dvb/adapter0/frontend0

Basic capabilities:
   Name: "Philips TDA10023 DVB-C"
   Frontend-type:       QAM (DVB-C)
   Frequency (min):     47000.000 kHz
   Frequency (max):     862000.000 kHz
   Frequency stepsiz:   62.500 kHz
   Frequency tolerance: 0.000 kHz
   Symbol rate (min):     0.451875 MSym/s
   Symbol rate (max):     7.230000 MSym/s
   Symbol rate tolerance: 0 ppm
   Notifier delay: 0 ms
   Frontend capabilities:
       auto inversion
       FEC AUTO
       QPSK
       QAM 16
       QAM 32
       QAM 64
       QAM 128
       QAM 256

Current parameters:
   Frequency:  362000.000 kHz
   Inversion:  ON
   Symbol rate:  6.900000 MSym/s
   FEC:  none
   Modulation:  QAM 64


Tested using Arch Linux 2.6.37-ARCH and current 2.6.39-rc3 kernels,
same result.

Signal level according to the set top box is ~57%, signal quality is
97-99%, and as i mentoined, set top box works without problems, and
it works using this DVB-C card and same cable when using with Windows
(but true, on different PC).

Any ideas ?

PS: I hope this mailing list is the right one for my issue.
--
Frantisek Augusztin
