Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39680 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0EATVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 May 2010 15:21:39 -0400
Received: by vws19 with SMTP id 19so929575vws.19
        for <linux-media@vger.kernel.org>; Sat, 01 May 2010 12:21:38 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 May 2010 12:21:38 -0700
Message-ID: <y2wa3ef07921005011221h4b71c791p7c906ab150875144@mail.gmail.com>
Subject: av7110 crash when unloading.
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just grabbed the latest hg tree and got the following when I tried
to unload the drivers for my nexus-s:

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077154] Oops: 0000 [#1] SMP

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077156] last sysfs file:
/sys/devices/virtual/vtconsole/vtcon0/uevent

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077193] Process rmmod (pid: 5099, ti=f6a54000
task=f5311490 task.ti=f6a54000)

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077300] CR2: 0000000000000000

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077296] EIP: [<f98dfeaa>]
v4l2_device_unregister+0x14/0x4f [videodev] SS:ESP 0068:f6a55e7c

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077273] Code: 89 c3 8b 00 85 c0 74 0d 31 d2 e8 90
91 8c c7 c7 03 00 00 00 00 5b c3 57 85 c0 56 89 c6 53 74 42 e8 da ff
ff ff 8b 5e 04 83 c6 04 <8b> 3b eb 2f 89 d8 e8 fb fe ff ff f6 43 0c 01
74 0c 8b 43 3c 85

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077195] Stack:

Message from syslogd@test at Sat May  1 12:19:23 2010 ...
test kernel: [  814.077211] Call Trace:

The modules wouldn't unload and a reboot was needed to clear it.
