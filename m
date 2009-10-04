Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:59241 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbZJDIzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 04:55:20 -0400
Date: Sun, 4 Oct 2009 10:54:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116  for newer kernels
Message-ID: <20091004105429.234acbc1@hyperion.delvare>
In-Reply-To: <1254584660.3169.25.camel@palomino.walls.org>
References: <1254584660.3169.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sat, 03 Oct 2009 11:44:20 -0400, Andy Walls wrote:
> Aleksandr and Jean,
> 
> Zdrastvoitye & Bonjour,
> 
> To support the AVerMedia M166's IR microcontroller in ivtv and
> ir-kbd-i2c with the new i2c binding model, I have added 3 changesets in
> 
> 	http://linuxtv.org/hg/~awalls/ivtv
> 
> 01/03: ivtv: Defer legacy I2C IR probing until after setup of known I2C devices
> http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=3d243437f046
> 
> 02/03: ivtv: Add explicit IR controller initialization for the AVerTV M116
> http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=0127ed2ea55b
> 
> 03/03: ir-kbd-i2c: Add support for the AVerTV M116 with the new binding model
> http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=c10e0d5d895c
> 
> 
>  ir-kbd-i2c.c       |    1 
>  ivtv/ivtv-cards.c  |    3 -
>  ivtv/ivtv-cards.h  |   35 +++++++-------
>  ivtv/ivtv-driver.c |    3 +
>  ivtv/ivtv-i2c.c    |  128 ++++++++++++++++++++++++++++++++++++++---------------
>  ivtv/ivtv-i2c.h    |    1 
>  6 files changed, 118 insertions(+), 53 deletions(-)
> 
> I cannot really test them as I still am using an older kernel.  Could
> you please review, and test them if possible?

I can't test as I don't have the hardware. But have reviewed your code.

> Change 01/03 actually fixes a problem I inadvertantly let slip by for
> ivtv in newer kernels, because I missed it in my initial review.  In
> ivtv, we should really only do IR chip probing after all other known I2C
> devices on a card are registered.

Conceptually this sounds totally right, indeed. I think this could even
be improved, by skipping IR device probing altogether if a known IR
device has already instantiated. Something like:

#define IVTV_HW_IR_ANY	(IVTV_HW_EM78P153S_IR_RX_AVER)

	/* probe for legacy IR controllers that aren't in card definitions */
	if (!(ivtv->card->hw_all & IVTV_HW_IR_ANY))
		ivtv_i2c_new_ir_legacy(itv);

Comments on the code itself:

Patch #1:

> --- a/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Sep 26 13:45:03 2009 -0300
> +++ b/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Oct 03 10:28:55 2009 -0400
> @@ -153,6 +153,45 @@
>  	"gpio",
>  };
>  
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> +/* Instantiate the IR receiver device using probing -- undesirable */
> +int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> +{
> +	struct i2c_board_info info;
> +	/*
> +	 * The external IR receiver is at i2c address 0x34.
> +	 * The internal IR receiver is at i2c address 0x30.
> +	 *
> +	 * In theory, both can be fitted, and Hauppauge suggests an external
> +	 * overrides an internal.  That's why we probe 0x1a (~0x34) first. CB
> +	 *
> +	 * Some of these addresses we probe may collide with other i2c address
> +	 * allocations, so this function must be called after all other i2c
> +	 * devices we care about are registered.
> +	 */
> +	const unsigned short addr_list[] = {
> +		0x1a,	/* Hauppauge IR external - collides with WM8739 */
> +		0x18,	/* Hauppauge IR internal */
> +		0x71,	/* Hauppauge IR (PVR150) */
> +		0x64,	/* Pixelview IR */
> +		0x30,	/* KNC ONE IR */
> +		0x6b,	/* Adaptec IR */
> +		I2C_CLIENT_END
> +	};
> +
> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> +	return i2c_new_probed_device(&itv->i2c_adap, &info, addr_list) == NULL
> +								       ? -1 : 0;

Why don't you just return the i2c client instead? This is less work,
and you don't use the returned value currently anyway.

> +}
> +#else
> +int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> +{
> +	/* ir-kbd-i2c does the legacy I2C IR controller probe for old kernels*/

Missing space before end of comment.

> +	return -1;
> +}
> +#endif
> +
>  int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
>  {
>  	struct v4l2_subdev *sd;

Patch #2:

> # HG changeset patch
> # User Andy Walls <awalls@radix.net>
> # Date 1254583380 14400
> # Node ID 0127ed2ea55b215cc17660a698a19ac990117a46
> # Parent  3d243437f04695220d92a0e906f287968e56d328
> ivtv: Add explicit IR controller initialization for the AVerTV M116
> 
> From: Andy Walls <awalls@radix.net>
> 
> Priority: normal
> 
> Signed-off-by: Andy Walls <awalls@radix.net>
> 
> --- a/linux/drivers/media/video/ivtv/ivtv-cards.c	Sat Oct 03 10:28:55 2009 -0400
> +++ b/linux/drivers/media/video/ivtv/ivtv-cards.c	Sat Oct 03 11:23:00 2009 -0400
> @@ -955,7 +955,8 @@
>  	.hw_video = IVTV_HW_CX25840,
>  	.hw_audio = IVTV_HW_CX25840,
>  	.hw_audio_ctrl = IVTV_HW_CX25840,
> -	.hw_all = IVTV_HW_CX25840 | IVTV_HW_TUNER | IVTV_HW_WM8739,
> +	.hw_all = IVTV_HW_CX25840 | IVTV_HW_TUNER | IVTV_HW_WM8739 |
> +		  IVTV_HW_EM78P153S_IR_RX_AVER,
>  	.video_inputs = {
>  		{ IVTV_CARD_INPUT_VID_TUNER,  0, CX25840_COMPOSITE2 },
>  		{ IVTV_CARD_INPUT_SVIDEO1,    1, CX25840_SVIDEO3    },
> --- a/linux/drivers/media/video/ivtv/ivtv-cards.h	Sat Oct 03 10:28:55 2009 -0400
> +++ b/linux/drivers/media/video/ivtv/ivtv-cards.h	Sat Oct 03 11:23:00 2009 -0400
> @@ -87,23 +87,24 @@
>  #define IVTV_PCI_ID_GOTVIEW1		0xffac
>  #define IVTV_PCI_ID_GOTVIEW2 		0xffad
>  
> -/* hardware flags, no gaps allowed, IVTV_HW_GPIO must always be last */
> -#define IVTV_HW_CX25840   (1 << 0)
> -#define IVTV_HW_SAA7115   (1 << 1)
> -#define IVTV_HW_SAA7127   (1 << 2)
> -#define IVTV_HW_MSP34XX   (1 << 3)
> -#define IVTV_HW_TUNER     (1 << 4)
> -#define IVTV_HW_WM8775    (1 << 5)
> -#define IVTV_HW_CS53L32A  (1 << 6)
> -#define IVTV_HW_TVEEPROM  (1 << 7)
> -#define IVTV_HW_SAA7114   (1 << 8)
> -#define IVTV_HW_UPD64031A (1 << 9)
> -#define IVTV_HW_UPD6408X  (1 << 10)
> -#define IVTV_HW_SAA717X   (1 << 11)
> -#define IVTV_HW_WM8739    (1 << 12)
> -#define IVTV_HW_VP27SMPX  (1 << 13)
> -#define IVTV_HW_M52790    (1 << 14)
> -#define IVTV_HW_GPIO      (1 << 15)
> +/* hardware flags, no gaps allowed */
> +#define IVTV_HW_CX25840			(1 << 0)
> +#define IVTV_HW_SAA7115			(1 << 1)
> +#define IVTV_HW_SAA7127			(1 << 2)
> +#define IVTV_HW_MSP34XX			(1 << 3)
> +#define IVTV_HW_TUNER			(1 << 4)
> +#define IVTV_HW_WM8775			(1 << 5)
> +#define IVTV_HW_CS53L32A		(1 << 6)
> +#define IVTV_HW_TVEEPROM		(1 << 7)
> +#define IVTV_HW_SAA7114			(1 << 8)
> +#define IVTV_HW_UPD64031A		(1 << 9)
> +#define IVTV_HW_UPD6408X		(1 << 10)
> +#define IVTV_HW_SAA717X			(1 << 11)
> +#define IVTV_HW_WM8739			(1 << 12)
> +#define IVTV_HW_VP27SMPX		(1 << 13)
> +#define IVTV_HW_M52790			(1 << 14)
> +#define IVTV_HW_GPIO			(1 << 15)
> +#define IVTV_HW_EM78P153S_IR_RX_AVER	(1 << 16)
>  
>  #define IVTV_HW_SAA711X   (IVTV_HW_SAA7115 | IVTV_HW_SAA7114)
>  
> --- a/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Oct 03 10:28:55 2009 -0400
> +++ b/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Oct 03 11:23:00 2009 -0400
> @@ -63,6 +63,9 @@
>  #include "ivtv-cards.h"
>  #include "ivtv-gpio.h"
>  #include "ivtv-i2c.h"
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> +#include <media/ir-kbd-i2c.h>
> +#endif
>  
>  /* i2c implementation for cx23415/6 chip, ivtv project.
>   * Author: Kevin Thayer (nufan_wfk at yahoo.com)
> @@ -88,6 +91,7 @@
>  #define IVTV_UPD64083_I2C_ADDR 		0x5c
>  #define IVTV_VP27SMPX_I2C_ADDR      	0x5b
>  #define IVTV_M52790_I2C_ADDR      	0x48
> +#define IVTV_EM78P153S_IR_RX_I2C_ADDR	0x40
>  
>  /* This array should match the IVTV_HW_ defines */
>  static const u8 hw_addrs[] = {
> @@ -106,7 +110,8 @@
>  	IVTV_WM8739_I2C_ADDR,
>  	IVTV_VP27SMPX_I2C_ADDR,
>  	IVTV_M52790_I2C_ADDR,
> -	0 		/* IVTV_HW_GPIO dummy driver ID */
> +	0,				/* IVTV_HW_GPIO dummy driver ID */
> +	IVTV_EM78P153S_IR_RX_I2C_ADDR	/* IVTV_HW_EM78P153S_IR_RX_AVER */
>  };

I suspect Hans put the GPIO at the end on purpose, I'm not sure why you
want to change this? It makes your patch slightly larger.

>  
>  /* This array should match the IVTV_HW_ defines */
> @@ -126,7 +131,8 @@
>  	"wm8739",
>  	"vp27smpx",
>  	"m52790",
> -	NULL
> +	NULL,
> +	NULL		/* IVTV_HW_EM78P153S_IR_RX_AVER */
>  };
>  
>  /* This array should match the IVTV_HW_ defines */
> @@ -151,9 +157,38 @@
>  	"vp27smpx",
>  	"m52790",
>  	"gpio",
> +	"ir_rx_em78p153s_aver",

This exceeds the maximum length for I2C client names (19 chars max.) So
your patch won't work. I could make the name field slightly larger (say
23 chars) if really needed, but I'd rather have you simply use shorter
names.

>  };
>  
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> +static const struct IR_i2c_init_data em78p153s_aver_ir_init_data = {
> +	.ir_codes = &ir_codes_avermedia_cardbus_table,
> +	.internal_get_key_func = IR_KBD_GET_KEY_AVERMEDIA_CARDBUS,
> +	.type = IR_TYPE_OTHER,
> +	.name = "ivtv-CX23416 EM78P153S AVerMedia",
> +};
> +
> +static int ivtv_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
> +			   u8 addr)
> +{
> +	struct i2c_board_info info;
> +	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
> +
> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, type, I2C_NAME_SIZE);
> +
> +	/* Our default information for ir-kbd-i2c.c to use */
> +	switch (hw) {
> +	case IVTV_HW_EM78P153S_IR_RX_AVER:
> +		info.platform_data = (void *) &em78p153s_aver_ir_init_data;

Useless cast. You never need to cast to void *.

> +		break;
> +	default:
> +		break;

Useless statement.

> +	}
> +
> +	return i2c_new_probed_device(adap, &info, addr_list) == NULL ? -1 : 0;

I don't really get why you use i2c_new_probed_device() instead of the
cheaper i2c_new_device(). Are you not 100% certain that the IR device
is present on this model?

> +}
> +
>  /* Instantiate the IR receiver device using probing -- undesirable */
>  int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
>  {
> @@ -185,9 +220,15 @@
>  								       ? -1 : 0;
>  }
>  #else
> +/* ir-kbd-i2c does the legacy I2C IR controller probe for old kernels*/

Missing space at end of comment.

> +static int ivtv_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
> +			   u8 addr)
> +{
> +	return -1;
> +}
> +
>  int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
>  {
> -	/* ir-kbd-i2c does the legacy I2C IR controller probe for old kernels*/
>  	return -1;
>  }
>  #endif
> @@ -221,8 +262,15 @@
>  			sd->grp_id = 1 << idx;
>  		return sd ? 0 : -1;
>  	}
> +
> +	if (hw & IVTV_HW_EM78P153S_IR_RX_AVER)

Maybe use IVTV_HW_IR_ANY as I defined earlier? Otherwise you'll have to
modify the code with each new remote control you add.

> +		return ivtv_i2c_new_ir(adap, hw, type, hw_addrs[idx]);
> +
> +	/* Is it not an I2C device or one we do not wish to register? */
>  	if (!hw_addrs[idx])
>  		return -1;
> +
> +	/* It's an I2C device other than an analog tuner or IR chip */
>  	if (hw == IVTV_HW_UPD64031A || hw == IVTV_HW_UPD6408X) {
>  		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
>  				adap, mod, type, 0, I2C_ADDRS(hw_addrs[idx]));

Patch #3.

> --- a/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:23:00 2009 -0400
> +++ b/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:27:19 2009 -0400
> @@ -730,6 +730,7 @@
>  	{ "ir_video", 0 },
>  	/* IR device specific entries should be added here */
>  	{ "ir_rx_z8f0811_haup", 0 },
> +	{ "ir_rx_em78p153s_aver", 0 },
>  	{ }
>  };
>  

I think we need to discuss this. I don't really see the point of adding
new entries if the ir-kbd-i2c driver doesn't do anything about it. This
makes device probing slower with no benefit. As long as you pass device
information with all the details, the ir-kbd-i2c driver won't care
about the device name.

So the question is, where are we going with the ir-kbd-i2c driver? Are
we happy with the current model where bridge drivers pass IR device
information? Or do we want to move to a model where they just pass a
device name and ir-kbd-i2c maps names to device information? In the
latter case, it makes sense to have many i2c_device_id entries in
ir-kbd-i2c, but in the former case it doesn't.

I guess the answer depends in part on how common IR devices and remote
controls are across adapters. If the same IR device is used on many
adapters then it makes some sense to move the definitions into
ir-kbd-i2c. But if devices are heavily adapter-dependent, and moving
the definitions into ir-kbd-i2c doesn't allow for any code refactoring,
then I don't quite see the point.

-- 
Jean Delvare
