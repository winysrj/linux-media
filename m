Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1524 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZGYPcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 11:32:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv11 6/8] FM TX: si4713: Add files to handle si4713 i2c device
Date: Sat, 25 Jul 2009 17:32:35 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248533862-20860-1-git-send-email-eduardo.valentin@nokia.com> <1248533862-20860-6-git-send-email-eduardo.valentin@nokia.com> <1248533862-20860-7-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1248533862-20860-7-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251732.35675.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 16:57:40 Eduardo Valentin wrote:
> This patch adds files to control si4713 devices.
> Internal functions to control device properties
> and initialization procedures are into these files.
> Also, a v4l2 subdev interface is also exported.
> This way other drivers can use this as v4l2 i2c subdevice.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  linux/drivers/media/radio/si4713-i2c.c | 2034 ++++++++++++++++++++++++++++++++
>  linux/drivers/media/radio/si4713-i2c.h |  237 ++++
>  linux/include/media/si4713.h           |   49 +
>  3 files changed, 2320 insertions(+), 0 deletions(-)
>  create mode 100644 linux/drivers/media/radio/si4713-i2c.c
>  create mode 100644 linux/drivers/media/radio/si4713-i2c.h
>  create mode 100644 linux/include/media/si4713.h
> 
> diff --git a/linux/drivers/media/radio/si4713-i2c.c b/linux/drivers/media/radio/si4713-i2c.c
> new file mode 100644
> index 0000000..9525f1d
> --- /dev/null
> +++ b/linux/drivers/media/radio/si4713-i2c.c

> +/* write string property */
> +static int si4713_write_econtrol_string(struct si4713_device *sdev,
> +				struct v4l2_ext_control *control)
> +{
> +	char ps_name[MAX_RDS_PS_NAME + 1];
> +	char radio_text[MAX_RDS_RADIO_TEXT + 1];
> +	int size;
> +	s32 rval = 0;
> +
> +	switch (control->id) {
> +	case V4L2_CID_RDS_TX_PS_NAME:
> +		size = control->length - 1;

You should add a check against control->length == 0 here and return -EINVAL
if it is 0. I noticed that the minimum lengths is set to 0 in v4l2_queryctrl.
That should be at least 1 (the length of an empty string).

You can also go ahead and check that size is a multiple of 8. Don't forget
to update the corresponding v4l2_ctrl_query_fill() with the new step value.

> +		if (size > MAX_RDS_PS_NAME)
> +			size = MAX_RDS_PS_NAME;
> +		rval = copy_from_user(ps_name, control->string, size);
> +		if (rval < 0)
> +			goto exit;
> +		ps_name[size] = '\0';
> +		rval = si4713_set_rds_ps_name(sdev, ps_name);
> +		break;
> +
> +	case V4L2_CID_RDS_TX_RADIO_TEXT:
> +		size = control->length - 1;

Ditto.

What is the step value for radio text? Looking at the RDS spec I'd say that
it depends on whether it is transmitted in block 2A or 2B.

What happens if the user passes an empty string? Is that even allowed?
If it isn't allowed, then the minimum string lengths should be updated.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
