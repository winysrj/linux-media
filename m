Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:38922 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaLVK6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 05:58:51 -0500
MIME-Version: 1.0
Date: Mon, 22 Dec 2014 11:58:49 +0100
Message-ID: <CAMuHMdV6XPseBk6pCoWogiU6AuSt1P_DVib-HdydnyCF0kKMSQ@mail.gmail.com>
Subject: SuperH Mobile CEU driver warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 454a4e728dd56c8515b80381c14168099279e7fc
("[media] v4l2-ioctl: WARN_ON if querycap didn't fill device_caps")
causes on r8a7740/armadillo-legacy:

sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
sh_mobile_ceu sh_mobile_ceu.0: pm_clk_resume()
------------[ cut here ]------------
WARNING: CPU: 0 PID: 199 at drivers/media/v4l2-core/v4l2-ioctl.c:1025
v4l_querycap+0x5c/0x78()
Modules linked in:
CPU: 0 PID: 199 Comm: v4l_id Not tainted
3.19.0-rc1-armadillo-legacy-00258-g85f5ee22d89dad78 #425
Hardware name: armadillo800eva
Backtrace:
[<c001130c>] (dump_backtrace) from [<c001152c>] (show_stack+0x18/0x1c)
 r6:c04a30cb r5:00000009 r4:00000000 r3:00400000
[<c0011514>] (show_stack) from [<c03a57bc>] (dump_stack+0x20/0x28)
[<c03a579c>] (dump_stack) from [<c0020374>] (warn_slowpath_common+0x90/0xb8)
[<c00202e4>] (warn_slowpath_common) from [<c0020440>]
(warn_slowpath_null+0x24/0x2c)
 r8:de323e30 r7:80685600 r6:c0553dc4 r5:00000000 r4:de323e30
[<c002041c>] (warn_slowpath_null) from [<c027209c>] (v4l_querycap+0x5c/0x78)
[<c0272040>] (v4l_querycap) from [<c0273c2c>] (__video_do_ioctl+0x1b0/0x290)
 r5:debc1000 r4:00000000
[<c0273a7c>] (__video_do_ioctl) from [<c0273848>] (video_usercopy+0x1d8/0x3f0)
 r10:00000000 r9:00000000 r8:00000000 r7:de323e30 r6:80685600 r5:00000000
 r4:00000000
[<c0273670>] (video_usercopy) from [<c0273a74>] (video_ioctl2+0x14/0x1c)
 r10:00000000 r9:de5a3840 r8:bef20c6c r7:00000003 r6:debc14d0 r5:80685600
 r4:debc1000
[<c0273a60>] (video_ioctl2) from [<c026e7ec>] (v4l2_ioctl+0x68/0x120)
[<c026e784>] (v4l2_ioctl) from [<c00c4f4c>] (do_vfs_ioctl+0x4a4/0x5ac)
 r9:de322000 r8:00000003 r7:00000003 r6:de5a3840 r5:de2530a0 r4:bef20c6c
[<c00c4aa8>] (do_vfs_ioctl) from [<c00c5090>] (SyS_ioctl+0x3c/0x64)
 r10:00000000 r9:de322000 r8:00000003 r7:80685600 r6:de5a3840 r5:de5a3840
 r4:bef20c6c
[<c00c5054>] (SyS_ioctl) from [<c000dea0>] (ret_fast_syscall+0x0/0x48)
 r8:c000e064 r7:00000036 r6:00020fbc r5:b6f20f10 r4:00000003 r3:00000000
---[ end trace ef1469dbfa7397f4 ]---
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
