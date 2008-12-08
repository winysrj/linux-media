Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <493D164E.40507@web.de>
Date: Mon, 08 Dec 2008 13:42:54 +0100
From: Marco Schinkel <schinkelm@web.de>
MIME-Version: 1.0
To: vdr@linuxtv.org, linux-dvb@linuxtv.org
Subject: [linux-dvb] Live-TV picture goes away on composite out of ttpci
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

Hello,

I experience some strange behavior with vdr and a plain full featured 
Technotrend Rev. 1.6 (no mods, no daughterboards, no usage of internal 
connectors):

When running VDR (version 1.6.0-2/1.6.0) after a few days the live tv on 
the composite out goes away (only black picture visible). The menu 
however is perfectly workable (and I can see it on the composite out on 
top of a black picture).

I use the newest available firmware and recent drivers from the v4l-dvb 
repository (using the v4l-dv-hg gentoo ebuild) on an 2.6.27.7 kernel.

dmesg output occasionally has the following message:

saa7146 (2) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer

There are no other problems on the system, so I assume that it is either 
a dvb driver/firmware thing, or a vdr bug.

Starting a recording in vdr leads to an empty 001.vdr file. Restarting 
vdr does not help. Reloading the drivers usually helps but sometimes 
not. In this cases i have to powercycle the system. The problem exists 
no matter what card I use and on which position on the pci bus the card 
sits (I tried different cards, all ttpci 1.6 on 4 different slots on 3 
different pci busses). The problem even occured on my old mainboard 
occasionally. So it is definitely not a hardware defect. I assume the 
problem is not even related with the i2c timeout.

Is this problem known? Is there a known workaround or even better a way 
to fix this?


Best Regards,


Marco Schinkel



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
