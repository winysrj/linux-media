Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46013 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1JYILh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 04:11:37 -0400
Received: by ywm3 with SMTP id 3so250003ywm.19
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 01:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA66C5F.8080202@samsung.com>
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
 <4EA66C5F.8080202@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 25 Oct 2011 01:11:17 -0700
Message-ID: <CAMm-=zBt9HufMLpvcDBfD3qS1vL+zwm77APcfVcPQst1zqEyPw@mail.gmail.com>
Subject: Re: [PATCH] media: vb2: reset queued list on REQBUFS(0) call
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Angela Wan <angela.j.wan@gmail.com>, linux-media@vger.kernel.org,
	leiwen@marvell.com, ytang5@marvell.com, qingx@marvell.com,
	jwan@marvell.com, Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 25, 2011 at 00:59, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Queued list was not reset on REQBUFS(0) call. This caused enqueuing
> a freed buffer to the driver.
>
> Reported-by: Angela Wan <angela.j.wan@gmail.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf2-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> index 3015e60..5722b81 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -254,6 +254,7 @@ static void __vb2_queue_free(struct vb2_queue *q)
>
>        q->num_buffers = 0;
>        q->memory = 0;
> +       INIT_LIST_HEAD(&q->queued_list);
>  }
>
>  /**
> --
> 1.7.1
>
>
>

Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
