Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39508 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753585AbdDDKfO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 06:35:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Raikhel, Evgeni" <evgeni.raikhel@intel.com>
Cc: "Liakhovetski, Guennadi" <guennadi.liakhovetski@intel.com>,
        "Tamir, Eliezer" <eliezer.tamir@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 0/2]  Intel Depth Formats for SR300 Camera
Date: Tue, 04 Apr 2017 13:35:59 +0300
Message-ID: <36384142.ViHC5ut9LT@avalon>
In-Reply-To: <AA09C8071EEEFC44A7852ADCECA86673020CE09B@hasmsx108.ger.corp.intel.com>
References: <AA09C8071EEEFC44A7852ADCECA86673A1E6E7@hasmsx108.ger.corp.intel.com> <1488498200-8014-1-git-send-email-evgeni.raikhel@intel.com> <AA09C8071EEEFC44A7852ADCECA86673020CE09B@hasmsx108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeni,

On Monday 03 Apr 2017 08:53:44 Raikhel, Evgeni wrote:
> Hi Laurent,
> Can you please update on the status of the submission?
> The last version has been reviewed a month ago.
> Is there any estimate on when it is going to be staged/triaged/merged into
> media tree?

I've just sent a pull request to Mauro (and CC'ed you). The patches should get 
merged in v4.12.

> -----Original Message-----
> From: Raikhel, Evgeni
> Sent: Friday, March 03, 2017 01:43
> To: linux-media@vger.kernel.org
> Cc: laurent.pinchart@ideasonboard.com; Liakhovetski, Guennadi
> <guennadi.liakhovetski@intel.com>; Tamir, Eliezer
> <eliezer.tamir@intel.com>; Raikhel, Evgeni <evgeni.raikhel@intel.com>
> Subject: [PATCH v4 0/2] Intel Depth Formats for SR300 Camera
> 
> From: Evgeni Raikhel <evgeni.raikhel@intel.com>
> 
> Change Log:
>  - Fixing FourCC description in v4l2_ioctl.c to be less than 32 bytes
>  - Reorder INZI format entry in Documentation chapter
> 
> Daniel Patrick Johnson (1):
>   uvcvideo: Add support for Intel SR300 depth camera
> 
> eraikhel (1):
>   Documentation: Intel SR300 Depth camera INZI format
> 
>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
>  Documentation/media/uapi/v4l/pixfmt-inzi.rst   | 81 ++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_driver.c             | 15 +++++
>  drivers/media/usb/uvc/uvcvideo.h               |  9 +++
>  drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
>  include/uapi/linux/videodev2.h                 |  1 +
>  6 files changed, 108 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst

-- 
Regards,

Laurent Pinchart
