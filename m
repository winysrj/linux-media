Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.udag.de ([62.146.106.17]:47004 "EHLO smtp01.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbcACTdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2016 14:33:13 -0500
Subject: Elgato Game Capture HD on Linux
To: Steven Toth <stoth@kernellabs.com>
References: <536C3403.8010402@cevel.net>
 <CALzAhNVtyhmt8cCapu2oK5pGkJY2zNTaf6Ws26Sn9kZxgAddew@mail.gmail.com>
 <54988806.7030800@cevel.net>
 <CALzAhNXOzR-HXLANQvT=GeskxmiHSJgd1TffrHy_pVhLeQXdTQ@mail.gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
From: Tolga Cakir <tolga@cevel.net>
Message-ID: <568967D7.60403@cevel.net>
Date: Sun, 3 Jan 2016 19:26:31 +0100
MIME-Version: 1.0
In-Reply-To: <CALzAhNXOzR-HXLANQvT=GeskxmiHSJgd1TffrHy_pVhLeQXdTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,


I wish you a happy new year, it's been a while. I've made great success 
on the Elgato Game Capture HD driver for Linux - the major features are 
working. Currently, it's supporting capturing / streaming HDMI with 
1080p30 and 720p60, and component with 1080p30, 1080i60, 720p60 and 
576p50 (PAL). Eventhough I've just quickly hacked together everything, 
I've learned alot.

The official Mac OS X drivers included files with comments. They were my 
cheatsheet. One important thing, I've just recently figured out: the 
official driver is not doing stuff sequentially, like I've always 
assumed. It's doing many things in parallel using threads. This is the 
reason, why reverse engineering has been a nightmare for me, cause lots 
of unrelated, random packets showed up and I couldn't interpret them. No 
two USB logs looked nearly the same - there were always differences. 
Sometimes major, sometimes minor.

There seems to be one thread, which is trying to receive bulk data on 
endpoints 0x04 and 0x01 (maybe even one thread per endpoint?), without 
any sleep. This was causing LOTS of USB log entries in conjunction with 
my USB hardware analyzer - talking about 5 - 8 million lines for 20 seconds.

Another thread is constantly checking the input source's information, 
like resolution (small sleeps, unlike bulk receive). If it changes, this 
thread writes new, customized configuration to the device. I have logged 
lots of different traffic and am sure, that I can track this down.

There seems to be another thread, which seems to do just the things, I 
was actually trying to track down in the first place: plain simple 
device setup / initialization. Just sending over some packets, like 
bitrate configuration and video output resolution. Luckily, most of 
these values are commented in Elgato's official Mac OS X driver and I've 
also figured out, how most of them work 
(https://github.com/tolga9009/elgato-gchd/blob/master/commands.h).

Eventhough lots and lots of refactoring is urgently waiting for me 
(honestly, I'm ashamed of it), I think it's atleast a good point to 
start. I'm gonna work on refactoring / tidying up next major hacking 
session in about 2 - 3 months. You can find the latest code here: 
https://github.com/tolga9009/elgato-gchd. Looking forward to port this 
over to V4L2, once the refactoring is done.

If you're interested in how things turned out, I've even uploaded a 
small video presentation on YouTube: 
https://youtu.be/rpm6TJu6HkE?t=6m34s. You can skip it to around 6:30, 
cause I'm just showing how to compile & firmware extraction first.


Cheers,
Tolga
