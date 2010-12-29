Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:30653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0L2LNF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 06:13:05 -0500
Message-ID: <4D1B17A1.1010803@redhat.com>
Date: Wed, 29 Dec 2010 09:12:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 2/3] ir-kbd-i2c: Add HD PVR IR Rx support to ir-kbd-i2c
References: <1293587067.3098.10.camel@localhost> <1293587266.3098.14.camel@localhost>
In-Reply-To: <1293587266.3098.14.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 28-12-2010 23:47, Andy Walls escreveu:
> 
> Add HD PVR IR Rx support to ir-kbd-i2c

Hmm... I know nothing about the hardware designs used on hd-pvr, but
it seems wrong to have both lirc-zilog and ir-kbd-i2c registering for
RX for the same device.

There are variants with hd-pvr that uses ir-kbd-i2c and others
that use another I2C chipset? Or, for some versions of Z8, the RX logic
is identical to the one provided by ir-kbd-i2c?

> 
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> 
> ---
>  drivers/media/video/ir-kbd-i2c.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index dd54c3d..c87b6bc 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -449,6 +449,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
>  	{ "ir_video", 0 },
>  	/* IR device specific entries should be added here */
>  	{ "ir_rx_z8f0811_haup", 0 },
> +	{ "ir_rx_z8f0811_hdpvr", 0 },
>  	{ }
>  };
>  

