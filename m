Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s10.bay0.hotmail.com ([65.54.246.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefan_ell@hotmail.com>) id 1KWBD3-00087U-Ms
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 16:32:25 +0200
Message-ID: <BAY108-W34A6237D826B4119100E1AFE6B0@phx.gbl>
From: Stefan Ellenberger <stefan_ell@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Thu, 21 Aug 2008 16:31:45 +0200
In-Reply-To: <mailman.1.1219312801.18695.linux-dvb@linuxtv.org>
References: <mailman.1.1219312801.18695.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] [multiproto patch] add support for using multiproto
 drivers with old api
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


hello list

I'm using Anssi Hannula patch (multiproto-support-old-api.diff from May 23) to use my Azurwave/Twinhan 1041 card with the old dvb api.

I can perfectly scan (using modified scan from manu) and tune the card (using szap2), but kaffeine (v0.8.6) and vdr (v1.6.0) show problems tuning with that card. It is sort of unreliable: sometimes tuning works fast and fine (namely if you stay on the sane transponder, just changing the pids) but sometimes output of vdr syslog stays like this:

Aug 21 16:09:37 ubuXFE vdr: [26566] switching to channel 1
Aug 21 16:09:37 ubuXFE vdr: [26830] transfer thread ended (pid=26566, tid=26830)
Aug 21 16:09:37 ubuXFE vdr: [26566] buffer stats: 192700 (9%) used
Aug 21 16:09:37 ubuXFE vdr: [26566] buffer stats: 0 (0%) used
Aug 21 16:09:37 ubuXFE kernel: [ 7972.116198] mantis stop feed and dma
Aug 21 16:09:37 ubuXFE vdr: [26832] TS buffer on device 1 thread ended (pid=26566, tid=26832)
Aug 21 16:09:38 ubuXFE vdr: [26831] buffer stats: 61288 (2%) used
Aug 21 16:09:38 ubuXFE vdr: [26831] receiver on device 1 thread ended (pid=26566, tid=26831)
Aug 21 16:09:38 ubuXFE kernel: [ 7972.168637] mantis start feed & dma
Aug 21 16:09:38 ubuXFE vdr: [26892] transfer thread started (pid=26566, tid=26892)
Aug 21 16:09:38 ubuXFE vdr: [26893] receiver on device 1 thread started (pid=26566, tid=26893)
Aug 21 16:09:38 ubuXFE vdr: [26894] TS buffer on device 1 thread started (pid=26566, tid=26894)
Aug 21 16:09:38 ubuXFE kernel: [ 7972.317323] stb0899_search: set DVB-S params
Aug 21 16:09:38 ubuXFE kernel: [ 7972.341396] stb6100_set_bandwidth: Bandwidth=61262500
Aug 21 16:09:38 ubuXFE kernel: [ 7972.345572] stb6100_get_bandwidth: Bandwidth=62000000
Aug 21 16:09:38 ubuXFE kernel: [ 7972.368189] stb6100_get_bandwidth: Bandwidth=62000000
Aug 21 16:09:38 ubuXFE kernel: [ 7972.439522] stb6100_set_frequency: Frequency=1237000
Aug 21 16:09:38 ubuXFE kernel: [ 7972.443941] stb6100_get_frequency: Frequency=1236990
Aug 21 16:09:38 ubuXFE kernel: [ 7972.455680] stb6100_get_bandwidth: Bandwidth=62000000
Aug 21 16:09:39 ubuXFE kernel: [ 7973.350734] stb0899_search: set DVB-S params
Aug 21 16:09:38 ubuXFE kernel: [ 7972.341396] stb6100_set_bandwidth: Bandwidth=61262500
[...]
these messages from stb6100 module get repeated exactly like this for several times - it takes sometimes a minute until lock is suddenly established showing the following log output

Aug 21 16:10:35 ubuXFE kernel: [ 8029.111530] stb0899_search: set DVB-S params
Aug 21 16:10:35 ubuXFE kernel: [ 8029.133851] stb6100_set_bandwidth: Bandwidth=61262500
Aug 21 16:10:35 ubuXFE kernel: [ 8029.138025] stb6100_get_bandwidth: Bandwidth=62000000
Aug 21 16:10:35 ubuXFE kernel: [ 8029.160773] stb6100_get_bandwidth: Bandwidth=62000000
Aug 21 16:10:35 ubuXFE kernel: [ 8029.223988] stb6100_set_frequency: Frequency=1237000
Aug 21 16:10:35 ubuXFE kernel: [ 8029.228163] stb6100_get_frequency: Frequency=1236990
Aug 21 16:10:35 ubuXFE kernel: [ 8029.241120] stb6100_get_bandwidth: Bandwidth=62000000
Aug 21 16:10:35 ubuXFE vdr: [26892] setting audio track to 1 (0)

dmesg repeatly shows the same log output as mentioned from syslog above:

[ 8029.111530] stb0899_search: set DVB-S params
[ 8029.133851] stb6100_set_bandwidth: Bandwidth=61262500
[ 8029.138025] stb6100_get_bandwidth: Bandwidth=62000000
[ 8029.160773] stb6100_get_bandwidth: Bandwidth=62000000
[ 8029.223988] stb6100_set_frequency: Frequency=1237000
[ 8029.228163] stb6100_get_frequency: Frequency=1236990
[ 8029.241120] stb6100_get_bandwidth: Bandwidth=62000000

#lsmod |grep mantis
mantis                43396  17 
lnbp21                  3200  1 mantis
mb86a16             21632  1 mantis
stb6100                8836  1 mantis
tda10021              7684  1 mantis
tda10023              7300  1 mantis
stb0899              36224  1 mantis
stv0299              11528  1 mantis
dvb_core            89596  2 mantis,stv0299
i2c_core             24832  9 mantis,lnbp21,mb86a16,stb6100,tda10021,tda10023,stb0899,stv0299,nvidia

#lscpi
01:05.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)

The mantis sources I applied the patch to are from hg repository: http://www.linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_(VP-1041)#Drivers> (Method 2)

I hope someone can shatter some light what I'm doing wrong and how it can be fixed to tune a little faster than one station lock per minute :-)

If modular log output is to short I can offer you a "verbosity level = 5"-built mantis module in action... actually it is built with verbosity level=1

thanks in advance for helping!
_________________________________________________________________
Windows Live Spaces - Ihr Leben, Ihr Space. Hier klicken und informieren.
http://get.live.com/spaces/overview
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
