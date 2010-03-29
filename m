Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:53369 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab0C2PeX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 11:34:23 -0400
Date: Mon, 29 Mar 2010 17:34:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@radix.net>,
	Dmitri Belimov <d.belimov@gmail.com>,
	linux-media@vger.kernel.org, "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: [PATCH] FusionHDTV: Use quick reads for I2C IR device probing
Message-ID: <20100329173420.39c4760b@hyperion.delvare>
In-Reply-To: <20100319144250.5553055c@hyperion.delvare>
References: <20100301153645.5d529766@glory.loctelecom.ru>
	<1267442919.3110.20.camel@palomino.walls.org>
	<20100316120502.3a9323ac@hyperion.delvare>
	<20100319144250.5553055c@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can the fix below please be picked quickly? This is a regression, the
fix should go upstream ASAP. Thanks.

On Fri, 19 Mar 2010 14:42:50 +0100, Jean Delvare wrote:
> IR support on FusionHDTV cards is broken since kernel 2.6.31. One side
> effect of the switch to the standard binding model for IR I2C devices
> was to let i2c-core do the probing instead of the ir-kbd-i2c driver.
> There is a slight difference between the two probe methods: i2c-core
> uses 0-byte writes, while the ir-kbd-i2c was using 0-byte reads. As
> some IR I2C devices only support reads, the new probe method fails to
> detect them.
> 
> For now, revert to letting the driver do the probe, using 0-byte
> reads. In the future, i2c-core will be extended to let callers of
> i2c_new_probed_device() provide a custom probing function.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Tested-by: "Timothy D. Lenz" <tlenz@vorgon.com>
> ---
> This fix applies to kernels 2.6.31 to 2.6.34. Should be sent to Linus
> quickly.
> 
>  drivers/media/video/cx23885/cx23885-i2c.c |   12 +++++++++++-
>  drivers/media/video/cx88/cx88-i2c.c       |   16 +++++++++++++++-
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.34-rc1.orig/drivers/media/video/cx23885/cx23885-i2c.c	2010-02-25 09:10:33.000000000 +0100
> +++ linux-2.6.34-rc1/drivers/media/video/cx23885/cx23885-i2c.c	2010-03-18 13:33:05.000000000 +0100
> @@ -365,7 +365,17 @@ int cx23885_i2c_register(struct cx23885_
>  
>  		memset(&info, 0, sizeof(struct i2c_board_info));
>  		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> -		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list);
> +		/*
> +		 * We can't call i2c_new_probed_device() because it uses
> +		 * quick writes for probing and the IR receiver device only
> +		 * replies to reads.
> +		 */
> +		if (i2c_smbus_xfer(&bus->i2c_adap, addr_list[0], 0,
> +				   I2C_SMBUS_READ, 0, I2C_SMBUS_QUICK,
> +				   NULL) >= 0) {
> +			info.addr = addr_list[0];
> +			i2c_new_device(&bus->i2c_adap, &info);
> +		}
>  	}
>  
>  	return bus->i2c_rc;
> --- linux-2.6.34-rc1.orig/drivers/media/video/cx88/cx88-i2c.c	2010-02-25 09:08:40.000000000 +0100
> +++ linux-2.6.34-rc1/drivers/media/video/cx88/cx88-i2c.c	2010-03-18 13:33:05.000000000 +0100
> @@ -188,10 +188,24 @@ int cx88_i2c_init(struct cx88_core *core
>  			0x18, 0x6b, 0x71,
>  			I2C_CLIENT_END
>  		};
> +		const unsigned short *addrp;
>  
>  		memset(&info, 0, sizeof(struct i2c_board_info));
>  		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> -		i2c_new_probed_device(&core->i2c_adap, &info, addr_list);
> +		/*
> +		 * We can't call i2c_new_probed_device() because it uses
> +		 * quick writes for probing and at least some R receiver
> +		 * devices only reply to reads.
> +		 */
> +		for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
> +			if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
> +					   I2C_SMBUS_READ, 0,
> +					   I2C_SMBUS_QUICK, NULL) >= 0) {
> +				info.addr = *addrp;
> +				i2c_new_device(&core->i2c_adap, &info);
> +				break;
> +			}
> +		}
>  	}
>  	return core->i2c_rc;
>  }
> 
> 


-- 
Jean Delvare
