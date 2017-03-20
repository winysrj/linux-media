Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39812
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753416AbdCTK6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:58:40 -0400
Date: Mon, 20 Mar 2017 07:58:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Michael Zoran <mzoran@crowfest.net>
Cc: Eric Anholt <eric@anholt.net>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
Message-ID: <20170320075831.65189ed7@vento.lan>
In-Reply-To: <20170319221107.05227532@vento.lan>
References: <20170127215503.13208-1-eric@anholt.net>
        <20170315110128.37e2bc5a@vento.lan>
        <87a88m19om.fsf@eliezer.anholt.net>
        <20170315220834.7019fd8b@vento.lan>
        <1489628784.8127.1.camel@crowfest.net>
        <20170316062900.0e835118@vento.lan>
        <87shmbv2w3.fsf@eliezer.anholt.net>
        <20170319135846.395feef8@vento.lan>
        <1489943068.13607.5.camel@crowfest.net>
        <20170319221107.05227532@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 19 Mar 2017 22:11:07 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Sun, 19 Mar 2017 10:04:28 -0700
> Michael Zoran <mzoran@crowfest.net> escreveu:
> 

> > A working DT that I tried this morning with the current firmware is
> > posted here:
> > http://lists.infradead.org/pipermail/linux-rpi-kernel/2017-March/005924
> > .html
> > 
> > It even works with minecraft_pi!  

With the new firmware, sometime after booting, I'm getting an oops, caused
by bcm2835_audio/vchiq:

[  298.788995] Unable to handle kernel NULL pointer dereference at virtual address 00000034
[  298.821458] pgd = ed004000
[  298.832294] [00000034] *pgd=2e5e9835, *pte=00000000, *ppte=00000000
[  298.857450] Internal error: Oops: 17 [#1] SMP ARM
[  298.876273] Modules linked in: cfg80211 hid_logitech_hidpp hid_logitech_dj snd_bcm2835(C) snd_pcm snd_timer snd soundcore vchiq(C) uio_pdrv_genirq uio fuse
[  298.932064] CPU: 3 PID: 847 Comm: pulseaudio Tainted: G         C      4.11.0-rc1+ #56
[  298.963774] Hardware name: Generic DT based system
[  298.982945] task: ef758580 task.stack: ee4c6000
[  299.001080] PC is at mutex_lock+0x14/0x3c
[  299.017148] LR is at vchiq_add_service_internal+0x138/0x3a0 [vchiq]
[  299.042246] pc : [<c0c849d4>]    lr : [<bf059654>]    psr: 40000013
sp : ee4c7ca8  ip : 00000000  fp : ef709800
[  299.088240] r10: 00000000  r9 : ee3bffc0  r8 : 00000034
[  299.109153] r7 : 00000003  r6 : 00000000  r5 : ee4c7d00  r4 : ee1d8c00
[  299.135291] r3 : ef758580  r2 : 00000000  r1 : ffffffc8  r0 : 00000034
[  299.161431] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  299.190008] Control: 10c5383d  Table: 2d00406a  DAC: 00000051
[  299.213011] Process pulseaudio (pid: 847, stack limit = 0xee4c6220)
[  299.238104] Stack: (0xee4c7ca8 to 0xee4c8000)
[  299.255539] 7ca0:                   c1403d54 80400040 ff7f0600 ff7f0660 bf06b578 ee3bffc0
[  299.288301] 7cc0: 00000000 ee3afd00 00000000 ee4c7d00 00000000 bf0640b4 00000000 bf066428
[  299.321064] 7ce0: ee3afd00 ee3afd00 ee4c7d34 ee3af444 ee3bffc0 ee3af444 ee3bffc0 bf0662ec
[  299.353826] 7d00: 41554453 bf065db0 ee3afd00 00010002 bf0d7408 ee3af440 00000000 bf0d7408
[  299.386587] 7d20: ee79bd80 bf0d5a04 00000000 ef709800 00000020 00000002 00000001 41554453
[  299.419349] 7d40: 00000000 00000000 00000000 bf0d559c ee3af440 00000001 00000001 00000000
[  299.452111] 7d60: ee24ac80 ee24ac80 ee1c4a00 00000000 ee79bd80 ee24ace8 00000001 bf0d4dfc
[  299.484872] 7d80: 0000000b ffffffff ee4b8c3c 00000000 ee4c7dc8 ee4b8800 ee4b8c28 ee4c6000
[  299.517635] 7da0: 00000000 ee4b8c3c ed029e40 bf0c0404 ee4b8800 ee1c4a00 ee4b8800 ed029e40
[  299.550398] 7dc0: 00000000 bf0c0560 ee072340 00000000 ef758580 c0367b7c ee4b8c40 ee4b8c40
[  299.583161] 7de0: 00000000 ee4b8800 ed029e40 ee318f80 ed029e40 00000006 ee318f80 bf0c0748
[  299.615924] 7e00: bf0a3430 ee4f6180 00000000 c0428fe0 ee318f80 000021b0 00000026 ed029e40
[  299.648697] 7e20: ee318f80 ed029e48 c0428f1c ee4c7e94 00000006 c0421cc0 ee4c7ed0 00000000
[  299.681464] 7e40: 00000802 00000000 ee4c7e94 00000006 ee318f80 c0432c8c ee4c7f40 c0433bc0
[  299.714225] 7e60: 00000000 ed029e40 00000000 00000041 00000000 ed004000 00000000 ee4c6000
[  299.746987] 7e80: eec69808 00000005 00000000 00000002 ee318f80 ef0d2910 ee924908 bf0ba284
[  299.779750] 7ea0: ee31bbc0 bebb53c4 ee4e1d00 00000011 ee4c7f74 00000001 fffff000 c0308b04
[  299.812512] 7ec0: ee4c6000 00000000 bebb5710 c0434578 ef0d2910 ee924908 73541c18 00000008
[  299.845274] 7ee0: ee4a7019 00000000 00000000 ee899bb0 ee318f80 00000101 00000002 00000084
[  299.878037] 7f00: 00000000 00000000 00000000 ee4c7f10 ee318df8 ed029840 40045532 bebb53c4
[  299.910799] 7f20: ee4c6000 ee4a7000 c1403ef8 bebb550c 00000011 ee5eca00 00000020 ee5eca18
[  299.943562] 7f40: ee4a7000 00000000 00080802 00000002 ffffff9c fffff000 00000011 ffffff9c
[  299.976324] 7f60: ee4a7000 c0422e70 00000002 c04359b0 ed029840 00000802 ed020000 00000006
[  300.009086] 7f80: 00000100 00000001 00000000 ffffffff 00000004 b189d000 00000005 c0308b04
[  300.041848] 7fa0: ee4c6000 c0308940 ffffffff 00000004 bebb550c 00080802 bebb53c4 00084b58
[  300.074611] 7fc0: ffffffff 00000004 b189d000 00000005 00000000 bebb550c 00099448 bebb5710
[  300.107373] 7fe0: 00000000 bebb53c8 b6c40da4 b6c24334 80000010 bebb550c 2fffd861 2fffdc61
[  300.140190] [<c0c849d4>] (mutex_lock) from [<bf059654>] (vchiq_add_service_internal+0x138/0x3a0 [vchiq])
[  300.178237] [<bf059654>] (vchiq_add_service_internal [vchiq]) from [<bf0640b4>] (vchiq_open_service+0x58/0xf0 [vchiq])
[  300.221152] [<bf0640b4>] (vchiq_open_service [vchiq]) from [<bf0662ec>] (vchi_service_open+0x74/0xa8 [vchiq])
[  300.260919] [<bf0662ec>] (vchi_service_open [vchiq]) from [<bf0d5a04>] (bcm2835_audio_open+0xe8/0x2d0 [snd_bcm2835])
[  300.303111] [<bf0d5a04>] (bcm2835_audio_open [snd_bcm2835]) from [<bf0d4dfc>] (snd_bcm2835_playback_open_generic+0xc0/0x1c4 [snd_bcm2835])
[  300.352975] [<bf0d4dfc>] (snd_bcm2835_playback_open_generic [snd_bcm2835]) from [<bf0c0404>] (snd_pcm_open_substream+0x60/0x110 [snd_pcm])
[  300.402848] [<bf0c0404>] (snd_pcm_open_substream [snd_pcm]) from [<bf0c0560>] (snd_pcm_open+0xac/0x1fc [snd_pcm])
[  300.444009] [<bf0c0560>] (snd_pcm_open [snd_pcm]) from [<bf0c0748>] (snd_pcm_playback_open+0x3c/0x5c [snd_pcm])
[  300.484459] [<bf0c0748>] (snd_pcm_playback_open [snd_pcm]) from [<c0428fe0>] (chrdev_open+0xc4/0x180)
[  300.521408] [<c0428fe0>] (chrdev_open) from [<c0421cc0>] (do_dentry_open.constprop.3+0x1fc/0x304)
[  300.556964] [<c0421cc0>] (do_dentry_open.constprop.3) from [<c0432c8c>] (path_openat+0x588/0x1078)
[  300.592866] [<c0432c8c>] (path_openat) from [<c0434578>] (do_filp_open+0x60/0xc4)
[  300.622846] [<c0434578>] (do_filp_open) from [<c0422e70>] (do_sys_open+0x110/0x1c0)
[  300.653524] [<c0422e70>] (do_sys_open) from [<c0308940>] (ret_fast_syscall+0x0/0x3c)


Thanks,
Mauro
