Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp122.mail.ukl.yahoo.com ([77.238.184.53]:32496 "HELO
	smtp122.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752978AbZIQRYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 13:24:22 -0400
Message-ID: <4AB270C8.1070107@yahoo.it>
Date: Thu, 17 Sep 2009 19:24:24 +0200
From: SebaX75 <sebax75@yahoo.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Tuning problem during scan with Pinnacle Hybrid Stick 320E (em28xx)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I've identified a problem, but after an IRC session 
(http://linuxtv.org/irc/v4l/index.php?date=2009-09-16) with Devin 
Heitmueller, he he did not understand what happens to my adapter, and no 
others seems to have reported this problem.

My configuration is Fedora 11 with kernel 2.6.30.5-43.fc11.i686.PAE and 
latest v4l-dvb tree; the adapter is a Pinnacle Dazzle Hybrid Stick 320E 
(EEPROM-ID=0x9567eb1a, EEPROM-hash=0xb8846b20).

The problem is that the adapter isn't able to performe a full scan 
searching for all channel, but it's able to tune (if trasmission are 
present) and scan only the first MUX, all MUX that follow this are not 
tunable. It is like the adapter, after first tuning attemp, remain 
locked and can't tune to other frequency or receive anymore data from 
aerial signal.

At http://pastebin.com/f75008ea6 is possible to see dmesg during various 
operation with tuner_xc2028 debug enabled:
* 1-178 - insert of device;
* 180-514 - first tuning section (only first MUX, at 474MHz, was tuned, 
nothing for 482 or 514MHz);
* 516-803 - second tuning section (only first MUX, at 514MHz, was tuned, 
nothing for 482 or 474MHz).

With the support of Devin Heitmueller, I've tried to enable debug of 
zl10353 too, but he has not seen anything useful to solve the problem 
and he has told to me that is necessary to found someone to add a bunch 
of printk() statements, and try to figure out what is going on.

Now I need to know if there are other people who have the same problem 
or if there is someone who can provide support to better identify the 
problem and correct it. Logically I'll do all test required and 
necessary to solve this.

Thanks to all for attention,
Sebastian
