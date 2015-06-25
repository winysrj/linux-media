Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33834 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbFYOKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 10:10:30 -0400
Received: by lagx9 with SMTP id x9so45830445lag.1
        for <linux-media@vger.kernel.org>; Thu, 25 Jun 2015 07:10:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
Date: Thu, 25 Jun 2015 15:10:28 +0100
Message-ID: <CAP3TMiEByap-vb_1CjEmSYFKwwhVOarccgU+qDj=S8vPWqujDw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] v4l2-mem2mem: set the queue owner field just
 as vb2_ioctl_reqbufs does
From: Kamil Debski <kamil@wypas.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 25 June 2015 at 11:01, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Please add the patch description no matter how simple it is and how
well the subject covers the content of the patch.

Best wishes,
Kamil

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index dc853e5..511caaa 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -357,9 +357,16 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>                      struct v4l2_requestbuffers *reqbufs)
>  {
>         struct vb2_queue *vq;
> +       int ret;
>
>         vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
> -       return vb2_reqbufs(vq, reqbufs);
> +       ret = vb2_reqbufs(vq, reqbufs);
> +       /* If count == 0, then the owner has released all buffers and he
> +          is no longer owner of the queue. Otherwise we have a new owner. */
> +       if (ret == 0)
> +               vq->owner = reqbufs->count ? file->private_data : NULL;
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
>
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
