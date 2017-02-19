Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46559 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbdBSQpO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 11:45:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: evgeni.raikhel@intel.com
Cc: linux-media@vger.kernel.org, guennadi.liakhovetski@intel.com,
        eliezer.tamir@intel.com
Subject: Re: [PATCH v3 1/2] Documentation: Intel SR300 Depth camera INZI format
Date: Sun, 19 Feb 2017 18:45:41 +0200
Message-ID: <4006803.aJX31t57Hd@avalon>
In-Reply-To: <1487520877-23173-2-git-send-email-evgeni.raikhel@intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com> <1487520877-23173-1-git-send-email-evgeni.raikhel@intel.com> <1487520877-23173-2-git-send-email-evgeni.raikhel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeni,

Thank you for the patch.

On Sunday 19 Feb 2017 18:14:36 evgeni.raikhel@intel.com wrote:
> From: eraikhel <evgeni.raikhel@intel.com>
> 
> Provide the frame structure and data layout of V4L2-PIX-FMT-INZI
> format utilized by Intel SR300 Depth camera.
> 
> Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
>  Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 ++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
>  include/uapi/linux/videodev2.h                 |  1 +
>  4 files changed, 84 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst
> 
> diff --git a/Documentation/media/uapi/v4l/depth-formats.rst
> b/Documentation/media/uapi/v4l/depth-formats.rst index
> 82f183870aae..c755be0e4d2a 100644
> --- a/Documentation/media/uapi/v4l/depth-formats.rst
> +++ b/Documentation/media/uapi/v4l/depth-formats.rst
> @@ -13,3 +13,4 @@ Depth data provides distance to points, mapped onto the
> image plane
>      :maxdepth: 1
> 
>      pixfmt-z16
> +    pixfmt-inzi

According the the cover letter, this version reordered "INZI entry in 
../depth-formats.rst to keep the list strictly alphabetic. Do we have a 
different definition of the alphabetic order ? :-)

[snip]

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index 0c3f238a2e76..3023e2351861
> 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1131,6 +1131,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> 	case V4L2_PIX_FMT_Y8I:		descr = "Interleaved 8-bit Greyscale";
> break;
> 	case V4L2_PIX_FMT_Y12I:		descr = "Interleaved 12-bit
> Greyscale"; break;
> 	case V4L2_PIX_FMT_Z16:		descr = "16-bit Depth"; break;
> +	case V4L2_PIX_FMT_INZI:		descr = "Planar 10-bit Greyscale and
> 16-bit Depth"; break;

I'm afraid that the format description is limited to 32 characters (including 
the terminating 0), while this is 41 characters long.

> 	case V4L2_PIX_FMT_PAL8:		descr = "8-bit Palette"; break;
>  	case V4L2_PIX_FMT_UV8:		descr = "8-bit Chrominance UV 4-4";
> break;
>  	case V4L2_PIX_FMT_YVU410:	descr = "Planar YVU 4:1:0"; break;

-- 
Regards,

Laurent Pinchart
