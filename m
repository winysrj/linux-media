Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ricksjunk@charter.net>) id 1P8Q1m-0008FL-O8
	for linux-dvb@linuxtv.org; Wed, 20 Oct 2010 06:11:51 +0200
Received: from mta31.charter.net ([216.33.127.82])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1P8Q1j-0004Dv-C8; Wed, 20 Oct 2010 06:11:50 +0200
Received: from imp10 ([10.20.200.15]) by mta31.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20101020041145.VMLV4190.mta31.charter.net@imp10>
	for <linux-dvb@linuxtv.org>; Wed, 20 Oct 2010 00:11:45 -0400
Message-ID: <4CBE6BF8.2000607@charter.net>
Date: Tue, 19 Oct 2010 23:11:36 -0500
From: RickCharter <ricksjunk@charter.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] kworld atsc120 tuner problems....
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

  Starting with the 2.6.35 kernels, my KWorld ATSC120 tuner will not 
lock on to any channels.  Everything works fine up to 2.6.34.7, but will 
not work with the newer kernels.  This card uses CX88-dvb, s5h1409, and 
xc2028/3028 modules, and all modules load without any errors. Firmware 
loads properly. In my /var/log/messages files, I get:

Oct 19 22:46:03 slackware kernel: cx88[0]: Calling XC2028/3028 callback
Oct 19 22:46:31 slackware last message repeated 25 times
Oct 19 22:46:33 slackware kernel: cx88[0]: Calling XC2028/3028 callback
Oct 19 22:47:04 slackware last message repeated 28 times
Oct 19 22:48:05 slackware last message repeated 55 times
Oct 19 22:49:03 slackware last message repeated 39 times
Oct 19 22:54:58 slackware kernel: cx88[0]: Calling XC2028/3028 callback
Oct 19 22:55:59 slackware last message repeated 48 times
Oct 19 22:56:02 slackware last message repeated 3 times

Tried to tune a channel in Kaffeine, get: kaffeine(2015) 
DvbDevice::frontendEvent: tuning failed

Xine and mplayer freeze trying to channel lock, Mythtv cannot lock on 
any channel.

Tried using a rc7 of the 2.36 kernel, get same problem... nothing after 
2.6.34.7 seems to work!

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
