Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:65186 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaBNBfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 20:35:45 -0500
Received: by mail-yh0-f47.google.com with SMTP id c41so10851959yho.20
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 17:35:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392284450-41019-5-git-send-email-hverkuil@xs4all.nl>
References: <1392284450-41019-1-git-send-email-hverkuil@xs4all.nl> <1392284450-41019-5-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 14 Feb 2014 10:35:04 +0900
Message-ID: <CAMm-=zBpboz8eJY=7-2bnnjuBBwRubc3_ixExCWgOZYnJA3K9g@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 04/10] vb2: call buf_finish from __dqbuf
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 13, 2014 at 6:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This ensures that it is also called from queue_cancel, which also calls
> __dqbuf(). Without this change any time queue_cancel is called while
> streaming the buf_finish op will not be called and any driver cleanup
> will not happen.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 1f037de..3756378 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1762,6 +1762,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>         if (vb->state == VB2_BUF_STATE_DEQUEUED)
>                 return;
>
> +       call_vb_qop(vb, buf_finish, vb);
> +
>         vb->state = VB2_BUF_STATE_DEQUEUED;
>
>         /* unmap DMABUF buffer */
> @@ -1787,8 +1789,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>         if (ret < 0)
>                 return ret;
>
> -       call_vb_qop(vb, buf_finish, vb);
> -
>         switch (vb->state) {
>         case VB2_BUF_STATE_DONE:
>                 dprintk(3, "dqbuf: Returning done buffer\n");
> --
> 1.8.4.rc3
>



-- 
Best regards,
Pawel Osciak
