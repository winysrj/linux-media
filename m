Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab3IILnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 07:43:07 -0400
Message-ID: <522DB442.3070005@redhat.com>
Date: Mon, 09 Sep 2013 13:42:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] gspca: store current mode instead of individual parameters
References: <1377896065-29392-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1377896065-29392-1-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks! I've added these to my gspca tree for 3.13, and send a pull-request
with these for 3.13 to Mauro.

Regards,

Hans


On 08/30/2013 10:54 PM, Ondrej Zary wrote:
> Store complete current mode (struct v4l2_pix_format) in struct gspca_dev
> instead of separate pixfmt, width and height parameters.
>
> This is a preparation for variable resolution support.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>   drivers/media/usb/gspca/conex.c                  |    3 +-
>   drivers/media/usb/gspca/cpia1.c                  |    4 +-
>   drivers/media/usb/gspca/gspca.c                  |   30 +++++--------
>   drivers/media/usb/gspca/gspca.h                  |    4 +-
>   drivers/media/usb/gspca/jeilinj.c                |    5 +-
>   drivers/media/usb/gspca/jl2005bcd.c              |    2 +-
>   drivers/media/usb/gspca/m5602/m5602_mt9m111.c    |    2 +-
>   drivers/media/usb/gspca/mars.c                   |    7 ++-
>   drivers/media/usb/gspca/mr97310a.c               |    6 +-
>   drivers/media/usb/gspca/nw80x.c                  |   11 +++--
>   drivers/media/usb/gspca/ov519.c                  |   51 ++++++++++++----------
>   drivers/media/usb/gspca/ov534.c                  |    5 +-
>   drivers/media/usb/gspca/pac207.c                 |    4 +-
>   drivers/media/usb/gspca/pac7311.c                |    6 +-
>   drivers/media/usb/gspca/se401.c                  |    6 +-
>   drivers/media/usb/gspca/sn9c20x.c                |    6 +-
>   drivers/media/usb/gspca/sonixb.c                 |    2 +-
>   drivers/media/usb/gspca/sonixj.c                 |    3 +-
>   drivers/media/usb/gspca/spca1528.c               |    3 +-
>   drivers/media/usb/gspca/spca500.c                |    3 +-
>   drivers/media/usb/gspca/sq905c.c                 |    2 +-
>   drivers/media/usb/gspca/sq930x.c                 |    3 +-
>   drivers/media/usb/gspca/stk014.c                 |    5 +-
>   drivers/media/usb/gspca/stk1135.c                |    8 ++--
>   drivers/media/usb/gspca/stv06xx/stv06xx.c        |    2 +-
>   drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |    2 +-
>   drivers/media/usb/gspca/sunplus.c                |    3 +-
>   drivers/media/usb/gspca/topro.c                  |   13 +++---
>   drivers/media/usb/gspca/tv8532.c                 |    7 ++-
>   drivers/media/usb/gspca/vicam.c                  |    8 ++--
>   drivers/media/usb/gspca/w996Xcf.c                |   28 ++++++------
>   drivers/media/usb/gspca/xirlink_cit.c            |   34 +++++++-------
>   drivers/media/usb/gspca/zc3xx.c                  |    3 +-
>   33 files changed, 145 insertions(+), 136 deletions(-)
>
> diff --git a/drivers/media/usb/gspca/conex.c b/drivers/media/usb/gspca/conex.c
> index 38714df..2e15c80 100644
> --- a/drivers/media/usb/gspca/conex.c
> +++ b/drivers/media/usb/gspca/conex.c
> @@ -783,7 +783,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	struct sd *sd = (struct sd *) gspca_dev;
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x22);		/* JPEG 411 */
>   	jpeg_set_qual(sd->jpeg_hdr, QUALITY);
>
> diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
> index 064b530..f23df4a 100644
> --- a/drivers/media/usb/gspca/cpia1.c
> +++ b/drivers/media/usb/gspca/cpia1.c
> @@ -1553,9 +1553,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   		sd->params.format.videoSize = VIDEOSIZE_CIF;
>
>   	sd->params.roi.colEnd = sd->params.roi.colStart +
> -				(gspca_dev->width >> 3);
> +				(gspca_dev->pixfmt.width >> 3);
>   	sd->params.roi.rowEnd = sd->params.roi.rowStart +
> -				(gspca_dev->height >> 2);
> +				(gspca_dev->pixfmt.height >> 2);
>
>   	/* And now set the camera to a known state */
>   	ret = do_command(gspca_dev, CPIA_COMMAND_SetGrabMode,
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index b7ae872..9ffcce6 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -504,8 +504,7 @@ static int frame_alloc(struct gspca_dev *gspca_dev, struct file *file,
>   	unsigned int frsz;
>   	int i;
>
> -	i = gspca_dev->curr_mode;
> -	frsz = gspca_dev->cam.cam_mode[i].sizeimage;
> +	frsz = gspca_dev->pixfmt.sizeimage;
>   	PDEBUG(D_STREAM, "frame alloc frsz: %d", frsz);
>   	frsz = PAGE_ALIGN(frsz);
>   	if (count >= GSPCA_MAX_FRAMES)
> @@ -627,16 +626,14 @@ static struct usb_host_endpoint *alt_xfer(struct usb_host_interface *alt,
>   static u32 which_bandwidth(struct gspca_dev *gspca_dev)
>   {
>   	u32 bandwidth;
> -	int i;
>
>   	/* get the (max) image size */
> -	i = gspca_dev->curr_mode;
> -	bandwidth = gspca_dev->cam.cam_mode[i].sizeimage;
> +	bandwidth = gspca_dev->pixfmt.sizeimage;
>
>   	/* if the image is compressed, estimate its mean size */
>   	if (!gspca_dev->cam.needs_full_bandwidth &&
> -	    bandwidth < gspca_dev->cam.cam_mode[i].width *
> -				gspca_dev->cam.cam_mode[i].height)
> +	    bandwidth < gspca_dev->pixfmt.width *
> +				gspca_dev->pixfmt.height)
>   		bandwidth = bandwidth * 3 / 8;	/* 0.375 */
>
>   	/* estimate the frame rate */
> @@ -650,7 +647,7 @@ static u32 which_bandwidth(struct gspca_dev *gspca_dev)
>
>   		/* don't hope more than 15 fps with USB 1.1 and
>   		 * image resolution >= 640x480 */
> -		if (gspca_dev->width >= 640
> +		if (gspca_dev->pixfmt.width >= 640
>   		 && gspca_dev->dev->speed == USB_SPEED_FULL)
>   			bandwidth *= 15;		/* 15 fps */
>   		else
> @@ -982,9 +979,7 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
>
>   	i = gspca_dev->cam.nmodes - 1;	/* take the highest mode */
>   	gspca_dev->curr_mode = i;
> -	gspca_dev->width = gspca_dev->cam.cam_mode[i].width;
> -	gspca_dev->height = gspca_dev->cam.cam_mode[i].height;
> -	gspca_dev->pixfmt = gspca_dev->cam.cam_mode[i].pixelformat;
> +	gspca_dev->pixfmt = gspca_dev->cam.cam_mode[i];
>
>   	/* does nothing if ctrl_handler == NULL */
>   	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
> @@ -1105,10 +1100,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>   			    struct v4l2_format *fmt)
>   {
>   	struct gspca_dev *gspca_dev = video_drvdata(file);
> -	int mode;
>
> -	mode = gspca_dev->curr_mode;
> -	fmt->fmt.pix = gspca_dev->cam.cam_mode[mode];
> +	fmt->fmt.pix = gspca_dev->pixfmt;
>   	/* some drivers use priv internally, zero it before giving it to
>   	   userspace */
>   	fmt->fmt.pix.priv = 0;
> @@ -1187,10 +1180,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>   		ret = -EBUSY;
>   		goto out;
>   	}
> -	gspca_dev->width = fmt->fmt.pix.width;
> -	gspca_dev->height = fmt->fmt.pix.height;
> -	gspca_dev->pixfmt = fmt->fmt.pix.pixelformat;
>   	gspca_dev->curr_mode = ret;
> +	gspca_dev->pixfmt = gspca_dev->cam.cam_mode[ret];
>
>   	ret = 0;
>   out:
> @@ -1467,8 +1458,9 @@ static int vidioc_streamon(struct file *file, void *priv,
>   		if (ret < 0)
>   			goto out;
>   	}
> -	PDEBUG_MODE(gspca_dev, D_STREAM, "stream on OK", gspca_dev->pixfmt,
> -		    gspca_dev->width, gspca_dev->height);
> +	PDEBUG_MODE(gspca_dev, D_STREAM, "stream on OK",
> +		    gspca_dev->pixfmt.pixelformat,
> +		    gspca_dev->pixfmt.width, gspca_dev->pixfmt.height);
>   	ret = 0;
>   out:
>   	mutex_unlock(&gspca_dev->queue_lock);
> diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
> index ac0b11f..0f3d150 100644
> --- a/drivers/media/usb/gspca/gspca.h
> +++ b/drivers/media/usb/gspca/gspca.h
> @@ -183,9 +183,7 @@ struct gspca_dev {
>   	__u8 streaming;			/* protected by both mutexes (*) */
>
>   	__u8 curr_mode;			/* current camera mode */
> -	__u32 pixfmt;			/* current mode parameters */
> -	__u16 width;
> -	__u16 height;
> +	struct v4l2_pix_format pixfmt;	/* current mode parameters */
>   	__u32 sequence;			/* frame sequence number */
>
>   	wait_queue_head_t wq;		/* wait queue */
> diff --git a/drivers/media/usb/gspca/jeilinj.c b/drivers/media/usb/gspca/jeilinj.c
> index 8da3dde..19736e2 100644
> --- a/drivers/media/usb/gspca/jeilinj.c
> +++ b/drivers/media/usb/gspca/jeilinj.c
> @@ -378,11 +378,12 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	struct sd *dev = (struct sd *) gspca_dev;
>
>   	/* create the JPEG header */
> -	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(dev->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x21);          /* JPEG 422 */
>   	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
>   	PDEBUG(D_STREAM, "Start streaming at %dx%d",
> -		gspca_dev->height, gspca_dev->width);
> +		gspca_dev->pixfmt.height, gspca_dev->pixfmt.width);
>   	jlj_start(gspca_dev);
>   	return gspca_dev->usb_err;
>   }
> diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
> index fdaeeb1..5b481fa 100644
> --- a/drivers/media/usb/gspca/jl2005bcd.c
> +++ b/drivers/media/usb/gspca/jl2005bcd.c
> @@ -455,7 +455,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	struct sd *sd = (struct sd *) gspca_dev;
>   	sd->cap_mode = gspca_dev->cam.cam_mode;
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 640:
>   		PDEBUG(D_STREAM, "Start streaming at vga resolution");
>   		jl2005c_stream_start_vga_lg(gspca_dev);
> diff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
> index cfa4663..27fcef1 100644
> --- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
> +++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
> @@ -266,7 +266,7 @@ static int mt9m111_set_hvflip(struct gspca_dev *gspca_dev)
>   		return err;
>
>   	data[0] = MT9M111_RMB_OVER_SIZED;
> -	if (gspca_dev->width == 640) {
> +	if (gspca_dev->pixfmt.width == 640) {
>   		data[1] = MT9M111_RMB_ROW_SKIP_2X |
>   			  MT9M111_RMB_COLUMN_SKIP_2X |
>   			  (hflip << 1) | vflip;
> diff --git a/drivers/media/usb/gspca/mars.c b/drivers/media/usb/gspca/mars.c
> index ff2c5ab..779a878 100644
> --- a/drivers/media/usb/gspca/mars.c
> +++ b/drivers/media/usb/gspca/mars.c
> @@ -254,7 +254,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	int i;
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x21);		/* JPEG 422 */
>   	jpeg_set_qual(sd->jpeg_hdr, QUALITY);
>
> @@ -270,8 +271,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	data[0] = 0x00;		/* address */
>   	data[1] = 0x0c | 0x01;	/* reg 0 */
>   	data[2] = 0x01;		/* reg 1 */
> -	data[3] = gspca_dev->width / 8;		/* h_size , reg 2 */
> -	data[4] = gspca_dev->height / 8;	/* v_size , reg 3 */
> +	data[3] = gspca_dev->pixfmt.width / 8;	/* h_size , reg 2 */
> +	data[4] = gspca_dev->pixfmt.height / 8;	/* v_size , reg 3 */
>   	data[5] = 0x30;		/* reg 4, MI, PAS5101 :
>   				 *	0x30 for 24mhz , 0x28 for 12mhz */
>   	data[6] = 0x02;		/* reg 5, H start - was 0x04 */
> diff --git a/drivers/media/usb/gspca/mr97310a.c b/drivers/media/usb/gspca/mr97310a.c
> index 68bb2f3..f006e29 100644
> --- a/drivers/media/usb/gspca/mr97310a.c
> +++ b/drivers/media/usb/gspca/mr97310a.c
> @@ -521,7 +521,7 @@ static int start_cif_cam(struct gspca_dev *gspca_dev)
>   	if (sd->sensor_type)
>   		data[5] = 0xbb;
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160:
>   		data[9] |= 0x04;  /* reg 8, 2:1 scale down from 320 */
>   		/* fall thru */
> @@ -618,7 +618,7 @@ static int start_vga_cam(struct gspca_dev *gspca_dev)
>   		data[10] = 0x18;
>   	}
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160:
>   		data[9] |= 0x0c;  /* reg 8, 4:1 scale down */
>   		/* fall thru */
> @@ -847,7 +847,7 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 expo, s32 min_clockdiv)
>   		u8 clockdiv = (60 * expo + 7999) / 8000;
>
>   		/* Limit framerate to not exceed usb bandwidth */
> -		if (clockdiv < min_clockdiv && gspca_dev->width >= 320)
> +		if (clockdiv < min_clockdiv && gspca_dev->pixfmt.width >= 320)
>   			clockdiv = min_clockdiv;
>   		else if (clockdiv < 2)
>   			clockdiv = 2;
> diff --git a/drivers/media/usb/gspca/nw80x.c b/drivers/media/usb/gspca/nw80x.c
> index 44c9964..599f755 100644
> --- a/drivers/media/usb/gspca/nw80x.c
> +++ b/drivers/media/usb/gspca/nw80x.c
> @@ -1708,7 +1708,7 @@ static void setautogain(struct gspca_dev *gspca_dev, s32 val)
>
>   	reg_r(gspca_dev, 0x1004, 1);
>   	if (gspca_dev->usb_buf[0] & 0x04) {	/* if AE_FULL_FRM */
> -		sd->ae_res = gspca_dev->width * gspca_dev->height;
> +		sd->ae_res = gspca_dev->pixfmt.width * gspca_dev->pixfmt.height;
>   	} else {				/* get the AE window size */
>   		reg_r(gspca_dev, 0x1011, 8);
>   		w = (gspca_dev->usb_buf[1] << 8) + gspca_dev->usb_buf[0]
> @@ -1717,7 +1717,8 @@ static void setautogain(struct gspca_dev *gspca_dev, s32 val)
>   		  - (gspca_dev->usb_buf[7] << 8) - gspca_dev->usb_buf[6];
>   		sd->ae_res = h * w;
>   		if (sd->ae_res == 0)
> -			sd->ae_res = gspca_dev->width * gspca_dev->height;
> +			sd->ae_res = gspca_dev->pixfmt.width *
> +					gspca_dev->pixfmt.height;
>   	}
>   }
>
> @@ -1856,21 +1857,21 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	reg_w_buf(gspca_dev, cmd);
>   	switch (sd->webcam) {
>   	case P35u:
> -		if (gspca_dev->width == 320)
> +		if (gspca_dev->pixfmt.width == 320)
>   			reg_w_buf(gspca_dev, nw801_start_qvga);
>   		else
>   			reg_w_buf(gspca_dev, nw801_start_vga);
>   		reg_w_buf(gspca_dev, nw801_start_2);
>   		break;
>   	case Kr651us:
> -		if (gspca_dev->width == 320)
> +		if (gspca_dev->pixfmt.width == 320)
>   			reg_w_buf(gspca_dev, kr651_start_qvga);
>   		else
>   			reg_w_buf(gspca_dev, kr651_start_vga);
>   		reg_w_buf(gspca_dev, kr651_start_2);
>   		break;
>   	case Proscope:
> -		if (gspca_dev->width == 320)
> +		if (gspca_dev->pixfmt.width == 320)
>   			reg_w_buf(gspca_dev, proscope_start_qvga);
>   		else
>   			reg_w_buf(gspca_dev, proscope_start_vga);
> diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
> index a3958ee..bdfc49f 100644
> --- a/drivers/media/usb/gspca/ov519.c
> +++ b/drivers/media/usb/gspca/ov519.c
> @@ -3466,7 +3466,7 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
>
>   	switch (sd->bridge) {
>   	case BRIDGE_OVFX2:
> -		if (gspca_dev->width != 800)
> +		if (gspca_dev->pixfmt.width != 800)
>   			gspca_dev->cam.bulk_size = OVFX2_BULK_SIZE;
>   		else
>   			gspca_dev->cam.bulk_size = 7 * 4096;
> @@ -3505,8 +3505,8 @@ static void ov511_mode_init_regs(struct sd *sd)
>   	/* Here I'm assuming that snapshot size == image size.
>   	 * I hope that's always true. --claudio
>   	 */
> -	hsegs = (sd->gspca_dev.width >> 3) - 1;
> -	vsegs = (sd->gspca_dev.height >> 3) - 1;
> +	hsegs = (sd->gspca_dev.pixfmt.width >> 3) - 1;
> +	vsegs = (sd->gspca_dev.pixfmt.height >> 3) - 1;
>
>   	reg_w(sd, R511_CAM_PXCNT, hsegs);
>   	reg_w(sd, R511_CAM_LNCNT, vsegs);
> @@ -3539,7 +3539,7 @@ static void ov511_mode_init_regs(struct sd *sd)
>   	case SEN_OV7640:
>   	case SEN_OV7648:
>   	case SEN_OV76BE:
> -		if (sd->gspca_dev.width == 320)
> +		if (sd->gspca_dev.pixfmt.width == 320)
>   			interlaced = 1;
>   		/* Fall through */
>   	case SEN_OV6630:
> @@ -3549,7 +3549,7 @@ static void ov511_mode_init_regs(struct sd *sd)
>   		case 30:
>   		case 25:
>   			/* Not enough bandwidth to do 640x480 @ 30 fps */
> -			if (sd->gspca_dev.width != 640) {
> +			if (sd->gspca_dev.pixfmt.width != 640) {
>   				sd->clockdiv = 0;
>   				break;
>   			}
> @@ -3582,7 +3582,8 @@ static void ov511_mode_init_regs(struct sd *sd)
>
>   	/* Check if we have enough bandwidth to disable compression */
>   	fps = (interlaced ? 60 : 30) / (sd->clockdiv + 1) + 1;
> -	needed = fps * sd->gspca_dev.width * sd->gspca_dev.height * 3 / 2;
> +	needed = fps * sd->gspca_dev.pixfmt.width *
> +			sd->gspca_dev.pixfmt.height * 3 / 2;
>   	/* 1000 isoc packets/sec */
>   	if (needed > 1000 * packet_size) {
>   		/* Enable Y and UV quantization and compression */
> @@ -3644,8 +3645,8 @@ static void ov518_mode_init_regs(struct sd *sd)
>   		reg_w(sd, 0x38, 0x80);
>   	}
>
> -	hsegs = sd->gspca_dev.width / 16;
> -	vsegs = sd->gspca_dev.height / 4;
> +	hsegs = sd->gspca_dev.pixfmt.width / 16;
> +	vsegs = sd->gspca_dev.pixfmt.height / 4;
>
>   	reg_w(sd, 0x29, hsegs);
>   	reg_w(sd, 0x2a, vsegs);
> @@ -3668,7 +3669,7 @@ static void ov518_mode_init_regs(struct sd *sd)
>   	if (sd->bridge == BRIDGE_OV518PLUS) {
>   		switch (sd->sensor) {
>   		case SEN_OV7620AE:
> -			if (sd->gspca_dev.width == 320) {
> +			if (sd->gspca_dev.pixfmt.width == 320) {
>   				reg_w(sd, 0x20, 0x00);
>   				reg_w(sd, 0x21, 0x19);
>   			} else {
> @@ -3794,8 +3795,8 @@ static void ov519_mode_init_regs(struct sd *sd)
>   		break;
>   	}
>
> -	reg_w(sd, OV519_R10_H_SIZE,	sd->gspca_dev.width >> 4);
> -	reg_w(sd, OV519_R11_V_SIZE,	sd->gspca_dev.height >> 3);
> +	reg_w(sd, OV519_R10_H_SIZE,	sd->gspca_dev.pixfmt.width >> 4);
> +	reg_w(sd, OV519_R11_V_SIZE,	sd->gspca_dev.pixfmt.height >> 3);
>   	if (sd->sensor == SEN_OV7670 &&
>   	    sd->gspca_dev.cam.cam_mode[sd->gspca_dev.curr_mode].priv)
>   		reg_w(sd, OV519_R12_X_OFFSETL, 0x04);
> @@ -3929,14 +3930,16 @@ static void mode_init_ov_sensor_regs(struct sd *sd)
>   	    }
>   	case SEN_OV3610:
>   		if (qvga) {
> -			xstart = (1040 - gspca_dev->width) / 2 + (0x1f << 4);
> -			ystart = (776 - gspca_dev->height) / 2;
> +			xstart = (1040 - gspca_dev->pixfmt.width) / 2 +
> +				(0x1f << 4);
> +			ystart = (776 - gspca_dev->pixfmt.height) / 2;
>   		} else {
> -			xstart = (2076 - gspca_dev->width) / 2 + (0x10 << 4);
> -			ystart = (1544 - gspca_dev->height) / 2;
> +			xstart = (2076 - gspca_dev->pixfmt.width) / 2 +
> +				(0x10 << 4);
> +			ystart = (1544 - gspca_dev->pixfmt.height) / 2;
>   		}
> -		xend = xstart + gspca_dev->width;
> -		yend = ystart + gspca_dev->height;
> +		xend = xstart + gspca_dev->pixfmt.width;
> +		yend = ystart + gspca_dev->pixfmt.height;
>   		/* Writing to the COMH register resets the other windowing regs
>   		   to their default values, so we must do this first. */
>   		i2c_w_mask(sd, 0x12, qvga ? 0x40 : 0x00, 0xf0);
> @@ -4211,8 +4214,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	struct sd *sd = (struct sd *) gspca_dev;
>
>   	/* Default for most bridges, allow bridge_mode_init_regs to override */
> -	sd->sensor_width = sd->gspca_dev.width;
> -	sd->sensor_height = sd->gspca_dev.height;
> +	sd->sensor_width = sd->gspca_dev.pixfmt.width;
> +	sd->sensor_height = sd->gspca_dev.pixfmt.height;
>
>   	switch (sd->bridge) {
>   	case BRIDGE_OV511:
> @@ -4327,12 +4330,13 @@ static void ov511_pkt_scan(struct gspca_dev *gspca_dev,
>   		ov51x_handle_button(gspca_dev, (in[8] >> 2) & 1);
>   		if (in[8] & 0x80) {
>   			/* Frame end */
> -			if ((in[9] + 1) * 8 != gspca_dev->width ||
> -			    (in[10] + 1) * 8 != gspca_dev->height) {
> +			if ((in[9] + 1) * 8 != gspca_dev->pixfmt.width ||
> +			    (in[10] + 1) * 8 != gspca_dev->pixfmt.height) {
>   				PERR("Invalid frame size, got: %dx%d,"
>   					" requested: %dx%d\n",
>   					(in[9] + 1) * 8, (in[10] + 1) * 8,
> -					gspca_dev->width, gspca_dev->height);
> +					gspca_dev->pixfmt.width,
> +					gspca_dev->pixfmt.height);
>   				gspca_dev->last_packet_type = DISCARD_PACKET;
>   				return;
>   			}
> @@ -4452,7 +4456,8 @@ static void ovfx2_pkt_scan(struct gspca_dev *gspca_dev,
>   		if (sd->first_frame) {
>   			sd->first_frame--;
>   			if (gspca_dev->image_len <
> -				  sd->gspca_dev.width * sd->gspca_dev.height)
> +				  sd->gspca_dev.pixfmt.width *
> +					sd->gspca_dev.pixfmt.height)
>   				gspca_dev->last_packet_type = DISCARD_PACKET;
>   		}
>   		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
> diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
> index 2e28c81..4df6b77 100644
> --- a/drivers/media/usb/gspca/ov534.c
> +++ b/drivers/media/usb/gspca/ov534.c
> @@ -1441,9 +1441,10 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>   		/* If this packet is marked as EOF, end the frame */
>   		} else if (data[1] & UVC_STREAM_EOF) {
>   			sd->last_pts = 0;
> -			if (gspca_dev->pixfmt == V4L2_PIX_FMT_YUYV
> +			if (gspca_dev->pixfmt.pixelformat == V4L2_PIX_FMT_YUYV
>   			 && gspca_dev->image_len + len - 12 !=
> -				   gspca_dev->width * gspca_dev->height * 2) {
> +				   gspca_dev->pixfmt.width *
> +					gspca_dev->pixfmt.height * 2) {
>   				PDEBUG(D_PACK, "wrong sized frame");
>   				goto discard;
>   			}
> diff --git a/drivers/media/usb/gspca/pac207.c b/drivers/media/usb/gspca/pac207.c
> index 83519be..cd79c18 100644
> --- a/drivers/media/usb/gspca/pac207.c
> +++ b/drivers/media/usb/gspca/pac207.c
> @@ -299,7 +299,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	pac207_write_regs(gspca_dev, 0x0042, pac207_sensor_init[3], 8);
>
>   	/* Compression Balance */
> -	if (gspca_dev->width == 176)
> +	if (gspca_dev->pixfmt.width == 176)
>   		pac207_write_reg(gspca_dev, 0x4a, 0xff);
>   	else
>   		pac207_write_reg(gspca_dev, 0x4a, 0x30);
> @@ -317,7 +317,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   		mode = 0x00;
>   	else
>   		mode = 0x02;
> -	if (gspca_dev->width == 176) {	/* 176x144 */
> +	if (gspca_dev->pixfmt.width == 176) {	/* 176x144 */
>   		mode |= 0x01;
>   		PDEBUG(D_STREAM, "pac207_start mode 176x144");
>   	} else {				/* 352x288 */
> diff --git a/drivers/media/usb/gspca/pac7311.c b/drivers/media/usb/gspca/pac7311.c
> index 1a5bdc8..25f86b1 100644
> --- a/drivers/media/usb/gspca/pac7311.c
> +++ b/drivers/media/usb/gspca/pac7311.c
> @@ -326,7 +326,7 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 val)
>   	 *  640x480 mode and page 4 reg 2 <= 3 then it must be 9
>   	 */
>   	reg_w(gspca_dev, 0xff, 0x01);
> -	if (gspca_dev->width != 640 && val <= 3)
> +	if (gspca_dev->pixfmt.width != 640 && val <= 3)
>   		reg_w(gspca_dev, 0x08, 0x09);
>   	else
>   		reg_w(gspca_dev, 0x08, 0x08);
> @@ -337,7 +337,7 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 val)
>   	 * camera to use higher compression or we may run out of
>   	 * bandwidth.
>   	 */
> -	if (gspca_dev->width == 640 && val == 2)
> +	if (gspca_dev->pixfmt.width == 640 && val == 2)
>   		reg_w(gspca_dev, 0x80, 0x01);
>   	else
>   		reg_w(gspca_dev, 0x80, 0x1c);
> @@ -615,7 +615,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>
>   		/* Start the new frame with the jpeg header */
>   		pac_start_frame(gspca_dev,
> -			gspca_dev->height, gspca_dev->width);
> +			gspca_dev->pixfmt.height, gspca_dev->pixfmt.width);
>   	}
>   	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
>   }
> diff --git a/drivers/media/usb/gspca/se401.c b/drivers/media/usb/gspca/se401.c
> index 5f729b8..5102cea 100644
> --- a/drivers/media/usb/gspca/se401.c
> +++ b/drivers/media/usb/gspca/se401.c
> @@ -354,9 +354,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
>
>   	/* set size + mode */
>   	se401_write_req(gspca_dev, SE401_REQ_SET_WIDTH,
> -			gspca_dev->width * mult, 0);
> +			gspca_dev->pixfmt.width * mult, 0);
>   	se401_write_req(gspca_dev, SE401_REQ_SET_HEIGHT,
> -			gspca_dev->height * mult, 0);
> +			gspca_dev->pixfmt.height * mult, 0);
>   	/*
>   	 * HDG: disabled this as it does not seem to do anything
>   	 * se401_write_req(gspca_dev, SE401_REQ_SET_OUTPUT_MODE,
> @@ -480,7 +480,7 @@ static void sd_complete_frame(struct gspca_dev *gspca_dev, u8 *data, int len)
>   static void sd_pkt_scan_janggu(struct gspca_dev *gspca_dev, u8 *data, int len)
>   {
>   	struct sd *sd = (struct sd *)gspca_dev;
> -	int imagesize = gspca_dev->width * gspca_dev->height;
> +	int imagesize = gspca_dev->pixfmt.width * gspca_dev->pixfmt.height;
>   	int i, plen, bits, pixels, info, count;
>
>   	if (sd->restart_stream)
> diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
> index f4453d5..2a38621 100644
> --- a/drivers/media/usb/gspca/sn9c20x.c
> +++ b/drivers/media/usb/gspca/sn9c20x.c
> @@ -1955,7 +1955,7 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
>   			return 0;
>   		}
>
> -		switch (gspca_dev->width) {
> +		switch (gspca_dev->pixfmt.width) {
>   		case 160: /* 160x120 */
>   			gspca_dev->alt = 2;
>   			break;
> @@ -1985,8 +1985,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   {
>   	struct sd *sd = (struct sd *) gspca_dev;
>   	int mode = gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv;
> -	int width = gspca_dev->width;
> -	int height = gspca_dev->height;
> +	int width = gspca_dev->pixfmt.width;
> +	int height = gspca_dev->pixfmt.height;
>   	u8 fmt, scale = 0;
>
>   	jpeg_define(sd->jpeg_hdr, height, width,
> diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
> index d7ff3b9..921802c 100644
> --- a/drivers/media/usb/gspca/sonixb.c
> +++ b/drivers/media/usb/gspca/sonixb.c
> @@ -753,7 +753,7 @@ static void setexposure(struct gspca_dev *gspca_dev)
>   		/* In 640x480, if the reg11 has less than 4, the image is
>   		   unstable (the bridge goes into a higher compression mode
>   		   which we have not reverse engineered yet). */
> -		if (gspca_dev->width == 640 && reg11 < 4)
> +		if (gspca_dev->pixfmt.width == 640 && reg11 < 4)
>   			reg11 = 4;
>
>   		/* frame exposure time in ms = 1000 * reg11 / 30    ->
> diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
> index 3b5ccb1..c69b45d 100644
> --- a/drivers/media/usb/gspca/sonixj.c
> +++ b/drivers/media/usb/gspca/sonixj.c
> @@ -2204,7 +2204,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   				{ 0x14, 0xe7, 0x1e, 0xdd };
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x21);		/* JPEG 422 */
>
>   	/* initialize the bridge */
> diff --git a/drivers/media/usb/gspca/spca1528.c b/drivers/media/usb/gspca/spca1528.c
> index 688592b..f38fd89 100644
> --- a/drivers/media/usb/gspca/spca1528.c
> +++ b/drivers/media/usb/gspca/spca1528.c
> @@ -255,7 +255,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	struct sd *sd = (struct sd *) gspca_dev;
>
>   	/* initialize the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x22);		/* JPEG 411 */
>
>   	/* the JPEG quality shall be 85% */
> diff --git a/drivers/media/usb/gspca/spca500.c b/drivers/media/usb/gspca/spca500.c
> index 9f8bf51..f011a30 100644
> --- a/drivers/media/usb/gspca/spca500.c
> +++ b/drivers/media/usb/gspca/spca500.c
> @@ -608,7 +608,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	__u8 xmult, ymult;
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x22);		/* JPEG 411 */
>   	jpeg_set_qual(sd->jpeg_hdr, QUALITY);
>
> diff --git a/drivers/media/usb/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
> index acb19fb..aa21edc 100644
> --- a/drivers/media/usb/gspca/sq905c.c
> +++ b/drivers/media/usb/gspca/sq905c.c
> @@ -272,7 +272,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>
>   	dev->cap_mode = gspca_dev->cam.cam_mode;
>   	/* "Open the shutter" and set size, to start capture */
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 640:
>   		PDEBUG(D_STREAM, "Start streaming at high resolution");
>   		dev->cap_mode++;
> diff --git a/drivers/media/usb/gspca/sq930x.c b/drivers/media/usb/gspca/sq930x.c
> index b10d082..e274cf19 100644
> --- a/drivers/media/usb/gspca/sq930x.c
> +++ b/drivers/media/usb/gspca/sq930x.c
> @@ -906,7 +906,8 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
>
>   	gspca_dev->cam.bulk_nurbs = 1;	/* there must be one URB only */
>   	sd->do_ctrl = 0;
> -	gspca_dev->cam.bulk_size = gspca_dev->width * gspca_dev->height + 8;
> +	gspca_dev->cam.bulk_size = gspca_dev->pixfmt.width *
> +			gspca_dev->pixfmt.height + 8;
>   	return 0;
>   }
>
> diff --git a/drivers/media/usb/gspca/stk014.c b/drivers/media/usb/gspca/stk014.c
> index 8c09826..b0c70fe 100644
> --- a/drivers/media/usb/gspca/stk014.c
> +++ b/drivers/media/usb/gspca/stk014.c
> @@ -250,7 +250,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	int ret, value;
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x22);		/* JPEG 411 */
>   	jpeg_set_qual(sd->jpeg_hdr, QUALITY);
>
> @@ -261,7 +262,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	set_par(gspca_dev, 0x00000000);
>   	set_par(gspca_dev, 0x8002e001);
>   	set_par(gspca_dev, 0x14000000);
> -	if (gspca_dev->width > 320)
> +	if (gspca_dev->pixfmt.width > 320)
>   		value = 0x8002e001;		/* 640x480 */
>   	else
>   		value = 0x4001f000;		/* 320x240 */
> diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
> index 5858688..5a6ed49 100644
> --- a/drivers/media/usb/gspca/stk1135.c
> +++ b/drivers/media/usb/gspca/stk1135.c
> @@ -347,8 +347,8 @@ static void stk1135_configure_mt9m112(struct gspca_dev *gspca_dev)
>   		sensor_write(gspca_dev, cfg[i].reg, cfg[i].val);
>
>   	/* set output size */
> -	width = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width;
> -	height = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].height;
> +	width = gspca_dev->pixfmt.width;
> +	height = gspca_dev->pixfmt.height;
>   	if (width <= 640) { /* use context A (half readout speed by default) */
>   		sensor_write(gspca_dev, 0x1a7, width);
>   		sensor_write(gspca_dev, 0x1aa, height);
> @@ -484,8 +484,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	reg_w(gspca_dev, STK1135_REG_CISPO + 3, 0x00);
>
>   	/* set capture end position */
> -	width = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].width;
> -	height = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].height;
> +	width = gspca_dev->pixfmt.width;
> +	height = gspca_dev->pixfmt.height;
>   	reg_w(gspca_dev, STK1135_REG_CIEPO + 0, width & 0xff);
>   	reg_w(gspca_dev, STK1135_REG_CIEPO + 1, width >> 8);
>   	reg_w(gspca_dev, STK1135_REG_CIEPO + 2, height & 0xff);
> diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
> index 55ee7a6..49d209b 100644
> --- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
> +++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
> @@ -452,7 +452,7 @@ frame_data:
>   					NULL, 0);
>
>   			if (sd->bridge == BRIDGE_ST6422)
> -				sd->to_skip = gspca_dev->width * 4;
> +				sd->to_skip = gspca_dev->pixfmt.width * 4;
>
>   			if (chunk_len)
>   				PERR("Chunk length is "
> diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
> index 8206b77..8d785ed 100644
> --- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
> +++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
> @@ -421,7 +421,7 @@ static int pb0100_set_autogain_target(struct gspca_dev *gspca_dev, __s32 val)
>
>   	/* Number of pixels counted by the sensor when subsampling the pixels.
>   	 * Slightly larger than the real value to avoid oscillation */
> -	totalpixels = gspca_dev->width * gspca_dev->height;
> +	totalpixels = gspca_dev->pixfmt.width * gspca_dev->pixfmt.height;
>   	totalpixels = totalpixels/(8*8) + totalpixels/(64*64);
>
>   	brightpixels = (totalpixels * val) >> 8;
> diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
> index af8767a..a517d18 100644
> --- a/drivers/media/usb/gspca/sunplus.c
> +++ b/drivers/media/usb/gspca/sunplus.c
> @@ -715,7 +715,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	int enable;
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x22);		/* JPEG 411 */
>   	jpeg_set_qual(sd->jpeg_hdr, QUALITY);
>
> diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
> index 4cb511c..640c2fe 100644
> --- a/drivers/media/usb/gspca/topro.c
> +++ b/drivers/media/usb/gspca/topro.c
> @@ -3856,7 +3856,7 @@ static void setsharpness(struct gspca_dev *gspca_dev, s32 val)
>
>   	if (sd->bridge == BRIDGE_TP6800) {
>   		val |= 0x08;		/* grid compensation enable */
> -		if (gspca_dev->width == 640)
> +		if (gspca_dev->pixfmt.width == 640)
>   			reg_w(gspca_dev, TP6800_R78_FORMAT, 0x00); /* vga */
>   		else
>   			val |= 0x04;		/* scaling down enable */
> @@ -3880,7 +3880,7 @@ static void set_resolution(struct gspca_dev *gspca_dev)
>   	struct sd *sd = (struct sd *) gspca_dev;
>
>   	reg_w(gspca_dev, TP6800_R21_ENDP_1_CTL, 0x00);
> -	if (gspca_dev->width == 320) {
> +	if (gspca_dev->pixfmt.width == 320) {
>   		reg_w(gspca_dev, TP6800_R3F_FRAME_RATE, 0x06);
>   		msleep(100);
>   		i2c_w(gspca_dev, CX0342_AUTO_ADC_CALIB, 0x01);
> @@ -3924,7 +3924,7 @@ static int get_fr_idx(struct gspca_dev *gspca_dev)
>
>   		/* 640x480 * 30 fps does not work */
>   		if (i == 6			/* if 30 fps */
> -		 && gspca_dev->width == 640)
> +		 && gspca_dev->pixfmt.width == 640)
>   			i = 0x05;		/* 15 fps */
>   	} else {
>   		for (i = 0; i < ARRAY_SIZE(rates_6810) - 1; i++) {
> @@ -3935,7 +3935,7 @@ static int get_fr_idx(struct gspca_dev *gspca_dev)
>
>   		/* 640x480 * 30 fps does not work */
>   		if (i == 7			/* if 30 fps */
> -		 && gspca_dev->width == 640)
> +		 && gspca_dev->pixfmt.width == 640)
>   			i = 6;			/* 15 fps */
>   		i |= 0x80;			/* clock * 1 */
>   	}
> @@ -4554,7 +4554,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   {
>   	struct sd *sd = (struct sd *) gspca_dev;
>
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width);
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width);
>   	set_dqt(gspca_dev, sd->quality);
>   	if (sd->bridge == BRIDGE_TP6800) {
>   		if (sd->sensor == SENSOR_CX0342)
> @@ -4737,7 +4738,7 @@ static void sd_dq_callback(struct gspca_dev *gspca_dev)
>   			(gspca_dev->usb_buf[26] << 8) + gspca_dev->usb_buf[25] +
>   			(gspca_dev->usb_buf[29] << 8) + gspca_dev->usb_buf[28])
>   				/ 8;
> -		if (gspca_dev->width == 640)
> +		if (gspca_dev->pixfmt.width == 640)
>   			luma /= 4;
>   		reg_w(gspca_dev, 0x7d, 0x00);
>
> diff --git a/drivers/media/usb/gspca/tv8532.c b/drivers/media/usb/gspca/tv8532.c
> index 8591324..d497ba3 100644
> --- a/drivers/media/usb/gspca/tv8532.c
> +++ b/drivers/media/usb/gspca/tv8532.c
> @@ -268,7 +268,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>   	packet_type0 = packet_type1 = INTER_PACKET;
>   	if (gspca_dev->empty_packet) {
>   		gspca_dev->empty_packet = 0;
> -		sd->packet = gspca_dev->height / 2;
> +		sd->packet = gspca_dev->pixfmt.height / 2;
>   		packet_type0 = FIRST_PACKET;
>   	} else if (sd->packet == 0)
>   		return;			/* 2 more lines in 352x288 ! */
> @@ -284,9 +284,10 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>   	 * - 4 bytes
>   	 */
>   	gspca_frame_add(gspca_dev, packet_type0,
> -			data + 2, gspca_dev->width);
> +			data + 2, gspca_dev->pixfmt.width);
>   	gspca_frame_add(gspca_dev, packet_type1,
> -			data + gspca_dev->width + 5, gspca_dev->width);
> +			data + gspca_dev->pixfmt.width + 5,
> +			gspca_dev->pixfmt.width);
>   }
>
>   static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
> diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
> index d6890bc..1689b8f 100644
> --- a/drivers/media/usb/gspca/vicam.c
> +++ b/drivers/media/usb/gspca/vicam.c
> @@ -121,13 +121,13 @@ static int vicam_read_frame(struct gspca_dev *gspca_dev, u8 *data, int size)
>
>   	memset(req_data, 0, 16);
>   	req_data[0] = gain;
> -	if (gspca_dev->width == 256)
> +	if (gspca_dev->pixfmt.width == 256)
>   		req_data[1] |= 0x01; /* low nibble x-scale */
> -	if (gspca_dev->height <= 122) {
> +	if (gspca_dev->pixfmt.height <= 122) {
>   		req_data[1] |= 0x10; /* high nibble y-scale */
> -		unscaled_height = gspca_dev->height * 2;
> +		unscaled_height = gspca_dev->pixfmt.height * 2;
>   	} else
> -		unscaled_height = gspca_dev->height;
> +		unscaled_height = gspca_dev->pixfmt.height;
>   	req_data[2] = 0x90; /* unknown, does not seem to do anything */
>   	if (unscaled_height <= 200)
>   		req_data[3] = 0x06; /* vend? */
> diff --git a/drivers/media/usb/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
> index 2165da0..fb9fe2e 100644
> --- a/drivers/media/usb/gspca/w996Xcf.c
> +++ b/drivers/media/usb/gspca/w996Xcf.c
> @@ -430,11 +430,11 @@ static void w9968cf_set_crop_window(struct sd *sd)
>   	#define SC(x) ((x) << 10)
>
>   	/* Scaling factors */
> -	fw = SC(sd->gspca_dev.width) / max_width;
> -	fh = SC(sd->gspca_dev.height) / max_height;
> +	fw = SC(sd->gspca_dev.pixfmt.width) / max_width;
> +	fh = SC(sd->gspca_dev.pixfmt.height) / max_height;
>
> -	cw = (fw >= fh) ? max_width : SC(sd->gspca_dev.width) / fh;
> -	ch = (fw >= fh) ? SC(sd->gspca_dev.height) / fw : max_height;
> +	cw = (fw >= fh) ? max_width : SC(sd->gspca_dev.pixfmt.width) / fh;
> +	ch = (fw >= fh) ? SC(sd->gspca_dev.pixfmt.height) / fw : max_height;
>
>   	sd->sensor_width = max_width;
>   	sd->sensor_height = max_height;
> @@ -454,34 +454,34 @@ static void w9968cf_mode_init_regs(struct sd *sd)
>
>   	w9968cf_set_crop_window(sd);
>
> -	reg_w(sd, 0x14, sd->gspca_dev.width);
> -	reg_w(sd, 0x15, sd->gspca_dev.height);
> +	reg_w(sd, 0x14, sd->gspca_dev.pixfmt.width);
> +	reg_w(sd, 0x15, sd->gspca_dev.pixfmt.height);
>
>   	/* JPEG width & height */
> -	reg_w(sd, 0x30, sd->gspca_dev.width);
> -	reg_w(sd, 0x31, sd->gspca_dev.height);
> +	reg_w(sd, 0x30, sd->gspca_dev.pixfmt.width);
> +	reg_w(sd, 0x31, sd->gspca_dev.pixfmt.height);
>
>   	/* Y & UV frame buffer strides (in WORD) */
>   	if (w9968cf_vga_mode[sd->gspca_dev.curr_mode].pixelformat ==
>   	    V4L2_PIX_FMT_JPEG) {
> -		reg_w(sd, 0x2c, sd->gspca_dev.width / 2);
> -		reg_w(sd, 0x2d, sd->gspca_dev.width / 4);
> +		reg_w(sd, 0x2c, sd->gspca_dev.pixfmt.width / 2);
> +		reg_w(sd, 0x2d, sd->gspca_dev.pixfmt.width / 4);
>   	} else
> -		reg_w(sd, 0x2c, sd->gspca_dev.width);
> +		reg_w(sd, 0x2c, sd->gspca_dev.pixfmt.width);
>
>   	reg_w(sd, 0x00, 0xbf17); /* reset everything */
>   	reg_w(sd, 0x00, 0xbf10); /* normal operation */
>
>   	/* Transfer size in WORDS (for UYVY format only) */
> -	val = sd->gspca_dev.width * sd->gspca_dev.height;
> +	val = sd->gspca_dev.pixfmt.width * sd->gspca_dev.pixfmt.height;
>   	reg_w(sd, 0x3d, val & 0xffff); /* low bits */
>   	reg_w(sd, 0x3e, val >> 16);    /* high bits */
>
>   	if (w9968cf_vga_mode[sd->gspca_dev.curr_mode].pixelformat ==
>   	    V4L2_PIX_FMT_JPEG) {
>   		/* We may get called multiple times (usb isoc bw negotiat.) */
> -		jpeg_define(sd->jpeg_hdr, sd->gspca_dev.height,
> -			    sd->gspca_dev.width, 0x22); /* JPEG 420 */
> +		jpeg_define(sd->jpeg_hdr, sd->gspca_dev.pixfmt.height,
> +			    sd->gspca_dev.pixfmt.width, 0x22); /* JPEG 420 */
>   		jpeg_set_qual(sd->jpeg_hdr, v4l2_ctrl_g_ctrl(sd->jpegqual));
>   		w9968cf_upload_quantizationtables(sd);
>   		v4l2_ctrl_grab(sd->jpegqual, true);
> diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
> index 7eaf64e..101df67 100644
> --- a/drivers/media/usb/gspca/xirlink_cit.c
> +++ b/drivers/media/usb/gspca/xirlink_cit.c
> @@ -1471,14 +1471,14 @@ static int cit_get_clock_div(struct gspca_dev *gspca_dev)
>
>   	while (clock_div > 3 &&
>   			1000 * packet_size >
> -			gspca_dev->width * gspca_dev->height *
> +			gspca_dev->pixfmt.width * gspca_dev->pixfmt.height *
>   			fps[clock_div - 1] * 3 / 2)
>   		clock_div--;
>
>   	PDEBUG(D_PROBE,
>   	       "PacketSize: %d, res: %dx%d -> using clockdiv: %d (%d fps)",
> -	       packet_size, gspca_dev->width, gspca_dev->height, clock_div,
> -	       fps[clock_div]);
> +	       packet_size, gspca_dev->pixfmt.width, gspca_dev->pixfmt.height,
> +	       clock_div, fps[clock_div]);
>
>   	return clock_div;
>   }
> @@ -1502,7 +1502,7 @@ static int cit_start_model0(struct gspca_dev *gspca_dev)
>   	cit_write_reg(gspca_dev, 0x0002, 0x0426);
>   	cit_write_reg(gspca_dev, 0x0014, 0x0427);
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160: /* 160x120 */
>   		cit_write_reg(gspca_dev, 0x0004, 0x010b);
>   		cit_write_reg(gspca_dev, 0x0001, 0x010a);
> @@ -1643,7 +1643,7 @@ static int cit_start_model1(struct gspca_dev *gspca_dev)
>   	cit_write_reg(gspca_dev, 0x00, 0x0101);
>   	cit_write_reg(gspca_dev, 0x00, 0x010a);
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 128: /* 128x96 */
>   		cit_write_reg(gspca_dev, 0x80, 0x0103);
>   		cit_write_reg(gspca_dev, 0x60, 0x0105);
> @@ -1700,7 +1700,7 @@ static int cit_start_model1(struct gspca_dev *gspca_dev)
>   	}
>
>   	/* Assorted init */
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 128: /* 128x96 */
>   		cit_Packet_Format1(gspca_dev, 0x2b, 0x1e);
>   		cit_write_reg(gspca_dev, 0xc9, 0x0119);	/* Same everywhere */
> @@ -1753,7 +1753,7 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
>   	cit_write_reg(gspca_dev, 0x0000, 0x0108);
>   	cit_write_reg(gspca_dev, 0x0001, 0x0133);
>   	cit_write_reg(gspca_dev, 0x0001, 0x0102);
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 176: /* 176x144 */
>   		cit_write_reg(gspca_dev, 0x002c, 0x0103);	/* All except 320x240 */
>   		cit_write_reg(gspca_dev, 0x0000, 0x0104);	/* Same */
> @@ -1792,7 +1792,7 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
>
>   	cit_write_reg(gspca_dev, 0x0000, 0x0100);	/* LED on */
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 176: /* 176x144 */
>   		cit_write_reg(gspca_dev, 0x0050, 0x0111);
>   		cit_write_reg(gspca_dev, 0x00d0, 0x0111);
> @@ -1840,7 +1840,7 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
>   	 * Magic control of CMOS sensor. Only lower values like
>   	 * 0-3 work, and picture shifts left or right. Don't change.
>   	 */
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 176: /* 176x144 */
>   		cit_model2_Packet1(gspca_dev, 0x0014, 0x0002);
>   		cit_model2_Packet1(gspca_dev, 0x0016, 0x0002); /* Horizontal shift */
> @@ -1899,7 +1899,7 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
>   	 * does not allow arbitrary values and apparently is a bit mask, to
>   	 * be activated only at appropriate time. Don't change it randomly!
>   	 */
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 176: /* 176x144 */
>   		cit_model2_Packet1(gspca_dev, 0x0026, 0x00c2);
>   		break;
> @@ -2023,7 +2023,7 @@ static int cit_start_model3(struct gspca_dev *gspca_dev)
>   	cit_model3_Packet1(gspca_dev, 0x009e, 0x0096);
>   	cit_model3_Packet1(gspca_dev, 0x009f, 0x000a);
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160:
>   		cit_write_reg(gspca_dev, 0x0000, 0x0101); /* Same on 160x120, 320x240 */
>   		cit_write_reg(gspca_dev, 0x00a0, 0x0103); /* Same on 160x120, 320x240 */
> @@ -2134,7 +2134,7 @@ static int cit_start_model3(struct gspca_dev *gspca_dev)
>   	   like with the IBM netcam pro). */
>   	cit_write_reg(gspca_dev, clock_div, 0x0111); /* Clock Divider */
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160:
>   		cit_model3_Packet1(gspca_dev, 0x001f, 0x0000); /* Same */
>   		cit_model3_Packet1(gspca_dev, 0x0039, 0x001f); /* Same */
> @@ -2211,7 +2211,7 @@ static int cit_start_model4(struct gspca_dev *gspca_dev)
>   	cit_write_reg(gspca_dev, 0xfffa, 0x0124);
>   	cit_model4_Packet1(gspca_dev, 0x0034, 0x0000);
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 128: /* 128x96 */
>   		cit_write_reg(gspca_dev, 0x0070, 0x0119);
>   		cit_write_reg(gspca_dev, 0x00d0, 0x0111);
> @@ -2531,7 +2531,7 @@ static int cit_start_ibm_netcam_pro(struct gspca_dev *gspca_dev)
>   	cit_write_reg(gspca_dev, 0x00fc, 0x012b); /* Same */
>   	cit_write_reg(gspca_dev, 0x0022, 0x012a); /* Same */
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160: /* 160x120 */
>   		cit_write_reg(gspca_dev, 0x0024, 0x010b);
>   		cit_write_reg(gspca_dev, 0x0089, 0x0119);
> @@ -2635,7 +2635,7 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
>   	struct usb_host_interface *alt;
>   	int max_packet_size;
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160:
>   		max_packet_size = 450;
>   		break;
> @@ -2659,7 +2659,7 @@ static int sd_isoc_nego(struct gspca_dev *gspca_dev)
>   	int ret, packet_size, min_packet_size;
>   	struct usb_host_interface *alt;
>
> -	switch (gspca_dev->width) {
> +	switch (gspca_dev->pixfmt.width) {
>   	case 160:
>   		min_packet_size = 200;
>   		break;
> @@ -2780,7 +2780,7 @@ static u8 *cit_find_sof(struct gspca_dev *gspca_dev, u8 *data, int len)
>   	case CIT_MODEL1:
>   	case CIT_MODEL3:
>   	case CIT_IBM_NETCAM_PRO:
> -		switch (gspca_dev->width) {
> +		switch (gspca_dev->pixfmt.width) {
>   		case 160: /* 160x120 */
>   			byte3 = 0x02;
>   			byte4 = 0x0a;
> diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
> index cbfc2f9..7b95d8e 100644
> --- a/drivers/media/usb/gspca/zc3xx.c
> +++ b/drivers/media/usb/gspca/zc3xx.c
> @@ -6700,7 +6700,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
>   	};
>
>   	/* create the JPEG header */
> -	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
> +	jpeg_define(sd->jpeg_hdr, gspca_dev->pixfmt.height,
> +			gspca_dev->pixfmt.width,
>   			0x21);		/* JPEG 422 */
>
>   	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
>
