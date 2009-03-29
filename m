Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2628 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZC2Wz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 18:55:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: [PATCH v2 1/4] Sensor orientation reporting
Date: Mon, 30 Mar 2009 00:55:02 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu
References: <200903292309.31267.linux@baker-net.org.uk> <200903292317.10249.linux@baker-net.org.uk>
In-Reply-To: <200903292317.10249.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903300055.02723.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 March 2009 00:17:10 Adam Baker wrote:
> Add support to the SQ-905 driver to pass back to user space the
> sensor orientation information obtained from the camera during init.
> Modifies gspca and the videodev2.h header to create the necessary
> API.
>
> Signed-off-by: Adam Baker <linux@baker-net.org.uk>
> ---
> diff -r d8d701594f71 linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Sun Mar 29 08:45:36 2009
> +0200 +++ b/linux/drivers/media/video/gspca/gspca.c	Sun Mar 29 23:00:08
> 2009 +0100 @@ -1147,6 +1147,7 @@
>  	if (input->index != 0)
>  		return -EINVAL;
>  	input->type = V4L2_INPUT_TYPE_CAMERA;
> +	input->status = gspca_dev->cam.input_flags;
>  	strncpy(input->name, gspca_dev->sd_desc->name,
>  		sizeof input->name);
>  	return 0;
> diff -r d8d701594f71 linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Sun Mar 29 08:45:36 2009
> +0200 +++ b/linux/drivers/media/video/gspca/gspca.h	Sun Mar 29 23:00:08
> 2009 +0100 @@ -56,6 +56,7 @@
>  				 * - cannot be > MAX_NURBS
>  				 * - when 0 and bulk_size != 0 means
>  				 *   1 URB and submit done by subdriver */
> +	u32 input_flags;	/* value for ENUM_INPUT status flags */
>  };
>
>  struct gspca_dev;
> diff -r d8d701594f71 linux/drivers/media/video/gspca/sq905.c
> --- a/linux/drivers/media/video/gspca/sq905.c	Sun Mar 29 08:45:36 2009
> +0200 +++ b/linux/drivers/media/video/gspca/sq905.c	Sun Mar 29 23:00:08
> 2009 +0100 @@ -360,6 +360,12 @@
>  	gspca_dev->cam.nmodes = ARRAY_SIZE(sq905_mode);
>  	if (!(ident & SQ905_HIRES_MASK))
>  		gspca_dev->cam.nmodes--;
> +
> +	if (ident & SQ905_ORIENTATION_MASK)
> +		gspca_dev->cam.input_flags = V4L2_IN_ST_VFLIP;
> +	else
> +		gspca_dev->cam.input_flags = V4L2_IN_ST_VFLIP |
> +					     V4L2_IN_ST_HFLIP;
>  	return 0;
>  }
>
> diff -r d8d701594f71 linux/include/linux/videodev2.h
> --- a/linux/include/linux/videodev2.h	Sun Mar 29 08:45:36 2009 +0200
> +++ b/linux/include/linux/videodev2.h	Sun Mar 29 23:00:08 2009 +0100
> @@ -737,6 +737,11 @@
>  #define V4L2_IN_ST_NO_SIGNAL   0x00000002
>  #define V4L2_IN_ST_NO_COLOR    0x00000004
>
> +/* field 'status' - sensor orientation */
> +/* If sensor is mounted upside down set both bits */
> +#define V4L2_IN_ST_HFLIP       0x00000010 /* Output is flipped
> horizontally */
> +#define V4L2_IN_ST_VFLIP       0x00000020 /* Output is flipped
> vertically */ +
>  /* field 'status' - analog */
>  #define V4L2_IN_ST_NO_H_LOCK   0x00000100  /* No horizontal sync lock */
>  #define V4L2_IN_ST_COLOR_KILL  0x00000200  /* Color killer is active */

Hi Adam,

I've only one small comment: the V4L2_IN_ST_H/VFLIP comments talk 
about 'Output' while these flags deal with an input. I know you mean the 
output from the sensor, but the point of view in this API is the 
application, and for the application it is an input.

Other than that I'm happy with it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
