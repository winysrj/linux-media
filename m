Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53377 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbeILLmw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 07:42:52 -0400
Subject: Re: [PATCH v2 0/2] [media] Depth confidence pixel-format for Intel
 RealSense cameras
To: dorodnic@gmail.com, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
References: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f752d94f-d1fc-5276-aa58-ef7cdff6b21b@xs4all.nl>
Date: Wed, 12 Sep 2018 08:39:44 +0200
MIME-Version: 1.0
In-Reply-To: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2018 08:42 AM, dorodnic@gmail.com wrote:
> From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> 
> Define new fourcc describing depth sensor confidence data used in Intel RealSense cameras.
> Confidence information is stored as packed 4 bits per pixel single-plane image.
> The patches were tested on 4.18-rc2 and merged with media_tree/master.
> Addressing code-review comments by Hans Verkuil <hverkuil@xs4all.nl> and
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>.
> 
> Sergey Dorodnicov (2):
>   CNF4 fourcc for 4 bit-per-pixel packed depth confidence information
>   CNF4 pixel format for media subsystem
> 
>  Documentation/media/uapi/v4l/depth-formats.rst |  1 +
>  Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 31 ++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvc_driver.c             |  5 +++++
>  drivers/media/usb/uvc/uvcvideo.h               |  3 +++
>  drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
>  include/uapi/linux/videodev2.h                 |  1 +
>  6 files changed, 42 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst
> 

Laurent, this looks good to me. Do you want to take this series or shall I?

If you take it, then you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

to these patches. If you want me to take it, then I'll need your Ack of course.

Regards,

	Hans
