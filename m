Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51825 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbbFKIb1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 04:31:27 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 11 Jun 2015 10:29:52 +0200
Subject: RE: [PATCH] [media] bdisp: remove unused var
Message-ID: <15ED7CB7B68B4D4C96C7D27A1A23941201B9F8D7E0@SAFEX1MAIL2.st.com>
References: <1433950485-12994-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1433950485-12994-1-git-send-email-mchehab@osg.samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Fabien Dessenne <fabien.dessenne@st.com>

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
> Sent: mercredi 10 juin 2015 17:35
> To: Linux Media Mailing List
> Cc: Mauro Carvalho Chehab; Mauro Carvalho Chehab
> Subject: [PATCH] [media] bdisp: remove unused var
> 
> Fix the following warning:
> 
> drivers/media/platform/sti/bdisp/bdisp-v4l2.c: In function
> 'bdisp_register_device':
> drivers/media/platform/sti/bdisp/bdisp-v4l2.c:1024:26: warning: variable
> 'pdev' set but not used [-Wunused-but-set-variable]
>   struct platform_device *pdev;
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> index 9a8405cd5216..9e782ebe18da 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
> @@ -1021,14 +1021,11 @@ static const struct v4l2_ioctl_ops bdisp_ioctl_ops
> = {
> 
>  static int bdisp_register_device(struct bdisp_dev *bdisp)  {
> -	struct platform_device *pdev;
>  	int ret;
> 
>  	if (!bdisp)
>  		return -ENODEV;
> 
> -	pdev = bdisp->pdev;
> -
>  	bdisp->vdev.fops        = &bdisp_fops;
>  	bdisp->vdev.ioctl_ops   = &bdisp_ioctl_ops;
>  	bdisp->vdev.release     = video_device_release_empty;
> --
> 2.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
