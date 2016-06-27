Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52430 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbcF0LLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 07:11:40 -0400
Subject: Re: [PATCH v5 7/9] Input: atmel_mxt_ts - add support for reference
 data
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466633313-15339-8-git-send-email-nick.dyer@itdev.co.uk>
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
Message-ID: <188bbbb9-e0f9-78e1-affe-aaa27c476e9d@xs4all.nl>
Date: Mon, 27 Jun 2016 13:11:33 +0200
MIME-Version: 1.0
In-Reply-To: <1466633313-15339-8-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2016 12:08 AM, Nick Dyer wrote:
> There are different datatypes available from a maXTouch chip. Add
> support to retrieve reference data as well.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 58 ++++++++++++++++++++++++++++----
>  1 file changed, 51 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 739d138..f733785 100644
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
> @@ -249,6 +250,12 @@ struct mxt_dbg {
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
> @@ -2273,6 +2280,7 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
>  	struct mxt_data *data = vb2_get_drv_priv(vb->vb2_queue);
>  	u16 *ptr;
>  	int ret;
> +	u8 mode;
>  
>  	ptr = vb2_plane_vaddr(vb, 0);
>  	if (!ptr) {
> @@ -2280,7 +2288,18 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
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
> @@ -2325,11 +2344,20 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
>  static int mxt_vidioc_enum_input(struct file *file, void *priv,
>  				   struct v4l2_input *i)
>  {
> -	if (i->index > 0)
> +	if (i->index >= MXT_V4L_INPUT_MAX)
>  		return -EINVAL;
>  
>  	i->type = V4L2_INPUT_TYPE_TOUCH;
> -	strlcpy(i->name, "Mutual References", sizeof(i->name));
> +
> +	switch (i->index) {
> +	case MXT_V4L_INPUT_REFS:
> +		strlcpy(i->name, "Mutual References", sizeof(i->name));
> +		break;
> +	case MXT_V4L_INPUT_DELTAS:
> +		strlcpy(i->name, "Mutual Deltas", sizeof(i->name));

Same here: Mutual Capacitance Deltas

> +		break;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -2337,12 +2365,16 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
>  {
>  	struct v4l2_pix_format *f = &data->dbg.format;
>  
> -	if (i > 0)
> +	if (i >= MXT_V4L_INPUT_MAX)
>  		return -EINVAL;
>  
> +	if (i == MXT_V4L_INPUT_DELTAS)
> +		f->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
> +	else
> +		f->pixelformat = V4L2_TCH_FMT_TU16;
> +
>  	f->width = data->xy_switch ? data->ysize : data->xsize;
>  	f->height = data->xy_switch ? data->xsize : data->ysize;
> -	f->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
>  	f->field = V4L2_FIELD_NONE;
>  	f->colorspace = V4L2_COLORSPACE_RAW;
>  	f->bytesperline = f->width * sizeof(u16);
> @@ -2380,10 +2412,22 @@ static int mxt_vidioc_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *fmt)
>  {
> -	if (fmt->index > 0 || fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	switch (fmt->index) {
> +	case 0:
> +		fmt->pixelformat = V4L2_TCH_FMT_TU16;
> +		break;
> +
> +	case 1:
> +		fmt->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
> +		break;
> +
> +	default:
>  		return -EINVAL;
> +	}
>  
> -	fmt->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
>  	return 0;
>  }
>  
> 

Regards,

	Hans
