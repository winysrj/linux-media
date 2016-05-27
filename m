Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46305 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbcE0M4e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:56:34 -0400
Subject: Re: [PATCH v2 8/8] Input: atmel_mxt_ts - add support for reference
 data
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
 <1462381638-7818-9-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <574843F2.9060309@xs4all.nl>
Date: Fri, 27 May 2016 14:56:18 +0200
MIME-Version: 1.0
In-Reply-To: <1462381638-7818-9-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2016 07:07 PM, Nick Dyer wrote:
> There are different datatypes available from a maXTouch chip. Add
> support to retrieve reference data as well.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 66 +++++++++++++++++++++++++++-----
>  1 file changed, 56 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index fca1096..1d9909f 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -135,6 +135,7 @@ struct t9_range {
>  /* MXT_DEBUG_DIAGNOSTIC_T37 */
>  #define MXT_DIAGNOSTIC_PAGEUP	0x01
>  #define MXT_DIAGNOSTIC_DELTAS	0x10
> +#define MXT_DIAGNOSTIC_REFS	0x11
>  #define MXT_DIAGNOSTIC_SIZE	128
>  
>  #define MXT_FAMILY_1386			160
> @@ -247,6 +248,12 @@ struct mxt_dbg {
>  	int input;
>  };
>  
> +enum v4l_dbg_inputs {
> +	MXT_V4L_INPUT_DELTAS,
> +	MXT_V4L_INPUT_REFS,
> +	MXT_V4L_INPUT_MAX,
> +};
> +
>  static const struct v4l2_file_operations mxt_video_fops = {
>  	.owner = THIS_MODULE,
>  	.open = v4l2_fh_open,
> @@ -2270,6 +2277,7 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
>  	struct mxt_data *data = vb2_get_drv_priv(vb->vb2_queue);
>  	u16 *ptr;
>  	int ret;
> +	u8 mode;
>  
>  	ptr = vb2_plane_vaddr(vb, 0);
>  	if (!ptr) {
> @@ -2277,7 +2285,18 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
>  		goto fault;
>  	}
>  
> -	ret = mxt_read_diagnostic_debug(data, MXT_DIAGNOSTIC_DELTAS, ptr);
> +	switch (data->dbg.input) {
> +	case MXT_V4L_INPUT_DELTAS:
> +	default:
> +		mode = MXT_DIAGNOSTIC_DELTAS;
> +		break;
> +
> +	case MXT_V4L_INPUT_REFS:
> +		mode = MXT_DIAGNOSTIC_REFS;
> +		break;
> +	}
> +
> +	ret = mxt_read_diagnostic_debug(data, mode, ptr);
>  	if (ret)
>  		goto fault;
>  
> @@ -2327,13 +2346,22 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
>  static int mxt_vidioc_enum_input(struct file *file, void *priv,
>  				   struct v4l2_input *i)
>  {
> -	if (i->index > 0)
> +	if (i->index >= MXT_V4L_INPUT_MAX)
>  		return -EINVAL;
>  
>  	i->type = V4L2_INPUT_TYPE_CAMERA;
>  	i->std = V4L2_STD_UNKNOWN;
>  	i->capabilities = 0;
> -	strlcpy(i->name, "Mutual References", sizeof(i->name));
> +
> +	switch (i->index) {
> +	case MXT_V4L_INPUT_REFS:
> +		strlcpy(i->name, "Mutual References", sizeof(i->name));
> +		break;
> +	case MXT_V4L_INPUT_DELTAS:
> +		strlcpy(i->name, "Mutual Deltas", sizeof(i->name));
> +		break;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -2341,12 +2369,16 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
>  {
>  	struct v4l2_pix_format *f = &data->dbg.format;
>  
> -	if (i > 0)
> +	if (i >= MXT_V4L_INPUT_MAX)
>  		return -EINVAL;
>  
> +	if (i == MXT_V4L_INPUT_DELTAS)
> +		f->pixelformat = V4L2_PIX_FMT_YS16;
> +	else
> +		f->pixelformat = V4L2_PIX_FMT_Y16;
> +
>  	f->width = data->xy_switch ? data->ysize : data->xsize;
>  	f->height = data->xy_switch ? data->xsize : data->ysize;
> -	f->pixelformat = V4L2_PIX_FMT_YS16;
>  	f->field = V4L2_FIELD_NONE;
>  	f->colorspace = V4L2_COLORSPACE_SRGB;
>  	f->bytesperline = f->width * sizeof(u16);
> @@ -2383,12 +2415,26 @@ static int mxt_vidioc_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *fmt)
>  {
> -	if (fmt->index > 0 || fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	switch (fmt->index) {
> +	case 0:
> +		fmt->pixelformat = V4L2_PIX_FMT_Y16;
> +		strlcpy(fmt->description, "16-bit unsigned raw debug data",
> +			sizeof(fmt->description));
> +		break;
> +
> +	case 1:
> +		fmt->pixelformat = V4L2_PIX_FMT_YS16;
> +		strlcpy(fmt->description, "16-bit signed raw debug data",
> +			sizeof(fmt->description));
> +		break;

Same as I mentioned in the other patch: don't set the description here.

> +
> +	default:
>  		return -EINVAL;
> +	}
>  
> -	fmt->pixelformat = V4L2_PIX_FMT_YS16;
> -	strlcpy(fmt->description, "16-bit raw debug data",
> -		sizeof(fmt->description));
>  	fmt->flags = 0;
>  	return 0;
>  }
> @@ -2410,7 +2456,7 @@ static int mxt_vidioc_enum_framesizes(struct file *file, void *priv,
>  static int mxt_vidioc_enum_frameintervals(struct file *file, void *priv,
>  					  struct v4l2_frmivalenum *f)
>  {
> -	if ((f->index > 0) || (f->pixel_format != V4L2_PIX_FMT_YS16))
> +	if (f->index > 0)
>  		return -EINVAL;
>  
>  	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> 

Regards,

	Hans
