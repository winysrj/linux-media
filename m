Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:9478 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZGPN7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 09:59:07 -0400
Received: by an-out-0708.google.com with SMTP id d40so200571and.1
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 06:59:06 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Antoine Jacquet <royale@zerezo.com>
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
Date: Thu, 16 Jul 2009 10:58:55 -0300
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
References: <200907152054.56581.lamarque@gmail.com> <4A5F2445.4080105@zerezo.com>
In-Reply-To: <4A5F2445.4080105@zerezo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907161058.56575.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Quinta-feira 16 Julho 2009, Antoine Jacquet escreveu:
> Thanks,
>
> I successfully applied your patch and tested it with mplayer.
> However I have the following trace each time I capture a frame:

	No, I do not have this problem neither in 2.6.28 (vanilla), 2.6.29.3 (vanilla 
source and v4l-dvb) and 2.6.30.1 (vanilla and v4l-dvb). My notebook is single 
core, maybe this problem is related to SMP. I will try to test the patch on a 
dual core processor.

> [  523.477064] BUG: scheduling while atomic: swapper/0/0x10010000
> [  523.477390] Modules linked in: zr364xx videodev v4l1_compat
> v4l2_compat_ioctl32 videobuf_vmalloc videobuf_core binfmt_misc ipv6 fuse
> ntfs it87 hwmon_vid snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
> snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event
> snd_seq snd_timer snd_seq_device pcspkr snd snd_page_alloc
> [  523.477390] CPU 0:
> [  523.477390] Modules linked in: zr364xx videodev v4l1_compat
> v4l2_compat_ioctl32 videobuf_vmalloc videobuf_core binfmt_misc ipv6 fuse
> ntfs it87 hwmon_vid snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
> snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event
> snd_seq snd_timer snd_seq_device pcspkr snd snd_page_alloc
> [  523.477390] Pid: 0, comm: swapper Not tainted 2.6.30.1 #1 Aspire T160
> [  523.477390] RIP: 0010:[<ffffffff8020fbcf>]  [<ffffffff8020fbcf>]
> default_idle+0x54/0x90
> [  523.477390] RSP: 0018:ffffffff807e3f38  EFLAGS: 00000246
> [  523.477390] RAX: ffffffff807e3fd8 RBX: 0000000000000000 RCX:
> 0000000000000000
> [  523.477390] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
> ffffffff8078d010
> [  523.477390] RBP: ffffffff8020b60e R08: 0000000000000000 R09:
> 0000000000000000
> [  523.477390] R10: 00000000000f423d R11: 0000000000000000 R12:
> ffff88003f87d180
> [  523.477390] R13: 0000000000000000 R14: ffff88003e1e9940 R15:
> ffff88003f87d180
> [  523.477390] FS:  00007f40f871e730(0000) GS:ffffffff80789000(0000)
> knlGS:0000000000000000
> [  523.477390] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [  523.477390] CR2: 00007f099e8c2008 CR3: 000000003c16c000 CR4:
> 00000000000006e0
> [  523.477390] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  523.477390] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  523.477390] Call Trace:
> [  523.477390]  [<ffffffff805a1615>] ? notifier_call_chain+0x29/0x4c
> [  523.477390]  [<ffffffff8020a124>] ? cpu_idle+0x23/0x5b
> [  523.477390]  [<ffffffff807eba7c>] ? start_kernel+0x2e8/0x2f4
> [  523.477390]  [<ffffffff807eb37e>] ? x86_64_start_kernel+0xe5/0xeb
>
> I can trigger it each time I read a frame, for example using dd on
> /dev/video0.
> Did you have the same behavior?
>
> Regards,
>
> Antoine
>
> Lamarque Vieira Souza wrote:
> > This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
> > converting the driver to use videobuf. This version is synced with
> > v4l-dvb as of 15/Jul/2009.
> >
> > Tested with Creative PC-CAM 880.
> >
> > It basically:
> > . implements V4L2_CAP_STREAMING using videobuf;
> >
> > . re-implements V4L2_CAP_READWRITE using videobuf;
> >
> > . copies cam->udev->product to the card field of the v4l2_capability
> > struct. That gives more information to the users about the webcam;
> >
> > . moves the brightness setting code from before requesting a frame (in
> > read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
> > executed only when the application requests a change in brightness and
> > not before every frame read;
> >
> > . comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype +
> > libv4l do not work.
> >
> > This patch fixes zr364xx for applications such as mplayer,
> > Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
> > with zr364xx chip.
> >
> > Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
> > ---


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/
