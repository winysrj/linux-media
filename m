Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0DIEJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 00:09:21 -0400
Message-ID: <4BBEA864.9090702@redhat.com>
Date: Fri, 09 Apr 2010 01:09:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] V4L/DVB: Use custom I2C probing function mechanism
References: <20100404161454.0f99cc06@hyperion.delvare>	<4BBA2B58.4000007@redhat.com>	<20100405230616.443792ac@hyperion.delvare>	<4BBAC7F6.5030807@redhat.com> <20100406182511.62894659@hyperion.delvare>
In-Reply-To: <20100406182511.62894659@hyperion.delvare>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> Hi Mauro,
> 
> On Tue, 06 Apr 2010 02:34:46 -0300, Mauro Carvalho Chehab wrote:
>> Jean Delvare wrote:
>>> On Mon, 05 Apr 2010 15:26:32 -0300, Mauro Carvalho Chehab wrote:
>>>> Please, don't add new things at ir-common module. It basically contains the
>>>> decoding functions for RC5 and pulse/distance, plus several IR keymaps. With
>>>> the IR rework I'm doing, this module will go away, after having all the current 
>>>> IR decoders implemented via ir-raw-input binding. 
>>>>
>>>> The keymaps were already removed from it, on my experimental tree 
>>>> (http://git.linuxtv.org/mchehab/ir.git), and rc5 decoder is already written
>>>> (but still needs a few fixes). 
>>>>
>>>> The new ir-core is creating an abstract way to deal with Remote Controllers,
>>>> meant to be used not only by IR's, but also for other types of RC, like, 
>>>> bluetooth and USB HID. It will also export a raw event interface, for use
>>>> with lirc. As this is the core of the RC subsystem, a i2c-specific binding
>>>> method also doesn't seem to belong there. SO, IMO, the better place is to add 
>>>> it as a static inline function at ir-kbd-i2c.h.
>>> Ever tried to pass the address of an inline function as another
>>> function's parameter? :)
>> :) Never tried... maybe gcc would to the hard thing, de-inlining it ;)
>>
>> Well, we need to put this code somewhere. Where are the other probing
>> codes? Probably the better is to put them together.
> 
> There are no other probing functions yet, this is the first one. I have
> added the mechanism to i2c-core for these very IR chips.
> 
> Putting all probe functions together would mean moving them to
> i2c-core. This wasn't my original intent, but after all, it makes some
> sense. Would you be happy with the following?

It seems fine for me. As you're touching on i2c core and on other drivers
on this series, I think that the better is if you could apply it on your
tree.

For both patches 1 and 2:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> * * * * *
> 
> From: Jean Delvare <khali@linux-fr.org>
> Subject: V4L/DVB: Use custom I2C probing function mechanism
> 
> Now that i2c-core offers the possibility to provide custom probing
> function for I2C devices, let's make use of it.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/i2c/i2c-core.c                    |    7 +++++++
>  drivers/media/video/cx23885/cx23885-i2c.c |   15 ++++-----------
>  drivers/media/video/cx88/cx88-i2c.c       |   19 ++++---------------
>  include/linux/i2c.h                       |    3 +++
>  4 files changed, 18 insertions(+), 26 deletions(-)
> 
> --- linux-2.6.34-rc3.orig/drivers/media/video/cx23885/cx23885-i2c.c	2010-04-06 11:31:20.000000000 +0200
> +++ linux-2.6.34-rc3/drivers/media/video/cx23885/cx23885-i2c.c	2010-04-06 12:28:09.000000000 +0200
> @@ -365,17 +365,10 @@ int cx23885_i2c_register(struct cx23885_
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
> +		/* Use quick read command for probe, some IR chips don't
> +		 * support writes */
> +		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list,
> +				      i2c_probe_func_quick_read);
>  	}
>  
>  	return bus->i2c_rc;
> --- linux-2.6.34-rc3.orig/drivers/media/video/cx88/cx88-i2c.c	2010-04-06 11:31:20.000000000 +0200
> +++ linux-2.6.34-rc3/drivers/media/video/cx88/cx88-i2c.c	2010-04-06 12:28:06.000000000 +0200
> @@ -188,24 +188,13 @@ int cx88_i2c_init(struct cx88_core *core
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
> +		/* Use quick read command for probe, some IR chips don't
> +		 * support writes */
> +		i2c_new_probed_device(&core->i2c_adap, &info, addr_list,
> +				      i2c_probe_func_quick_read);
>  	}
>  	return core->i2c_rc;
>  }
> --- linux-2.6.34-rc3.orig/drivers/i2c/i2c-core.c	2010-04-06 10:15:02.000000000 +0200
> +++ linux-2.6.34-rc3/drivers/i2c/i2c-core.c	2010-04-06 12:25:31.000000000 +0200
> @@ -1460,6 +1460,13 @@ static int i2c_default_probe(struct i2c_
>  	return err >= 0;
>  }
>  
> +int i2c_probe_func_quick_read(struct i2c_adapter *i2c, unsigned short addr)
> +{
> +	return i2c_smbus_xfer(i2c, addr, 0, I2C_SMBUS_READ, 0,
> +			      I2C_SMBUS_QUICK, NULL) >= 0;
> +}
> +EXPORT_SYMBOL_GPL(i2c_probe_func_quick_read);
> +
>  struct i2c_client *
>  i2c_new_probed_device(struct i2c_adapter *adap,
>  		      struct i2c_board_info *info,
> --- linux-2.6.34-rc3.orig/include/linux/i2c.h	2010-04-06 10:15:02.000000000 +0200
> +++ linux-2.6.34-rc3/include/linux/i2c.h	2010-04-06 12:26:29.000000000 +0200
> @@ -288,6 +288,9 @@ i2c_new_probed_device(struct i2c_adapter
>  		      unsigned short const *addr_list,
>  		      int (*probe)(struct i2c_adapter *, unsigned short addr));
>  
> +/* common custom probe functions */
> +extern int i2c_probe_func_quick_read(struct i2c_adapter *, unsigned short addr);
> +
>  /* For devices that use several addresses, use i2c_new_dummy() to make
>   * client handles for the extra addresses.
>   */
> 
> 
> 


-- 

Cheers,
Mauro
