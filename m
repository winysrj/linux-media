Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:20427 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZBWBpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 20:45:10 -0500
Received: by an-out-0708.google.com with SMTP id c2so740377anc.1
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2009 17:45:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49A1B90B.8080502@rogers.com>
References: <1767e6740902181819i9982865u1dec75b5f337b8a4@mail.gmail.com>
	 <49A1B90B.8080502@rogers.com>
Date: Sun, 22 Feb 2009 19:45:06 -0600
Message-ID: <1767e6740902221745r48506a51ne1f080d8abe7a2f0@mail.gmail.com>
Subject: Re: Kworld atsc 110 nxt2004 init
From: Jonathan Isom <jeisom@gmail.com>
To: CityK <cityk@rogers.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 22, 2009 at 2:43 PM, CityK <cityk@rogers.com> wrote:
> Jonathan Isom wrote:
>> Hi
>> I was looking over my logs and I'm wondering is
>> "nxt200x: Timeout waiting for nxt2004 to init"
>> common
>
> No its not common
>
>> or is this womething I need to worry about.  I got one shortly before a
>> lockup(No backtrace).  Nothing was doing other than dvbstreamer sitting idle.
>> I'll provide further logs if it should be needed.  I would think that
>> It would need to
>> only be initialize at module load.  Am I wrong in this thinking?
>>
>> in kernel  drivers 2.6.28.4
Hi
Looking at the logs I found that there was a backtrace. However I believe it
is related to dvbstreamer and the kworld cards.  I cycle thru the channels to
download epg info.  The previous crash I forgot that I was running the script
to cycle them and export the xmltv data.


>From today's lockup.
----------------------------------------------------------------
Feb 22 09:58:05 ravage [53228.039032] BUG: unable to handle kernel
paging request at ffffe2865147d078
Feb 22 09:58:05 ravage [53228.039040] IP: [<ffffffff8108b3ae>]
unmap_vmas+0x4ae/0x8f0
Feb 22 09:58:05 ravage [53228.039047] PGD 0
Feb 22 09:58:05 ravage [53228.039049] Oops: 0000 [#1] SMP
Feb 22 09:58:05 ravage [53228.039050] last sysfs file:
/sys/devices/platform/it87.656/fan3_input
Feb 22 09:58:05 ravage [53228.039052] CPU 0
Feb 22 09:58:05 ravage [53228.039053] Modules linked in: vboxdrv nfsd
exportfs wlan_tkip bridge stp llc tun it87 hwmon_vid tuner_simple
tuner_types nxt200x saa7134_dvb videobuf_d
vb dvb_core tuner wlan_scan_sta ath_rate_sample saa7134 snd_hda_intel
ir_common compat_ioctl32 ath_pci nvidia(P) videodev snd_pcm wlan
v4l1_compat snd_timer v4l2_common ath_hal(P
) videobuf_dma_sg snd videobuf_core tveeprom soundcore snd_page_alloc
k8temp hwmon i2c_piix4 pl2303 usbserial lirc_mceusb2 lirc_dev r8169
mii i2c_core parport_pc parport
Feb 22 09:58:05 ravage [53228.039074] Pid: 30949, comm: cc1plus
Tainted: P           2.6.28.4 #1
Feb 22 09:58:05 ravage [53228.039075] RIP: 0010:[<ffffffff8108b3ae>]
[<ffffffff8108b3ae>] unmap_vmas+0x4ae/0x8f0
Feb 22 09:58:05 ravage [53228.039078] RSP: 0018:ffff88010edfdd48
EFLAGS: 00010246
Feb 22 09:58:05 ravage [53228.039079] RAX: ffff880028025280 RBX:
00002b5197a00000 RCX: 37a926605da94067
Feb 22 09:58:05 ravage [53228.039080] RDX: ffff880028025280 RSI:
00000000fffffff0 RDI: ffff880000015600
Feb 22 09:58:05 ravage [53228.039082] RBP: ffffe2865147d060 R08:
ffff88012fc01040 R09: 0000000000000001
Feb 22 09:58:05 ravage [53228.039083] R10: 0000000000000002 R11:
00000000000001ad R12: 00002b5197917000
Feb 22 09:58:05 ravage [53228.039084] R13: ffff8800706788b8 R14:
00000000000aa000 R15: 0000000000000020
Feb 22 09:58:05 ravage [53228.039086] FS:  00002b519703f0a0(0000)
GS:ffffffff816c8040(0000) knlGS:00000000f6484a10
Feb 22 09:58:05 ravage [53228.039087] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Feb 22 09:58:05 ravage [53228.039088] CR2: ffffe2865147d078 CR3:
0000000000201000 CR4: 00000000000006a0
Feb 22 09:58:05 ravage [53228.039089] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb 22 09:58:05 ravage [53228.039091] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb 22 09:58:05 ravage [53228.039092] Process cc1plus (pid: 30949,
threadinfo ffff88010edfc000, task ffff88011cbcd370)
Feb 22 09:58:05 ravage [53228.039093] Stack:
Feb 22 09:58:05 ravage [53228.039094]  ffff880119e3f460
00002b519b5fffff ffffe20001896a50 0000000000000000
Feb 22 09:58:05 ravage [53228.039096]  ffff88010edfde48
ffffffffffffffff 0000000000000000 ffff8800a9f82b00
Feb 22 09:58:05 ravage [53228.039098]  ffff88010edfde50
0000000196b85190 0000000000000000 00002b519b600000
Feb 22 09:58:05 ravage [53228.039101] Call Trace:
Feb 22 09:58:05 ravage [53228.039102]  [<ffffffff810902ef>] ?
exit_mmap+0x8f/0x150
Feb 22 09:58:05 ravage [53228.039105]  [<ffffffff8103ba55>] ? mmput+0x25/0xb0
Feb 22 09:58:05 ravage [53228.039108]  [<ffffffff8103f99c>] ? exit_mm+0xfc/0x130
Feb 22 09:58:05 ravage [53228.039110]  [<ffffffff81041bb0>] ?
do_exit+0x730/0x930
Feb 22 09:58:05 ravage [53228.039112]  [<ffffffff8109023b>] ?
remove_vma+0x5b/0x80
Feb 22 09:58:05 ravage [53228.039114]  [<ffffffff810915e0>] ?
do_munmap+0x340/0x380
Feb 22 09:58:05 ravage [53228.039116]  [<ffffffff81041de9>] ?
do_group_exit+0x39/0xa0
Feb 22 09:58:05 ravage [53228.039118]  [<ffffffff81041e62>] ?
sys_exit_group+0x12/0x20
Feb 22 09:58:05 ravage [53228.039120]  [<ffffffff8100c1db>] ?
system_call_fastpath+0x16/0x1b
Feb 22 09:58:05 ravage [53228.039122] Code: c7 45 00 00 00 00 00 48 8b
54 24 60 48 85 ed c7 42 0c 01 00 00 00 0f 84 03 ff ff ff 48 83 bc 24
b0 00 00 00 00 0f 85 b2 03 00 00 <f6>
45 18 01 0f 84 a0 01 00 00 ff 8c 24 88 00 00 00 48 8b 74 24
Feb 22 09:58:05 ravage [53228.039137] RIP  [<ffffffff8108b3ae>]
unmap_vmas+0x4ae/0x8f0
Feb 22 09:58:05 ravage [53228.039138]  RSP <ffff88010edfdd48>
Feb 22 09:58:05 ravage [53228.039139] CR2: ffffe2865147d078
Feb 22 09:58:05 ravage [53228.039141] ---[ end trace 8bae73de4732ea2f ]---
Feb 22 09:58:05 ravage [53228.039142] Fixing recursive fault but
reboot is needed!
