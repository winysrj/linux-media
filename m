Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37708 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZAUIyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 03:54:08 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "Shah, Hardik" <hardik.shah@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 21 Jan 2009 14:23:39 +0530
Subject: RE: [PATCHv2 3/4] V4L2 New IOCTLs for OMAP V4L2 Display Driver
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F5110096@dbde02.ent.ti.com>
In-Reply-To: <1224841999-24632-1-git-send-email-hardik.shah@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Shah, Hardik
> Sent: Friday, October 24, 2008 3:23 PM
> To: linux-omap@vger.kernel.org; linux-fbdev-devel@lists.sourceforge.net;
> video4linux-list@redhat.com
> Cc: Shah, Hardik
> Subject: [PATCHv2 3/4] V4L2 New IOCTLs for OMAP V4L2 Display Driver
> 
> New IOCTLs added to the V4L2 framework according to the
> comments received from the open source.
> 
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> 		Hari Nagalla <hnagalla@ti.com>
> 		Hardik Shah <hardik.shah@ti.com>
> 		Manjunath Hadli <mrh@ti.com>
> 		R Sivaraj <sivaraj@ti.com>
> 		Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   19 +++++++++++++++++++
>  include/linux/videodev2.h        |   18 +++++++++++++++++-
>  include/media/v4l2-ioctl.h       |    4 ++++
>  3 files changed, 40 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-
> ioctl.c
> index 140ef92..39d1d6d 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -269,6 +269,8 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_G_CHIP_IDENT)]     = "VIDIOC_G_CHIP_IDENT",
>  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
>  #endif
> +	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   = "VIDIOC_S_COLOR_SPACE_CONV",
> +	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]   = "VIDIOC_G_COLOR_SPACE_CONV",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> 
> @@ -1761,6 +1763,23 @@ static int __video_do_ioctl(struct inode *inode, struct
> file *file,
>  		ret = ops->vidioc_s_hw_freq_seek(file, fh, p);
>  		break;
>  	}
> +	/*---------------Color space conversion------------------------------*/
> +	case VIDIOC_S_COLOR_SPACE_CONV:
> +	{
> +		struct v4l2_color_space_conversion *p = arg;
> +		if (!ops->vidioc_s_color_space_conv)
> +			break;
> +		ret = ops->vidioc_s_color_space_conv(file, fh, p);
> +		break;
> +	}
> +	case VIDIOC_G_COLOR_SPACE_CONV:
> +	{
> +		struct v4l2_color_space_conversion *p = arg;
> +		if (!ops->vidioc_g_color_space_conv)
> +			break;
> +		ret = ops->vidioc_g_color_space_conv(file, fh, p);
> +		break;
> +	}
>  	default:
>  	{
>  		if (!ops->vidioc_default)
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 303d93f..3112cc0 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -869,8 +869,10 @@ enum v4l2_power_line_frequency {
>  #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
>  #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
>  #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
> +#define V4L2_CID_ROTATION			(V4L2_CID_BASE+31)
> +#define V4L2_CID_BG_COLOR			(V4L2_CID_BASE+32)
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+33)
> 
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
> @@ -1150,6 +1152,18 @@ struct v4l2_hw_freq_seek {
>  };
> 
>  /*
> + * Color conversion
> + * User needs to pass pointer to color conversion matrix
> + * defined by hardware
> + */
> +struct v4l2_color_space_conversion {
> +	__s32 coefficients[3][3];
> +	__s32 const_factor;
> +	__s32 input_offs[3];
> +	__s32 output_offs[3];
> +};
> +
> +/*
>   *	A U D I O
>   */
>  struct v4l2_audio {
> @@ -1425,6 +1439,8 @@ struct v4l2_chip_ident {
>  #define VIDIOC_G_CHIP_IDENT     _IOWR('V', 81, struct v4l2_chip_ident)
>  #endif
>  #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
> +#define VIDIOC_S_COLOR_SPACE_CONV	 _IOW('V', 83, struct
> v4l2_color_space_conversion)
> +#define VIDIOC_G_COLOR_SPACE_CONV	 _IOR('V', 84, struct
> v4l2_color_space_conversion)
> 
>  #ifdef __OLD_VIDIOC_
>  /* for compatibility, will go away some day */
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index dc64046..62771af 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -240,6 +240,10 @@ struct v4l2_ioctl_ops {
>  	/* For other private ioctls */
>  	int (*vidioc_default)	       (struct file *file, void *fh,
>  					int cmd, void *arg);
> +	int (*vidioc_s_color_space_conv)     (struct file *file, void *fh,
> +					struct v4l2_color_space_conversion *a);
> +	int (*vidioc_g_color_space_conv)     (struct file *file, void *fh,
> +					struct v4l2_color_space_conversion *a);
>  };
> 
> 
> --
> 1.5.6

[Shah, Hardik] 
Hi,
 I had sent the above patch long back. But because of the new DSS library on OMAP and other issues I was not able to follow up on the above patch.  This is discussed in detail in the following thread
http://www.spinics.net/lists/vfl/msg39065.html


Hans/Mauro,
I will refresh the patch against the tip of the tree and resend it.

Thanks and Regards,
Hardik Shahj
