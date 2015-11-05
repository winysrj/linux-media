Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46886 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031125AbbKELOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 06:14:53 -0500
Subject: Re: [RFC PATCH v9 6/6] media: videobuf2: Move vb2_fileio_data and
 vb2_thread to core part
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-7-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563B3A24.5030209@xs4all.nl>
Date: Thu, 5 Nov 2015 12:14:44 +0100
MIME-Version: 1.0
In-Reply-To: <1446545802-28496-7-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/15 11:16, Junghak Sung wrote:
> Move things related with vb2 file I/O and vb2_thread without doing any
> functional changes. After that, videobuf2-internal.h is removed because
> it is not necessary any more.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Nice to see that videobuf2-internal.h has now disappeared!

One note (something for a separate patch):

> ---
>  drivers/media/v4l2-core/videobuf2-core.c     |  777 +++++++++++++++++++++++++-
>  drivers/media/v4l2-core/videobuf2-internal.h |  161 ------
>  drivers/media/v4l2-core/videobuf2-v4l2.c     |  630 +--------------------
>  include/media/videobuf2-core.h               |   43 ++
>  include/media/videobuf2-v4l2.h               |   38 +-
>  5 files changed, 824 insertions(+), 825 deletions(-)
>  delete mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 33bdd81..f62c548 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c

<snip>

> +	q->threadio = NULL;
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(vb2_thread_stop);
> +
>  MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");

This description should be updated as it is no longer a v4l2 framework but a
more generic media framework.

>  MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
>  MODULE_LICENSE("GPL");

Regards,

	Hans
