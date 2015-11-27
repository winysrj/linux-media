Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59311 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbbK0NhJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 08:37:09 -0500
Subject: Re: [PATCH] cx18: Fix VIDIOC_TRY_FMT to fill in sizeimage and
 bytesperline
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
References: <1448388580-22082-1-git-send-email-simon.farnsworth@onelan.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56585C80.2030805@xs4all.nl>
Date: Fri, 27 Nov 2015 14:37:04 +0100
MIME-Version: 1.0
In-Reply-To: <1448388580-22082-1-git-send-email-simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2015 07:09 PM, Simon Farnsworth wrote:
> I was having trouble capturing raw video from GStreamer; turns out that I
> now need VIDIOC_TRY_FMT to fill in sizeimage and bytesperline to make it work.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> ---
> 
> I'm leaving ONELAN on Friday, so this is a drive-by patch being sent for the
> benefit of anyone else trying to use raw capture from a cx18 card. If it's
> not suitable for applying as-is, please feel free to just leave it in the
> archives so that someone else hitting the same problem can find my fix.
> 
>  drivers/media/pci/cx18/cx18-ioctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
> index 55525af..1c9924a 100644
> --- a/drivers/media/pci/cx18/cx18-ioctl.c
> +++ b/drivers/media/pci/cx18/cx18-ioctl.c
> @@ -234,6 +234,13 @@ static int cx18_try_fmt_vid_cap(struct file *file, void *fh,
>  
>  	fmt->fmt.pix.width = w;
>  	fmt->fmt.pix.height = h;
> +	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_HM12) {
> +		fmt->fmt.pix.sizeimage = h * 720 * 3 / 2;
> +		fmt->fmt.pix.bytesperline = 720; /* First plane */
> +	} else {
> +		fmt->fmt.pix.sizeimage = h * 720 * 2;
> +		fmt->fmt.pix.bytesperline = 1440; /* Packed */
> +	}

This isn't correct: for MPEG formats bytesperline should be 0 and sizeimage is fixed
at 128*1024.

I really have no time to make a proper patch, Andy is this something you can look at?

Hmm, ivtv does it a bit better but it will return the wrong sizeimage.

Regards,

	Hans

>  	return 0;
>  }
>  
> 

