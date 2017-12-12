Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55758 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdLLHpP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 02:45:15 -0500
Date: Tue, 12 Dec 2017 08:45:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] uvcvideo: Refactor code to ease metadata
 implementation
In-Reply-To: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1712120832090.26789@axis700.grange>
References: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patches. Please feel free to add either or both of

Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

to both of the patches. Whereas in fact strictly speaking your current 
tree has updated improved versions of the patches, at least of the first 
of them - it now correctly handles the struct video_device::vfl_dir field, 
even thoough I'd still find merging that "if" with the following "switch" 
prettier ;-) So, strictly speaking you'd have to post those updated 
versions, in any case my approval tags refer to versions in your tree with 
commit IDs

53464c9f76da054ac3c291d27f348170d2a346c6
and
b6c5f10563c4ee8437cd9131bc3d389514456519

Thanks
Guennadi

On Tue, 5 Dec 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> This small patch series refactors the uvc_video_register() function to extract
> the code that you need into a new uvc_video_register_device() function. Please
> let me know if it can help.
> 
> Laurent Pinchart (2):
>   uvcvideo: Factor out video device registration to a function
>   uvcvideo: Report V4L2 device caps through the video_device structure
> 
>  drivers/media/usb/uvc/uvc_driver.c | 77 +++++++++++++++++++++++++-------------
>  drivers/media/usb/uvc/uvc_v4l2.c   |  4 --
>  drivers/media/usb/uvc/uvcvideo.h   |  8 ++++
>  3 files changed, 60 insertions(+), 29 deletions(-)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
