Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway14.websitewelcome.com ([69.93.164.18])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JyjPm-00007u-PL
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 10:11:16 +0200
Received: from [77.109.107.126] (port=48144 helo=[127.0.0.1])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1JyjPb-0004J9-It
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 03:11:03 -0500
Message-ID: <4833D91A.1050101@kipdola.com>
Date: Wed, 21 May 2008 10:11:06 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
Subject: [linux-dvb] TT S2-3200 LIRC remote - Multiproto drivers merge?
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

Hello again,

I finally got the Technotrend S2-3200 to work on LinuxMCE 0710, now I'm 
wondering how to get the IR transceiver to work. (Not that I've managed 
to get mythtv working, but since activity on that subject is a bit 
slower...)

I already tried to ask on the lirc mailing list, but it seems like a 
very dead place.

My dmesg output proves the transceiver is discovered and I have a 
/dev/class/input kind of file, I just don't know how to get lirc to 
work, or how to get a /dev/lirc0 file (I actually already have another 
transceiver on this computer which apparantly only works with MCE 
remotes (it's an integrated IR transceiver in my Antec Fusion v2 case)) 
since there isn't a specific driver in lirc for this technotrend card.

Now, I want to get some facts straight about the multiproto driver:
Is it "done"? What's the big difference between multiproto and 
multiproto plus? (Even though there hasn't been an update in 5 weeks for 
the regular drivers, the plus drivers seemed to have more activity)

Or is it correct to assume that now only the software applications need 
to get a patch to work with our multiproto drivers?

And, looking at the multiproto_plus drivers, I see they "merged" with 
v4l-dvb - what does this mean exactly?

Thank you for your time,

Jelle De Loecker

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
