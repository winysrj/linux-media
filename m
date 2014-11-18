Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43235 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaKRJpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 04:45:03 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so19011606lbj.23
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 01:45:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-10-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-10-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 18 Nov 2014 17:38:22 +0800
Message-ID: <CAMm-=zDy+yRYrGT+WYaVRxSjt9vFDnZ9aF2P=4qdYLTrr1Y=eg@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 09/16] vivid: enable vb2_expbuf support.
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
> Now that vb2 supports DMABUF export for dma-sg and vmalloc memory
> modes, we can enable the vb2_expbuf support in vivid.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/platform/vivid/vivid-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 2c61a62..7de8d9d 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -588,7 +588,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
>         .vidioc_querybuf                = vb2_ioctl_querybuf,
>         .vidioc_qbuf                    = vb2_ioctl_qbuf,
>         .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
> -/* Not yet     .vidioc_expbuf          = vb2_ioctl_expbuf,*/
> +       .vidioc_expbuf                  = vb2_ioctl_expbuf,
>         .vidioc_streamon                = vb2_ioctl_streamon,
>         .vidioc_streamoff               = vb2_ioctl_streamoff,
>
> --
> 2.1.1
>


-- 
Best regards,
Pawel Osciak
