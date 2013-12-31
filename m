Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47087 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3LaPTU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Dec 2013 10:19:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chuanbo Weng <strgnm@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: DMABUF doesn't work when frame size not equal to the size of GPU bo
Date: Tue, 31 Dec 2013 16:19:53 +0100
Message-ID: <3150357.rYSWurtcIU@avalon>
In-Reply-To: <CAFu4+mV7D_Ys-tobgtoi92pvuS41mqE71PQf_e0qS_6rOnvV3g@mail.gmail.com>
References: <CAFu4+mW7ja=FR3Csw_svfnSCtivZNACgaTV-J7vD=15vKHzQtg@mail.gmail.com> <52C275B9.1030803@samsung.com> <CAFu4+mV7D_Ys-tobgtoi92pvuS41mqE71PQf_e0qS_6rOnvV3g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chuanbo,

On Tuesday 31 December 2013 19:21:09 Chuanbo Weng wrote:
> 2013/12/31 Tomasz Stanislawski <t.stanislaws@samsung.com>:
> > Hi Chuanbo Weng,
> > 
> > I suspect that the problem might be caused by difference
> > between size of DMABUF object and buffer size in V4L2.
> 
> Thanks for your reply! I agree with you because my experiment prove it
> (Even when the bo is bigget than frame size, not smaller!!!).
> 
> > What is the content of v4l2_format returned by VIDIOC_G_FMT?
> 
> The content is V4L2_PIX_FMT_YUYV. (And if the content V4L2_PIX_FMT_MJPEG,
> this issue doesn't happen.)

Could you please give us the content of all the other fields ?

> > What is the content of V4l2_buffer structure passed by VIDIOC_QBUF?

Same here.

> The fd in v4l2_buffer structure is fd of gem object created by
> DRM_IOCTL_MODE_CREATE_DUMB.
>
> I've upload the program that can reproduce this issue on intel platform. You
> just need to clone it from
> https://github.com/strgnm/v4l2-dmabuf-test.git
> Then build and run as said in README.

-- 
Regards,

Laurent Pinchart

