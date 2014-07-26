Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2193 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZPN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 11:13:26 -0400
Message-ID: <53D3C578.8000802@xs4all.nl>
Date: Sat, 26 Jul 2014 17:12:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>,
	linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 2/3] [media] coda: fix coda_g_selection
References: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com> <1406385272-425-2-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1406385272-425-2-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/26/2014 04:34 PM, Philipp Zabel wrote:
> Crop targets are valid on the capture side and compose targets are valid
> on the output side, not the other way around.

Are you sure about this? Usually for m2m devices the capture side supports
compose (i.e. the result of the m2m operation can be composed into the capture
buffer) and the output side supports crop (i.e. the m2m operates on the cropped
part of the output buffer instead of on the full buffer), like the coda driver
does today.

As a result of that the old G/S_CROP API cannot be used with most m2m devices
since it does the opposite operation, which does not apply to m2m devices.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/media/platform/coda/coda-common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 95d0b04..b542340 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -600,7 +600,7 @@ static int coda_g_selection(struct file *file, void *fh,
>  		rsel = &r;
>  		/* fallthrough */
>  	case V4L2_SEL_TGT_CROP:
> -		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  			return -EINVAL;
>  		break;
>  	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> @@ -609,7 +609,7 @@ static int coda_g_selection(struct file *file, void *fh,
>  		/* fallthrough */
>  	case V4L2_SEL_TGT_COMPOSE:
>  	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> -		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  			return -EINVAL;
>  		break;
>  	default:
> 

