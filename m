Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbeHNLes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:34:48 -0400
Date: Tue, 14 Aug 2018 05:48:33 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 01/34] Documentation: v4l: document request API
Message-ID: <20180814054833.69d4cc41@coco.lan>
In-Reply-To: <18b31024-2cf0-58b3-4df5-fcb89b77e50f@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-2-hverkuil@xs4all.nl>
        <20180809144300.6ea1d040@coco.lan>
        <18b31024-2cf0-58b3-4df5-fcb89b77e50f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 09:57:27 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/08/18 19:43, Mauro Carvalho Chehab wrote:
> >> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> index 9e448a4aa3aa..0e415f2551b2 100644
> >> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> >> @@ -65,7 +65,7 @@ To enqueue a :ref:`memory mapped <mmap>` buffer applications set the
> >>  with a pointer to this structure the driver sets the
> >>  ``V4L2_BUF_FLAG_MAPPED`` and ``V4L2_BUF_FLAG_QUEUED`` flags and clears
> >>  the ``V4L2_BUF_FLAG_DONE`` flag in the ``flags`` field, or it returns an
> >> -EINVAL error code.
> >> +``EINVAL`` error code.  
> > 
> > Side note: we should likely do a similar replacement on all other places
> > inside the media uAPI docs.
> >   
> >>  
> >>  To enqueue a :ref:`user pointer <userp>` buffer applications set the
> >>  ``memory`` field to ``V4L2_MEMORY_USERPTR``, the ``m.userptr`` field to
> >> @@ -98,6 +98,25 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
> >>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
> >>  device is closed.
> >>  
> >> +The ``request_fd`` field can be used with the ``VIDIOC_QBUF`` ioctl to specify  
> > 
> > Please prefer using :ref: for QBUF too, e. g.: 
> > 	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>`  
> 
> Does this make sense when you are in the QBUF documentation itself? Using :ref: will
> just link back to the same page.
> 
> We need some guidelines here. I personally don't think this makes sense.

I'm almost sure we're doing the same on every other place within media docs.

> 
> Regards,
> 
> 	Hans



Thanks,
Mauro
