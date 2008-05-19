Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 108.203.233.220.exetel.com.au ([220.233.203.108]
	helo=hack.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian@hack.id.au>) id 1Jy1H7-0006mY-ML
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 11:03:26 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by hack.id.au (Postfix) with ESMTP id 196952101AB
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 19:02:43 +1000 (EST)
Received: from hack.id.au ([127.0.0.1])
	by localhost (shonky.hack.id.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V3dWRWO4dKnS for <linux-dvb@linuxtv.org>;
	Mon, 19 May 2008 19:02:39 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by hack.id.au (Postfix) with ESMTP id 778422107C5
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 19:02:39 +1000 (EST)
Received: from CHLAPTOP (unknown [192.168.99.157])
	by hack.id.au (Postfix) with ESMTP id 808BA2101AB
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 19:02:38 +1000 (EST)
From: "Christian Hack" <christianh@edmi.com.au>
To: <linux-dvb@linuxtv.org>
Date: Mon, 19 May 2008 19:00:27 +1000
Message-ID: <000f01c8b98e$c88e6950$07000100@edmi.local>
MIME-Version: 1.0
Subject: [linux-dvb] LifeView TV Walker Twin DVB-T (LR540) Problem
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

Hi guys,

I've got one of these that has been successfully working on my MythDora
(based on Fedora 8) machine for the past few months. It didn't ever scan
properly though. I was able to use my other cards to populate the channel
list. Once the channels were set up, it worked perfectly.

All of sudden it seems to have stopped working. Using dvbtune it is unable
to lock on to a signal. In MythTV I just get a garbled mess like a very bad
signal. The audio is almost intelligble, video is a mess.

The firmware is in the right spot (as it was working before). I even
downloaded it again to check it hadn't somehow corrupted. As far as I am
aware nothing has changed (well it must have since it's not working).

Unplugging it and using it on my WinXP laptop it seems to work fine. So the
hardware, cabling etc should alright.

I'm not real sure what to try now. I can't seem to get the debug options
with the kernel modules to work properly. I'm not getting any extra info
output that I can see i.e. I'm doing this:
modprobe dvb_usb debug=511
modprobe dvb_usb_m920x debug=1
Is that right?

>From /var/log/messages it all looks ok. (I have to Hauppage PCI Nova-Ts that
are running just fine)

May 19 18:52:16 mythtv kernel: dvb-usb: found a 'LifeView TV Walker Twin
DVB-T USB2.0' in warm state.
May 19 18:52:16 mythtv kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
May 19 18:52:16 mythtv kernel: DVB: registering new adapter (LifeView TV
Walker Twin DVB-T USB2.0)
May 19 18:52:16 mythtv kernel: DVB: registering frontend 2 (Philips
TDA10046H DVB-T)...
May 19 18:52:16 mythtv kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
May 19 18:52:16 mythtv kernel: DVB: registering new adapter (LifeView TV
Walker Twin DVB-T USB2.0)
May 19 18:52:16 mythtv kernel: DVB: registering frontend 3 (Philips
TDA10046H DVB-T)...
May 19 18:52:16 mythtv kernel: input: IR-receiver inside an USB DVB receiver
as /class/input/input12
May 19 18:52:16 mythtv kernel: dvb-usb: schedule remote query interval to
100 msecs.
May 19 18:52:16 mythtv kernel: dvb-usb: LifeView TV Walker Twin DVB-T USB2.0
successfully initialized and connected.
May 19 18:52:16 mythtv kernel: usbcore: registered new interface driver
dvb_usb_m920x

Any ideas or suggestions on where to look in terms of debugging?

Whilst I'm here is there anyway to force DVB frontend ids? It seems to
randomly order them i.e. sometimes 1 and 3 are the Nova-Ts, sometimes they
are 0 and 1 etc...

Thanks
CH


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
