Return-path: <mchehab@gaivota>
Received: from mailout4.samsung.com ([203.254.224.34]:16409 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0LNLTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 06:19:13 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDF006SB0RZB280@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 20:19:11 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDF0007F0RZ6V@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 20:19:11 +0900 (KST)
Date: Tue, 14 Dec 2010 20:19:06 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Should a index be passed on the fly with the VIDIOC_QBUF ioctl in
 V4L2_MEMORY_USERPTR case ?
In-reply-to: <201012141200.29925.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Message-id: <01bc01cb9b80$bb6eefc0$324ccf40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <AANLkTinzO2BN7AbRgqoKzO7-2ay385CZHAaNGZB2fcKO@mail.gmail.com>
 <01bb01cb9b7c$d885f9e0$8991eda0$%han@samsung.com>
 <201012141200.29925.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Hi Laurent Pinchart,

Thanks you for reply.
It makes sense.

Best regards,
Jonghun Han

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Tuesday, December 14, 2010 8:00 PM
> To: Jonghun Han
> Cc: linux-media@vger.kernel.org; 'Hans Verkuil'; mchehab@redhat.com
> Subject: Re: Should a index be passed on the fly with the VIDIOC_QBUF
ioctl in
> V4L2_MEMORY_USERPTR case ?
> 
> Hi Jonghun,
> 
> On Tuesday 14 December 2010 11:51:17 Jonghun Han wrote:
> > Hi,
> >
> > Any comment for this ?
> >
> > In my opinion v4l2 spec is not accurate in this topic.
> > Because VIDIOC_REQBUFS describes count is only used in
> V4L2_MEMORY_MMAP as
> > below.
> > __u32	count	The number of buffers requested or granted. This
field is
> > only used when memory is set to V4L2_MEMORY_MMAP.
> >
> > But there is no comment in QBUF and DQBUF part about index.
> > So I am confused. If an index isn't needed, how to driver handle it ?
> 
> The spec should be fixed. VIDIOC_REQBUFS needs to be called for USERPTR as
> well, and the buffer count is definitely used.
> 
> > On Saturday, December 11, 2010 2:10 PM Jonghun Han wrote:
> > >
> > > I wonder that a index should be passed on the fly with the VIDIOC_QBUF
> > > ioctl in V4L2_MEMORY_USERPTR case.
> > > If it isn't needed, should driver return virtual address gotten from
> > > application on the fly with the VIDIOC_DQBUF ioctl ?
> 
> VIDIOC_DQBUF is supposed to fill the v4l2_buffer structure with the index
and
> the userspace virtual address (among other information). If it doesn't,
it's a
> driver bug.
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

