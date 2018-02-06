Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57355 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbeBFHfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 02:35:09 -0500
Date: Tue, 6 Feb 2018 08:35:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/2 v6] uvcvideo: asynchronous controls
In-Reply-To: <1513179293-17324-1-git-send-email-guennadi.liakhovetski@intel.com>
Message-ID: <alpine.DEB.2.20.1802060834340.5889@axis700.grange>
References: <1513179293-17324-1-git-send-email-guennadi.liakhovetski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Any update on this?

Thanks
Guennadi

On Wed, 13 Dec 2017, Guennadi Liakhovetski wrote:

> This is an update of the two patches, adding asynchronous control
> support to the uvcvideo driver. If a control is sent, while the camera
> is still processing an earlier control, it will generate a protocol
> STALL condition on the control pipe.
> 
> Thanks
> Guennadi
> 
> Guennadi Liakhovetski (2):
>   uvcvideo: send a control event when a Control Change interrupt arrives
>   uvcvideo: handle control pipe protocol STALLs
> 
>  drivers/media/usb/uvc/uvc_ctrl.c   | 166 +++++++++++++++++++++++++++++++++----
>  drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
>  drivers/media/usb/uvc/uvc_video.c  |  59 +++++++++++--
>  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
>  include/uapi/linux/uvcvideo.h      |   2 +
>  6 files changed, 322 insertions(+), 35 deletions(-)
> 
> -- 
> 1.9.3
> 
