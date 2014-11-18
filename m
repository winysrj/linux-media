Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34237 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaKRJl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 04:41:26 -0500
Received: by mail-lb0-f177.google.com with SMTP id z12so10431546lbi.22
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 01:41:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415623771-29634-11-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-11-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 18 Nov 2014 17:40:44 +0800
Message-ID: <CAMm-=zD77S8tYgs-y7ShkkvKjXcG4xoNPZZRpJYNjZQauoQ7Jg@mail.gmail.com>
Subject: Re: [RFCv6 PATCH 10/16] vim2m: support expbuf
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
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/platform/vim2m.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 87af47a..1105c11 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -697,6 +697,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
>         .vidioc_querybuf        = v4l2_m2m_ioctl_querybuf,
>         .vidioc_qbuf            = v4l2_m2m_ioctl_qbuf,
>         .vidioc_dqbuf           = v4l2_m2m_ioctl_dqbuf,
> +       .vidioc_expbuf          = v4l2_m2m_ioctl_expbuf,
>
>         .vidioc_streamon        = v4l2_m2m_ioctl_streamon,
>         .vidioc_streamoff       = v4l2_m2m_ioctl_streamoff,
> --
> 2.1.1
>


-- 
Best regards,
Pawel Osciak
