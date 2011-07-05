Return-path: <mchehab@localhost>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58223 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1GETHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 15:07:41 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p65J7cfv017263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Jul 2011 14:07:41 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Semwal, Sumit" <sumit.semwal@ti.com>,
	"Nilofer, Samreen" <samreen@ti.com>
Date: Wed, 6 Jul 2011 00:37:37 +0530
Subject: RE: [PATCH 6/6] V4l2: OMAP: VOUT: Minor Cleanup, removing the
 unnecessary code.
Message-ID: <19F8576C6E063C45BE387C64729E739404E3485E6D@dbde02.ent.ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
 <1307458058-29030-7-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-7-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Tuesday, June 07, 2011 8:18 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; Semwal, Sumit; JAIN, AMBER; Nilofer, Samreen
> Subject: [PATCH 6/6] V4l2: OMAP: VOUT: Minor Cleanup, removing the
> unnecessary code.
> 
> Minor changes to remove the unused code from omap_vout driver.
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> Signed-off-by: Samreen <samreen@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 25025a1..4aeea06 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -1090,10 +1090,7 @@ static int vidioc_enum_fmt_vid_out_mplane(struct
> file *file, void *fh,
>  			struct v4l2_fmtdesc *fmt)
>  {
>  	int index = fmt->index;
> -	enum v4l2_buf_type type = fmt->type;
> 
> -	fmt->index = index;
> -	fmt->type = type;
[Hiremath, Vaibhav] These lines are not present in main-line driver? Which baseline have you used for this patch?

Thanks,
Vaibhav

>  	if (index >= NUM_OUTPUT_FORMATS)
>  		return -EINVAL;
> 
> @@ -1268,10 +1265,7 @@ static int vidioc_enum_fmt_vid_overlay(struct file
> *file, void *fh,
>  			struct v4l2_fmtdesc *fmt)
>  {
>  	int index = fmt->index;
> -	enum v4l2_buf_type type = fmt->type;
> 
> -	fmt->index = index;
> -	fmt->type = type;
>  	if (index >= NUM_OUTPUT_FORMATS)
>  		return -EINVAL;
> 
> --
> 1.7.1

