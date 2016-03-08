Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38305 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbcCHJjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 04:39:00 -0500
Subject: Re: videobuf2-dma-sg and multiple planes semantics
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Pawel Osciak <pawel@osciak.com>
References: <87y49uuu21.fsf@belgarion.home> <87twkiupnf.fsf@belgarion.home>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56DE9DBD.8010203@xs4all.nl>
Date: Tue, 8 Mar 2016 10:39:09 +0100
MIME-Version: 1.0
In-Reply-To: <87twkiupnf.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On 03/07/16 19:08, Robert Jarzmik wrote:
> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> 
>> Hi,
>>
>> I've been converting pxa_camera driver from videobuf to videobuf2, and I have a
>> question about multiple plane semantics.
>>
>> I have a case where I have 3 planes for a yuv422 capture :
>>  - 1 Y plane (total_size / 2 bytes)
>>  - 1 U plane (total_size / 4 bytes)
>>  - 1 V plane (total_size / 4 bytes)
>>
>> I would have expected vb2_dma_sg_plane_desc(vb, i) to return me 3 different
>> sg_tables, one for each plane. I would have been then able to feed them to 3
>> dmaengine channels (this is the case for pxa27x platform), so that the 3 planes
>> are filled in concurrently.
>>
>> My understanding is that videobuf2-dma-sg has only 1 sg_table, which seems to be
>> enforced by vb2_dma_sg_cookie(), so the question is : is it on purpose, and how
>> do the multiple planes are handled within videobuf2-dma-sg ?
> 
> Oh I think I was a bit mislead, because I was looking at it from a userspace
> perspective. The in-kernel pxa_camera has 3 different sg_tables all right.
> 
> The issue is rather that from userspace, the call to VIDIOC_QUERYBUF, which is
> an old userspace program (such as capture_example.c, year 2008 version), returns
> only half of the total_size.
> 
> Now looking at it more closely, I think this is because :
>  - in videobuf2-v4l2.c
>  - as my old program doesn't set the V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE bit
>  - __fill_v4l2_buffer() returns b->length = vb->planes[0].length
> 
> I would have expected to have b->length = sum(vb->planes[i].length).
> 
> Could someone explain to me the rationale behind returning only the first plane
> length instead of the sum of all planes lengthes ?

I think the cause of your confusion is what 'multi-planar' means in the v4l2 context.
The multi-planar formats are formats that have more than one plane where each plane
can be anywhere in memory. So two or three buffers are allocated separately and
each buffer has its own sglist (setup by vb2).

In the case of PIX_FMT_YUV422P there is only *one* buffer and the planes are laid out in
that single buffer. So from the point of view of v4l2/vb2 this is a single planar
format and you have a single sglist.

You'll have to use sg_split() to split up that single large sglist into three, one for
each channel.

An alternative might be to switch to use V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE and use
V4L2_PIX_FMT_YUV422M instead of PIX_FMT_YUV422P, but that would affect existing
applications that expect single planar formats and I cannot recommend this.

Especially since the sg_split function already exists, so it is not hard to split
the single sglist into three.

Regards,

	Hans
