Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754032Ab0BAT1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 14:27:06 -0500
Subject: Re: Kernel Oops, dvb_dmxdev_filter_reset, bisected
From: Chicken Shack <chicken.shack@gmx.de>
To: Thomas Voegtle <tv@lio96.de>
Cc: obi@linuxtv.org, mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1002011855590.30919@er-systems.de>
References: <alpine.LNX.2.00.1002011855590.30919@er-systems.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 20:25:21 +0100
Message-ID: <1265052321.19005.8.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 01.02.2010, 19:06 +0100 schrieb Thomas Voegtle:
> Hello,
> 
> yesterday I moved from 2.6.31.y to 2.6.32 and found a reproducable kernel 
> oops.
> Bug is in Linus' tree, too.
> 
> I use a Hauppauge Nova-T Stick with dvb_usb_dib0700
> 
> I start mplayer (no problems so far) and then alevt. Then there comes
> the Oops:
> 
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> Modules linked in: i915 drm_kms_helper video backlight output microcode 
> loop mt2060 dvb_usb_dib0700 dib7000p dib7000m dib0070 dvb_usb dib8000 
> dvb_core dib3000mc dibx000_common uhci_hcd ehci_hcd usbcore
> 
> Pid: 3429, comm: alevt Not tainted 2.6.33-rc6 #17 MS-7267/MS-7267
> EIP: 0060:[<f86bb11b>] EFLAGS: 00210246 CPU: 1
> EIP is at dvb_dmxdev_filter_reset+0x1a/0x80 [dvb_core]
> EAX: 00000000 EBX: f886b204 ECX: fffffff8 EDX: e0cb3000
> ESI: f886b204 EDI: f886b208 EBP: f27ff440 ESP: e0cb3f48
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process alevt (pid: 3429, ti=e0cb3000 task=e9dcdb20 task.ti=e0cb3000)
> Stack:
>   00000008 f886b204 f75bc88c f86bb1b9 f27ff440 f886b27c f75bc8d0 00000008
> <0> f7111744 f6e5fc54 f27ff440 c1074013 f7111744 f741dcc0 f6e5fc54 
> 00000000
> <0> f27ff440 f74673c0 e0cb3000 c1071a92 f74673c0 00000003 080674e8 
> c1071af2
> Call Trace:
>   [<f86bb1b9>] ? dvb_demux_release+0x38/0x107 [dvb_core]
>   [<c1074013>] ? __fput+0xd5/0x169
>   [<c1071a92>] ? filp_close+0x45/0x4b
>   [<c1071af2>] ? sys_close+0x5a/0x8d
>   [<c1002710>] ? sysenter_do_call+0x12/0x26
>   [<c12b0000>] ? pci_read_bridge_bases+0x173/0x2fe
> Code: 75 dd 8d 46 54 e8 c2 86 00 00 31 c0 5b 5e 5f 5d c3 57 56 53 89 c3 83 
> 78 4c 01 76 6f 83 78 48 02 75 49 8b 40 04 8d 7b 04 8d 48 f8 <8b> 41 08 8d 
> 70 f8 eb 28 8b 41 08 8b 51 0c 89 50 04 89 02 c7 41
> EIP: [<f86bb11b>] dvb_dmxdev_filter_reset+0x1a/0x80 [dvb_core] SS:ESP 
> 0068:e0cb3f48
> CR2: 0000000000000000
> ---[ end trace 629e2045091796f7 ]---
> 
> 
> 
> I bisected this down to:
> 
> root@scratchy:/data/kernel/linux-2.6# git bisect bad
> 1cb662a3144992259edfd3cf9f54a6b25a913a0f is first bad commit
> commit 1cb662a3144992259edfd3cf9f54a6b25a913a0f
> Author: Andreas Oberritter <obi@linuxtv.org>
> Date:   Tue Jul 14 20:28:50 2009 -0300
> 
>      V4L/DVB (12275): Add two new ioctls: DMX_ADD_PID and DMX_REMOVE_PID
> ...
> 
> 
> Reverting the patch on top of 2.6.33-rc6, I can start mplayer 
> and alevt with no problems.

Hi Thomas,

thanks for reproducing that kernel oops.

Question:

Can you also confirm / reproduce that alevt does not follow the new TV
or radio channel if the new channel, tuned by dvbstream / mplayer for
example, is part of another transponder?

Normal, i. e. expected behaviour can be desribed in the following
example:

a. You start mplayer://ZDF, then you start alevt, and ZDF teletext
should be visible.

b. You change the channel to mplayer://Das Erste.
Now alevt should follow the new tuning and tune one channel of the
transponder containing the ARD bouquet.

But instead of that alevt hangs and cannot be finished by an ordinary
quit. You need _violence_ a la "killall -9 alevt" or, on the command
line: STRG-C as shortcut.

Can you reproduce / confirm that, Thomas?

Thanks

CS
 




> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


