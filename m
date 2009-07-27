Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2757 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZG0MZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 08:25:40 -0400
Message-ID: <10871.62.70.2.252.1248697526.squirrel@webmail.xs4all.nl>
Date: Mon, 27 Jul 2009 14:25:26 +0200 (CEST)
Subject: Re: [PATCHv12 6/8] FM TX: si4713: Add files to handle si4713 i2c
     device
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Eduardo Valentin" <eduardo.valentin@nokia.com>
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>,
	"Aaltonen Matti.J" <matti.j.aaltonen@nokia.com>,
	"Linux-Media" <linux-media@vger.kernel.org>,
	"Eduardo Valentin" <eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> This patch adds files to control si4713 devices.
> Internal functions to control device properties
> and initialization procedures are into these files.
> Also, a v4l2 subdev interface is also exported.
> This way other drivers can use this as v4l2 i2c subdevice.
>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  linux/drivers/media/radio/si4713-i2c.c | 2052
> ++++++++++++++++++++++++++++++++
>  linux/drivers/media/radio/si4713-i2c.h |  237 ++++
>  linux/include/media/si4713.h           |   49 +
>  3 files changed, 2338 insertions(+), 0 deletions(-)
>  create mode 100644 linux/drivers/media/radio/si4713-i2c.c
>  create mode 100644 linux/drivers/media/radio/si4713-i2c.h
>  create mode 100644 linux/include/media/si4713.h
>
> diff --git a/linux/drivers/media/radio/si4713-i2c.c
> b/linux/drivers/media/radio/si4713-i2c.c
> new file mode 100644
> index 0000000..adce6e8
> --- /dev/null
> +++ b/linux/drivers/media/radio/si4713-i2c.c

<snip>

> +/* write string property */
> +static int si4713_write_econtrol_string(struct si4713_device *sdev,
> +				struct v4l2_ext_control *control)
> +{
> +	struct v4l2_queryctrl vqc;
> +	char ps_name[MAX_RDS_PS_NAME + 1];
> +	char radio_text[MAX_RDS_RADIO_TEXT + 1];
> +	int len;
> +	s32 rval = 0;
> +
> +	len = strlen(control->string);

This is wrong. control->string has not yet been copied to kernelspace.

> +	vqc.id = control->id;
> +	rval = si4713_queryctrl(&sdev->sd, &vqc);
> +	if (rval < 0)
> +		goto exit;
> +
> +	if (len > vqc.maximum || len % vqc.step) {
> +		rval = -ENOSPC;
> +		goto exit;
> +	}
> +
> +	switch (control->id) {
> +	case V4L2_CID_RDS_TX_PS_NAME:
> +		rval = copy_from_user(ps_name, control->string, len);
> +		if (rval < 0)
> +			goto exit;
> +		ps_name[len] = '\0';

The check should be done here: it's now in kernelspace, and guaranteed to
be zero-terminated.

> +		rval = si4713_set_rds_ps_name(sdev, ps_name);
> +		break;
> +
> +	case V4L2_CID_RDS_TX_RADIO_TEXT:
> +		rval = copy_from_user(radio_text, control->string, len);
> +		if (rval < 0)
> +			goto exit;
> +		radio_text[len] = '\0';
> +		rval = si4713_set_rds_radio_text(sdev, radio_text);
> +		break;
> +
> +	default:
> +		rval = -EINVAL;
> +		break;
> +	};
> +
> +exit:
> +	return rval;
> +}

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

