Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0DES0o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Apr 2010 14:26:44 -0400
Message-ID: <4BBA2B58.4000007@redhat.com>
Date: Mon, 05 Apr 2010 15:26:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] V4L/DVB: Use custom I2C probing function mechanism
References: <20100404161454.0f99cc06@hyperion.delvare>
In-Reply-To: <20100404161454.0f99cc06@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Jean Delvare wrote:
> Now that i2c-core offers the possibility to provide custom probing
> function for I2C devices, let's make use of it.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> I wasn't too sure where to put the custom probe function: in each driver,
> in the ir-common module or in the v4l2-common module. I went for the
> second option as a middle ground, but am ready to discuss it if anyone
> objects.

Please, don't add new things at ir-common module. It basically contains the
decoding functions for RC5 and pulse/distance, plus several IR keymaps. With
the IR rework I'm doing, this module will go away, after having all the current 
IR decoders implemented via ir-raw-input binding. 

The keymaps were already removed from it, on my experimental tree 
(http://git.linuxtv.org/mchehab/ir.git), and rc5 decoder is already written
(but still needs a few fixes). 

The new ir-core is creating an abstract way to deal with Remote Controllers,
meant to be used not only by IR's, but also for other types of RC, like, 
bluetooth and USB HID. It will also export a raw event interface, for use
with lirc. As this is the core of the RC subsystem, a i2c-specific binding
method also doesn't seem to belong there. SO, IMO, the better place is to add 
it as a static inline function at ir-kbd-i2c.h.


> 
>  drivers/media/IR/ir-functions.c           |   12 ++++++++++++
>  drivers/media/video/cx23885/cx23885-i2c.c |   14 +++-----------
>  drivers/media/video/cx88/cx88-i2c.c       |   18 +++---------------
>  include/media/ir-common.h                 |    5 +++++
>  4 files changed, 23 insertions(+), 26 deletions(-)
> 
> --- linux-2.6.34-rc3.orig/drivers/media/video/cx23885/cx23885-i2c.c	2010-04-04 09:06:38.000000000 +0200
> +++ linux-2.6.34-rc3/drivers/media/video/cx23885/cx23885-i2c.c	2010-04-04 13:34:34.000000000 +0200
> @@ -28,6 +28,7 @@
>  #include "cx23885.h"
>  
>  #include <media/v4l2-common.h>
> +#include <media/ir-common.h>
>  
>  static unsigned int i2c_debug;
>  module_param(i2c_debug, int, 0644);
> @@ -365,17 +366,8 @@ int cx23885_i2c_register(struct cx23885_
>  
>  		memset(&info, 0, sizeof(struct i2c_board_info));
>  		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> -		/*
> -		 * We can't call i2c_new_probed_device() because it uses
> -		 * quick writes for probing and the IR receiver device only
> -		 * replies to reads.
> -		 */
> -		if (i2c_smbus_xfer(&bus->i2c_adap, addr_list[0], 0,
> -				   I2C_SMBUS_READ, 0, I2C_SMBUS_QUICK,
> -				   NULL) >= 0) {
> -			info.addr = addr_list[0];
> -			i2c_new_device(&bus->i2c_adap, &info);
> -		}
> +		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list,
> +				      ir_i2c_probe);
>  	}
>  
>  	return bus->i2c_rc;
> --- linux-2.6.34-rc3.orig/drivers/media/video/cx88/cx88-i2c.c	2010-04-04 09:06:38.000000000 +0200
> +++ linux-2.6.34-rc3/drivers/media/video/cx88/cx88-i2c.c	2010-04-04 13:34:34.000000000 +0200
> @@ -34,6 +34,7 @@
>  
>  #include "cx88.h"
>  #include <media/v4l2-common.h>
> +#include <media/ir-common.h>
>  
>  static unsigned int i2c_debug;
>  module_param(i2c_debug, int, 0644);
> @@ -188,24 +189,11 @@ int cx88_i2c_init(struct cx88_core *core
>  			0x18, 0x6b, 0x71,
>  			I2C_CLIENT_END
>  		};
> -		const unsigned short *addrp;
>  
>  		memset(&info, 0, sizeof(struct i2c_board_info));
>  		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> -		/*
> -		 * We can't call i2c_new_probed_device() because it uses
> -		 * quick writes for probing and at least some R receiver
> -		 * devices only reply to reads.
> -		 */
> -		for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
> -			if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
> -					   I2C_SMBUS_READ, 0,
> -					   I2C_SMBUS_QUICK, NULL) >= 0) {
> -				info.addr = *addrp;
> -				i2c_new_device(&core->i2c_adap, &info);
> -				break;
> -			}
> -		}
> +		i2c_new_probed_device(&core->i2c_adap, &info, addr_list,
> +				      ir_i2c_probe);
>  	}
>  	return core->i2c_rc;
>  }
> --- linux-2.6.34-rc3.orig/drivers/media/IR/ir-functions.c	2010-03-18 17:06:30.000000000 +0100
> +++ linux-2.6.34-rc3/drivers/media/IR/ir-functions.c	2010-04-04 14:30:29.000000000 +0200
> @@ -23,6 +23,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/jiffies.h>
> +#include <linux/i2c.h>
>  #include <media/ir-common.h>
>  
>  /* -------------------------------------------------------------------------- */
> @@ -353,3 +354,14 @@ void ir_rc5_timer_keyup(unsigned long da
>  	ir_input_nokey(ir->dev, &ir->ir);
>  }
>  EXPORT_SYMBOL_GPL(ir_rc5_timer_keyup);
> +
> +/* Some functions only needed for I2C devices */
> +#if defined CONFIG_I2C || defined CONFIG_I2C_MODULE
> +/* use quick read command for probe, some IR chips don't support writes */
> +int ir_i2c_probe(struct i2c_adapter *i2c, unsigned short addr)
> +{
> +	return i2c_smbus_xfer(i2c, addr, 0, I2C_SMBUS_READ, 0,
> +			      I2C_SMBUS_QUICK, NULL) >= 0;
> +}
> +EXPORT_SYMBOL_GPL(ir_i2c_probe);
> +#endif
> --- linux-2.6.34-rc3.orig/include/media/ir-common.h	2010-03-18 17:06:30.000000000 +0100
> +++ linux-2.6.34-rc3/include/media/ir-common.h	2010-04-04 14:29:54.000000000 +0200
> @@ -97,6 +97,11 @@ u32  ir_rc5_decode(unsigned int code);
>  void ir_rc5_timer_end(unsigned long data);
>  void ir_rc5_timer_keyup(unsigned long data);
>  
> +#if defined CONFIG_I2C || defined CONFIG_I2C_MODULE
> +struct i2c_adapter;
> +int ir_i2c_probe(struct i2c_adapter *i2c, unsigned short addr);
> +#endif
> +
>  /* scancode->keycode map tables from ir-keymaps.c */
>  
>  extern struct ir_scancode_table ir_codes_empty_table;
> 
> 


-- 

Cheers,
Mauro
