Return-path: <mchehab@gaivota>
Received: from mailout1.samsung.com ([203.254.224.24]:17500 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0LNKvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 05:51:23 -0500
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDE000FEZHLO990@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 19:51:21 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDE00ACQZHLI5@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 19:51:21 +0900 (KST)
Date: Tue, 14 Dec 2010 19:51:17 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Should a index be passed on the fly with the VIDIOC_QBUF ioctl in
 V4L2_MEMORY_USERPTR case ?
In-reply-to: <AANLkTinzO2BN7AbRgqoKzO7-2ay385CZHAaNGZB2fcKO@mail.gmail.com>
To: linux-media@vger.kernel.org
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>, mchehab@redhat.com
Message-id: <01bb01cb9b7c$d885f9e0$8991eda0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <AANLkTinzO2BN7AbRgqoKzO7-2ay385CZHAaNGZB2fcKO@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Hi,

Any comment for this ?

In my opinion v4l2 spec is not accurate in this topic.
Because VIDIOC_REQBUFS describes count is only used in V4L2_MEMORY_MMAP as
below.
__u32	count	The number of buffers requested or granted. This field is
only used when memory is set to V4L2_MEMORY_MMAP.

But there is no comment in QBUF and DQBUF part about index.
So I am confused. If an index isn't needed, how to driver handle it ?

Best regards,
Jonghun Han,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Jonghun Han
> Sent: Saturday, December 11, 2010 2:10 PM
> To: linux-media@vger.kernel.org
> Subject: Should a index be passed on the fly with the VIDIOC_QBUF ioctl in
> V4L2_MEMORY_USERPTR case ?
> 
> Hi,
> 
> I wonder that a index should be passed on the fly with the VIDIOC_QBUF
> ioctl in V4L2_MEMORY_USERPTR case.
> If it isn't needed, should driver return virtual address gotten from
> application on the fly with the VIDIOC_DQBUF ioctl ?
> 
> Best regards,
> Jonghun Han,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

