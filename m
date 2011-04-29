Return-path: <mchehab@pedra>
Received: from acoma.acyna.com ([72.9.254.68]:56856 "EHLO acoma.acyna.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab1D2PBn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 11:01:43 -0400
Received: from acoma ([127.0.0.1] helo=[127.0.0.100])
	by acoma.acyna.com with esmtpa (Exim 4.69)
	(envelope-from <linuxtv@hubstar.net>)
	id 1QFkdS-0000OQ-VX
	for linux-media@vger.kernel.org; Fri, 29 Apr 2011 11:09:19 +0100
Message-ID: <4DBAC672.5060503@hubstar.net>
Date: Fri, 29 Apr 2011 15:08:50 +0100
From: linuxtv <linuxtv@hubstar.net>
MIME-Version: 1.0
To: vger <linux-media@vger.kernel.org>
Subject: Fwd: HVR1300 cx88 Blackbird - no audio in mpeg stream at latest level
 - 2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

I am using openSuse 11.4 mythtv 0.24 and patched the drivers (attachment
on the bug) to avoid the locking issue that is in the current kernel
drivers (cx88)

However I can not get audio recorded on this device at this level. Video
is fine. (Recording from the hw encoded stream /dev/video1 on composite1)

I did briefly managed to get audio one day using
v4lctl -c /dev/video1 volume mute off
But once I tried to set it up to automatically run, I've never got audio
again.

I know the hardware is all working, as the same box has Suse 11.1 and
mythtv 0.21 working fine 100% of the time with no hacks. I had to
upgrade as 11.1 to get updates, so went the whole way.

I also tried pulling older driver levels, but unfortunately I'm not
really upto speed with all the changes that happened in v4l and so
drivers at early 2010 I get compilation errors.

Any help / ideas would be great

Sorry I couldn't reply to the first message (not sure how)

I wanted to add the following strangeness

- I can sometimes get it working by running smplayer /dev/video1
Once it is working it stays working until power off
- I added some delays to the start_codec function in cx88-blackbird.c, and
it starts up quicker (one or two smplayer starts). 

However I can't make it start 100% of the time.

Thanks




