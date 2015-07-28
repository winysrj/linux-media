Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34503 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbbG1ICy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 04:02:54 -0400
Message-ID: <55B73724.4040500@xs4all.nl>
Date: Tue, 28 Jul 2015 10:02:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <kamil@wypas.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] [media] v4l2: export videobuf2 trace points
References: <1438070104-24084-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1438070104-24084-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2015 09:55 AM, Philipp Zabel wrote:
> If videobuf2-core is built as a module, the vb2 trace points must be
> exported from videodev.o to avoid errors when linking videobuf2-core.

I'm no tracepoint expert, so I'll just ask: if the tracepoint functionality
is disabled in the kernel, will this still compile OK?

That is, will the EXPORT_TRACEPOINT_SYMBOL_GPL() code disappear in that
case or will it point to absent code/data?

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 85de455..e8b78ae 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2784,3 +2784,8 @@ long video_ioctl2(struct file *file,
>  	return video_usercopy(file, cmd, arg, __video_do_ioctl);
>  }
>  EXPORT_SYMBOL(video_ioctl2);
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
> 

