Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43109 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVJjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 05:39:14 -0400
Received: by mail-ob0-f180.google.com with SMTP id vb8so208866obc.11
        for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 02:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413970161.3107.2.camel@pengutronix.de>
References: <CAL8zT=j2STDuLHW3ONw1+cOfePZceBN7yTsV1WxDjFo0bZMBaA@mail.gmail.com>
 <54465F34.1000400@xs4all.nl> <CAL8zT=herYZ9d3TKrx_5Nre0_RRRXK3Az9-NvmqGE7_SkHLzHg@mail.gmail.com>
 <54466471.8050607@xs4all.nl> <CAL8zT=jykeu33QRvj9JxhuSxV2Cg8La2J8KxVJpu+GsaE9wZnA@mail.gmail.com>
 <1413908485.3081.4.camel@pengutronix.de> <CAL8zT=hDEth-xoEr=9phzdZ9dXJMBeP9rpiTLYHwoqgf7E4tjQ@mail.gmail.com>
 <CAL8zT=jQ-pg8x1rqX5SFvgbtKuTsaJXdSVuMU3ocJGRUBCo3Bg@mail.gmail.com> <1413970161.3107.2.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 22 Oct 2014 11:38:58 +0200
Message-ID: <CAL8zT=iGxfYx-E-fHj15os0vK3G5urXfFbO2CeCBc-x1H45RFg@mail.gmail.com>
Subject: Re: [media] CODA960: Fails to allocate memory
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-10-22 11:29 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Jean-Michel,
>
> Am Mittwoch, den 22.10.2014, 11:21 +0200 schrieb Jean-Michel Hautbois:
>> I may have misunderstand something...
>> I try to encode, and modified the CODA_MAX_FRAME_SIZE to 0x500000 just to see.
>>
>> And here is the trace-cmd :
>>
>> $> trace-cmd  record -e v4l2*  v4l2-ctl -d1  --stream-out-mmap
>> --stream-mmap --stream-to x.raw
>
> Are you sure /dev/video1 is the encoder device?
>
>   $ cat /sys/class/video4linux/video12/name
>   coda-encoder
>
>   $ cat /sys/class/video4linux/video13/name
>   coda-decoder

Ahem you are right... :/

So, here is the trace-cmd with device 0 which is the encoder... and
this is pretty bad :(

$> trace-cmd  record -e v4l2*  v4l2-ctl -d0  --stream-out-mmap
--stream-mmap --stream-to x.raw

[ 1429.222887] cma: cma_alloc(cma 814923f8, count 3, align 2)
[ 1429.223856] cma: cma_alloc(): returned b7eb8f80
[ 1429.224073] cma: cma_alloc(cma 814923f8, count 1280, align 8)
[ 1429.224579] cma: cma_alloc(): returned b7ebe000
[ 1429.256453] cma: cma_alloc(cma 814923f8, count 1280, align 8)
[ 1429.258174] cma: cma_alloc(): memory range at b7ec8000 is busy, retrying
[ 1429.259623] cma: cma_alloc(): memory range at b7eca000 is busy, retrying
[ 1429.261581] cma: cma_alloc(): returned b7ecc000
[ 1429.279247] cma: cma_alloc(cma 814923f8, count 1280, align 8)
[ 1429.279618] cma: cma_alloc(): returned b7ed6000
[ 1429.293288] cma: cma_alloc(cma 814923f8, count 1280, align 8)
[ 1429.295417] cma: cma_alloc(): returned b7ee0000
[ 1429.309931] cma: cma_alloc(cma 814923f8, count 1280, align 8)
[ 1429.312176] cma: cma_alloc(): returned b7eea000
[ 1429.326262] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1429.328392] cma: cma_alloc(): returned b7ef4000
[ 1429.339247] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1429.339453] cma: cma_alloc(): returned b7efa000
[ 1429.349290] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1429.350072] cma: cma_alloc(): returned b7f00000
[ 1429.359980] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1429.361497] cma: cma_alloc(): returned b7f06000
[ 1429.373118] coda 2040000.vpu: Not output type
[ 1429.377539] coda 2040000.vpu: streamon_out (N), streamon_cap (Y)
[ 1429.383950] coda 2040000.vpu: Not H264 pix fmt
[ 1429.388526] cma: cma_alloc(cma 814923f8, count 20, align 5)
[ 1429.390033] cma: cma_alloc(): returned b7ebd400

[ 1429.391953] ======================================================
[ 1429.398137] [ INFO: possible circular locking dependency detected ]
[ 1429.404410] 3.18.0-rc1+yocto+gc943ff8 #2 Not tainted
[ 1429.409378] -------------------------------------------------------
[ 1429.415648] v4l2-ctl/1179 is trying to acquire lock:
[ 1429.420617]  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<802d7d9c>]
__create_file+0x70/0x21c
[ 1429.429157]
but task is already holding lock:
[ 1429.434996]  (&dev->dev_mutex){+.+.+.}, at: [<8052be98>]
v4l2_ioctl+0x60/0x17c
[ 1429.442294]
which lock already depends on the new lock.

[ 1429.450477]
the existing dependency chain (in reverse order) is:
[ 1429.457964]
-> #2 (&dev->dev_mutex){+.+.+.}:
[ 1429.462473]        [<807879ec>] mutex_lock_interruptible_nested+0x6c/0x454
[ 1429.469379]        [<7f000e3c>] v4l2_m2m_fop_mmap+0x34/0x90 [v4l2_mem2mem]
[ 1429.476291]        [<8052b9a8>] v4l2_mmap+0x64/0x9c
[ 1429.481191]        [<80113de8>] mmap_region+0x380/0x6a0
[ 1429.486440]        [<80114428>] do_mmap_pgoff+0x320/0x3b8
[ 1429.491859]        [<800fe504>] vm_mmap_pgoff+0x74/0xa4
[ 1429.497115]        [<80112868>] SyS_mmap_pgoff+0xa4/0xcc
[ 1429.502449]        [<8000fa40>] ret_fast_syscall+0x0/0x48
[ 1429.507875]
-> #1 (&mm->mmap_sem){++++++}:
[ 1429.512208]        [<8010bb28>] might_fault+0x70/0x98
[ 1429.517290]        [<8013e6a0>] filldir64+0x7c/0x194
[ 1429.522279]        [<80153020>] dcache_readdir+0x1a4/0x25c
[ 1429.527787]        [<8013e41c>] iterate_dir+0x90/0x110
[ 1429.532946]        [<8013e934>] SyS_getdents64+0x84/0xf8
[ 1429.538278]        [<8000fa40>] ret_fast_syscall+0x0/0x48
[ 1429.543700]
-> #0 (&sb->s_type->i_mutex_key#3){+.+.+.}:
[ 1429.549180]        [<8006cc3c>] lock_acquire+0xb0/0x118
[ 1429.554427]        [<80786dd4>] mutex_lock_nested+0x60/0x3d4
[ 1429.560110]        [<802d7d9c>] __create_file+0x70/0x21c
[ 1429.565445]        [<802d7f7c>] debugfs_create_file+0x34/0x40
[ 1429.571212]        [<802d830c>] debugfs_create_blob+0x24/0x30
[ 1429.576981]        [<7f022ef4>] coda_alloc_aux_buf+0xa4/0x100 [coda]
[ 1429.583372]        [<7f025080>] coda_alloc_context_buffers+0xa4/0x20c [coda]
[ 1429.590451]        [<7f026068>] coda_start_encoding+0x2c/0x88c [coda]
[ 1429.596921]        [<7f021f44>] coda_start_streaming+0xb8/0x268 [coda]
[ 1429.603474]        [<80542d04>] vb2_start_streaming+0x6c/0x168
[ 1429.609337]        [<805451d8>] vb2_internal_streamon+0xfc/0x158
[ 1429.615367]        [<80545270>] vb2_streamon+0x3c/0x60
[ 1429.620527]        [<7f00086c>] v4l2_m2m_streamon+0x30/0x48 [v4l2_mem2mem]
[ 1429.627429]        [<7f0008a4>] v4l2_m2m_ioctl_streamon+0x20/0x24
[v4l2_mem2mem]
[ 1429.634851]        [<8052d684>] v4l_streamon+0x28/0x2c
[ 1429.640012]        [<80530bb8>] __video_do_ioctl+0x288/0x304
[ 1429.645695]        [<805304fc>] video_usercopy+0x174/0x584
[ 1429.651201]        [<80530928>] video_ioctl2+0x1c/0x24
[ 1429.656360]        [<8052bf8c>] v4l2_ioctl+0x154/0x17c
[ 1429.661519]        [<8013e0c4>] do_vfs_ioctl+0x410/0x66c
[ 1429.666851]        [<8013e364>] SyS_ioctl+0x44/0x6c
[ 1429.671749]        [<8000fa40>] ret_fast_syscall+0x0/0x48
[ 1429.677171]
other info that might help us debug this:

[ 1429.685181] Chain exists of:
  &sb->s_type->i_mutex_key#3 --> &mm->mmap_sem --> &dev->dev_mutex

[ 1429.694250]  Possible unsafe locking scenario:

[ 1429.700174]        CPU0                    CPU1
[ 1429.704706]        ----                    ----
[ 1429.709238]   lock(&dev->dev_mutex);
[ 1429.712848]                                lock(&mm->mmap_sem);
[ 1429.718799]                                lock(&dev->dev_mutex);
[ 1429.724924]   lock(&sb->s_type->i_mutex_key#3);
[ 1429.729502]
 *** DEADLOCK ***

[ 1429.735428] 1 lock held by v4l2-ctl/1179:
[ 1429.739440]  #0:  (&dev->dev_mutex){+.+.+.}, at: [<8052be98>]
v4l2_ioctl+0x60/0x17c
[ 1429.747180]
stack backtrace:
[ 1429.751548] CPU: 1 PID: 1179 Comm: v4l2-ctl Not tainted
3.18.0-rc1+yocto+gc943ff8 #2
[ 1429.759296] Backtrace:
[ 1429.761770] [<80013b90>] (dump_backtrace) from [<80013ed4>]
(show_stack+0x20/0x24)
[ 1429.769344]  r6:80c3e1f4 r5:00000000 r4:00000000 r3:00000000
[ 1429.775078] [<80013eb4>] (show_stack) from [<80782b28>]
(dump_stack+0x8c/0xa4)
[ 1429.782311] [<80782a9c>] (dump_stack) from [<80068738>]
(print_circular_bug+0x1d4/0x318)
[ 1429.790403]  r6:80deafd0 r5:80e023b0 r4:80dcf6e0 r3:00000002
[ 1429.796135] [<80068564>] (print_circular_bug) from [<8006c2c0>]
(__lock_acquire+0x1d30/0x1e88)
[ 1429.804748]  r10:00000001 r9:b6afa018 r8:00000001 r7:814461ec
r6:80c3e2d8 r5:b6a5ce00
[ 1429.812661]  r4:b6a5d270 r3:b6a5d258
[ 1429.816277] [<8006a590>] (__lock_acquire) from [<8006cc3c>]
(lock_acquire+0xb0/0x118)
[ 1429.824109]  r10:802d7d9c r9:00000000 r8:00000000 r7:00000000
r6:00000000 r5:b6773438
[ 1429.832020]  r4:00000000
[ 1429.834580] [<8006cb8c>] (lock_acquire) from [<80786dd4>]
(mutex_lock_nested+0x60/0x3d4)
[ 1429.842673]  r10:b6773400 r9:802d7d9c r8:b6afa030 r7:b6a5ce00
r6:814461ec r5:00000000
[ 1429.850586]  r4:b6afa000
[ 1429.853147] [<80786d74>] (mutex_lock_nested) from [<802d7d9c>]
(__create_file+0x70/0x21c)
[ 1429.861326]  r10:00000000 r9:b6a383c0 r8:7f028e30 r7:b4eafdf8
r6:000001a4 r5:b477f2e0
[ 1429.869238]  r4:81497388
[ 1429.871796] [<802d7d2c>] (__create_file) from [<802d7f7c>]
(debugfs_create_file+0x34/0x40)
[ 1429.880062]  r8:00000012 r7:b6a9c010 r6:7f028e30 r5:00014000 r4:b4eafdec
[ 1429.886853] [<802d7f48>] (debugfs_create_file) from [<802d830c>]
(debugfs_create_blob+0x24/0x30)
[ 1429.895656] [<802d82e8>] (debugfs_create_blob) from [<7f022ef4>]
(coda_alloc_aux_buf+0xa4/0x100 [coda])
[ 1429.905071] [<7f022e50>] (coda_alloc_aux_buf [coda]) from
[<7f025080>] (coda_alloc_context_buffers+0xa4/0x20c [coda])
[ 1429.915682]  r7:b4eaf8e4 r6:b6a9c040 r5:b6a9c010 r4:b4eaf800
[ 1429.921428] [<7f024fdc>] (coda_alloc_context_buffers [coda]) from
[<7f026068>] (coda_start_encoding+0x2c/0x88c [coda])
[ 1429.932125]  r7:34363248 r6:b6a9c040 r5:b6a9c010 r4:b4eaf800
[ 1429.937867] [<7f02603c>] (coda_start_encoding [coda]) from
[<7f021f44>] (coda_start_streaming+0xb8/0x268 [coda])
[ 1429.948042]  r10:00000000 r9:b6a383c0 r8:00000012 r7:b4ccd9e0
r6:b6a9c040 r5:00000004
[ 1429.955955]  r4:b4eaf800
[ 1429.958522] [<7f021e8c>] (coda_start_streaming [coda]) from
[<80542d04>] (vb2_start_streaming+0x6c/0x168)
[ 1429.968091]  r7:b6a9c0d0 r6:b4ccd9e0 r5:b4ccdae0 r4:b4ccd8b0
[ 1429.973824] [<80542c98>] (vb2_start_streaming) from [<805451d8>]
(vb2_internal_streamon+0xfc/0x158)
[ 1429.982871]  r7:b6a9c0d0 r6:40045612 r5:b4ccd800 r4:b4ccd9e0
[ 1429.988603] [<805450dc>] (vb2_internal_streamon) from [<80545270>]
(vb2_streamon+0x3c/0x60)
[ 1429.996956]  r5:b4ccd800 r4:00000002
[ 1430.000580] [<80545234>] (vb2_streamon) from [<7f00086c>]
(v4l2_m2m_streamon+0x30/0x48 [v4l2_mem2mem])
[ 1430.009903] [<7f00083c>] (v4l2_m2m_streamon [v4l2_mem2mem]) from
[<7f0008a4>] (v4l2_m2m_ioctl_streamon+0x20/0x24 [v4l2_mem2mem])
[ 1430.021468]  r5:00000001 r4:b4eaf9d8
[ 1430.025088] [<7f000884>] (v4l2_m2m_ioctl_streamon [v4l2_mem2mem])
from [<8052d684>] (v4l_streamon+0x28/0x2c)
[ 1430.034927] [<8052d65c>] (v4l_streamon) from [<80530bb8>]
(__video_do_ioctl+0x288/0x304)
[ 1430.043028] [<80530930>] (__video_do_ioctl) from [<805304fc>]
(video_usercopy+0x174/0x584)
[ 1430.051295]  r10:b6a383c0 r9:80530930 r8:00000001 r7:00000000
r6:b6afbe18 r5:00000004
[ 1430.059209]  r4:40045612
[ 1430.061770] [<80530388>] (video_usercopy) from [<80530928>]
(video_ioctl2+0x1c/0x24)
[ 1430.069518]  r10:00000000 r9:b6afa000 r8:b6a9c80c r7:b6a383c0
r6:7e9ef5b4 r5:40045612
[ 1430.077431]  r4:b6a9c0d0
[ 1430.079990] [<8053090c>] (video_ioctl2) from [<8052bf8c>]
(v4l2_ioctl+0x154/0x17c)
[ 1430.087573] [<8052be38>] (v4l2_ioctl) from [<8013e0c4>]
(do_vfs_ioctl+0x410/0x66c)
[ 1430.095145]  r8:00000003 r7:8013e364 r6:b6a383c0 r5:7e9ef5b4
r4:b6b867f8 r3:8052be38
[ 1430.102977] [<8013dcb4>] (do_vfs_ioctl) from [<8013e364>]
(SyS_ioctl+0x44/0x6c)
[ 1430.110290]  r10:00000000 r9:b6afa000 r8:00000003 r7:40045612
r6:b6a383c0 r5:7e9ef5b4
[ 1430.118203]  r4:b6a383c0
[ 1430.120762] [<8013e320>] (SyS_ioctl) from [<8000fa40>]
(ret_fast_syscall+0x0/0x48)
[ 1430.128334]  r8:8000fcc4 r7:00000036 r6:0003eb78 r5:000330f0
r4:7e9eb9c8 r3:00000000
[ 1430.138972] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1430.145725] cma: cma_alloc(): returned b7f0c000
[ 1430.158730] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1430.164549] cma: cma_alloc(): returned b7f12000
[ 1430.177621] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1430.183652] cma: cma_alloc(): returned b7f18000
[ 1430.196775] cma: cma_alloc(cma 814923f8, count 765, align 8)
[ 1430.203849] cma: cma_alloc(): returned b7f1e000
[ 1431.215547] coda 2040000.vpu: CODA PIC_RUN timeout

Thx,
JM
