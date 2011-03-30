Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <joshoekstra@gmx.net>) id 1Q51uU-00008G-Ml
	for linux-dvb@linuxtv.org; Wed, 30 Mar 2011 22:22:35 +0200
Received: from mailout-de.gmx.net ([213.165.64.22])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with smtp
	for <linux-dvb@linuxtv.org>
	id 1Q51uU-0004We-He; Wed, 30 Mar 2011 22:22:34 +0200
Message-ID: <4D9390FA.9040402@gmx.net>
Date: Wed, 30 Mar 2011 22:22:18 +0200
From: Jos Hoekstra <joshoekstra@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technisat Cablestar HD2 not automatically detected by
	kernel > 2.6.33?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Good evening,

I got this card and it doesn't seem to be detected by Ubuntu 10.4.2 with 
kernel 2.6.35(-25-generic #44~lucid1-Ubuntu SMP Tue Jan 25 19:17:25 UTC 
2011 x86_64 GNU/Linux)

The wiki seems to indicate that this card is supported as of kernel 
2.6.33, however it doesn't show up as a dvb-adapter.

I checked if it is the same card as on the wiki and it seems to be 
looking at the device-id:

01:0a.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
Bridge Controller [Ver 1.0] (rev 01)
     Subsystem: Device 1ae4:0002
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (2000ns min, 63750ns max)
     Interrupt: pin A routed to IRQ 15
     Region 0: Memory at cbfff000 (32-bit, prefetchable) [size=4K]

I performed "modprobe mantis" and it seems to load op the correct 
modules just fine:

mantis                 17985  0
mantis_core            33224  1 mantis
tda665x                 3446  1 mantis
lnbp21                  2338  1 mantis
mb86a16                21798  1 mantis
stb6100                 7128  1 mantis
tda10021                6920  1 mantis
tda10023                6996  1 mantis
zl10353                 7817  1 mantis
stb0899                36531  1 mantis
stv0299                10593  1 mantis
ir_core                16906  11 
mantis_core,rc_hauppauge_new,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,cx88xx,ir_common,ir_nec_decoder
dvb_core              105399  5 
mantis_core,stv0299,cx88_dvb,videobuf_dvb,dvb_usb

After rebooting it however seems I need to manually modprobe mantis and 
restart the backend to have mythtv work with this card. Is there a way 
to make these modules load automatically after a reboot?

Also for my DTV-provider there's no initial scanfile, I've managed to 
scan the channels by making my own initial scan file with:

C 304000000 6875000 NONE QAM64

And am able to scan all the channels(which are unencrypted).

So far so good, added the channels to mythtv after testing in Kaffeine, 
where they play near flawlessly in in Kaffeine however have heavy 
distortions in mythtv. The work-around seems to be to disable the C1E 
halt state on the Geforce 8200 motherboard I use.

Is the wiki still active? So I can put my experiences there later on?
Can I somehow submit the initial scan file to be used with Glashart in 
the Netherlands?

Thanks in advance,

Jos Hoekstra

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
