Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:42948 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaKRJlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 04:41:23 -0500
Received: by mail-la0-f41.google.com with SMTP id gf13so7927836lab.0
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 01:41:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-9-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-9-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 18 Nov 2014 17:34:25 +0800
Message-ID: <CAMm-=zC2OSgJoLiELtyqEGzt+LwOLfirvkk9GgE3Q24y2WXafg@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 08/16] vb2-vmalloc: add support for dmabuf exports
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hansverk@cisco.com>
>
> Add support for DMABUF exporting to the vb2-vmalloc implementation.
>
> All memory models now have support for both importing and exporting of DMABUFs.
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-vmalloc.c | 174 ++++++++++++++++++++++++++++
>  1 file changed, 174 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index bba2460..dfbb6d5 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -31,6 +31,9 @@ struct vb2_vmalloc_buf {
>         atomic_t                        refcount;
>         struct vb2_vmarea_handler       handler;
>         struct dma_buf                  *dbuf;
> +
> +       /* DMABUF related */
> +       struct dma_buf_attachment       *db_attach;

Unused?

-- 
Best regards,
Pawel Osciak
