Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:58513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0IEH6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 03:58:00 -0400
Message-ID: <4C834EDE.6050703@redhat.com>
Date: Sun, 05 Sep 2010 10:03:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_cpia1: Add lamp control for Intel Play QX3 microscope
References: <1283476182.17527.4.camel@morgan.silverblock.net>
In-Reply-To: <1283476182.17527.4.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi,

On 09/03/2010 03:09 AM, Andy Walls wrote:
> # HG changeset patch
> # User Andy Walls<awalls@radix.net>
> # Date 1283475832 14400
> # Node ID 0d251a2976b46e11cc817207de191896718b93a3
> # Parent  a4c762698bcb138982b81cf59e5bc4b7155866a9
> gspca_cpia1: Add lamp cotrol for Intel Play QX3 microscope
>
> From: Andy Walls<awalls@md.metrocast.net>
>
> Add a v4l2 control to get the lamp control code working for the Intel Play
> QX3 microscope.  My daughter in middle school thought it was cool, and is now
> examining the grossest specimens she can find.
>

Hehe, cool I'm very happy to hear the cpia1 driver actually being used in a
"productive" manner, that shows it is worth all the time and effort I've put into
cleaning up / rewriting old v4l1 drivers :)

About the patch: first of all thanks. wrt lamps versus lights I'm indifferent.
The only thing I've notices is that you've made the controls instand apply. Normally
controls setting changes when not streaming are just remembered and then applied
when the stream is initialized.

However your code sends the lamp settings to the device as soon as they are
changed, and does not send them on sd_start. The sending as soon as changes
makes sense. But did you check that this actually works, iow did you play with
the lamps control while not streaming ? and then tried to stream and see if
the settings stuck.

Also the not sending at sd_start, nor sd_init means that you assume that the
defaults in the driver (both lamps off) ar the same as of the device as you
never force that the device <-> driver settings are synced on driver load
or stream start. This may not be the case when resuming from suspend or
the driver is rmmod-ed insmod-ed. So assuming that the instant apply
of this control does not cause issues, you should add a call to
command_setlamps(gspca_dev); at the end of sd_init.

Regards,

Hans


> Priority: normal
>
> Signed-off-by: Andy Walls<awalls@md.metrocast.net>
>
> diff -r a4c762698bcb -r 0d251a2976b4 linux/drivers/media/video/gspca/cpia1.c
> --- a/linux/drivers/media/video/gspca/cpia1.c	Wed Aug 25 16:13:54 2010 -0300
> +++ b/linux/drivers/media/video/gspca/cpia1.c	Thu Sep 02 21:03:52 2010 -0400
> @@ -333,8 +333,8 @@
>   	} format;
>   	struct {                        /* Intel QX3 specific data */
>   		u8 qx3_detected;        /* a QX3 is present */
> -		u8 toplight;            /* top light lit , R/W */
> -		u8 bottomlight;         /* bottom light lit, R/W */
> +		u8 toplamp;             /* top lamp lit , R/W */
> +		u8 bottomlamp;          /* bottom lamp lit, R/W */
>   		u8 button;              /* snapshot button pressed (R/O) */
>   		u8 cradled;             /* microscope is in cradle (R/O) */
>   	} qx3;
> @@ -373,6 +373,8 @@
>   static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);
>   static int sd_setcomptarget(struct gspca_dev *gspca_dev, __s32 val);
>   static int sd_getcomptarget(struct gspca_dev *gspca_dev, __s32 *val);
> +static int sd_setlamps(struct gspca_dev *gspca_dev, __s32 val);
> +static int sd_getlamps(struct gspca_dev *gspca_dev, __s32 *val);
>
>   static const struct ctrl sd_ctrls[] = {
>   	{
> @@ -447,6 +449,20 @@
>   		.set = sd_setcomptarget,
>   		.get = sd_getcomptarget,
>   	},
> +	{
> +		{
> +#define V4L2_CID_LAMPS (V4L2_CID_PRIVATE_BASE+1)
> +			.id	 = V4L2_CID_LAMPS,
> +			.type    = V4L2_CTRL_TYPE_MENU,
> +			.name    = "Lamps",
> +			.minimum = 0,
> +			.maximum = 3,
> +			.step    = 1,
> +			.default_value = 0,
> +		},
> +		.set = sd_setlamps,
> +		.get = sd_getlamps,
> +	},
>   };
>
>   static const struct v4l2_pix_format mode[] = {
> @@ -766,8 +782,8 @@
>   	params->compressionTarget.targetQ = 5; /* From windows driver */
>
>   	params->qx3.qx3_detected = 0;
> -	params->qx3.toplight = 0;
> -	params->qx3.bottomlight = 0;
> +	params->qx3.toplamp = 0;
> +	params->qx3.bottomlamp = 0;
>   	params->qx3.button = 0;
>   	params->qx3.cradled = 0;
>   }
> @@ -1059,17 +1075,16 @@
>   			  0, sd->params.streamStartLine, 0, 0);
>   }
>
> -#if 0 /* Currently unused */ /* keep */
> -static int command_setlights(struct gspca_dev *gspca_dev)
> +static int command_setlamps(struct gspca_dev *gspca_dev)
>   {
>   	struct sd *sd = (struct sd *) gspca_dev;
> -	int ret, p1, p2;
> +	int ret, p;
>
>   	if (!sd->params.qx3.qx3_detected)
>   		return 0;
>
> -	p1 = (sd->params.qx3.bottomlight == 0)<<  1;
> -	p2 = (sd->params.qx3.toplight == 0)<<  3;
> +	p  = (sd->params.qx3.toplamp    == 0) ? 0x8 : 0;
> +	p |= (sd->params.qx3.bottomlamp == 0) ? 0x2 : 0;
>
>   	ret = do_command(gspca_dev, CPIA_COMMAND_WriteVCReg,
>   			 0x90, 0x8F, 0x50, 0);
> @@ -1077,9 +1092,8 @@
>   		return ret;
>
>   	return do_command(gspca_dev, CPIA_COMMAND_WriteMCPort, 2, 0,
> -			  p1 | p2 | 0xE0, 0);
> +			  p | 0xE0, 0);
>   }
> -#endif
>
>   static int set_flicker(struct gspca_dev *gspca_dev, int on, int apply)
>   {
> @@ -1932,6 +1946,27 @@
>   	return 0;
>   }
>
> +static int sd_setlamps(struct gspca_dev *gspca_dev, __s32 val)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +
> +	sd->params.qx3.toplamp    = (val&  0x2) ? 1 : 0;
> +	sd->params.qx3.bottomlamp = (val&  0x1) ? 1 : 0;
> +
> +	if (sd->params.qx3.qx3_detected)
> +		return command_setlamps(gspca_dev);
> +
> +	return 0;
> +}
> +
> +static int sd_getlamps(struct gspca_dev *gspca_dev, __s32 *val)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +
> +	*val = (sd->params.qx3.toplamp<<  1) | (sd->params.qx3.bottomlamp<<  0);
> +	return 0;
> +}
> +
>   static int sd_querymenu(struct gspca_dev *gspca_dev,
>   			struct v4l2_querymenu *menu)
>   {
> @@ -1959,6 +1994,22 @@
>   			return 0;
>   		}
>   		break;
> +	case V4L2_CID_LAMPS:
> +		switch (menu->index) {
> +		case 0:
> +			strcpy((char *) menu->name, "Off");
> +			return 0;
> +		case 1:
> +			strcpy((char *) menu->name, "Bottom");
> +			return 0;
> +		case 2:
> +			strcpy((char *) menu->name, "Top");
> +			return 0;
> +		case 3:
> +			strcpy((char *) menu->name, "Both");
> +			return 0;
> +		}
> +		break;
>   	}
>   	return -EINVAL;
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
