Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1754 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2JCGh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 02:37:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: davinci: vpfe: fix build error
Date: Wed, 3 Oct 2012 08:37:14 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	VGER <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1349095968-14257-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349095968-14257-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210030837.14378.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 1 2012 14:52:48 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> recent patch with commit id 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
> which makes vidioc_s_crop const, was causing a following build error.
> 
> vpfe_capture.c: In function 'vpfe_s_crop':
> vpfe_capture.c:1695: error: assignment of read-only location '*crop'
> vpfe_capture.c:1706: warning: passing argument 1 of
> 'ccdc_dev->hw_ops.set_image_window' discards qualifiers from pointer target type
> vpfe_capture.c:1706: note: expected 'struct v4l2_rect *' but argument is of
> type 'const struct v4l2_rect *'
> make[4]: *** [drivers/media/platform/davinci/vpfe_capture.o] Error 1

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/davinci/vpfe_capture.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 48052cb..8be492c 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1669,6 +1669,7 @@ static int vpfe_s_crop(struct file *file, void *priv,
>  			     const struct v4l2_crop *crop)
>  {
>  	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct v4l2_rect rect = crop->c;
>  	int ret = 0;
>  
>  	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_crop\n");
> @@ -1684,7 +1685,7 @@ static int vpfe_s_crop(struct file *file, void *priv,
>  	if (ret)
>  		return ret;
>  
> -	if (crop->c.top < 0 || crop->c.left < 0) {
> +	if (rect.top < 0 || rect.left < 0) {
>  		v4l2_err(&vpfe_dev->v4l2_dev,
>  			"doesn't support negative values for top & left\n");
>  		ret = -EINVAL;
> @@ -1692,26 +1693,26 @@ static int vpfe_s_crop(struct file *file, void *priv,
>  	}
>  
>  	/* adjust the width to 16 pixel boundary */
> -	crop->c.width = ((crop->c.width + 15) & ~0xf);
> +	rect.width = ((rect.width + 15) & ~0xf);
>  
>  	/* make sure parameters are valid */
> -	if ((crop->c.left + crop->c.width >
> +	if ((rect.left + rect.width >
>  		vpfe_dev->std_info.active_pixels) ||
> -	    (crop->c.top + crop->c.height >
> +	    (rect.top + rect.height >
>  		vpfe_dev->std_info.active_lines)) {
>  		v4l2_err(&vpfe_dev->v4l2_dev, "Error in S_CROP params\n");
>  		ret = -EINVAL;
>  		goto unlock_out;
>  	}
> -	ccdc_dev->hw_ops.set_image_window(&crop->c);
> -	vpfe_dev->fmt.fmt.pix.width = crop->c.width;
> -	vpfe_dev->fmt.fmt.pix.height = crop->c.height;
> +	ccdc_dev->hw_ops.set_image_window(&rect);
> +	vpfe_dev->fmt.fmt.pix.width = rect.width;
> +	vpfe_dev->fmt.fmt.pix.height = rect.height;
>  	vpfe_dev->fmt.fmt.pix.bytesperline =
>  		ccdc_dev->hw_ops.get_line_length();
>  	vpfe_dev->fmt.fmt.pix.sizeimage =
>  		vpfe_dev->fmt.fmt.pix.bytesperline *
>  		vpfe_dev->fmt.fmt.pix.height;
> -	vpfe_dev->crop = crop->c;
> +	vpfe_dev->crop = rect;
>  unlock_out:
>  	mutex_unlock(&vpfe_dev->lock);
>  	return ret;
> 
