Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1Kl4Oy-0003O0-8j
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 18:18:14 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	BCE4718001C9
	for <linux-dvb@linuxtv.org>; Wed,  1 Oct 2008 16:17:56 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: linux-dvb@linuxtv.org
Date: Wed, 1 Oct 2008 10:17:56 -0600
Message-Id: <20081001161756.860D24476B@ws5-1.us4.outblaze.com>
Subject: [linux-dvb] Linux and Pinnacle HDTV Pro USB Stick
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

Greetings,

I have searched all over this web site and its forums for a solution to my dilemma and have not yet found one.  I am at my wit's end so turn to you for assistance.  

I have this Pinnacle USB tuner stick connected via RF to the back of my cable box (Motorola DCH6200 provided by Brighthouse Networks) and via USB 2 to my desktop computer.  With Pinnacle's software in Windoze, I can tune to channel 3 and whatever is selected on the set top box plays fine in a window on the computer monitor.  

I cannot get the same result in Linux (Ubuntu Hardy Heron).  I have found several websites which say this is basically the same hardware (em28xx device) as Hauppage's 950 stick and that it works with Myth TV.  I followed the instructions explicitly for downloading, compiling, and installing video4linux and appropriate drivers, etc, but cannot get any application I try (MeTV, Myth TV, Kaffeine, MPlayer, etc) to tune that one channel. I have tried all the standard cable, QAM, ATSC frequencies to no avail.

I had a look at dmesg and the em28xx device/module loads fine and when I launch a video application the firmware is apparently loaded correctly, as well.  I have also tried connecting the RF end of the stick directly to the cable (bypassing the set top box) and couldn't tune anything that way either.  Without the set top box, there are mainly analog but also some digital signals (local channels in hi-def) but I cannot "find" any of them.  Out of desperation I tried using the little portable antenna that comes with the tuner stick and had no luck there either but that is probably inconclusive since I live quite a ways from the nearest tower.  

I do not know how to build a channel.conf file from scratch but even if I did I don't know where to find the frequencies that Brighthouse Networks uses to distribute cable content here in the Florida panhandle.  The only examples of channel.conf files I have been able to find were all for broadcasters in Europe so they were no help.  I am willing to do the scut work to manually build a channel.conf file then post it for others if I can only get the basic information necessary to do so.

So, if anyone out there has successfully gotten this Pinnacle HDTV Pro USB tuner stick to work in Linux (preferably Ubuntu), I would appreciate any and all hints.

Paul in NW Florida

=
Dependable Adoption Courier Service
I provide courier services for adoption from China, Russia, Ukraine, Guatemala, Haiti, India, Vietnam, Nicaragua, Ethiopia, and Brazil. Inexpensive yet reliable service.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=6e2550b8d02ac9f41d459774866ae302


-- 
Powered by Outblaze

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
