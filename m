Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60806 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbcLENqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 08:46:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: evgeni.raikhel@gmail.com
Cc: linux-media@vger.kernel.org,
        Evgeni Raikhel <evgeni.raikhel@intel.com>
Subject: Re: [PATCH 2/2] uvcvideo: Document Intel SR300 Depth camera INZI format
Date: Mon, 05 Dec 2016 15:46:33 +0200
Message-ID: <2814535.1GUuC5bdsj@avalon>
In-Reply-To: <1480944299-3349-3-git-send-email-evgeni.raikhel@intel.com>
References: <1480944299-3349-1-git-send-email-evgeni.raikhel@intel.com> <1480944299-3349-3-git-send-email-evgeni.raikhel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeni,

Thank you for the patch.

On Monday 05 Dec 2016 15:24:59 evgeni.raikhel@gmail.com wrote:
> From: Evgeni Raikhel <evgeni.raikhel@intel.com>
> 
> Provide the frame structure and data layout of V4L2-PIX-FMT-INZI
> format utilized by Intel SR300 Depth camera.
> 
> This is a complimentary patch for:
> [PATCH] UVC: Add support for Intel SR300 depth camera

Once the patches will be committed this reference will be harder to use, as it 
would require searching for the other commit through the whole git history. 
Here you should instead group related changes in a single patch. The first 
patch in this series should add the new INZI format to the V4L2 API, with the 
new format definition in include/uapi/linux/videodev2.h (currently part of 
patch 1/2) and this documentation. The second patch should then add support 
for that format in the uvcvideo driver, with the changes to 
drivers/media/usb/uvc/* from patch 1/2.

Could you please split the patches that way and resubmit ? And please see 
below for additional comments.

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

The documentation, like source code, should be limited to 80 characters per 
column. Could you please reformat the file ?

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

This table is harder to wrap to 80 columns, but if you use the same format 
description style as the rest of the media documentation the limit shouldn't 
be an issue.

-- 
Regards,

Laurent Pinchart

