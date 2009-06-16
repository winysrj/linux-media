Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailfe04.tele2.it ([212.247.154.109] helo=swip.net)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sarkiaponius@alice.it>) id 1MGMg6-0004JN-Em
	for linux-dvb@linuxtv.org; Tue, 16 Jun 2009 02:37:32 +0200
Received: from [93.145.98.22] (account cxu-4hk-aaa@tele2.it HELO debian.it)
	by mailfe04.swip.net (CommuniGate Pro SMTP 5.2.13)
	with ESMTPA id 1259718944 for linux-dvb@linuxtv.org;
	Tue, 16 Jun 2009 02:37:26 +0200
From: Andrea Giuliano <sarkiaponius@alice.it>
To: linux-dvb@linuxtv.org
Date: Tue, 16 Jun 2009 02:37:25 +0200
Message-Id: <1245112645.12983.9.camel@localhost>
Mime-Version: 1.0
Subject: [linux-dvb] Choppy audio/video with KWorld DVB-S 100...
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

Hi,

I've been watching and recording free channels for almost a couple of
year with this card, using MythTV, but suddenly some weeks ago I
couldn't any more.

I thought it was a problem with the signal in my region, but it could
not be the case, since I still can watch TV perfectly fine with the same
dish and a set top box.

Also, at present MythTV says "signal 98%, s/n 4.8db", which sounds
strange.

Last but not least, femon -H gives the following output:

FE: Conexant CX24123/CX24109 (DVBS)
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  64% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  60% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  63% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  63% | ber 35 | unc 0 | 
Problem retrieving frontend information: Operation not supported
status S     | signal  44% | snr  62% | ber 35 | unc 0 | 

The lines about a problem are new to me: I ran femon many many times in
the past without those lines. Please also note the completely different
value for the strength (44% vs 98% that MythTV says).

I'm afraid my card could be damaged, or something is going wrong with
driver, config or what else.

What's going on?

Any hint would be much appreciated.

---
Andrea

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
