Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LQPda-0005Xi-2q
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 18:16:11 +0100
Received: by ewy13 with SMTP id 13so3343182ewy.17
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 09:15:36 -0800 (PST)
Date: Fri, 23 Jan 2009 18:15:22 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Message-ID: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Subject: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
Reply-To: linux-media@vger.kernel.org
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

Moin moin,

I've just learned that effective 24.Feb, there will be a change
made to the channel assignment in the area of Hamburg.

This is due to the fact that one existing multiplex is found
within the VHF band, which is in the process of being cleared
of DVB-T services, moving them to assigned UHF channels, in
order to free the VHF band for radio services (DAB/DAB+ and
family).

Several other areas, such as Bayern, currently make use of
VHF frequencies at several transmitter sites.  I am not yet
aware of what plans exist to change these frequencies...

The following diff will add the newly assigned frequency,
and remove the old one, with an effective date of 24.Feb.

The particular modulation parameters are not confirmed, so
I've had to guess based on existing values used elsewhere
in the NDR coverage area as well as what generally is used
throughout germany.

In particular, for the public service broadcasters'
multiplexes, they generally seem to use a FEC of 3/4 in
the 7MHz VHF band, but the more rugged 2/3 in 8MHz UHF
channel space to compensate for the poorer propagation
while keeping comparable bitrate available.

Ideally, this would be confirmed after the switch, or
in some technical document which I haven't searched out.


--- /lost+found/CVSUP/SRC/HG-src/dvb-apps/util/scan/dvb-t/de-Hamburg	2008-08-23 10:18:28.000000000 +0200
+++ /tmp/de-Hamburg	2009-01-23 17:42:54.029209331 +0100
@@ -1,6 +1,5 @@
-# DVB-T Hamburg
+# DVB-T Hamburg (ab 24.02.2009 CH09->CH54)
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 205500000 7MHz 3/4 NONE QAM16 8k 1/8 NONE     # CH09: NDR, WDR, MDR, Bayrisches Fernsehen
 T 490000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE     # CH23: ZDF, Info/3sat, Doku/KiKa
 T 498000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
 T 514000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE     #ARD, MDR S-Anhalt, NDR MV, NDR SH, rbb Berlin
@@ -10,6 +9,7 @@
 T 602000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
 T 626000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE     # CH40: RTL Television, RTL2, Super RTL, VOX
 T 674000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE     # CH53: HH1, Eurosport, Terra Nova, Neun Live
+T 682000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE     # CH54: NDR, WDR, MDR, Bayrisches Fernsehen
 T 738000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE     #ZDF, Doku/KiKa, Info/3sat
 T 754000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE     # CH56: NDR, MDR, WDR, hr
 T 786000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE


Note that I am using the existing file, which to my eyes may
contain errors -- it certainly includes more than just the
frequencies used by transmitters in Hamburg, and the values
I have on my receiver are more than a year old so I haven't
compared against that.

However, I'm concerned by the duplication of ZDF, particularly
with a different FEC.  I can confirm from the ZDF teletext info
that channel 23 is in use at two transmitter sites, but I see
nowhere in the general vicinity of HH where channel 54 is in
use by ZDFmobil from that source.

Similarly the appearance of ARD and NDR duplicates at channel
26 with similar FEC raises my eyebrows.  If anything this would
be spillage from, say, S-H.  And channels such as TerraNova
are long since history, but the multiplex technical parameters
are probably unchanged.

No matter...

thanks,
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
