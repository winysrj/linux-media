Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58388 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbbIVO6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:58:55 -0400
Subject: Re: [RFC PATCH v5 8/8] media: videobuf2: Move v4l2-specific stuff to
 videobuf2-v4l2
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-9-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56016CA8.3060508@xs4all.nl>
Date: Tue, 22 Sep 2015 16:58:48 +0200
MIME-Version: 1.0
In-Reply-To: <1442928636-3589-9-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

A few small comments...

On 22-09-15 15:30, Junghak Sung wrote:
> Move v4l2-specific stuff from videobu2-core to videobuf2-v4l2
> without doing any functional changes.

I feel the introduction of v4l2_buf_ops falls under functional changes.
Is it possible to do that change in a separate patch before this one?

> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c     | 1872 +-------------------------
>  drivers/media/v4l2-core/videobuf2-internal.h |  161 +++
>  drivers/media/v4l2-core/videobuf2-v4l2.c     | 1678 +++++++++++++++++++++++
>  include/media/videobuf2-core.h               |  118 +-
>  include/media/videobuf2-dvb.h                |    8 +-
>  include/media/videobuf2-v4l2.h               |   96 ++
>  6 files changed, 2009 insertions(+), 1924 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
> 

<snip>

> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 2f2b738..8ca07bb 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> +
> +const struct vb2_buf_ops v4l2_buf_ops = {

Shouldn't this be static?

> +	.fill_user_buffer	= __fill_v4l2_buffer,
> +	.fill_vb2_buffer	= __fill_vb2_buffer,
> +	.set_timestamp		= __set_timestamp,
> +};

Regards,

	Hans
