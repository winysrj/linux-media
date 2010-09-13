Return-path: <mchehab@localhost.localdomain>
Received: from mx1.redhat.com ([209.132.183.28]:36590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0IMHSg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 03:18:36 -0400
Message-ID: <4C8DD041.4010207@redhat.com>
Date: Mon, 13 Sep 2010 09:18:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH v2 2/3] gspca_cpia1: Restore QX3 illuminators' state on
 resume
References: <1284313518.2027.31.camel@morgan.silverblock.net>
In-Reply-To: <1284313518.2027.31.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Ack!

Acked-by: Hans de Goede <hdegoede@redhat.com>


On 09/12/2010 07:45 PM, Andy Walls wrote:
> Turn the lights of the QX3 on (or off) as needed when resuming and at module
> load.
>
> Signed-off-by: Andy Walls<awalls@md.metrocast.net>
>
> diff -r f09faf8dd85d -r 5e576066eeaf linux/drivers/media/video/gspca/cpia1.c
> --- a/linux/drivers/media/video/gspca/cpia1.c	Sun Sep 12 12:43:45 2010 -0400
> +++ b/linux/drivers/media/video/gspca/cpia1.c	Sun Sep 12 12:47:00 2010 -0400
> @@ -1756,6 +1756,10 @@
>   	if (ret)
>   		return ret;
>
> +	/* Ensure the QX3 illuminators' states are restored upon resume */
> +	if (sd->params.qx3.qx3_detected)
> +		command_setlights(gspca_dev);
> +
>   	sd_stopN(gspca_dev);
>
>   	PDEBUG(D_PROBE, "CPIA Version:             %d.%02d (%d.%d)",
>
>
>
>
>
>
>
