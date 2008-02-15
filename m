Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guillaume.ml@gmail.com>) id 1JQ8dq-000144-CZ
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 23:02:46 +0100
Received: by wa-out-1112.google.com with SMTP id m28so1338281wag.13
	for <linux-dvb@linuxtv.org>; Fri, 15 Feb 2008 14:02:43 -0800 (PST)
Message-ID: <4758d4170802151402r3a4dfd54t9cb54803a7fa29e4@mail.gmail.com>
Date: Fri, 15 Feb 2008 23:02:43 +0100
From: "=?ISO-8859-1?Q?Guillaume_Membr=E9?=" <guillaume.ml@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] problems with a satelco easy watch dvb-c
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I'm trying to setup a Satelco easy watch dvb-c but it doesn't work :
when doing a scan with the following command :
$ scan fr-noos-numericable
scanning fr-noos-numericable
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 147000000 6875000 0 3
>>> tune to: 147000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64
WARNING: >>> tuning failed!!!
>>> tune to: 147000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64 (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

the kernel shows the following errors :
DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x10, val
== 0x00, ret == -512)
DVB: TDA10023: tda10023_readreg: readreg error (ret == -512)

and it doesn't find any channels as it should. I have a set top box
from my cable provider which works fine with this tuning frequencie.

I'm running debian unstable with a 2.6.24.2 kernel.
Here is the initialization of the card :

PCI: Found IRQ 10 for device 0000:00:0e.0
saa7146: found saa7146 @ mem f88d2000 (revision 1, irq 10) (0x1894,0x002c).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Satelco EasyWatch DVB-C MK3)
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
KNC1-0: MAC addr = 00:09:d6:6d:a5:0b
DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
budget-av: ci interface initialised.

and the result of lsmod :
lsmod
Module                  Size  Used by
nfs                   116076  1
lockd                  59784  1 nfs
sunrpc                155164  8 nfs,lockd
fglrx                1479212  18
sr_mod                 14116  0
sd_mod                 20880  0
8250                   19700  0
serial_core            16640  1 8250
tda10023                5764  1
via_rhine              19464  0
mii                     4480  1 via_rhine
budget_av              17792  0
saa7146_vv             44288  1 budget_av
videobuf_dma_sg        11012  1 saa7146_vv
videobuf_core          14340  2 saa7146_vv,videobuf_dma_sg
budget_core             8452  1 budget_av
dvb_core               70396  2 budget_av,budget_core
saa7146                14984  3 budget_av,saa7146_vv,budget_core
ttpci_eeprom            2176  1 budget_core
via_agp                 8064  1
agpgart                26288  2 fglrx,via_agp
evdev                   8576  1

what's wrong ? where is my error ?
thanks a lot for your help

Guillaume

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
