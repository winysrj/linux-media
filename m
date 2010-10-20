Return-path: <mchehab@pedra>
Received: from que21.charter.net ([209.225.8.22]:39379 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0JTR5U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 13:57:20 -0400
Received: from imp11 ([10.20.200.11]) by mta21.charter.net
          (InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
          id <20101020173833.VKRD3705.mta21.charter.net@imp11>
          for <linux-media@vger.kernel.org>;
          Wed, 20 Oct 2010 13:38:33 -0400
Message-ID: <4CBF291B.1080506@charter.net>
Date: Wed, 20 Oct 2010 12:38:35 -0500
From: RickCharter <ricksjunk@charter.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx88_dvb cannot lock channels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  Starting with the 2.6.35 kernels, my KWorld ATSC120 tuner will not 
lock on to any channels.  Everything works fine up to 2.6.34.7, but will 
not work with the newer kernels.  This card uses CX88-dvb, s5h1409, and 
xc2028/3028 modules, and all modules load without any errors. Firmware 
loads properly. Only irregularity is that in my /var/log/messages files, 
I get:

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
