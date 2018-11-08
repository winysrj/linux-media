Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37774 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbeKIChZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 21:37:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v5 0/9] Asynchronous UVC
Date: Thu, 08 Nov 2018 19:01:11 +0200
Message-ID: <10862360.e6FNNLbdJF@avalon>
In-Reply-To: <2885485.8lvEIT6Ze7@avalon>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com> <2885485.8lvEIT6Ze7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 7 November 2018 01:31:29 EET Laurent Pinchart wrote:
> On Tuesday, 6 November 2018 23:27:11 EET Kieran Bingham wrote:
> > From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> >=20
> > The Linux UVC driver has long provided adequate performance capabilities
> > for web-cams and low data rate video devices in Linux while resolutions
> > were low.
> >=20
> > Modern USB cameras are now capable of high data rates thanks to USB3 wi=
th
> > 1080p, and even 4k capture resolutions supported.
> >=20
> > Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO
> > (isochronous transfers) can generate more data than an embedded ARM core
> > is able to process on a single core, resulting in frame loss.
> >=20
> > A large part of this performance impact is from the requirement to
> > =E2=80=98memcpy=E2=80=99 frames out from URB packets to destination fra=
mes. This
> > unfortunate requirement is due to the UVC protocol allowing a variable
> > length header, and thus it is not possible to provide the target frame
> > buffers directly.
> >=20
> > Extra throughput is possible by moving the actual memcpy actions to a w=
ork
> > queue, and moving the memcpy out of interrupt context thus allowing work
> > tasks to be scheduled across multiple cores.
> >=20
> > This series has been tested on both the ZED and BRIO cameras on arm64
> > platforms, and with thanks to Randy Dunlap, a Dynex 1.3MP Webcam, a Son=
ix
> > USB2 Camera, and a built in Toshiba Laptop camera, and with thanks to
> > Philipp Zabel for testing on a Lite-On internal Laptop Webcam, Logitech
> > C910 (USB2 isoc), Oculus Sensor (USB3 isoc), and Microsoft HoloLens
> > Sensors (USB3 bulk).
> >=20
> > As far as I am aware iSight devices, and devices which use UVC to encode
> > data (output device) have not yet been tested - but should find no ill
> > effect (at least not until they are tested of course :D )
>
> :-D
>=20
> I'm not sure whether anyone is still using those devices with Linux. I
> wouldn't be surprised if we realized down the road that they already don't
> work.
>=20
> > Tested-by: Randy Dunlap <rdunlap@infradead.org>
> > Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
> >=20
> > v2:
> >  - Fix race reported by Guennadi
> >=20
> > v3:
> >  - Fix similar race reported by Laurent
> >  - Only queue work if required (encode/isight do not queue work)
> >  - Refactor/Rename variables for clarity
> >=20
> > v4:
> >  - (Yet another) Rework of the uninitialise path.
> > =20
> >    This time to hopefully clean up the shutdown races for good.
> >    use usb_poison_urb() to halt all URBs, then flush the work queue
> >    before freeing.
> > =20
> >  - Rebase to latest linux-media/master
> >=20
> > v5:
> >  - Provide lockdep validation
> >  - rename uvc_queue_requeue -> uvc_queue_buffer_requeue()
> >  - Fix comments and periods throughout
> >  - Rebase to media/v4.20-2
> >  - Use GFP_KERNEL allocation in uvc_video_copy_data_work()
> >  - Fix function documentation for uvc_video_copy_data_work()
> >  - Add periods to the end of sentences
> >  - Rename 'decode' variable to 'op' in uvc_video_decode_data()
> >  - Move uvc_urb->async_operations initialisation to before use
> >  - Move async workqueue to match uvc_streaming lifetime instead of
> > =20
> >    streamon/streamoff
> > =20
> >  - bracket the for_each_uvc_urb() macro
> > =20
> >  - New patches added to series:
> >     media: uvcvideo: Split uvc_video_enable into two
> >     media: uvcvideo: Rename uvc_{un,}init_video()
> >     media: uvcvideo: Utilise for_each_uvc_urb iterator
> >=20
> > Kieran Bingham (9):
> >   media: uvcvideo: Refactor URB descriptors
> >   media: uvcvideo: Convert decode functions to use new context structure
> >   media: uvcvideo: Protect queue internals with helper
> >   media: uvcvideo: queue: Simplify spin-lock usage
> >   media: uvcvideo: queue: Support asynchronous buffer handling
> >   media: uvcvideo: Move decode processing to process context
> >   media: uvcvideo: Split uvc_video_enable into two
>=20
> I've taken the above patches in my tree.

I'm afraid I'll have to drop them :-( If I disconnect the camera while in u=
se,
I get the following oops:

[  237.514625] usb 2-1.4: USB disconnect, device number 5
[  237.516123] uvcvideo: Failed to resubmit video URB (-19).
[  237.549470] BUG: unable to handle kernel paging request at 000000004bec0=
091
[  237.549476] PGD 0 P4D 0=20
[  237.549481] Oops: 0000 [#1] PREEMPT SMP PTI
[  237.549485] CPU: 3 PID: 5332 Comm: luvcview Tainted: G        W  O      =
4.18.16-gentoo #1
[  237.549487] Hardware name: Dell Inc. Latitude E6420/0K0DNP, BIOS A08 10/=
18/2011
[  237.549493] RIP: 0010:flush_workqueue_prep_pwqs+0x49/0x120
[  237.549494] Code: 47 48 85 c0 0f 85 e1 00 00 00 c7 45 48 01 00 00 00 48 =
8b 45 00 4c 8d 78 90 48 39 c5 0f 84 d0 00 00 00 c6 44 24 07 00 4d 63 f4 <4d=
> 8b 2f 4c 89 ef e8 5c b3 89 00 45 85 e4 78 1d 41 83 7f 14 ff 75=20
[  237.549525] RSP: 0018:ffffc9000154fc50 EFLAGS: 00010296
[  237.549527] RAX: 000000004bec0101 RBX: 0000000000000002 RCX: 00000000000=
00002
[  237.549529] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff8803024=
1c600
[  237.549530] RBP: ffff88030241c600 R08: 0000000000000000 R09: 00000000000=
00000
[  237.549532] R10: ffffc9000154fd30 R11: ffff8802faa09398 R12: 00000000000=
00001
[  237.549534] R13: ffff88030241c668 R14: 0000000000000001 R15: 000000004be=
c0091
[  237.549536] FS:  0000000000000000(0000) GS:ffff88032dd80000(0000) knlGS:=
0000000000000000
[  237.549537] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  237.549539] CR2: 000000004bec0091 CR3: 000000000220a001 CR4: 00000000000=
606e0
[  237.549540] Call Trace:
[  237.549545]  flush_workqueue+0x161/0x390
[  237.549549]  ? preempt_count_add+0x8d/0x90
[  237.549557]  ? uvc_uninit_video+0x51/0xa0 [uvcvideo]
[  237.549560]  uvc_uninit_video+0x51/0xa0 [uvcvideo]
[  237.549565]  uvc_video_stop_streaming+0xe/0x80 [uvcvideo]
[  237.549568]  uvc_stop_streaming+0x17/0x40 [uvcvideo]
[  237.549573]  __vb2_queue_cancel+0x25/0x1c0 [videobuf2_common]
[  237.549576]  vb2_core_queue_release+0x19/0x40 [videobuf2_common]
[  237.549580]  uvc_queue_release+0x1c/0x30 [uvcvideo]
[  237.549584]  uvc_v4l2_release+0x9d/0xd0 [uvcvideo]
[  237.549594]  v4l2_release+0x2d/0x80 [videodev]
[  237.549598]  __fput+0x95/0x1d0
[  237.549602]  task_work_run+0x84/0xa0
[  237.549605]  do_exit+0x2a3/0xad0
[  237.549608]  do_group_exit+0x2e/0xa0
[  237.549610]  __x64_sys_exit_group+0xf/0x10
[  237.549613]  do_syscall_64+0x3d/0xf0
[  237.549617]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  237.549619] RIP: 0033:0x7f2b0b6097a6
[  237.549620] Code: Bad RIP value.
[  237.549625] RSP: 002b:00007ffd2ddf5088 EFLAGS: 00000246 ORIG_RAX: 000000=
00000000e7
[  237.549627] RAX: ffffffffffffffda RBX: 00007f2b0b8f8740 RCX: 00007f2b0b6=
097a6
[  237.549629] RDX: 0000000000000000 RSI: 000000000000003c RDI: 00000000000=
00000
[  237.549630] RBP: 0000000000000000 R08: 00000000000000e7 R09: fffffffffff=
fff80
[  237.549632] R10: 00007f2b05e37168 R11: 0000000000000246 R12: 00007f2b0b8=
f8740
[  237.549634] R13: 0000000000000001 R14: 00007f2b0b9016e8 R15: 00000000000=
00000
[  237.549636] Modules linked in: uvcvideo(O) videobuf2_vmalloc(O) videobuf=
2_memops(O) videobuf2_v4l2(O) videobuf2_common(O) v4l2_common(O) videodev(O=
) media(O) xt_conntrack ip6table_filter binfmt_misc dell_laptop snd_hda_cod=
ec_hdmi dell_smbios dcdbas coretemp hwmon kvm_intel kvm irqbypass snd_hda_c=
odec_idt snd_hda_codec_generic iwldvm snd_hda_intel snd_hda_codec snd_hwdep=
 snd_hda_core snd_pcm snd_timer iwlwifi snd [last unloaded: media]
[  237.549659] CR2: 000000004bec0091
[  237.549662] ---[ end trace 574358b4f247dc6f ]---
[  237.549664] RIP: 0010:flush_workqueue_prep_pwqs+0x49/0x120
[  237.549665] Code: 47 48 85 c0 0f 85 e1 00 00 00 c7 45 48 01 00 00 00 48 =
8b 45 00 4c 8d 78 90 48 39 c5 0f 84 d0 00 00 00 c6 44 24 07 00 4d 63 f4 <4d=
> 8b 2f 4c 89 ef e8 5c b3 89 00 45 85 e4 78 1d 41 83 7f 14 ff 75=20
[  237.549696] RSP: 0018:ffffc9000154fc50 EFLAGS: 00010296
[  237.549699] RAX: 000000004bec0101 RBX: 0000000000000002 RCX: 00000000000=
00002
[  237.549700] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff8803024=
1c600
[  237.549702] RBP: ffff88030241c600 R08: 0000000000000000 R09: 00000000000=
00000
[  237.549704] R10: ffffc9000154fd30 R11: ffff8802faa09398 R12: 00000000000=
00001
[  237.549706] R13: ffff88030241c668 R14: 0000000000000001 R15: 000000004be=
c0091
[  237.549708] FS:  0000000000000000(0000) GS:ffff88032dd80000(0000) knlGS:=
0000000000000000
[  237.549710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  237.549712] CR2: 00007f2b0b60977c CR3: 000000000220a001 CR4: 00000000000=
606e0
[  237.549714] Fixing recursive fault but reboot is needed!

> >   media: uvcvideo: Rename uvc_{un,}init_video()
> >   media: uvcvideo: Utilise for_each_uvc_urb iterator
>=20
> And I've sent review comments for these two.
>=20
> >  drivers/media/usb/uvc/uvc_driver.c |   2 +-
> >  drivers/media/usb/uvc/uvc_isight.c |   6 +-
> >  drivers/media/usb/uvc/uvc_queue.c  | 110 +++++++++---
> >  drivers/media/usb/uvc/uvc_video.c  | 282 +++++++++++++++++++-----------
> >  drivers/media/usb/uvc/uvcvideo.h   |  65 ++++++-
> >  5 files changed, 331 insertions(+), 134 deletions(-)
> >=20
> > base-commit: dafb7f9aef2fd44991ff1691721ff765a23be27b

=2D-=20
Regards,

Laurent Pinchart
