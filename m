Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45673 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab0L3Neu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:34:50 -0500
Subject: Re: [PATCH v2] [media] ivtv: Add Adaptec Remote Controller
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D1C839C.3090102@redhat.com>
References: <cover.1293709356.git.mchehab@redhat.com>
	 <20101230094509.2ecbf089@gaivota>  <4D1C839C.3090102@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 08:35:28 -0500
Message-ID: <1293716128.4084.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 2010-12-30 at 11:05 -0200, Mauro Carvalho Chehab wrote:
> >From f4b19dd8ac2d15666975f262cc1bdf461d48e687 Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date: Thu, 30 Dec 2010 09:31:10 -0200
> Subject: [PATCH] [media] ivtv: Add Adaptec Remote Controller
> 
> lirc-i2c implements a get key logic for the Adaptec Remote
> Controller, at address 0x6b. The only driver that seems to have
> an Adaptec device is ivtv:
> 
> $ git grep -i adaptec drivers/media
> drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
> drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
> drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
> drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
> drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
> drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
> drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
> drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
> drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */
> 
> There are two Adaptec cards defined there, but AVC-2010 doesn't have a
> remote controller. So, the logic at lirc_i2c seems to be for Adaptec AVC-2410.
> 
> As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
> use it for AVC-2410.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Nak!

See below...

> ---
> 
> v2: Update comment and add a new entry at hw_devicenames table
> 
> 
> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
> index 6817092..71912ec 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> @@ -94,6 +94,7 @@
>  #define IVTV_HAUP_INT_IR_RX_I2C_ADDR 	0x18
>  #define IVTV_Z8F0811_IR_TX_I2C_ADDR	0x70
>  #define IVTV_Z8F0811_IR_RX_I2C_ADDR	0x71
> +#define IVTV_ADAPTEC_IR			0x6b
>  
>  /* This array should match the IVTV_HW_ defines */
>  static const u8 hw_addrs[] = {
> @@ -118,6 +119,7 @@ static const u8 hw_addrs[] = {
>  	IVTV_HAUP_INT_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_HAUP_INT */
>  	IVTV_Z8F0811_IR_TX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
>  	IVTV_Z8F0811_IR_RX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
> +	IVTV_ADAPTEC_IR,
>  };
>  
>  /* This array should match the IVTV_HW_ defines */
> @@ -143,8 +145,34 @@ static const char * const hw_devicenames[] = {
>  	"ir_video",		/* IVTV_HW_I2C_IR_RX_HAUP_INT */
>  	"ir_tx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
>  	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
> +	"ir_adaptec",
>  };

That won't work.  ir-kbd-i2c.c is only looking to bind with devices
labeled "ir_video" or "ir_rx_z8f0811_haup".


> +static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> +{
> +	unsigned char keybuf[4];
> +
> +	keybuf[0] = 0x00;
> +	i2c_master_send(ir->c, keybuf, 1);
> +	/* poll IR chip */
> +	if (i2c_master_recv(ir->c, keybuf, sizeof(keybuf)) != sizeof(keybuf)) {
> +		return 0;
> +	}
> +
> +	/* key pressed ? */
> +	if (keybuf[2] == 0xff)
> +		return 0;
> +
> +	/* remove repeat bit */
> +	keybuf[2] &= 0x7f;
> +	keybuf[3] |= 0x80;
> +
> +	*ir_key = (u32) keybuf;
> +	*ir_raw = (u32) keybuf;
> +
> +	return 1;
> +}
> +
>  static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  {
>  	struct i2c_board_info info;
> @@ -190,6 +218,12 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  		init_data->type = RC_TYPE_RC5;
>  		init_data->name = itv->card_name;
>  		break;
> +	case IVTV_CARD_AVC2410:

As I mentioned before, that won't work.  Following the function call
chain:

	ivtv-driver.c:ivtv_probe()
		ivtv-driver.c:ivtv_load_and_init_modules()
			ivtv-i2c.c:ivtv_i2c_register(..., idx = i)
				ivtv-i2c.c:ivtv_i2c_new_ir(..., hw = 1 << idx, ...) /* Known card IR configurations */
			ivtv-i2c.c:ivtv_i2c_new_ir_legacy()			    /* Legacy probing for IR chips */
			
The switch on "hw" in ivtv_i2c_new_ir() is switching on these defines at ivtv-cards.h:

        #define IVTV_HW_I2C_IR_RX_AVER          (1 << 16)
        #define IVTV_HW_I2C_IR_RX_HAUP_EXT      (1 << 17) /* External before internal */
        #define IVTV_HW_I2C_IR_RX_HAUP_INT      (1 << 18)
        #define IVTV_HW_Z8F0811_IR_TX_HAUP      (1 << 19)
        #define IVTV_HW_Z8F0811_IR_RX_HAUP      (1 << 20)

You need to add a new one in ivtv-cards.h and fix the Adaptec card entry
in ivtv-cards.c or no probe attempt will even be made for the IR unit on
the Adaptec card.

The switch statement must operate on a bit flag that corresponds to an
I2C device, not "IVTV_CARD_AVC2410", which is en enumerated value for a
card model.

Regards,
Andy
> +		init_data->ir_codes = RC_MAP_EMPTY;
> +		init_data->get_key = get_key_adaptec;
> +		init_data->type = RC_TYPE_UNKNOWN;
> +		init_data->name = itv->card_name;
> +		break;
>  	}
>  
>  	memset(&info, 0, sizeof(struct i2c_board_info));
> @@ -219,7 +253,6 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
>  		0x1a,	/* Hauppauge IR external - collides with WM8739 */
>  		0x18,	/* Hauppauge IR internal */
>  		0x71,	/* Hauppauge IR (PVR150) */
> -		0x6b,	/* Adaptec IR */
>  		I2C_CLIENT_END
>  	};
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


