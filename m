Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3218 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab0EBUPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 16:15:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: av7110 crash when unloading.
Date: Sun, 2 May 2010 22:16:14 +0200
Cc: VDR User <user.vdr@gmail.com>, Oliver Endriss <o.endriss@gmx.de>
References: <y2wa3ef07921005011221h4b71c791p7c906ab150875144@mail.gmail.com> <201005022157.08106@orion.escape-edv.de>
In-Reply-To: <201005022157.08106@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005022216.14727.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 02 May 2010 21:57:07 Oliver Endriss wrote:
> Hi,
> 
> On Saturday 01 May 2010 21:21:38 VDR User wrote:
> > I just grabbed the latest hg tree and got the following when I tried
> > to unload the drivers for my nexus-s:
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077154] Oops: 0000 [#1] SMP
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077156] last sysfs file:
> > /sys/devices/virtual/vtconsole/vtcon0/uevent
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077193] Process rmmod (pid: 5099, ti=f6a54000
> > task=f5311490 task.ti=f6a54000)
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077300] CR2: 0000000000000000
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077296] EIP: [<f98dfeaa>]
> > v4l2_device_unregister+0x14/0x4f [videodev] SS:ESP 0068:f6a55e7c
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077273] Code: 89 c3 8b 00 85 c0 74 0d 31 d2 e8 90
> > 91 8c c7 c7 03 00 00 00 00 5b c3 57 85 c0 56 89 c6 53 74 42 e8 da ff
> > ff ff 8b 5e 04 83 c6 04 <8b> 3b eb 2f 89 d8 e8 fb fe ff ff f6 43 0c 01
> > 74 0c 8b 43 3c 85
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077195] Stack:
> > 
> > Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> > test kernel: [  814.077211] Call Trace:
> > 
> > The modules wouldn't unload and a reboot was needed to clear it.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> See
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg16895.html
> 
> CU
> Oliver
> 
> 

The patch to fix this is in the git fixes tree for quite some time, but since
it hasn't been upstreamed yet it is still not in the v4l-dvb git or hg trees.
I've asked Mauro when he is going to do that, I can't do much more.

For the time being you can apply the diff from fixes.git:

http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73

Save to e.g. fix.diff, go to the linux directory in your v4l-dvb tree and apply it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
