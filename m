Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web112510.mail.gq1.yahoo.com ([98.137.26.158])
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <dalton_harvie@yahoo.com.au>) id 1MgJZT-0006lI-Ao
	for linux-dvb@linuxtv.org; Wed, 26 Aug 2009 16:33:56 +0200
Message-ID: <357341.28380.qm@web112510.mail.gq1.yahoo.com>
Date: Wed, 26 Aug 2009 07:33:20 -0700 (PDT)
From: Dalton Harvie <dalton_harvie@yahoo.com.au>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Can ir polling be turned off in cx88 module for Leadtek
	1000DTV card?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

I'm no expert with this stuff but have been using mythtv under ubuntu for a while.  Lately the machine became quite sluggish.

I have two Leadtek 1000DTV cards and a usb remote in a ubuntu 8.04 (2.6.24-24-generic) machine with the standard packaged kernel.

>From /var/log/dmesg
[   56.656386] cx88[0]: subsystem: 107d:665f, board: WinFast DTV1000-T [card=35,autodetected]


I installed powertop and found that there were 500 wakeups/s occuring from `run_workqueue (ir_timer)' which I assume is to do with polling the built in remote receiver on these tuner cards.  I no longer use these Leadtek remotes, instead using a mceusb type one - so would like to stop this polling.

I tried a hack with my limited c knowledge - I edited cx88-input.c to remove all references to the DTV1000 card (two places) and recompiled the modules.  Now the rapid polling has gone.  The reponse of the new mceusb remote seems to be much better now too.  The problem is that I don't want to have to recompile these modules each time there is an update package to the kernel available.

My question is - is there any way to stop this polling without having to recompile the modules?  Some option to pass to them maybe?  If there isn't, would it be a good idea?

Thanks for any help.


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
