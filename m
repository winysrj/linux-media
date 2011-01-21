Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AUEv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 23:51:57 -0500
Date: Thu, 20 Jan 2011 23:51:19 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>, Mike Isely <isely@isely.net>
Subject: Re: [PATCH 3/3] ir-kbd-i2c: improve remote behavior with z8 behind
 usb
Message-ID: <20110121045119.GA14446@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
 <1295584225-21210-4-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295584225-21210-4-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

D'oh, butchered Mike's last name (and domain name), apologies...

On Thu, Jan 20, 2011 at 11:30:25PM -0500, Jarod Wilson wrote:
> Add the same "are you ready?" i2c_master_send() poll command to
> get_key_haup_xvr found in lirc_zilog, which is apparently seen in
> the Windows driver for the PVR-150 w/a z8. This stabilizes what is
> received from both the HD-PVR and HVR-1950, even with their polling
> intervals at the default of 100, thus the removal of the custom
> 260ms polling_interval in pvrusb2-i2c-core.c.
> 
> CC: Andy Walls <awalls@md.metrocast.net>
> CC: Mike Isely <isely@isely.net>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
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
> -- 
> 1.7.3.4
> 

-- 
Jarod Wilson
jarod@redhat.com

