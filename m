Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1148 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3HBN00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 09:26:26 -0400
Message-ID: <51FBB379.4060108@xs4all.nl>
Date: Fri, 02 Aug 2013 15:26:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [RFC PATCH 7/8] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl> <1375101661-6493-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-8-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prabhakar,

Can you please double check this patch? I'd like to have your Acked-by before I
commit it.

Thanks!

	Hans

On 07/29/2013 02:41 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Use the new blanking and frame size defines. This also fixed a bug in
> these drivers: they assumed that the height for interlaced formats was
> the field height, however height is the frame height. So the height
> for a field is actually bt->height / 2.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 10 ++--------
>  drivers/media/platform/davinci/vpif_display.c | 10 ++--------
>  2 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index b11d7a7..e1b6a3b 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1799,19 +1799,15 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  
>  	/* Configure video port timings */
>  
> -	std_info->eav2sav = bt->hbackporch + bt->hfrontporch +
> -		bt->hsync - 8;
> +	std_info->eav2sav = V4L2_DV_BT_BLANKING_WIDTH(bt) - 8;
>  	std_info->sav2eav = bt->width;
>  
>  	std_info->l1 = 1;
>  	std_info->l3 = bt->vsync + bt->vbackporch + 1;
>  
> +	std_info->vsize = V4L2_DV_BT_FRAME_HEIGHT(bt);
>  	if (bt->interlaced) {
>  		if (bt->il_vbackporch || bt->il_vfrontporch || bt->il_vsync) {
> -			std_info->vsize = bt->height * 2 +
> -				bt->vfrontporch + bt->vsync + bt->vbackporch +
> -				bt->il_vfrontporch + bt->il_vsync +
> -				bt->il_vbackporch;
>  			std_info->l5 = std_info->vsize/2 -
>  				(bt->vfrontporch - 1);
>  			std_info->l7 = std_info->vsize/2 + 1;
> @@ -1825,8 +1821,6 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  			return -EINVAL;
>  		}
>  	} else {
> -		std_info->vsize = bt->height + bt->vfrontporch +
> -			bt->vsync + bt->vbackporch;
>  		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
>  	}
>  	strncpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index c2ff067..a42e43c 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1436,19 +1436,15 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  
>  	/* Configure video port timings */
>  
> -	std_info->eav2sav = bt->hbackporch + bt->hfrontporch +
> -		bt->hsync - 8;
> +	std_info->eav2sav = V4L2_DV_BT_BLANKING_WIDTH(bt) - 8;
>  	std_info->sav2eav = bt->width;
>  
>  	std_info->l1 = 1;
>  	std_info->l3 = bt->vsync + bt->vbackporch + 1;
>  
> +	std_info->vsize = V4L2_DV_BT_FRAME_HEIGHT(bt);
>  	if (bt->interlaced) {
>  		if (bt->il_vbackporch || bt->il_vfrontporch || bt->il_vsync) {
> -			std_info->vsize = bt->height * 2 +
> -				bt->vfrontporch + bt->vsync + bt->vbackporch +
> -				bt->il_vfrontporch + bt->il_vsync +
> -				bt->il_vbackporch;
>  			std_info->l5 = std_info->vsize/2 -
>  				(bt->vfrontporch - 1);
>  			std_info->l7 = std_info->vsize/2 + 1;
> @@ -1462,8 +1458,6 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  			return -EINVAL;
>  		}
>  	} else {
> -		std_info->vsize = bt->height + bt->vfrontporch +
> -			bt->vsync + bt->vbackporch;
>  		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
>  	}
>  	strncpy(std_info->name, "Custom timings BT656/1120",
> 
