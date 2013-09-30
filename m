Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2296 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3I3MaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 08:30:05 -0400
Message-ID: <52496E9E.6080500@xs4all.nl>
Date: Mon, 30 Sep 2013 14:29:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] stk1135: fix two warnings added by changeset
 76e0598
References: <1380192149-27995-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1380192149-27995-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2013 12:42 PM, Mauro Carvalho Chehab wrote:
> drivers/media/usb/gspca/stk1135.c:615:6: warning: no previous prototype for 'stk1135_try_fmt' [-Wmissing-prototypes]
>  void stk1135_try_fmt(struct gspca_dev *gspca_dev, struct v4l2_format *fmt)
>       ^
> drivers/media/usb/gspca/stk1135.c:627:5: warning: no previous prototype for 'stk1135_enum_framesizes' [-Wmissing-prototypes]
>  int stk1135_enum_framesizes(struct gspca_dev *gspca_dev,
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/gspca/stk1135.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
> index 8add2f7..1fc80af 100644
> --- a/drivers/media/usb/gspca/stk1135.c
> +++ b/drivers/media/usb/gspca/stk1135.c
> @@ -612,7 +612,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
>  	return 0;
>  }
>  
> -void stk1135_try_fmt(struct gspca_dev *gspca_dev, struct v4l2_format *fmt)
> +static void stk1135_try_fmt(struct gspca_dev *gspca_dev, struct v4l2_format *fmt)
>  {
>  	fmt->fmt.pix.width = clamp(fmt->fmt.pix.width, 32U, 1280U);
>  	fmt->fmt.pix.height = clamp(fmt->fmt.pix.height, 32U, 1024U);
> @@ -624,7 +624,7 @@ void stk1135_try_fmt(struct gspca_dev *gspca_dev, struct v4l2_format *fmt)
>  	fmt->fmt.pix.sizeimage = fmt->fmt.pix.width * fmt->fmt.pix.height;
>  }
>  
> -int stk1135_enum_framesizes(struct gspca_dev *gspca_dev,
> +static int stk1135_enum_framesizes(struct gspca_dev *gspca_dev,
>  			struct v4l2_frmsizeenum *fsize)
>  {
>  	if (fsize->index != 0 || fsize->pixel_format != V4L2_PIX_FMT_SBGGR8)
> 

