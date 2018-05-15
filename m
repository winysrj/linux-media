Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbeEOTWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 15:22:41 -0400
Date: Tue, 15 May 2018 16:22:33 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 0/6] Asynchronous UVC
Message-ID: <20180515162233.2937906e@vento.lan>
In-Reply-To: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Mar 2018 17:45:57 +0100
Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:

> The Linux UVC driver has long provided adequate performance capabilities =
for
> web-cams and low data rate video devices in Linux while resolutions were =
low.
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
> requirement is due to the UVC protocol allowing a variable length header,=
 and
> thus it is not possible to provide the target frame buffers directly.
>=20
> Extra throughput is possible by moving the actual memcpy actions to a work
> queue, and moving the memcpy out of interrupt context thus allowing work =
tasks
> to be scheduled across multiple cores.
>=20
> This series has been tested on both the ZED and BRIO cameras on arm64
> platforms, and with thanks to Randy Dunlap, a Dynex 1.3MP Webcam, a Sonix=
 USB2
> Camera, and a built in Toshiba Laptop camera, and with thanks to Philipp =
Zabel
> for testing on a Lite-On internal Laptop Webcam, Logitech C910 (USB2 isoc=
),
> Oculus Sensor (USB3 isoc), and Microsoft HoloLens Sensors (USB3 bulk).
>=20
> As far as I am aware iSight devices, and devices which use UVC to encode =
data
> (output device) have not yet been tested - but should find no ill effect =
(at
> least not until they are tested of course :D )
>=20
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

Kieran/Laurent,

What's the status of this patchset?

Regards,
Mauro

>=20
> Kieran Bingham (6):
>   media: uvcvideo: Refactor URB descriptors
>   media: uvcvideo: Convert decode functions to use new context structure
>   media: uvcvideo: Protect queue internals with helper
>   media: uvcvideo: queue: Simplify spin-lock usage
>   media: uvcvideo: queue: Support asynchronous buffer handling
>   media: uvcvideo: Move decode processing to process context
>=20
>  drivers/media/usb/uvc/uvc_isight.c |   6 +-
>  drivers/media/usb/uvc/uvc_queue.c  | 102 +++++++++++++----
>  drivers/media/usb/uvc/uvc_video.c  | 180 +++++++++++++++++++++---------
>  drivers/media/usb/uvc/uvcvideo.h   |  59 ++++++++--
>  4 files changed, 266 insertions(+), 81 deletions(-)
>=20
> base-commit: a77cfdf6bd06eef0dadea2b541a7c01502b1b4f6



Thanks,
Mauro
