Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:41193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751312AbeFVO13 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 10:27:29 -0400
Date: Fri, 22 Jun 2018 16:27:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 0/3] uvcvideo: asynchronous controls
In-Reply-To: <alpine.DEB.2.20.1805312300430.32544@axis700.grange>
Message-ID: <alpine.DEB.2.20.1806221625290.14000@axis700.grange>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <alpine.DEB.2.20.1805312300430.32544@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

6.5 weeks and counting. Can we please schedule a review of these patches 
for the next week? Not much time is left to make it for 4.19.

Thanks
Guennadi

On Thu, 31 May 2018, Guennadi Liakhovetski wrote:

> Hi Laurent,
> 
> More than 3 weeks since v8 has been posted. Seems like we've missed 4.18. 
> Could you please review them ASAP to make sure we merge them into 4.19?
> 
> Thanks
> Guennadi
> 
> On Tue, 8 May 2018, Guennadi Liakhovetski wrote:
> 
> > Added a patch to remove a redundant check, addressed Laurent's
> > comments.
> > 
> > Guennadi Liakhovetski (3):
> >   uvcvideo: remove a redundant check
> >   uvcvideo: send a control event when a Control Change interrupt arrives
> >   uvcvideo: handle control pipe protocol STALLs
> > 
> >  drivers/media/usb/uvc/uvc_ctrl.c   | 168 ++++++++++++++++++++++++++++++-------
> >  drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++++++++++++++---
> >  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> >  drivers/media/usb/uvc/uvc_video.c  |  52 ++++++++++--
> >  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> >  include/uapi/linux/uvcvideo.h      |   2 +
> >  6 files changed, 302 insertions(+), 51 deletions(-)
> > 
> > -- 
> > 1.9.3
> > 
> > Thanks
> > Guennadi
> > 
> 
