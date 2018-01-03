Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33586 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbeACVNL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 16:13:11 -0500
Received: by mail-oi0-f66.google.com with SMTP id w131so1821426oiw.0
        for <linux-media@vger.kernel.org>; Wed, 03 Jan 2018 13:13:11 -0800 (PST)
Subject: Re: [RFC/RFT PATCH 0/6] Asynchronous UVC
To: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
From: Troy Kisky <troy.kisky@boundarydevices.com>
Message-ID: <b18d0633-cb04-639b-4ade-55b6839da0b3@boundarydevices.com>
Date: Wed, 3 Jan 2018 13:13:10 -0800
MIME-Version: 1.0
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/3/2018 12:32 PM, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> The Linux UVC driver has long provided adequate performance capabilities for
> web-cams and low data rate video devices in Linux while resolutions were low.
> 
> Modern USB cameras are now capable of high data rates thanks to USB3 with
> 1080p, and even 4k capture resolutions supported.
> 
> Cameras such as the Stereolabs ZED or the Logitech Brio can generate more data
> than an embedded ARM core is able to process on a single core, resulting in
> frame loss.
> 
> A large part of this performance impact is from the requirement to
> ‘memcpy’ frames out from URB packets to destination frames. This unfortunate
> requirement is due to the UVC protocol allowing a variable length header, and
> thus it is not possible to provide the target frame buffers directly.


I have a rather large patch that does provide frame buffers directly for bulk
cameras. It cannot be used with ISOC cameras.  But it is currently for 4.1.
I'll be porting it to 4.9 in a few days if you'd like to see it.

BR
Troy


> 
> Extra throughput is possible by moving the actual memcpy actions to a work
> queue, and moving the memcpy out of interrupt context and allowing work tasks
> to be scheduled across multiple cores.
> 
> This series has been tested on both the ZED and Brio cameras on arm64
> platforms, however due to the intrinsic changes in the driver I would like to
> see it tested with other devices and other platforms, so I'd appreciate if
> anyone can test this on a range of USB cameras.
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
>  drivers/media/usb/uvc/uvc_queue.c  | 115 ++++++++++++++----
>  drivers/media/usb/uvc/uvc_video.c  | 191 ++++++++++++++++++++++--------
>  drivers/media/usb/uvc/uvcvideo.h   |  56 +++++++--
>  4 files changed, 289 insertions(+), 77 deletions(-)
> 
> base-commit: 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f
> 
