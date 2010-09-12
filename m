Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0ILH2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 03:28:54 -0400
Message-ID: <4C8C8127.9000707@redhat.com>
Date: Sun, 12 Sep 2010 09:28:39 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 3/3] gspca_cpia1: Restore QX3 illuminators' state on resume
References: <1284256281.2030.20.camel@morgan.silverblock.net>
In-Reply-To: <1284256281.2030.20.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/12/2010 03:51 AM, Andy Walls wrote:
> gspca_cpia1: Restore QX3 illuminators' state on resume
>
> Turn the lights of the QX3 on (or off) as needed when resuming and at module
> load.
>
> Signed-off-by: Andy Walls<awalls@md.metrocast.net>
>
> diff -r 32d5c323c541 -r c2e7fb2d768e linux/drivers/media/video/gspca/cpia1.c
> --- a/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 21:15:03 2010 -0400
> +++ b/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 21:32:35 2010 -0400
> @@ -1772,6 +1772,10 @@
>   	if (ret)
>   		return ret;
>
> +	/* Ensure the QX3 illuminators' states are restored upon resume */
> +	if (sd->params.qx3.qx3_detected)
> +		command_setlights(gspca_dev);
> +
>   	sd_stopN(gspca_dev);
>
>   	if (!sd->params.qx3.qx3_detected)


Notice the:

	if (sd->params.qx3.qx3_detected)
		command_setlights(gspca_dev);

    	sd_stopN(gspca_dev);

	if (!sd->params.qx3.qx3_detected)
		....

Given that at least the order of execution of the second if statement
does not matter wrt to the sd_stopN(gspca_dev), can we please
make this:

	if (sd->params.qx3.qx3_detected)
		command_setlights(gspca_dev);
	else
		....

    	sd_stopN(gspca_dev);

Thanks,

Hans
