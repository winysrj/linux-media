Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:37425 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGInb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 04:43:31 -0400
Received: by mail-yh0-f49.google.com with SMTP id z6so5494774yhz.36
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 01:43:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394486458-9836-9-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-9-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 17:42:50 +0900
Message-ID: <CAMm-=zD3-APQtnS1QFiB3TCCEPWK9jFPyjeEpM-GqV+T9_h8gg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 08/11] vb2: simplify a confusing condition.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 6:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> q->start_streaming_called is always true, so the WARN_ON check against
> it being false can be dropped.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 8984187..2ae316b 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1099,9 +1099,8 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>         if (!q->start_streaming_called) {
>                 if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
>                         state = VB2_BUF_STATE_QUEUED;
> -       } else if (!WARN_ON(!q->start_streaming_called)) {
> -               if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> -                           state != VB2_BUF_STATE_ERROR))
> +       } else if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> +                          state != VB2_BUF_STATE_ERROR)) {
>                         state = VB2_BUF_STATE_ERROR;
>         }
>
> --
> 1.9.0
>



-- 
Best regards,
Pawel Osciak
