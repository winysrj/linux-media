Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0ILH0h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 03:26:37 -0400
Message-ID: <4C8C80A0.1060606@redhat.com>
Date: Sun, 12 Sep 2010 09:26:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 2/3] gspca_cpia1: Disable illuminator controls if not
 an Intel Play QX3
References: <1284256276.2030.19.camel@morgan.silverblock.net>
In-Reply-To: <1284256276.2030.19.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/12/2010 03:51 AM, Andy Walls wrote:
> gspca_cpia1: Disable illuminator controls if not an Intel Play QX3
>
> The illuminator controls should only be available to the user for the Intel
> Play QX3 microscope.
>
> Signed-off-by: Andy Walls<awalls@md.metrocast.net>
>
> diff -r d165649ca8a0 -r 32d5c323c541 linux/drivers/media/video/gspca/cpia1.c
> --- a/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 14:15:26 2010 -0400
> +++ b/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 21:15:03 2010 -0400
> @@ -1743,6 +1743,22 @@
>   	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
>   }
>
> +static void sd_disable_qx3_ctrls(struct gspca_dev *gspca_dev)
> +{
> +	int i, n;
> +	__u32 id;
> +
> +	n = ARRAY_SIZE(sd_ctrls);
> +	for (i = 0; i<  n; i++) {
> +		id = sd_ctrls[i].qctrl.id;
> +
> +		if (id == V4L2_CID_ILLUMINATORS_1 ||
> +		    id == V4L2_CID_ILLUMINATORS_2) {
> +			gspca_dev->ctrl_dis |= (1<<  i);
> +		}
> +	}
> +}
> +
>   /* this function is called at probe and resume time */
>   static int sd_init(struct gspca_dev *gspca_dev)
>   {

Hmm, this deviates from how all other gspca subdrivers do this, they
define indexes for ctrls together with the sd_ctrls intializer and
then use these, so instead of the above blurb there would be
a

#define ILLUMINATORS_1_IDX x
#define ILLUMINATORS_2_IDX x

Where these ctrls get "defined" (see for example ov519.c)

And then:

> +	if (!sd->params.qx3.qx3_detected)
> +		sd_disable_qx3_ctrls(gspca_dev);
> +

Would become:

	if (!sd->params.qx3.qx3_detected)
		gspca_dev->ctrl_dis |= (1 << ILLUMINATORS_1_IDX) |
				       (1 << ILLUMINATORS_2_IDX);

I think it would be good to use the same construction in the cpia1
driver for consistency between all the gspca subdrivers.

Regards,

Hans

