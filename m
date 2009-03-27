Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZC0RcE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 13:32:04 -0400
Date: Fri, 27 Mar 2009 14:31:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-media@vger.kernel.org, kilgota@banach.math.auburn.edu,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC][PATCH 1/2] Sensor orientation reporting
Message-ID: <20090327143154.67102e2f@pedra.chehab.org>
In-Reply-To: <200903152229.48761.linux@baker-net.org.uk>
References: <200903152224.29388.linux@baker-net.org.uk>
	<200903152229.48761.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 22:29:48 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> Add support to the SQ-905 driver to pass back to user space the
> sensor orientation information obtained from the camera during init.
> Modifies gspca and the videodev2.h header to create the necessary
> API.

Please provide also the V4L2 specs change to include those new controls.

> 
> Signed-off-by: Adam Baker <linux@baker-net.org.uk>
> 
> ---
> diff -r 1248509d8bed linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Sat Mar 14 08:44:42 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.c	Sun Mar 15 22:25:34 2009 +0000
> @@ -1147,6 +1147,7 @@ static int vidioc_enum_input(struct file
>  	if (input->index != 0)
>  		return -EINVAL;
>  	input->type = V4L2_INPUT_TYPE_CAMERA;
> +	input->status = gspca_dev->input_flags;
>  	strncpy(input->name, gspca_dev->sd_desc->name,
>  		sizeof input->name);
>  	return 0;
> diff -r 1248509d8bed linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Sat Mar 14 08:44:42 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.h	Sun Mar 15 22:25:34 2009 +0000
> @@ -168,6 +168,7 @@ struct gspca_dev {
>  	__u8 alt;			/* USB alternate setting */
>  	__u8 nbalt;			/* number of USB alternate settings */
>  	u8 bulk;			/* image transfer by 0:isoc / 1:bulk */
> +	u32 input_flags;		/* value for ENUM_INPUT status flags */
>  };
>  
>  int gspca_dev_probe(struct usb_interface *intf,
> diff -r 1248509d8bed linux/drivers/media/video/gspca/sq905.c
> --- a/linux/drivers/media/video/gspca/sq905.c	Sat Mar 14 08:44:42 2009 +0100
> +++ b/linux/drivers/media/video/gspca/sq905.c	Sun Mar 15 22:25:34 2009 +0000
> @@ -357,6 +357,12 @@ static int sd_init(struct gspca_dev *gsp
>  	gspca_dev->cam.nmodes = ARRAY_SIZE(sq905_mode);
>  	if (!(ident & SQ905_HIRES_MASK))
>  		gspca_dev->cam.nmodes--;
> +
> +	if (ident & SQ905_ORIENTATION_MASK)
> +		gspca_dev->input_flags = V4L2_IN_ST_VFLIP;
> +	else
> +		gspca_dev->input_flags = V4L2_IN_ST_VFLIP |
> +					 V4L2_IN_ST_HFLIP;
>  	return 0;
>  }
>  
> diff -r 1248509d8bed linux/include/linux/videodev2.h
> --- a/linux/include/linux/videodev2.h	Sat Mar 14 08:44:42 2009 +0100
> +++ b/linux/include/linux/videodev2.h	Sun Mar 15 22:25:34 2009 +0000
> @@ -736,6 +736,11 @@ struct v4l2_input {
>  #define V4L2_IN_ST_NO_SIGNAL   0x00000002
>  #define V4L2_IN_ST_NO_COLOR    0x00000004
>  
> +/* field 'status' - sensor orientation */
> +/* If sensor is mounted upside down set both bits */
> +#define V4L2_IN_ST_HFLIP       0x00000010 /* Output is flipped horizontally */
> +#define V4L2_IN_ST_VFLIP       0x00000020 /* Output is flipped vertically */
> +
>  /* field 'status' - analog */
>  #define V4L2_IN_ST_NO_H_LOCK   0x00000100  /* No horizontal sync lock */
>  #define V4L2_IN_ST_COLOR_KILL  0x00000200  /* Color killer is active */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
