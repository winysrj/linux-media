Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ash25e.internode.on.net ([203.16.214.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sph3r3@internode.on.net>) id 1KC2aD-0004sS-LF
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 03:17:03 +0200
From: "Adam" <sph3r3@internode.on.net>
To: linux-dvb@linuxtv.org
Date: Fri, 27 Jun 2008 10:46:45 +0930
Message-id: <48643f7d.168.28cb.583@internode.on.net>
MIME-Version: 1.0
Subject: [linux-dvb] DVICO FusionHDTV DVB-T Pro
Reply-To: sph3r3@internode.on.net
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

Late last year I got my card working in a Fedora 8/2.6.24
system (thanks Chris!).  I've now upgraded to Fedora 9
(2.6.25) and am trying to get my card going again as magic
didn't seem to happen with Fedora's out-of-the-box drivers.

I've noticed that my card is now listed in cardlist.cx88, so
I've downloaded and built the latest v4l-dvb repo (#8110) in
preference to the xc-test branch that I used last year. 
/dev/dvb0/* is populated and dmesg shows that the card is
correctly detected:

> cx88[0]: subsystem: 18ac:db30, board: DViCO FusionHDTV
DVB-T PRO [card=64,autodetected]
> cx88[0]: TV tuner type 4, Radio tuner type -1
> cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 19,
latency: 32, mmio: 0xf4000000
...

Firmware was extracted using extract_xc3028.pl as described
in
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028,
and is installed in /etc/firmware.

This is where it all begins to get unstuck.

When I run scandvb to create a channel list it prints the
following messages:
scanning /usr/share/dvb-apps/dvb-t/au-Adelaide
using '/dev/dvb/adapter0/frontend0' and
'/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 3 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 564500000 1 2 9 3 1 2 0
>>> tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
[...snip...]

Correspondingly, dmesg shows:
xc2028 2-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
cx88[0]: Error: Calling callback for tuner 4
cx88[0]: Error: Calling callback for tuner 4
[...snip...]

Before running scandvb everything looks happy in dmesg.

Any ideas?

Thanks,
Adam

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
