Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34212 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbbJBPOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 11:14:53 -0400
Message-ID: <1443798890.3445.122.camel@pengutronix.de>
Subject: Re: Coda encoder stop
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Zahari Doychev <zahari.doychev@linux.com>
Date: Fri, 02 Oct 2015 17:14:50 +0200
In-Reply-To: <CAH-u=819gNJw+bP72cNqDSbntm=kVPcwGTjyOOhei-uAQWo67w@mail.gmail.com>
References: <CAH-u=82892OHC6BzkB0z+Rc=ig7FiAZfOz6Y7WboNWq2+nxuZw@mail.gmail.com>
	 <CAH-u=819gNJw+bP72cNqDSbntm=kVPcwGTjyOOhei-uAQWo67w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 02.10.2015, 16:59 +0200 schrieb Jean-Michel Hautbois:
[...]
> Oups, forgot to paste the kernel output :
> 
> [  324.390498] ------------[ cut here ]------------
> [  324.395163] WARNING: CPU: 1 PID: 1434 at
> /run/media/jm/SSD_JM/Projets/git_mirrors/linux-2.6-imx/kernel/locking/lockdep.c:3382
> lock_release+0x2b0/0x6d4()
> [  324.408821] DEBUG_LOCKS_WARN_ON(depth <= 0)
> [  324.412840] Modules linked in:
> [  324.415917]  ath9k_htc ath9k_common ath9k_hw ath snd_soc_adv76xx
> snd_soc_vbx3_fpga vbx3_fpga_vswitch smsc95xx usbnet mx6_camera(C)
> imx_ipu_scaler imx_ipu vbx3_fpga adv7604 snd_soc_sgtl5000 lmh0395
> snd_soc_vbx3sdi vbx3_sdi fbcon bitblit softcursor font
> [  324.437279] CPU: 1 PID: 1434 Comm: video-h264:src Tainted: G
>  C      4.2.0 #106
> [  324.445204] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  324.451741] Backtrace:
> [  324.454226] [<8001524c>] (dump_backtrace) from [<80015494>]
> (show_stack+0x20/0x24)
> [  324.461804]  r6:80fb1a60 r5:00000000 r4:00000000 r3:00000000
> [  324.467562] [<80015474>] (show_stack) from [<808fdd6c>]
> (dump_stack+0x98/0xc8)
> [  324.474803] [<808fdcd4>] (dump_stack) from [<800304f0>]
> (warn_slowpath_common+0x8c/0xc8)
> [  324.482902]  r6:8007ffbc r5:00000009 r4:a4eafab8 r3:00000001
> [  324.488652] [<80030464>] (warn_slowpath_common) from [<8003056c>]
> (warn_slowpath_fmt+0x40/0x48)
> [  324.497359]  r8:80fb1b60 r7:80904b3c r6:a636c9c0 r5:a6c9f368 r4:80c1e150
> [  324.504168] [<80030530>] (warn_slowpath_fmt) from [<8007ffbc>]
> (lock_release+0x2b0/0x6d4)
> [  324.512353]  r3:80c246fc r2:80c1e150
> [  324.515971]  r4:a6c9f32c
> [  324.518541] [<8007fd0c>] (lock_release) from [<80904a34>]
> (__mutex_unlock_slowpath+0xc4/0x1b4)
> [  324.527160]  r10:00000000 r9:a4531281 r8:00000000 r7:8185231c
> r6:80904b3c r5:600f0013
> [  324.535091]  r4:a6c9f32c
> [  324.537657] [<80904970>] (__mutex_unlock_slowpath) from
> [<80904b3c>] (mutex_unlock+0x18/0x1c)
> [  324.546189]  r7:00000000 r6:a4eafcd4 r5:00000041 r4:a5e1b000
> [  324.551945] [<80904b24>] (mutex_unlock) from [<80602fe8>]
> (v4l2_m2m_fop_poll+0x5c/0x64)
> [  324.559970] [<80602f8c>] (v4l2_m2m_fop_poll) from [<805ec694>]
> (v4l2_poll+0x6c/0xa0)
> [  324.567722]  r6:a4eafbec r5:00000000 r4:a6c9e090 r3:80602f8c
> [  324.573481] [<805ec628>] (v4l2_poll) from [<80174d04>]
> (do_sys_poll+0x230/0x4d0)
> [  324.580886]  r5:00000000 r4:a4eafbe4
> [  324.584515] [<80174ad4>] (do_sys_poll) from [<801752e0>]
> (SyS_ppoll+0x1d4/0x1fc)
> [  324.591917]  r10:00000000 r9:a4eae000 r8:00000000 r7:00000000
> r6:74a14790 r5:00000002
> [  324.599846]  r4:00000000
> [  324.602419] [<8017510c>] (SyS_ppoll) from [<80010b00>]
> (ret_fast_syscall+0x0/0x54)
> [  324.609996]  r8:80010ce4 r7:00000150 r6:74a14790 r5:00000002 r4:00000008
> [  324.616798] ---[ end trace 0012dc3dcc1c27d5 ]---

Hm, that looks very similar to the issue Zahari's "[media] m2m: fix bad
unlock balance" is supposed to fix:
https://patchwork.linuxtv.org/patch/30906/

regards
Philipp

