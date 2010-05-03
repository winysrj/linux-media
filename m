Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab0ECAB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 20:01:56 -0400
Message-ID: <4BDE1267.2040508@infradead.org>
Date: Sun, 02 May 2010 21:01:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, VDR User <user.vdr@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: av7110 crash when unloading.
References: <y2wa3ef07921005011221h4b71c791p7c906ab150875144@mail.gmail.com> <201005022157.08106@orion.escape-edv.de> <201005022216.14727.hverkuil@xs4all.nl>
In-Reply-To: <201005022216.14727.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 02 May 2010 21:57:07 Oliver Endriss wrote:
>> Hi,
>>
>> On Saturday 01 May 2010 21:21:38 VDR User wrote:
>>> I just grabbed the latest hg tree and got the following when I tried
>>> to unload the drivers for my nexus-s:
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077154] Oops: 0000 [#1] SMP
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077156] last sysfs file:
>>> /sys/devices/virtual/vtconsole/vtcon0/uevent
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077193] Process rmmod (pid: 5099, ti=f6a54000
>>> task=f5311490 task.ti=f6a54000)
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077300] CR2: 0000000000000000
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077296] EIP: [<f98dfeaa>]
>>> v4l2_device_unregister+0x14/0x4f [videodev] SS:ESP 0068:f6a55e7c
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077273] Code: 89 c3 8b 00 85 c0 74 0d 31 d2 e8 90
>>> 91 8c c7 c7 03 00 00 00 00 5b c3 57 85 c0 56 89 c6 53 74 42 e8 da ff
>>> ff ff 8b 5e 04 83 c6 04 <8b> 3b eb 2f 89 d8 e8 fb fe ff ff f6 43 0c 01
>>> 74 0c 8b 43 3c 85
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077195] Stack:
>>>
>>> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
>>> test kernel: [  814.077211] Call Trace:
>>>
>>> The modules wouldn't unload and a reboot was needed to clear it.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> See
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg16895.html
>>
>> CU
>> Oliver
>>
>>
> 
> The patch to fix this is in the git fixes tree for quite some time, but since
> it hasn't been upstreamed yet it is still not in the v4l-dvb git or hg trees.
> I've asked Mauro when he is going to do that, I can't do much more.

My intention is to finish merging patches and sending the pending stuff upstream 
tomorrow. That's said, I'll need to adopt a different procedure on -git, on order 
to better handle merges. With the current way, we would backport from fixes.git
only with 2.6.35 stable. I'll probably opt to have some topic branches and commit 
work into a topic branch, only merging at master after being upstream.

With relation to -hg, Douglas is the maintainer. I think he is considering to
backport also from fixes.git.
> 
> For the time being you can apply the diff from fixes.git:
> 
> http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73
> 
> Save to e.g. fix.diff, go to the linux directory in your v4l-dvb tree and apply it.
> 
> Regards,
> 
> 	Hans
> 


-- 

Cheers,
Mauro
