Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59675 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab3KIQYO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Nov 2013 11:24:14 -0500
Received: from [192.168.2.109] ([77.191.174.230]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0M5q45-1VqY7A1I6b-00xweS for
 <linux-media@vger.kernel.org>; Sat, 09 Nov 2013 17:24:13 +0100
Message-ID: <527E606A.40101@gmx.de>
Date: Sat, 09 Nov 2013 17:18:50 +0100
From: =?ISO-8859-1?Q?Lorenz_R=F6hrl?= <sheepshit@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: BUG: Freeze upon loading bttv module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i'm having problems loading the bttv-module for my bt878 based DVB-T 
card: my system just freezes. Magic-Syskeys also won't work then.
With kernel 3.9.0 this worked just fine. Versions 3.10, 3.11 and 3.12 
won't work.

Last messages on screen with 3.12 upon booting/loading the module is: 
http://abload.de/img/bttv_freezeqxdn2.png

With kernel 3.9 i get an additional line on module loading and the 
device works fine:
[    1.895037] bttv: 0: add subdevice "dvb0"

I traced the problem, it dies somewhere in v4l2_ctrl_handler_setup on 
line 4169 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/pci/bt8xx/bttv-driver.c#n4169

lspci output from kernel 3.9:
[...]
04:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB card
         Flags: bus master, medium devsel, latency 32, IRQ 16
         Memory at f0401000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

04:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB Card
         Flags: bus master, medium devsel, latency 32, IRQ 16
         Memory at f0400000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bt878
         Kernel modules: bt878



Please CC me as i'm not subscribed to the list.

Thanks!

- Lorenz
