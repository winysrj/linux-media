Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43263 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0LNK7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 05:59:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonghun Han <jonghun.han@samsung.com>
Subject: Re: Should a index be passed on the fly with the VIDIOC_QBUF ioctl in V4L2_MEMORY_USERPTR case ?
Date: Tue, 14 Dec 2010 12:00:29 +0100
Cc: linux-media@vger.kernel.org, "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	mchehab@redhat.com
References: <AANLkTinzO2BN7AbRgqoKzO7-2ay385CZHAaNGZB2fcKO@mail.gmail.com> <01bb01cb9b7c$d885f9e0$8991eda0$%han@samsung.com>
In-Reply-To: <01bb01cb9b7c$d885f9e0$8991eda0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141200.29925.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Jonghun,

On Tuesday 14 December 2010 11:51:17 Jonghun Han wrote:
> Hi,
> 
> Any comment for this ?
> 
> In my opinion v4l2 spec is not accurate in this topic.
> Because VIDIOC_REQBUFS describes count is only used in V4L2_MEMORY_MMAP as
> below.
> __u32	count	The number of buffers requested or granted. This field is
> only used when memory is set to V4L2_MEMORY_MMAP.
> 
> But there is no comment in QBUF and DQBUF part about index.
> So I am confused. If an index isn't needed, how to driver handle it ?

The spec should be fixed. VIDIOC_REQBUFS needs to be called for USERPTR as 
well, and the buffer count is definitely used.

> On Saturday, December 11, 2010 2:10 PM Jonghun Han wrote:
> > 
> > I wonder that a index should be passed on the fly with the VIDIOC_QBUF
> > ioctl in V4L2_MEMORY_USERPTR case.
> > If it isn't needed, should driver return virtual address gotten from
> > application on the fly with the VIDIOC_DQBUF ioctl ?

VIDIOC_DQBUF is supposed to fill the v4l2_buffer structure with the index and 
the userspace virtual address (among other information). If it doesn't, it's a 
driver bug.

-- 
Regards,

Laurent Pinchart
