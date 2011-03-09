Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50723 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1CIOUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 09:20:12 -0500
Received: by eyx24 with SMTP id 24so152114eyx.19
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 06:20:11 -0800 (PST)
From: =?iso-8859-1?Q?Pascal_J=FCrgens?=
	<lists.pascal.juergens@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Simultaneous recordings from one frontend
Date: Wed, 9 Mar 2011 15:20:06 +0100
Message-Id: <B7991825-5F55-4AA0-AB7B-BB2A968F7464@googlemail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

SUMMARY: What's the best available tool for demultiplexing into multiple simultaneous recordings (files)?

I'm looking for a way to record a program (video, audio, subtitle, teletext PIDs) to overlapping files (ie, files2 should start 5 minutes before file1 ends). This means that two readers need to access the card at once. As far as I can tell from past discussions [1], this is not a feature that's currently present or planned in the kernel.

So while searching for a userspace app that is capable of this, I found two options[3]:

- Adam Charrett's dvbstreamer [2] seems to run a sort-of ringbuffer and can output to streams and files. However, it's not all too stable, especially when using the remote control protocol and in low signal situations.

- the RTP streaming apps (dvblast, mumudvb, dvbyell etc.) are designed to allow multiple listeners. The ideal solution would be something like an interface-local ipv6 multicast. Sadly, I haven't gotten that to work [4].

Hence my questions are:
- Am I doing something wrong and is there actually an easy way to stream to two files locally?
- Is there some other solution that I'm not aware of that fits my scenario perfectly?

Thanks in advance,
regards,
Pascal Juergens

[1] http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.html /
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15413
[2] http://sourceforge.net/projects/dvbstreamer/

[3] There's also the Linux::DVB::DVBT perl extension, but in my tests it wasn't happy about recording anything: "timed out waiting for data : Inappropriate ioctl for device at /usr/local/bin/dvbt-record line 53"

[4] dvblast, for example, gives "warning: getaddrinfo error: Name or service not known
error: Invalid target address for -d switch" when using [ff01::1%eth0] as the target address.
Additionally, I wasn't able to consume a regular ipv4 multicast with two instances of mplayer - the first one worked, the second one couldn't access the url.