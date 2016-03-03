Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:32859 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbcCCUjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 15:39:43 -0500
Received: by mail-qg0-f65.google.com with SMTP id y89so2162406qge.0
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 12:39:42 -0800 (PST)
Received: from mail-qk0-f174.google.com (mail-qk0-f174.google.com. [209.85.220.174])
        by smtp.gmail.com with ESMTPSA id f5sm100463qkb.30.2016.03.03.12.39.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Mar 2016 12:39:41 -0800 (PST)
Received: by mail-qk0-f174.google.com with SMTP id s5so13347573qkd.0
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 12:39:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d9c55486ee5daff0caf19c1eab8ca8856d79ff5d.1455233154.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
	<d9c55486ee5daff0caf19c1eab8ca8856d79ff5d.1455233154.git.shuahkh@osg.samsung.com>
Date: Thu, 3 Mar 2016 22:39:40 +0200
Message-ID: <CAAZRmGziEGkywO5fU8aQqk6gFC8EWrY0VJA84PMCDj5crtiO3w@mail.gmail.com>
Subject: Re: [PATCH v3 13/22] media: Change v4l-core to check if source is free
From: Olli Salonen <olli.salonen@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

This patch seems to cause issues with my setup. Basically, when I try
to tune to a channel, I get an oops. I'm using TechnoTrend CT2-4650
PCIe DVB-T tuner (cx23885).

Here's the oops:

[  548.443272] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[  548.452036] IP: [<ffffffffc020ffc9>]
v4l_vb2q_enable_media_source+0x9/0x50 [videodev]
[  548.460792] PGD b820e067 PUD bb3df067 PMD 0
[  548.465582] Oops: 0000 [#1] SMP
[  548.469199] Modules linked in: sp2(OE) si2157(OE) si2168(OE)
cx25840(OE) cx23885(OE) altera_ci(OE) tda18271(OE) altera_stapl(OE)
videobuf2_dvb(OE) m88ds3103(OE) tveeprom(OE) cx2341x(OE) dvb_core(OE)
rc_core(OE) videobuf2_dma_sg(OE) videobuf2_memops(OE)
frame_vector(POE) v4l2_common(OE) videobuf2_v4l2(OE)
videobuf2_core(OE) videodev(OE) media(OE) i2c_mux snd_pcm snd_timer
snd soundcore des_generic md4 nls_utf8 cifs fscache ipmi_ssif
intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel gpio_ich aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd serio_raw i7core_edac ipmi_si edac_core
shpchp ipmi_msghandler tpm_infineon lpc_ich lp 8250_fintek mac_hid
parport igb i2c_algo_bit dca ahci ptp libahci pps_core [last unloaded:
tveeprom]
[  548.546864] CPU: 12 PID: 18651 Comm: dvbv5-scan Tainted: P
IOE   4.1.7-040107-generic #201509131330
[  548.557833] Hardware name: HP ProLiant DL160 G6  , BIOS O33 07/01/2013
[  548.565117] task: ffff880239c9b250 ti: ffff88013a738000 task.ti:
ffff88013a738000
[  548.573466] RIP: 0010:[<ffffffffc020ffc9>]  [<ffffffffc020ffc9>]
v4l_vb2q_enable_media_source+0x9/0x50 [videodev]
[  548.584936] RSP: 0018:ffff88013a73bba0  EFLAGS: 00010287
[  548.590862] RAX: 0000000000000000 RBX: ffff88023a55e828 RCX: ffff88023a55e9b0
[  548.598824] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff88023a55e828
[  548.606788] RBP: ffff88013a73bbc8 R08: 00000000000002f0 R09: 0000000000000000
[  548.614751] R10: ffffffff81ab5eb7 R11: ffffea0000dad080 R12: ffff88013a7c7000
[  548.622712] R13: 0000000000000000 R14: ffff88023a55e9a8 R15: 0000000000000020
[  548.630675] FS:  00007fe55f94d740(0000) GS:ffff88013bb80000(0000)
knlGS:0000000000000000
[  548.639704] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  548.646114] CR2: 0000000000000010 CR3: 00000000baa41000 CR4: 00000000000006e0
[  548.654076] Stack:
[  548.656318]  ffffffffc01caf15 ffff88013a7c7000 0000000000000000
ffff88023a55e9a8
[  548.664610]  ffff88023a55e828 ffff88013a73bc18 ffffffffc01cce13
ffffffffc01cd689
[  548.672902]  0000002000000001 8000000000000163 ffff88023a55e828
ffffffffc01f2220
[  548.681194] Call Trace:
[  548.683926]  [<ffffffffc01caf15>] ? vb2_core_streamon+0x125/0x170
[videobuf2_core]
[  548.692376]  [<ffffffffc01cce13>] __vb2_init_fileio+0x273/0x2f0
[videobuf2_core]
[  548.700631]  [<ffffffffc01cd689>] ? vb2_thread_start+0x69/0x9e0
[videobuf2_core]
[  548.708886]  [<ffffffffc01f2220>] ? vb2_dvb_start_feed+0xc0/0xc0
[videobuf2_dvb]
[  548.717141]  [<ffffffffc01cd6b6>] vb2_thread_start+0x96/0x9e0
[videobuf2_core]
[  548.725204]  [<ffffffff811bea35>] ? map_vm_area+0x35/0x40
[  548.731228]  [<ffffffffc01f21e8>] vb2_dvb_start_feed+0x88/0xc0
[videobuf2_dvb]
[  548.739290]  [<ffffffffc03548c1>]
dmx_section_feed_start_filtering+0xe1/0x1b0 [dvb_core]
[  548.748322]  [<ffffffffc03532fe>]
dvb_dmxdev_filter_start+0x20e/0x470 [dvb_core]
[  548.756578]  [<ffffffffc0353803>] dvb_demux_do_ioctl+0x2a3/0x700 [dvb_core]
[  548.764349]  [<ffffffffc0351625>] dvb_usercopy+0x115/0x190 [dvb_core]
[  548.771539]  [<ffffffff810b11e4>] ? update_curr+0xe4/0x180
[  548.777663]  [<ffffffffc0353560>] ?
dvb_dmxdev_filter_start+0x470/0x470 [dvb_core]
[  548.786112]  [<ffffffff810af509>] ? pick_next_entity+0xa9/0x190
[  548.792716]  [<ffffffff810b6c1b>] ? pick_next_task_fair+0x65b/0x910
[  548.799710]  [<ffffffffc0351975>] dvb_demux_ioctl+0x15/0x20 [dvb_core]
[  548.806994]  [<ffffffff8120ce68>] do_vfs_ioctl+0x2f8/0x510
[  548.813117]  [<ffffffff817d44e6>] ? __schedule+0x386/0x9a0
[  548.819237]  [<ffffffff8120d101>] SyS_ioctl+0x81/0xa0
[  548.824872]  [<ffffffff817d4b37>] ? schedule+0x37/0x90
[  548.830608]  [<ffffffff810159bb>] ? math_state_restore+0xdb/0x1d0
[  548.837401]  [<ffffffff817d8ab2>] system_call_fastpath+0x16/0x75
[  548.844103] Code: 8b 80 c8 05 00 00 48 85 c0 74 07 55 48 89 e5 ff
d0 5d f3 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
48 8b 47 18 <48> 8b 78 10 48 8b 07 48 85 c0 74 2b 48 8b 90 c0 05 00 00
31 c0
[  548.865851] RIP  [<ffffffffc020ffc9>]
v4l_vb2q_enable_media_source+0x9/0x50 [videodev]
[  548.874704]  RSP <ffff88013a73bba0>
[  548.878593] CR2: 0000000000000010
[  548.882304] ---[ end trace 38ce56384a5e39e2 ]---

Here's the git bisect result:

77fa4e072998705883c4dc672963b4bf7483cea9 is the first bad commit
commit 77fa4e072998705883c4dc672963b4bf7483cea9
Author: Shuah Khan <shuahkh@osg.samsung.com>
Date:   Thu Feb 11 21:41:29 2016 -0200

    [media] media: Change v4l-core to check if source is free

    Change s_input, s_fmt, s_tuner, s_frequency, querystd, s_hw_freq_seek,
    and vb2_core_streamon interfaces that alter the tuner configuration to
    check if it is free, by calling v4l_enable_media_source().

    If source isn't free, return -EBUSY.

    v4l_disable_media_source() is called from v4l2_fh_exit() to release
    tuner (source).

    vb2_core_streamon() uses v4l_vb2q_enable_media_source().

    Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

:040000 040000 853ab8842fcbd6c3add680cedff54b1c352d4768
990ddc77b888d935d969859c087e581307365ed8 M      drivers

After reverting this single patch, the tuner worked normally again.

Cheers,
-olli

On 12 February 2016 at 01:41, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Change s_input, s_fmt, s_tuner, s_frequency, querystd,
> s_hw_freq_seek, and vb2_core_streamon interfaces that
> alter the tuner configuration to check if it is free,
> by calling v4l_enable_media_source(). If source isn't
> free, return -EBUSY. v4l_disable_media_source() is
> called from v4l2_fh_exit() to release tuner (source).
> vb2_core_streamon() uses v4l_vb2q_enable_media_source().
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-fh.c        |  2 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c     | 30 ++++++++++++++++++++++++++++++
>  drivers/media/v4l2-core/videobuf2-core.c |  4 ++++
>  3 files changed, 36 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
> index c97067a..c183f09 100644
> --- a/drivers/media/v4l2-core/v4l2-fh.c
> +++ b/drivers/media/v4l2-core/v4l2-fh.c
> @@ -29,6 +29,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mc.h>
>
>  void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
>  {
> @@ -92,6 +93,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
>  {
>         if (fh->vdev == NULL)
>                 return;
> +       v4l_disable_media_source(fh->vdev);
>         v4l2_event_unsubscribe_all(fh);
>         fh->vdev = NULL;
>  }
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 8a018c6..ceaa44a 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -27,6 +27,7 @@
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-device.h>
>  #include <media/videobuf2-v4l2.h>
> +#include <media/v4l2-mc.h>
>
>  #include <trace/events/v4l2.h>
>
> @@ -1041,6 +1042,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
>  static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
>                                 struct file *file, void *fh, void *arg)
>  {
> +       struct video_device *vfd = video_devdata(file);
> +       int ret;
> +
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
>  }
>
> @@ -1448,6 +1455,9 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>         bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>         int ret;
>
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         v4l_sanitize_format(p);
>
>         switch (p->type) {
> @@ -1637,7 +1647,11 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
>  {
>         struct video_device *vfd = video_devdata(file);
>         struct v4l2_tuner *p = arg;
> +       int ret;
>
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>                         V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>         return ops->vidioc_s_tuner(file, fh, p);
> @@ -1691,7 +1705,11 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
>         struct video_device *vfd = video_devdata(file);
>         const struct v4l2_frequency *p = arg;
>         enum v4l2_tuner_type type;
> +       int ret;
>
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         if (vfd->vfl_type == VFL_TYPE_SDR) {
>                 if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
>                         return -EINVAL;
> @@ -1746,7 +1764,11 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
>  {
>         struct video_device *vfd = video_devdata(file);
>         v4l2_std_id id = *(v4l2_std_id *)arg, norm;
> +       int ret;
>
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         norm = id & vfd->tvnorms;
>         if (vfd->tvnorms && !norm)      /* Check if std is supported */
>                 return -EINVAL;
> @@ -1760,7 +1782,11 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
>  {
>         struct video_device *vfd = video_devdata(file);
>         v4l2_std_id *p = arg;
> +       int ret;
>
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         /*
>          * If no signal is detected, then the driver should return
>          * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
> @@ -1779,7 +1805,11 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
>         struct video_device *vfd = video_devdata(file);
>         struct v4l2_hw_freq_seek *p = arg;
>         enum v4l2_tuner_type type;
> +       int ret;
>
> +       ret = v4l_enable_media_source(vfd);
> +       if (ret)
> +               return ret;
>         /* s_hw_freq_seek is not supported for SDR for now */
>         if (vfd->vfl_type == VFL_TYPE_SDR)
>                 return -EINVAL;
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index ec5b78e..d381478 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -25,6 +25,7 @@
>  #include <linux/kthread.h>
>
>  #include <media/videobuf2-core.h>
> +#include <media/v4l2-mc.h>
>
>  #include <trace/events/vb2.h>
>
> @@ -1873,6 +1874,9 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
>          * are available.
>          */
>         if (q->queued_count >= q->min_buffers_needed) {
> +               ret = v4l_vb2q_enable_media_source(q);
> +               if (ret)
> +                       return ret;
>                 ret = vb2_start_streaming(q);
>                 if (ret) {
>                         __vb2_queue_cancel(q);
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
