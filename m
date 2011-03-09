Return-path: <mchehab@pedra>
Received: from tuur.schedom-europe.net ([193.109.184.94]:58265 "EHLO
	tuur.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab1CIOze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 09:55:34 -0500
Date: Wed, 9 Mar 2011 15:47:37 +0100
From: Guy Martin <gmsoft@tuxicoman.be>
To: Pascal =?UTF-8?B?SsO8cmdlbnM=?=
	<lists.pascal.juergens@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Simultaneous recordings from one frontend
Message-ID: <20110309154737.3a567af8@borg.bxl.tuxicoman.be>
In-Reply-To: <B7991825-5F55-4AA0-AB7B-BB2A968F7464@googlemail.com>
References: <B7991825-5F55-4AA0-AB7B-BB2A968F7464@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi Pascal,

I've written a very small program that does just that :
https://svn.tuxicoman.be/listing.php?repname=dvbsplit
It's a quick hack, there is probably a better way to do this but at
least it works :)

To get the sources : "svn checkout
https://svn.tuxicoman.be/svn/dvbsplit/trunk dvbsplit". Check the readme
for compilation.

You'll need to tune to the right TP with `{stc}zap -r`, then start it
and it will dump everything in the directory.

HTH,
  Guy

On Wed, 9 Mar 2011 15:20:06 +0100
Pascal Jürgens  <lists.pascal.juergens@googlemail.com> wrote:

> Hi all,
> 
> SUMMARY: What's the best available tool for demultiplexing into
> multiple simultaneous recordings (files)?
> 
> I'm looking for a way to record a program (video, audio, subtitle,
> teletext PIDs) to overlapping files (ie, files2 should start 5
> minutes before file1 ends). This means that two readers need to
> access the card at once. As far as I can tell from past discussions
> [1], this is not a feature that's currently present or planned in the
> kernel.
> 
> So while searching for a userspace app that is capable of this, I
> found two options[3]:
> 
> - Adam Charrett's dvbstreamer [2] seems to run a sort-of ringbuffer
> and can output to streams and files. However, it's not all too
> stable, especially when using the remote control protocol and in low
> signal situations.
> 
> - the RTP streaming apps (dvblast, mumudvb, dvbyell etc.) are
> designed to allow multiple listeners. The ideal solution would be
> something like an interface-local ipv6 multicast. Sadly, I haven't
> gotten that to work [4].
> 
> Hence my questions are:
> - Am I doing something wrong and is there actually an easy way to
> stream to two files locally?
> - Is there some other solution that I'm not aware of that fits my
> scenario perfectly?
> 
> Thanks in advance,
> regards,
> Pascal Juergens
> 
> [1]
> http://www.linuxtv.org/pipermail/linux-dvb/2008-February/024093.html /
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15413
> [2] http://sourceforge.net/projects/dvbstreamer/
> 
> [3] There's also the Linux::DVB::DVBT perl extension, but in my tests
> it wasn't happy about recording anything: "timed out waiting for
> data : Inappropriate ioctl for device at /usr/local/bin/dvbt-record
> line 53"
> 
> [4] dvblast, for example, gives "warning: getaddrinfo error: Name or
> service not known error: Invalid target address for -d switch" when
> using [ff01::1%eth0] as the target address. Additionally, I wasn't
> able to consume a regular ipv4 multicast with two instances of
> mplayer - the first one worked, the second one couldn't access the
> url.-- To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

