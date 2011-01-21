Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:32918 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab1AUNuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 08:50:16 -0500
Subject: Re: [PATCH 3/3] ir-kbd-i2c: improve remote behavior with z8 behind
 usb
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, Mike Isley <isley@isley.net>
In-Reply-To: <1295584225-21210-4-git-send-email-jarod@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
	 <1295584225-21210-4-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 08:50:53 -0500
Message-ID: <1295617853.2114.46.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-01-20 at 23:30 -0500, Jarod Wilson wrote:
> Add the same "are you ready?" i2c_master_send() poll command to
> get_key_haup_xvr found in lirc_zilog, which is apparently seen in
> the Windows driver for the PVR-150 w/a z8. This stabilizes what is
> received from both the HD-PVR and HVR-1950, even with their polling
> intervals at the default of 100, thus the removal of the custom
> 260ms polling_interval in pvrusb2-i2c-core.c.
> 
> CC: Andy Walls <awalls@md.metrocast.net>
> CC: Mike Isley <isley@isley.net>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

I haven't tested it, but it looks good.

The only thing to worry about is accidentally writing a 0 to register 0
at address 0x71 and maybe losing an Rx button press.  (However, for that
to happen, the Z8 would have already screwed up in its role of an I2C
slave anyway, or the I2C master did not honor the Z8's clock stretches.)

Since it makes things better and lirc_zilog already does it anyway...

Acked-by: Andy Walls <awalls@md.metrocast.net>

> ---
>  drivers/media/video/ir-kbd-i2c.c               |   13 +++++++++++++
>  drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    1 -
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index d2b20ad..a221ad6 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -128,6 +128,19 @@ static int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  
>  static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  {
> +	int ret;
> +	unsigned char buf[1] = { 0 };
> +
> +	/*
> +	 * This is the same apparent "are you ready?" poll command observed
> +	 * watching Windows driver traffic and implemented in lirc_zilog. With
> +	 * this added, we get far saner remote behavior with z8 chips on usb
> +	 * connected devices, even with the default polling interval of 100ms.
> +	 */
> +	ret = i2c_master_send(ir->c, buf, 1);
> +	if (ret != 1)
> +		return (ret < 0) ? ret : -EINVAL;
> +
>  	return get_key_haup_common (ir, ir_key, ir_raw, 6, 3);
>  }
>  
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> index ccc8849..451ecd4 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
> @@ -597,7 +597,6 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
>  		init_data->type                  = RC_TYPE_RC5;
>  		init_data->name                  = hdw->hdw_desc->description;
> -		init_data->polling_interval      = 260; /* ms From lirc_zilog */
>  		/* IR Receiver */
>  		info.addr          = 0x71;
>  		info.platform_data = init_data;


