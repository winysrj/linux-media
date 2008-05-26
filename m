Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <acros@gmx.de>) id 1K0iLz-0002nw-HN
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 21:27:32 +0200
Message-ID: <483B0F00.4040305@gmx.de>
Date: Mon, 26 May 2008 21:26:56 +0200
From: Acros <acros@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Hauppauge HVR1110 Firmware Not Loading
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

Hello!

I'm having a problem with my Hauppauge HVR1110-Card (a PCI-Card with 
tda10046 Frontend).
I already posted this in the IRC-Channel but got no answer.
I am trying to use the DVB-T-Part of the Card, sometimes it works fine, 
but most the time there is some problem with firmware uploading.
I've turned on debugging in the tda1004x module, and it seems that 
during the firmware upload tda10046_init() is executed a second time and 
messing up something.
Here is a syslog when it's not working, at line 2500 tda10046_init() is 
executed during firmware upload: http://ubuntuusers.de/paste/226485/
The few times it is working, this is not occuring, tda10046_init() is 
only executed once and the firmware upload finishes without errors.
When its not working, also removing and re-inserting of the 
kernel-module doesn't help, i have to reboot the computer.

I am running Ubuntu 8.04 and have no other OS installed where the 
working firmware might be coming from.

I have no clue where this is coming from, maybe something with 
hotplugging? (is hotplug used for firmware upload?)
It is really annoying to reboot the system three or four times to get 
the TV thing working (the sole purpose of this pc is watching tv/movies)

regards
Moritz

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
