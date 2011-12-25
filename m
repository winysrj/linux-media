Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60106 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1LYP5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 10:57:02 -0500
Received: by wgbdr13 with SMTP id dr13so19307373wgb.1
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 07:57:00 -0800 (PST)
Message-ID: <4EF747C7.10001@gmail.com>
Date: Sun, 25 Dec 2011 16:56:55 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mihai Dobrescu <msdobrescu@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Hauppauge HVR-930C problems
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com> <4EE9AA21.1060101@gmail.com> <CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com> <4EEAFF47.5040003@gmail.com> <CALJK-Qhpk7NtSezrft_6+4FZ7Y35k=41xrc6ebxf2DzEH6KCWw@mail.gmail.com> <4EECB2C2.8050701@gmail.com> <4EECE392.5080000@gmail.com> <CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com> <4EEDB060.7070708@gmail.com>
In-Reply-To: <4EEDB060.7070708@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/11 10:20, Fredrik Lingvall wrote:
> On 12/17/11 20:53, Mihai Dobrescu wrote:
>>
>>
>>
>> Mihai,
>>
>> I got some success. I did this,
>>
>> # cd /usr/src (for example)
>>
>> # git clone git://linuxtv.org/media_build.git
>>
>> # emerge dev-util/patchutils
>> # emerge Proc-ProcessTable
>>
>> # cd media_build
>> # ./build
>> # make install
>>
>> Which will install the latest driver on your running kernel (just in 
>> case
>> make sure /usr/src/linux points to your running kernel sources). Then
>> reboot.
>>
>> You should now see that (among other) modules have loaded:
>>
>> # lsmod
>>
>> <snip>
>>
>> em28xx                 93528  1 em28xx_dvb
>> v4l2_common             5254  1 em28xx
>> videobuf_vmalloc        4167  1 em28xx
>> videobuf_core          15151  2 em28xx,videobuf_vmalloc
>>
>> Then try w_scan and dvbscan etc. I got mythtv to scan too now. There 
>> were
>> some warnings and timeouts and I'm not sure if this is normal or not.
>>
>> You can also do a dmesg -c while scanning to monitor the changes en the
>> kernel log.
>>
>> Regards,
>>
>> /Fredrik
>>
>>
>> In my case I have:
>>
>> lsmod |grep em2
>> em28xx_dvb             12608  0
>> dvb_core               76187  1 em28xx_dvb
>> em28xx                 82436  1 em28xx_dvb
>> v4l2_common             5087  1 em28xx
>> videodev               70123  2 em28xx,v4l2_common
>> videobuf_vmalloc        3783  1 em28xx
>> videobuf_core          12991  2 em28xx,videobuf_vmalloc
>> rc_core                11695  11
>> rc_hauppauge,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,em28xx,ir_nec_decoder 
>>
>> tveeprom               12441  1 em28xx
>> i2c_core               14232  9
>> xc5000,drxk,em28xx_dvb,em28xx,v4l2_common,videodev,tveeprom,nvidia,i2c_i801 
>>
>>
>> yet, w_scan founds nothing.
>
> I was able to scan using the "media_build" install method described 
> above but when trying to watch a free channel the image and sound was 
> stuttering severly. I have tried both MythTV and mplayer with similar 
> results.
>
> I created the channel list for mplayer with:
>
> lintv ~ # dvbscan -x0 -fc /usr/share/dvb/dvb-c/no-Oslo-Get -o zap > 
> .mplayer/channels.conf
>
> And, for example,  I get this output from mplayer plus a very (blocky) 
> stuttering image and sound:
>
> lin-tv ~ # mplayer dvb://1@"TV8 Oslo" -ao jack
>

I did some more tests with release snapshots 2011-12-13, 2011-12-21, and 
2011-12-25, respectively. I did this by changing

LATEST_TAR := 
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
LATEST_TAR_MD5 := 
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5

in linux/Makefile to the corresponding release.

Results:

* linux-media-2011-12-13.tar.bz2

The ./build script builds the drivers cleanly, scanning works, but  
watching video does not work correctly.

* linux-media-2011-12-21.tar.bz2

The ./build script fails at the as3645a.c file (on this machine but I 
can build it on two other machines using the same kernel and kernel 
2.6.39-gentoo-r3, respectively). I can build it with make menuconfig etc 
(where I disabled stuff I don't need, eg. disabling [ ] Media Controller 
API (EXPERIMENTAL) ). The em28xx generate a kernel core dump though [1].

* linux-media-2011-12-25.tar.bz2

Same problem as 2011-12-21.

Regards,

/Fredrik

[1]

[ 2231.881231] em28xx #0: chip ID is em2884
[ 2231.933025] em28xx #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[ 2231.933132] em28xx #0: Config register raw data: 0xcb
[ 2231.933139] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000028
[ 2231.933325] IP: [<ffffffffa0df4538>] em28xx_wake_i2c+0x28/0xe0 [em28xx]
[ 2231.933425] PGD 1181ef067 PUD 118383067 PMD 0
[ 2231.933513] Oops: 0000 [#1] PREEMPT SMP
[ 2231.933601] CPU 0
[ 2231.933607] Modules linked in: em28xx(+) xc5000 coretemp drxk 
nvidia(P) dvb_core rc_hauppauge ir_lirc_codec lirc_dev 
ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder 
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder v4l2_common 
videobuf_vmalloc videobuf_core uvcvideo rc_core videobuf2_core videodev 
tveeprom media v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops 
firewire_ohci iwlagn firewire_core mac80211 crc_itu_t snd_hdsp 
snd_rawmidi e1000e [last unloaded: em28xx]
[ 2231.934117]
[ 2231.934117] Pid: 20150, comm: modprobe Tainted: P            
3.0.6-gentoo #2 Dell Inc. Precision M2400                 /0HT029
[ 2231.934117] RIP: 0010:[<ffffffffa0df4538>]  [<ffffffffa0df4538>] 
em28xx_wake_i2c+0x28/0xe0 [em28xx]
[ 2231.934117] RSP: 0018:ffff88011a34fbc8  EFLAGS: 00010213
[ 2231.934117] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000
[ 2231.934117] RDX: ffffffff81c13468 RSI: 0000000000000082 RDI: 
ffff8801184ca000
[ 2231.934117] RBP: ffff88011a34fbe8 R08: 0000000000000000 R09: 
0000000000000000
[ 2231.934117] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff8801184ca038
[ 2231.934117] R13: ffff8801184ca000 R14: ffff8801184ca000 R15: 
ffff880119db0800
[ 2231.934117] FS:  00007f1b79fc2700(0000) GS:ffff88011fc00000(0000) 
knlGS:0000000000000000
[ 2231.934117] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2231.934117] CR2: 0000000000000028 CR3: 000000011445f000 CR4: 
00000000000006f0
[ 2231.934117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 2231.934117] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 2231.934117] Process modprobe (pid: 20150, threadinfo 
ffff88011a34e000, task ffff88011a9660b0)
[ 2231.934117] Stack:
[ 2231.934117]  0000000000000000 0000000000000000 ffff8801184ca948 
0000000000000000
[ 2231.934117]  ffff88011a34fd58 ffffffffa0df1f69 0000000f00000000 
ffff88011a34fc17
[ 2231.934117]  ffffffffa0dfe8b0 00205d3800000001 ffff8801184ca030 
ffff880119e2c430
[ 2231.934117] Call Trace:
[ 2231.934117]  [<ffffffffa0df1f69>] em28xx_usb_probe+0x619/0xb80 [em28xx]
[ 2231.934117]  [<ffffffff81495ec3>] usb_probe_interface+0x113/0x220
[ 2231.934117]  [<ffffffff813e6616>] driver_probe_device+0x96/0x1c0
[ 2231.934117]  [<ffffffff813e67db>] __driver_attach+0x9b/0xa0
[ 2231.934117]  [<ffffffff813e6740>] ? driver_probe_device+0x1c0/0x1c0
[ 2231.934117]  [<ffffffff813e565e>] bus_for_each_dev+0x5e/0x90
[ 2231.934117]  [<ffffffff813e62a9>] driver_attach+0x19/0x20
[ 2231.934117]  [<ffffffff813e5e40>] bus_add_driver+0xc0/0x280
[ 2231.934117]  [<ffffffff813e6d7f>] driver_register+0x6f/0x130
[ 2231.934117]  [<ffffffff814954d8>] usb_register_driver+0xb8/0x170
[ 2231.934117]  [<ffffffffa00cd000>] ? 0xffffffffa00ccfff
[ 2231.934117]  [<ffffffffa00cd023>] em28xx_module_init+0x23/0x4e [em28xx]
[ 2231.934117]  [<ffffffff810002bf>] do_one_initcall+0x3f/0x170
[ 2231.934117]  [<ffffffff81087a32>] sys_init_module+0x92/0x1e0
[ 2231.934117]  [<ffffffff8170627b>] system_call_fastpath+0x16/0x1b
[ 2231.934117] Code: 00 00 00 55 48 89 e5 41 55 49 89 fd 41 54 4c 8d 67 
38 53 48 83 ec 08 48 8b 5f 38 4c 39 e3 0f 84 ac 00 00 00 0f 1f 80 00 00 
00 00
[ 2231.934117]  8b 43 28 48 8b 00 48 85 c0 74 10 48 8b 40 28 48 85 c0 74 07
[ 2231.934117] RIP  [<ffffffffa0df4538>] em28xx_wake_i2c+0x28/0xe0 [em28xx]
[ 2231.934117]  RSP <ffff88011a34fbc8>
[ 2231.934117] CR2: 0000000000000028
[ 2231.939276] ---[ end trace f190e9cb70245d0a ]---
lin-tv media_build #


