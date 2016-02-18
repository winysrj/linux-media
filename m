Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35706 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbcBRF65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 00:58:57 -0500
Received: by mail-qk0-f175.google.com with SMTP id o6so14946085qkc.2
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 21:58:56 -0800 (PST)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com. [209.85.192.43])
        by smtp.gmail.com with ESMTPSA id o75sm16840875qgd.12.2016.02.17.21.58.55
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 17 Feb 2016 21:58:55 -0800 (PST)
Received: by mail-qg0-f43.google.com with SMTP id b67so29873420qgb.1
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 21:58:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C4A712.4050403@xs4all.nl>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
 <1452533428-12762-5-git-send-email-dianders@chromium.org> <56C4A712.4050403@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 18 Feb 2016 14:58:35 +0900
Message-ID: <CAAFQd5AEKS+Cmett-dHLK6n_BChZ4XhMHLPKScSbjRjQo5F_fQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] videobuf2-dc: Let drivers specify DMA attrs
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Douglas Anderson <dianders@chromium.org>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Feb 18, 2016 at 2:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Doug,
>
> Is there any reason to think that different planes will need different
> DMA attrs? I ask because this patch series of mine:
>
> http://www.spinics.net/lists/linux-media/msg97522.html
>
> does away with allocating allocation contexts (struct vb2_dc_conf).
>
> For dma_attr this would mean that struct dma_attrs would probably be implemented
> as a struct dma_attrs pointer in the vb2_queue struct once I rebase that patch series
> on top of this patch. In other words, the same dma_attrs struct would be used for all
> planes.

I could think of some format consisting of video and metadata planes
(such as V4L2_PIX_FMT_S5C_UYVY_JPG) and some hypothetical hardware,
which generates the metadata in a way that requires patching in
.buf_finish(). In this case, we can allocate video plane without
kernel mapping, but for metadata plane kernel mapping is necessary to
do the patching.

However the above is only a hypothetical "what if" of mine, since
personally I haven't seen such case yet. Our real use case is
allocating raw video planes without kernel mapping, while keeping
kernel mapping available for encoded bitstream, which needs some extra
patching. The reason for disabling kernel mapping is that vmalloc
space can be easily exhausted when processing high resolution video
with long buffer queues (e.g. high resolution H264 decode/encode).

>
> Second question: would specifying dma_attrs also make sense for videobuf2-dma-sg.c?

For our particular use case, probably not, because I don't see kernel
mapping being implicitly created at videobuf2-dma-sg level for
allocated MMAP buffers. AFAICT only if vb2_plane_vaddr() or respective
DMA-BUF op is called then the mapping is created, which is unavoidable
because the caller apparently needs it for something.

Best regards,
Tomasz
