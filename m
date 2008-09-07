Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bis.amsnet.pl ([195.64.174.7] helo=host.amsnet.pl ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gasiu@konto.pl>) id 1KcL91-0005Qk-Rd
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 16:21:41 +0200
Received: from dxr214.neoplus.adsl.tpnet.pl ([83.22.103.214]
	helo=[192.168.1.3]) by host.amsnet.pl with esmtpa (Exim 4.67)
	(envelope-from <gasiu@konto.pl>) id 1KcL95-0004GP-Kx
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 16:21:43 +0200
Message-ID: <48C3E36E.5090107@konto.pl>
Date: Sun, 07 Sep 2008 16:21:34 +0200
From: Gasiu <gasiu@konto.pl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Multiproto+SkystarHD-very slow decoding
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

I use SkyStar HD + SkyStar HD CI Slot + Aston v2.18 + Cyfra+ 
(Poland)(Seca) + Multiproto + Old-Api Patch + Kaffeine, and I've got a 
strange problem - on some freq. decoding doesn't work fine - I must wait 
a long time (up to 30min.) to watch program :-( - for example:

Hotbird 7A (13.0E) - 10719.00 V - MINIMINI
Hotbird 7A (13.0E) - 11278.36 V - HBO, HBO2, HBO Commedy

and on others freq. everything works fine and fast - for example:

Hotbird 7A (13.0E) - 10892.00 H  - Canal+ Polska,TVP1
Hotbird 7A (13.0E) - 11393.44 V  - TVN, TVN24

logs from kaffeine on HBO:

Tuning to: HBO / autocount: 3
Using DVB device 0:0 "STB0899 Multistandard"
tuning DVB-S to 10719000 v 27500000
inv:2 fecH:3
DiSEqC: switch pos 0, 13V, loband (index 0)
DiSEqC: e0 10 38 f0 00 00
. LOCKED.
NOUT: 1
CamThread: started
CamThread: just using the first cam slot
PmtThread: started
dvbEvents 0:0 started
Tuning delay: 469 ms
pipe opened
demux_wavpack: (open_wv_file:127) open_wv_file: non-seekable inputs 
aren't supported yet.
xine pipe opened /home/gasiu/.kaxtv1.ts
CamThread: cam 0 is ready
CamThread: LLCI cam slot detected
en50221_tl_handle_sb: Received T_SB for connection not in T_STATE_ACTIVE 
from module on slot 00

CamThread: [warning] polling the stack failed

 >>>> after 15 min. !!!!!!!!!!!

PmtThread: new pmt received
PmtThread: stopped
CamThread: pmt sent to cam




Can You tell me what's wrong?

-- 
Pozdrawiam!
Gasiu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
