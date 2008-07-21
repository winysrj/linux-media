Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server55.greatnet.de ([83.133.97.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <asc@aksels.de>) id 1KKpav-00008g-GP
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 09:14:44 +0200
Date: Mon, 21 Jul 2008 09:15:24 +0200
From: asc <asc@aksels.de>
To: linux-dvb@linuxtv.org
Message-Id: <20080721091524.c5071274.asc@aksels.de>
Mime-Version: 1.0
Subject: [linux-dvb] KNC1 tv station dvb-t tuning problem
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


Hi,

I have a strange problem with this card.
generally it works, but tuning on channel 40 (626000000) does not work.
other channels work fine. I tried the original drivers provided by kernel
2.6.24.5 and cvs updates. (also tried with my old kernel 2.6.18 and cvs updates,
always with the same result).

I use the frimware tda10046 from get_dvb_firmware script (TT_PCI_2.19h_28_11_2006.zip)
tested also the frimware from  "TT_PCI_2.17", but I think this is the same firmware.

dmesg reports firmware revision 20.

so now the strange thing: If I first start windows, and using globetv, I have all channels.
then, doing a warm start loading linux, dmesg reports version 26 (think this is the
firmware from windows globetv) and tzap works on channel 40.

what's the problem? 


some infos:

lspci:
01:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: KNC One Unknown device 0030
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_av
        Kernel modules: budget-av

tzap -r (cold start with linux, tda10046 rev. 20)
tuning to 626000000 Hz
video pid 0x0201, audio pid 0x0202
status 00 | signal 0000 | snr f5f5 | ber 0001fffe | unc 00000000 | 
status 1f | signal 5151 | snr e6e6 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5252 | snr e7e7 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 01 | signal 5353 | snr 0000 | ber 0001fffe | unc 00000000 | 
status 1f | signal 5353 | snr e5e5 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5252 | snr e6e6 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 01 | signal 5353 | snr 0000 | ber 0001fffe | unc 00000077 | 
status 1f | signal 5252 | snr e7e7 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5353 | snr e7e7 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 01 | signal 5353 | snr 0000 | ber 0001fffe | unc ffffffff | 
status 1f | signal 5252 | snr 0000 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5252 | snr 0000 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 01 | signal 5353 | snr 0000 | ber 0001fffe | unc ffffffff | 
status 1f | signal 5252 | snr 0000 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5252 | snr 0000 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5252 | snr 0000 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5252 | snr 0000 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 01 | signal 5353 | snr 7f7f | ber 0001fffe | unc ffffffff | 
status 1f | signal 5252 | snr e7e7 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK
status 1f | signal 5353 | snr e7e7 | ber 0001fffe | unc ffffffff | FE_HAS_LOCK


scan -c -v -5
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
dumping lists (0 services)
Done.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
