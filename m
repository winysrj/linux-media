Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway07.websitewelcome.com ([69.56.170.18])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JwYyg-0004js-C7
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 10:38:20 +0200
Received: from [77.109.107.153] (port=59895 helo=[127.0.0.1])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1JwYyY-0000nN-5t
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 03:38:10 -0500
Message-ID: <482BF672.1090402@kipdola.com>
Date: Thu, 15 May 2008 10:38:10 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technotrend S2-3200 (Or Technisat Skystar HD) on
 LinuxMCE 0710 (Kubuntu Feisty)
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

Good morning all,

I'm having difficulty getting my DVB-S2 card to work on LinuxMCE 0710 
(Kubuntu Feisty, kernel 2.6.22-14-generic) I'll start with some lspci 
info to prove the card is connected:

lspci -v:
04:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH S2-3200
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at febffc00 (32-bit, non-prefetchable) [size=512]

I can compile the drivers just fine, I followed the instructions from 
this French page:
http://wilco.bercot.org/debian/s2-3200.html  
<http://wilco.bercot.org/debian/s2-3200.html>(I don't completely 
understand French, but we all speak code!)

But after loading the drivers I don't get a /dev/dvb folder.
My dmesg output only shows this message:
saa7146: register extension 'budget_ci dvb'.

My problem reminds me of this one, from this mailing list: 
http://www.linuxtv.org/pipermail/linux-dvb/2007-May/018287.html

However, on that post (which is over a year old) they're talking about 
other drivers from the same author (stb0899-v4l-dvb) which seem to be 
part of the multiproto drivers now.
(Adding to all the confusion is another driver called "multiproto-plus".)

Basically, I'm following year old tutorials and I don't know which 
driver is correct.

I do know that both drivers requires some kind of patch, but for the 
multiproto drivers this seems to be for a newer kernel ("Patch pour 
noyau 2.6.24") and the patch for the stb0899-v4l-dvb is a dead-link now.

Keep in mind that I have not connected my LNB yet  - I still need to put 
up my satellite tonight, but I should still be able to see the /dev/dvb 
links, no?

Thank you for your time!

Jelle De Loecker
<http://jusst.de/manu/stb0899-v4l-dvb.tar.bz2>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
