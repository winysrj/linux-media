Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41906 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbeARFAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 00:00:12 -0500
Subject: Re: [RFT PATCH v3 0/6] Asynchronous UVC
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d8a30e87-5b95-113f-9725-2d4deb682527@infradead.org>
Date: Wed, 17 Jan 2018 20:59:54 -0800
MIME-Version: 1.0
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2018 01:19 AM, Kieran Bingham wrote:
> The Linux UVC driver has long provided adequate performance capabilities for
> web-cams and low data rate video devices in Linux while resolutions were low.
> 
> Modern USB cameras are now capable of high data rates thanks to USB3 with
> 1080p, and even 4k capture resolutions supported.
> 
> Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO
> (isochronous transfers) can generate more data than an embedded ARM core is
> able to process on a single core, resulting in frame loss.
> 
> A large part of this performance impact is from the requirement to
> ‘memcpy’ frames out from URB packets to destination frames. This unfortunate
> requirement is due to the UVC protocol allowing a variable length header, and
> thus it is not possible to provide the target frame buffers directly.
> 
> Extra throughput is possible by moving the actual memcpy actions to a work
> queue, and moving the memcpy out of interrupt context thus allowing work tasks
> to be scheduled across multiple cores.
> 
> This series has been tested on both the ZED and BRIO cameras on arm64
> platforms, however due to the intrinsic changes in the driver I would like to
> see it tested with other devices and other platforms, so I'd appreciate if
> anyone can test this on a range of USB cameras.
> 
> In particular, any iSight devices, or devices which use UVC to encode data
> (output device) would certainly be great to be tested with these patches.
> 
> v2:
>  - Fix race reported by Guennadi
> 
> v3:
>  - Fix similar race reported by Laurent
>  - Only queue work if required (encode/isight do not queue work)
>  - Refactor/Rename variables for clarity
> 
> Kieran Bingham (6):
>   uvcvideo: Refactor URB descriptors
>   uvcvideo: Convert decode functions to use new context structure
>   uvcvideo: Protect queue internals with helper
>   uvcvideo: queue: Simplify spin-lock usage
>   uvcvideo: queue: Support asynchronous buffer handling
>   uvcvideo: Move decode processing to process context
> 
>  drivers/media/usb/uvc/uvc_isight.c |   4 +-
>  drivers/media/usb/uvc/uvc_queue.c  | 114 +++++++++++++----
>  drivers/media/usb/uvc/uvc_video.c  | 198 ++++++++++++++++++++++--------
>  drivers/media/usb/uvc/uvcvideo.h   |  56 +++++++-
>  4 files changed, 296 insertions(+), 76 deletions(-)
> 
> base-commit: 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f

Hi,

Tested on x86_64, Linux 4.15-rc8 + these 9 patches, with 3 UVC webcams.

1.
usb 1-1.3: Product: Dynex 1.3MP Webcam
usb 1-1.3: Manufacturer: Dynex
uvcvideo: Found UVC 1.00 device Dynex 1.3MP Webcam (19ff:0102)

2. uvcvideo: Found UVC 1.00 device 2SF001 (0bda:58f5)  (builtin on Toshiba laptop)

3.
usb 1-1.3: New USB device found, idVendor=0c45, idProduct=62c0
usb 1-1.3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
usb 1-1.3: Product: USB 2.0 Camera
usb 1-1.3: Manufacturer: Sonix Technology Co., Ltd.
usb 1-1.3: SerialNumber: SN0001
uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:62c0)


BTW, qv4l2 was very useful for this.  Thanks, Hans.

Tested-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
