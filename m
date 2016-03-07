Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:47890 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbcCGSIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 13:08:44 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: videobuf2-dma-sg and multiple planes semantics
References: <87y49uuu21.fsf@belgarion.home>
Date: Mon, 07 Mar 2016 19:08:36 +0100
In-Reply-To: <87y49uuu21.fsf@belgarion.home> (Robert Jarzmik's message of
	"Mon, 07 Mar 2016 17:33:26 +0100")
Message-ID: <87twkiupnf.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Hi,
>
> I've been converting pxa_camera driver from videobuf to videobuf2, and I have a
> question about multiple plane semantics.
>
> I have a case where I have 3 planes for a yuv422 capture :
>  - 1 Y plane (total_size / 2 bytes)
>  - 1 U plane (total_size / 4 bytes)
>  - 1 V plane (total_size / 4 bytes)
>
> I would have expected vb2_dma_sg_plane_desc(vb, i) to return me 3 different
> sg_tables, one for each plane. I would have been then able to feed them to 3
> dmaengine channels (this is the case for pxa27x platform), so that the 3 planes
> are filled in concurrently.
>
> My understanding is that videobuf2-dma-sg has only 1 sg_table, which seems to be
> enforced by vb2_dma_sg_cookie(), so the question is : is it on purpose, and how
> do the multiple planes are handled within videobuf2-dma-sg ?

Oh I think I was a bit mislead, because I was looking at it from a userspace
perspective. The in-kernel pxa_camera has 3 different sg_tables all right.

The issue is rather that from userspace, the call to VIDIOC_QUERYBUF, which is
an old userspace program (such as capture_example.c, year 2008 version), returns
only half of the total_size.

Now looking at it more closely, I think this is because :
 - in videobuf2-v4l2.c
 - as my old program doesn't set the V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE bit
 - __fill_v4l2_buffer() returns b->length = vb->planes[0].length

I would have expected to have b->length = sum(vb->planes[i].length).

Could someone explain to me the rationale behind returning only the first plane
length instead of the sum of all planes lengthes ?

Cheers.

-- 
Robert
