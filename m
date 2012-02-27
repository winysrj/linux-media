Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2B0Jyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 04:54:33 -0500
Date: Mon, 27 Feb 2012 10:54:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	mchehab@infradead.org
Subject: Re: [PATCH v2] media: i.MX27 camera: Add resizing support.
In-Reply-To: <1329918701-16329-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1202271032340.32434@axis700.grange>
References: <1329918701-16329-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Wed, 22 Feb 2012, Javier Martin wrote:

> If the attached video sensor cannot provide the
> requested image size, try to use resizing engine
> included in the eMMa-PrP IP.
> 
> This patch supports both averaging and bilinear
> algorithms.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  Changes since v1:
>  - Fix several cosmetic issues.
>  - Don't return -EINVAL if resizing is not possible.
>  - Only allow resizing for YUYV format at the moment.
>  - Simplify some lines of code.
> 
> ---
>  drivers/media/video/mx2_camera.c |  256 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 252 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index fcb6b3f..453ad4c 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c

[snip]

> @@ -1059,6 +1154,119 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
>  	return formats;
>  }
>  
> +static int mx2_emmaprp_resize(struct mx2_camera_dev *pcdev,
> +			      struct v4l2_mbus_framefmt *mf_in,
> +			      struct v4l2_pix_format *pix_out)
> +{
> +	int num, den;
> +	unsigned long m;
> +	int i, dir;
> +
> +	for (dir = RESIZE_DIR_H; dir <= RESIZE_DIR_V; dir++) {
> +		unsigned char *s = pcdev->resizing[dir].s;
> +		int len = 0;
> +		int in, out;
> +
> +		if (dir == RESIZE_DIR_H) {
> +			in = mf_in->width;
> +			out = pix_out->width;
> +		} else {
> +			in = mf_in->height;
> +			out = pix_out->height;
> +		}
> +
> +		if (in < out)
> +			return -EINVAL;
> +		else if (in == out)
> +			continue;
> +
> +		/* Calculate ratio */
> +		m = gcd(in, out);
> +		num = in / m;
> +		den = out / m;
> +		if (num > RESIZE_NUM_MAX)
> +			return -EINVAL;
> +
> +		if ((num >= 2 * den) && (den == 1) &&
> +		    (num < 9) && (!(num & 0x01))) {
> +			int sum = 0;
> +			int j;
> +
> +			/* Average scaling for >= 2:1 ratios */
> +			/* Support can be added for num >=9 and odd values */
> +

In this function you modify your controller private data:

> +			pcdev->resizing[dir].algo = RESIZE_ALGO_AVERAGING;
> +			len = num;
> +
> +			for (i = 0; i < (len / 2); i++)
> +				s[i] = 8;
> +
> +			do {
> +				for (i = 0; i < (len / 2); i++) {
> +					s[i] = s[i] >> 1;
> +					sum = 0;
> +					for (j = 0; j < (len / 2); j++)
> +						sum += s[j];
> +					if (sum == 4)
> +						break;
> +				}
> +			} while (sum != 4);
> +
> +			for (i = (len / 2); i < len; i++)
> +				s[i] = s[len - i - 1];
> +
> +			s[len - 1] |= SZ_COEF;
> +		} else {
> +			/* bilinear scaling for < 2:1 ratios */
> +			int v; /* overflow counter */
> +			int coeff, nxt; /* table output */
> +			int in_pos_inc = 2 * den;
> +			int out_pos = num;
> +			int out_pos_inc = 2 * num;
> +			int init_carry = num - den;
> +			int carry = init_carry;
> +

Here too:

> +			pcdev->resizing[dir].algo = RESIZE_ALGO_BILINEAR;
> +			v = den + in_pos_inc;
> +			do {
> +				coeff = v - out_pos;
> +				out_pos += out_pos_inc;
> +				carry += out_pos_inc;
> +				for (nxt = 0; v < out_pos; nxt++) {
> +					v += in_pos_inc;
> +					carry -= in_pos_inc;
> +				}
> +
> +				if (len > RESIZE_NUM_MAX)
> +					return -EINVAL;
> +
> +				coeff = ((coeff << BC_COEF) +
> +					(in_pos_inc >> 1)) / in_pos_inc;
> +
> +				if (coeff >= (SZ_COEF - 1))
> +					coeff--;
> +
> +				coeff |= SZ_COEF;
> +				s[len] = (unsigned char)coeff;
> +				len++;
> +
> +				for (i = 1; i < nxt; i++) {
> +					if (len >= RESIZE_NUM_MAX)
> +						return -EINVAL;
> +					s[len] = 0;
> +					len++;
> +				}
> +			} while (carry != init_carry);
> +		}

And here again:

> +		pcdev->resizing[dir].len = len;
> +		if (dir == RESIZE_DIR_H)
> +			mf_in->width = pix_out->width;
> +		else
> +			mf_in->height = pix_out->height;
> +	}
> +	return 0;
> +}
> +
>  static int mx2_camera_set_fmt(struct soc_camera_device *icd,
>  			       struct v4l2_format *f)
>  {

[snip]

> @@ -1163,6 +1394,20 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>  	if (ret < 0)
>  		return ret;
>  
> +	dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
> +		__func__, pcdev->s_width, pcdev->s_height);
> +
> +	/* If the sensor does not support image size try PrP resizing */

And this is what actually triggered me this time:

> +	pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
> +						   xlate->host_fmt->fourcc);
> +
> +	memset(pcdev->resizing, 0, sizeof(pcdev->resizing));
> +	if ((mf.width != pix->width || mf.height != pix->height) &&
> +		pcdev->emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {

And here too you cann the function, that modifies your persistent data. 
So, I, probably, didn't explain it well: .try_fmt() should not modify any 
your persistent data (used for real tasks, at least). Let's say, a program 
does S_FMT, you decide to use and configure EMMA resizing. For which you 
set .algo and .len resizer configuration members. Then the user does a 
TRY_FMT, you change those values. But the user decided to not use the 
result of that TRY_FMT and continues to STREAMON, hoping to get, what they 
last configured with S_FMT. But your .algo, .len, and now also ->emma_prp, 
have changed. So, your mx2_start_streaming() willconfuse things 
completely.

> +		if (mx2_emmaprp_resize(pcdev, &mf, pix) < 0)
> +			dev_dbg(icd->parent, "%s: can't resize\n", __func__);
> +	}
> +
>  	if (mf.field == V4L2_FIELD_ANY)
>  		mf.field = V4L2_FIELD_NONE;
>  	/*

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
