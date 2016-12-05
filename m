Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60818 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbcLENt1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 08:49:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: evgeni.raikhel@gmail.com
Cc: linux-media@vger.kernel.org,
        Evgeni Raikhel <evgeni.raikhel@intel.com>
Subject: Re: [PATCH 2/2] uvcvideo: Document Intel SR300 Depth camera INZI format
Date: Mon, 05 Dec 2016 15:49:47 +0200
Message-ID: <1757661.3qrq6qFaV4@avalon>
In-Reply-To: <1480944299-3349-3-git-send-email-evgeni.raikhel@intel.com>
References: <1480944299-3349-1-git-send-email-evgeni.raikhel@intel.com> <1480944299-3349-3-git-send-email-evgeni.raikhel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeni,

On Monday 05 Dec 2016 15:24:59 evgeni.raikhel@gmail.com wrote:
> From: Evgeni Raikhel <evgeni.raikhel@intel.com>
> 
> Provide the frame structure and data layout of V4L2-PIX-FMT-INZI
> format utilized by Intel SR300 Depth camera.
> 
> This is a complimentary patch for:
> [PATCH] UVC: Add support for Intel SR300 depth camera
> 
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> ---
>  Documentation/media/uapi/v4l/pixfmt-inzi.rst | 40 +++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst
> b/Documentation/media/uapi/v4l/pixfmt-inzi.rst new file mode 100644
> index 000000000000..cdfdeae4a664
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
> @@ -0,0 +1,40 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _V4L2-PIX-FMT-INZI:
> +
> +**************************
> +V4L2_PIX_FMT_INZI ('INZI')
> +**************************
> +
> +Infrared 10-bit linked with Depth 16-bit images
> +
> +
> +Description
> +===========
> +
> +Custom multi-planar format used by Intel SR300 Depth cameras, comprise of
> Infrared image followed by Depth data. +The pixel definition is 32-bpp,
> with the Depth and Infrared Data split into separate continuous planes of
> identical dimensions. +
> +The first plane - Infrared data - is stored in V4L2_PIX_FMT_Y10 (see
> :ref:`pixfmt-y10`) greyscale format. Each pixel is 16-bit cell, with actual
> data present in the 10 LSBs with values in range 0 to 1023. The six
> remaining MSBs are padded with zeros. +
> +The second plane provides 16-bit per-pixel Depth data in V4L2_PIX_FMT_Z16
> (:ref:`pixfmt-z16`) format. +

In addition to my previous comments, wouldn't it make more sense to create a 
multiplanar format for this instead of bundling the two separate images into a 
single plane ?

> +**Frame Structure.**
> +Each cell is a 16-bit word with the significant data byte is stored at
> lower memory address (little-endian). +
> ++-----------------+-----------------+-----------------+-----------------+--
> ---------------+-----------------+ +| Ir\ :sub:`0`    | Ir\ :sub:`1`    |
> Ir\ :sub:`2`    |       ...       |        ...      |       ...       |
> ++-----------------+-----------------+-----------------+-----------------+-
> ----------------+-----------------+ +|      ...       ...       ...         
>                                                                     | +|   
>                              Infrared Data                                 
>                            | +|                                            
>     ...   ...   ...                                           |
> ++-----------------+-----------------+-----------------+-----------------+-
> ----------------+-----------------+ +| Ir\ :sub:`n-3`  | Ir\ :sub:`n-2`  |
> Ir\ :sub:`n-1`  | Depth\ :sub:`0` | Depth\ :sub:`1` | Depth\ :sub:`2` |
> ++-----------------+-----------------+-----------------+-----------------+-
> ----------------+-----------------+ +|      ...       ...       ...         
>                                                                     | +|   
>                              Depth Data                                    
>                            | +|                                            
>     ...   ...   ...                                           |
> ++-----------------+-----------------+-----------------+-----------------+-
> ----------------+-----------------+ +|       ...       |       ...       |  
>     ...       |Depth\ :sub:`n-3`|Depth\ :sub:`n-2`|Depth\ :sub:`n-1`|
> ++-----------------+-----------------+-----------------+-----------------+-
> ----------------+-----------------+

-- 
Regards,

Laurent Pinchart

