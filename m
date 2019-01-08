Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE02C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39A02087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546958745;
	bh=abRc5PDoOc5cpAjma1vvI1TuMf7mCqzkMJ/nuIXPWrk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=HWrV+8nJjbNoYINXjWRZ6K8azWhWI96KUOM0LVVa2gzcUWH8Aa6KOMnSYuJ5ieySs
	 EWYSqC2RaPfy3gHrldOM8IMPxmfyJ6cNzJKpX8tumXqeyhUp5gcemoHAIHCwLW48Vn
	 YpiSo7T1g2NqhnZ4NWjAOOd9MPRB4+JfUZYG6slg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfAHOpo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:45:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:59040 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfAHOpo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4ax+mVrGAvF5BL1mhuS8hIFpOloAOxx1Jow/gmEh1aA=; b=Kuvd83rUEmbP6M3xEOZ+nilBCI
        JygRLLUX+gAwW7OXUu987DqbmDrcs2Ws9YJO2CCM1QxolFFBWhlN5/YxGt2T+kj3u6er09oKn7yfW
        +fC85fPaRAenTISM+rXAc51iDuTedTO3aNJ1UqafpTg5oz4vWvTp9ZPqVJLNF1pJKYjXlmYEJnZF9
        n8rJ0BjQvtw8rXXlTOqE2fWDIeeKZy/fYwittYEc//Mv1Q6iD6uLAjRMQ4lJsddejM9MX0+zmJuSH
        iCHI9j4n9Ymz+fFSlJrBSqMDdhxdUb/uoFhkxv2aVm/QSGNrqpqesBR4jBaoFeW7XtM5p2arJSwYk
        1IhkEqvg==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggsdR-00085J-Mo; Tue, 08 Jan 2019 14:45:42 +0000
Date:   Tue, 8 Jan 2019 12:45:37 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc:     linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I
 start capture video
Message-ID: <20190108124532.5159b90a@coco.lan>
In-Reply-To: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mike,

Em Sun, 6 Jan 2019 01:05:16 +0500
Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> escreveu:

> Hi folks!
> Every time when I start capture video from external capture card
> Avermedia Live Gamer ULTRA GC553
> (https://www.avermedia.com/gaming/product/game_capture/live_gamer_ultra_g=
c553)

What's the driver used by this device?

A quick browsing at the Avermedia page you pointed, it indicates that this
should be using the UVC driver:

	"The LGU takes full advantage of UVC technology, which=20
	 basically standardizes video drivers across Windows and Mac.=20
	 In other words, all you need to do is plug your LGU to=20
	 your PC or Mac and it=E2=80=99s ready to record and stream."

So, I *suspect* that it uses the uvcvideo driver, but better to
double check.

> I got kernel error "Unknown pixelformat 0x00000000".
> It look like false positive because I am able record video with OBS in
> 4K resolution from another Linux machine or PS 4 Pro  if I select
> video format "Planar YVU 4:2:0" or "YU12 (Emulated)"
> But very unpleasant to see this error in kernel log.
>=20
> $ uname -r
> 4.20.0-1.fc30.x86_64
>=20
> $ lsusb
> Bus 004 Device 007: ID 07ca:0553 AVerMedia Technologies, Inc.
>=20
>=20
> [   75.985776] ------------[ cut here ]------------
> [   75.985780] Unknown pixelformat 0x00000000
> [   75.985813] WARNING: CPU: 12 PID: 3175 at
> drivers/media/v4l2-core/v4l2-ioctl.c:1342 v4l_enum_fmt+0xfc0/0x1380
> [videodev]
> [   75.985814] Modules linked in: nls_utf8 isofs fuse rfcomm
> xt_CHECKSUM ipt_MASQUERADE tun bridge stp llc devlink
> nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
> ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ip6table_nat
> nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat
> nf_nat_ipv4 nf_nat iptable_mangle iptable_raw iptable_security
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink
> ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep sunrpc
> xfs vfat fat libcrc32c edac_mce_amd arc4 kvm_amd kvm r8822be(C)
> snd_hda_codec_realtek snd_hda_codec_generic irqbypass
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec mac80211 snd_usb_audio
> crct10dif_pclmul snd_hda_core snd_usbmidi_lib crc32_pclmul snd_hwdep
> snd_rawmidi snd_seq snd_seq_device uvcvideo snd_pcm
> ghash_clmulni_intel btusb videobuf2_vmalloc videobuf2_memops btrtl
> videobuf2_v4l2 btbcm eeepc_wmi videobuf2_common btintel asus_wmi
> sparse_keymap bluetooth video videodev wmi_bmof joydev
> [   75.985838]  snd_timer cfg80211 media k10temp snd sp5100_tco
> i2c_piix4 soundcore ecdh_generic ccp rfkill pcc_cpufreq gpio_amdpt
> gpio_generic acpi_cpufreq binfmt_misc uas usb_storage hid_sony
> ff_memless amdgpu hid_logitech_hidpp chash amd_iommu_v2 gpu_sched
> drm_kms_helper ttm drm igb crc32c_intel hid_logitech_dj dca nvme
> i2c_algo_bit nvme_core wmi pinctrl_amd
> [   75.985854] CPU: 12 PID: 3175 Comm: obs Tainted: G         C
> 4.20.0-1.fc30.x86_64 #1
> [   75.985856] Hardware name: System manufacturer System Product
> Name/ROG STRIX X470-I GAMING, BIOS 1103 11/16/2018
> [   75.985862] RIP: 0010:v4l_enum_fmt+0xfc0/0x1380 [videodev]
> [   75.985863] Code: c6 4b 79 b5 c0 e9 55 f1 ff ff 48 c7 c6 09 7c b5
> c0 3d 56 50 38 30 0f 84 43 f1 ff ff 89 c6 48 c7 c7 1c 7d b5 c0 e8 3a
> 3b 57 f9 <0f> 0b 41 80 7c 24 0c 00 0f 85 45 f1 ff ff 41 8b 44 24 2c 49
> 8d 7c
> [   75.985865] RSP: 0018:ffffa52889277cb8 EFLAGS: 00010286
> [   75.985867] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000000=
0000006
> [   75.985868] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffff964cb=
eb168c0
> [   75.985869] RBP: 0000000000000000 R08: 0000000000000005 R09: 000000000=
0000007
> [   75.985870] R10: 0000000000000000 R11: ffffffffbb99e22d R12: ffffa5288=
9277dc0
> [   75.985872] R13: ffffffffc05079e0 R14: ffff964c8a790600 R15: fffffffff=
fffffed
> [   75.985873] FS:  00007f0c1eab1f00(0000) GS:ffff964cbeb00000(0000)
> knlGS:0000000000000000
> [   75.985875] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   75.985876] CR2: 00007f0c08197294 CR3: 000000078795e000 CR4: 000000000=
03406e0
> [   75.985877] Call Trace:
> [   75.985885]  __video_do_ioctl+0x174/0x3b0 [videodev]
> [   75.985889]  ? page_add_file_rmap+0xa0/0x2d0
> [   75.985892]  ? alloc_set_pte+0x293/0x660
> [   75.985897]  video_usercopy+0x253/0x5a0 [videodev]
> [   75.985903]  ? copy_overflow+0x20/0x20 [videodev]
> [   75.985906]  ? selinux_file_ioctl+0x161/0x200
> [   75.985911]  v4l2_ioctl+0x45/0x50 [videodev]
> [   75.985914]  do_vfs_ioctl+0xa4/0x630
> [   75.985916]  ksys_ioctl+0x60/0x90
> [   75.985918]  __x64_sys_ioctl+0x16/0x20
> [   75.985921]  do_syscall_64+0x5b/0x160
> [   75.985924]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   75.985926] RIP: 0033:0x7f0c2454014d
> [   75.985928] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e
> fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0b 5d 0c 00 f7 d8 64 89
> 01 48
> [   75.985929] RSP: 002b:00007ffe01cdc5f8 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [   75.985931] RAX: ffffffffffffffda RBX: 00007f0c08197280 RCX: 00007f0c2=
454014d
> [   75.985932] RDX: 00007ffe01cdc660 RSI: 00000000c0405602 RDI: 000000000=
0000027
> [   75.985933] RBP: 0000000000000004 R08: 0000000000000000 R09: 000000000=
0000000
> [   75.985934] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000=
0000007
> [   75.985935] R13: 0000000000000001 R14: 00007ffe01cdc630 R15: 000055a98=
2fdf6e0
> [   75.985937] ---[ end trace 26d01f03c564a254 ]---
>=20
>=20
> Is it possible to fix this error?

I suspect that the UVC descriptors are pointing to another format that
the driver currently doesn't recognize, but I would be expecting to see
some message with:

	Unknown video format xxxxxxx

printed as well, if this is, indeed, using the uvcdriver.

Regards,
Mauro


Thanks,
Mauro
