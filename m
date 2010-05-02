Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758095Ab0EBT5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 15:57:51 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: VDR User <user.vdr@gmail.com>
Subject: Re: av7110 crash when unloading.
Date: Sun, 2 May 2010 21:57:07 +0200
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
References: <y2wa3ef07921005011221h4b71c791p7c906ab150875144@mail.gmail.com>
In-Reply-To: <y2wa3ef07921005011221h4b71c791p7c906ab150875144@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005022157.08106@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Saturday 01 May 2010 21:21:38 VDR User wrote:
> I just grabbed the latest hg tree and got the following when I tried
> to unload the drivers for my nexus-s:
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077154] Oops: 0000 [#1] SMP
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077156] last sysfs file:
> /sys/devices/virtual/vtconsole/vtcon0/uevent
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077193] Process rmmod (pid: 5099, ti=f6a54000
> task=f5311490 task.ti=f6a54000)
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077300] CR2: 0000000000000000
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077296] EIP: [<f98dfeaa>]
> v4l2_device_unregister+0x14/0x4f [videodev] SS:ESP 0068:f6a55e7c
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077273] Code: 89 c3 8b 00 85 c0 74 0d 31 d2 e8 90
> 91 8c c7 c7 03 00 00 00 00 5b c3 57 85 c0 56 89 c6 53 74 42 e8 da ff
> ff ff 8b 5e 04 83 c6 04 <8b> 3b eb 2f 89 d8 e8 fb fe ff ff f6 43 0c 01
> 74 0c 8b 43 3c 85
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077195] Stack:
> 
> Message from syslogd@test at Sat May  1 12:19:23 2010 ...
> test kernel: [  814.077211] Call Trace:
> 
> The modules wouldn't unload and a reboot was needed to clear it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

See
http://www.mail-archive.com/linux-media@vger.kernel.org/msg16895.html

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
