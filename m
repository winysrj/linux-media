Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59960 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730409AbeKGI7A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 03:59:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v5 0/9] Asynchronous UVC
Date: Wed, 07 Nov 2018 01:31:29 +0200
Message-ID: <2885485.8lvEIT6Ze7@avalon>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patches.

On Tuesday, 6 November 2018 23:27:11 EET Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
>=20
> The Linux UVC driver has long provided adequate performance capabilities =
for
> web-cams and low data rate video devices in Linux while resolutions were
> low.
>=20
> Modern USB cameras are now capable of high data rates thanks to USB3 with
> 1080p, and even 4k capture resolutions supported.
>=20
> Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO
> (isochronous transfers) can generate more data than an embedded ARM core =
is
> able to process on a single core, resulting in frame loss.
>=20
> A large part of this performance impact is from the requirement to
> =E2=80=98memcpy=E2=80=99 frames out from URB packets to destination frame=
s. This unfortunate
> requirement is due to the UVC protocol allowing a variable length header,
> and thus it is not possible to provide the target frame buffers directly.
>=20
> Extra throughput is possible by moving the actual memcpy actions to a work
> queue, and moving the memcpy out of interrupt context thus allowing work
> tasks to be scheduled across multiple cores.
>=20
> This series has been tested on both the ZED and BRIO cameras on arm64
> platforms, and with thanks to Randy Dunlap, a Dynex 1.3MP Webcam, a Sonix
> USB2 Camera, and a built in Toshiba Laptop camera, and with thanks to
> Philipp Zabel for testing on a Lite-On internal Laptop Webcam, Logitech
> C910 (USB2 isoc), Oculus Sensor (USB3 isoc), and Microsoft HoloLens Senso=
rs
> (USB3 bulk).
>=20
> As far as I am aware iSight devices, and devices which use UVC to encode
> data (output device) have not yet been tested - but should find no ill
> effect (at least not until they are tested of course :D )

:-D

I'm not sure whether anyone is still using those devices with Linux. I=20
wouldn't be surprised if we realized down the road that they already don't=
=20
work.

> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
>=20
> v2:
>  - Fix race reported by Guennadi
>=20
> v3:
>  - Fix similar race reported by Laurent
>  - Only queue work if required (encode/isight do not queue work)
>  - Refactor/Rename variables for clarity
>=20
> v4:
>  - (Yet another) Rework of the uninitialise path.
>    This time to hopefully clean up the shutdown races for good.
>    use usb_poison_urb() to halt all URBs, then flush the work queue
>    before freeing.
>  - Rebase to latest linux-media/master
>=20
> v5:
>  - Provide lockdep validation
>  - rename uvc_queue_requeue -> uvc_queue_buffer_requeue()
>  - Fix comments and periods throughout
>  - Rebase to media/v4.20-2
>  - Use GFP_KERNEL allocation in uvc_video_copy_data_work()
>  - Fix function documentation for uvc_video_copy_data_work()
>  - Add periods to the end of sentences
>  - Rename 'decode' variable to 'op' in uvc_video_decode_data()
>  - Move uvc_urb->async_operations initialisation to before use
>  - Move async workqueue to match uvc_streaming lifetime instead of
>    streamon/streamoff
>  - bracket the for_each_uvc_urb() macro
>=20
>  - New patches added to series:
>     media: uvcvideo: Split uvc_video_enable into two
>     media: uvcvideo: Rename uvc_{un,}init_video()
>     media: uvcvideo: Utilise for_each_uvc_urb iterator
>=20
> Kieran Bingham (9):
>   media: uvcvideo: Refactor URB descriptors
>   media: uvcvideo: Convert decode functions to use new context structure
>   media: uvcvideo: Protect queue internals with helper
>   media: uvcvideo: queue: Simplify spin-lock usage
>   media: uvcvideo: queue: Support asynchronous buffer handling
>   media: uvcvideo: Move decode processing to process context
>   media: uvcvideo: Split uvc_video_enable into two

I've taken the above patches in my tree.

>   media: uvcvideo: Rename uvc_{un,}init_video()
>   media: uvcvideo: Utilise for_each_uvc_urb iterator

And I've sent review comments for these two.

>  drivers/media/usb/uvc/uvc_driver.c |   2 +-
>  drivers/media/usb/uvc/uvc_isight.c |   6 +-
>  drivers/media/usb/uvc/uvc_queue.c  | 110 +++++++++---
>  drivers/media/usb/uvc/uvc_video.c  | 282 +++++++++++++++++++-----------
>  drivers/media/usb/uvc/uvcvideo.h   |  65 ++++++-
>  5 files changed, 331 insertions(+), 134 deletions(-)
>=20
> base-commit: dafb7f9aef2fd44991ff1691721ff765a23be27b

=2D-=20
Regards,

Laurent Pinchart
