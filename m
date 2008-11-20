Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from portal.beam.ltd.uk ([62.49.82.227] helo=beam.beamnet)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <terry1@beam.ltd.uk>) id 1L39lc-0001Vy-W4
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 14:40:22 +0100
Received: from beam.beamnet (beam.beamnet [192.168.1.1]) (authenticated bits=0)
	by beam.beamnet (8.14.2/8.14.2) with ESMTP id mAKDdkfs014734
	for <linux-dvb@linuxtv.org>; Thu, 20 Nov 2008 13:39:46 GMT
Message-ID: <492568A2.4030100@beam.ltd.uk>
Date: Thu, 20 Nov 2008 13:39:46 +0000
From: Terry Barnaby <terry1@beam.ltd.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Twinhan VisionPlus DVB-T Card not working
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

I am having a problem with the latest DVB drivers.
I have a Twinhan VisionPlus DVB-T card (and other DVB cards) in my
MythTv server running Fedora 8. This is running fine
with the Fedora stock kernel: 2.6.26.6-49.fc8.

However, I have now added a Hauppauge DVB-S2 and so have been
trying the latest DVB Mercurial DVB tree.
This compiles and installs fine and the two DVB-T cards and the
new DVB-S card are recognised and has /dev/dvb entries.
The first DVB-T card, a Twinhan based on the SAA7133/SAA7135
works fine but the Twinhan VisionPlus, which is Bt878 will not
tune in.

Any ideas ?
Has there been any recent changes to the Bt878 driver that could
have caused this ?

/var/log/messages does have:

bttv0: tuner absent


>From the dvb apps scan utility I get:

[root@king scan]# ./scan -a 2 dvb-t/uk-Mendip
scanning dvb-t/uk-Mendip
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
initial transponder 754167000 0 2 9 1 0 0 0
>>> tune to:
754167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
754167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)



The lspci dump for the card is:

02:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture
(rev 11)
        Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB card
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at cfeff000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: bttv
        Kernel modules: bttv

In numeric:
02:00.0 0400: 109e:036e (rev 11)
        Subsystem: 1822:0001
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at cfeff000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: bttv
        Kernel modules: bttv

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
