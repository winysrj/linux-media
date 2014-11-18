Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54778 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaKRKBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 05:01:15 -0500
Received: by mail-lb0-f173.google.com with SMTP id n15so17555102lbi.32
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 02:01:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-12-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-12-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 18 Nov 2014 17:55:28 +0800
Message-ID: <CAMm-=zBDdqKGzKZOLNGOOYbP4bh14GG1C6tCm_pSrqoWrRtOvw@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 11/16] vb2: use dma_map_sg_attrs to prevent
 unnecessary sync
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> By default dma_map_sg syncs the mapped buffer to the device. But
> buf_prepare expects a buffer syncs for the cpu and the buffer
> will be synced to the device in the prepare memop.
>
> The reverse is true for dma_unmap_sg, buf_finish and the finish
> memop.
>
> To prevent unnecessary syncs we ask dma_(un)map_sg to skip the
> sync.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 29 +++++++++++++++++-----
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 33 +++++++++++++++++++++-----
>  2 files changed, 50 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index c4305bf..27f5926 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -317,8 +317,9 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>                 attach->dma_dir = DMA_NONE;
>         }
>
> -       /* mapping to the client with new direction */
> -       ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
> +       /* Mapping to the client with new direction */
> +       ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> +                        dma_dir);

Do we need this chunk?

-- 
Best regards,
Pawel Osciak
