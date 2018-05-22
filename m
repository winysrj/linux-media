Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:46991 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751172AbeEVL5w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:57:52 -0400
Subject: Re: [PATCH v10 09/16] cobalt: add .is_unordered() for cobalt
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
 <20180521165946.11778-10-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <27bdf91f-920c-a5b6-1114-42996fff9813@xs4all.nl>
Date: Tue, 22 May 2018 13:57:50 +0200
MIME-Version: 1.0
In-Reply-To: <20180521165946.11778-10-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/05/18 18:59, Ezequiel Garcia wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> The cobalt driver may reorder the capture buffers so we need to report
> it as such.
> 
> v3: set formats as unordered
> v2: use vb2_ops_set_unordered() helper
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/pci/cobalt/cobalt-v4l2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
> index e2a4c705d353..ccca1a96df90 100644
> --- a/drivers/media/pci/cobalt/cobalt-v4l2.c
> +++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
> @@ -430,6 +430,7 @@ static const struct vb2_ops cobalt_qops = {
>  	.stop_streaming = cobalt_stop_streaming,
>  	.wait_prepare = vb2_ops_wait_prepare,
>  	.wait_finish = vb2_ops_wait_finish,
> +	.is_unordered = vb2_ops_is_unordered,
>  };
>  
>  /* V4L2 ioctls */
> @@ -695,14 +696,17 @@ static int cobalt_enum_fmt_vid_cap(struct file *file, void *priv_fh,
>  	case 0:
>  		strlcpy(f->description, "YUV 4:2:2", sizeof(f->description));
>  		f->pixelformat = V4L2_PIX_FMT_YUYV;
> +		f->flags |= V4L2_FMT_FLAG_UNORDERED;
>  		break;
>  	case 1:
>  		strlcpy(f->description, "RGB24", sizeof(f->description));
>  		f->pixelformat = V4L2_PIX_FMT_RGB24;
> +		f->flags |= V4L2_FMT_FLAG_UNORDERED;
>  		break;
>  	case 2:
>  		strlcpy(f->description, "RGB32", sizeof(f->description));
>  		f->pixelformat = V4L2_PIX_FMT_BGR32;
> +		f->flags |= V4L2_FMT_FLAG_UNORDERED;

Rather than adding this for every case, just move it out of the switch and
set it just before the 'return 0'.

Regards,

	Hans

>  		break;
>  	default:
>  		return -EINVAL;
> 
