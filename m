Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54051 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbZDDNnl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 09:43:41 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
In-Reply-To: <20090404142837.3e12824c@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142837.3e12824c@hyperion.delvare>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 09:42:09 -0400
Message-Id: <1238852529.2845.34.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-04-04 at 14:28 +0200, Jean Delvare wrote:
> Let card drivers probe for IR receiver devices and instantiate them if
> found. Ultimately it would be better if we could stop probing
> completely, but I suspect this won't be possible for all card types.
> 
> There's certainly room for cleanups. For example, some drivers are
> sharing I2C adapter IDs, so they also had to share the list of I2C
> addresses being probed for an IR receiver. Now that each driver
> explicitly says which addresses should be probed, maybe some addresses
> can be dropped from some drivers.
> 
> Also, the special cases in saa7134-i2c should probably be handled on a
> per-board basis. This would be more efficient and less risky than always
> probing extra addresses on all boards. I'll give it a try later.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Andy Walls <awalls@radix.net>
> Cc: Mike Isely <isely@pobox.com>
> ---
>  linux/drivers/media/video/cx18/cx18-i2c.c            |   30 ++
>  linux/drivers/media/video/ivtv/ivtv-i2c.c            |   31 ++
>  linux/include/media/ir-kbd-i2c.h                     |    2 
>  17 files changed, 284 insertions(+), 196 deletions(-)
> 

> --- v4l-dvb.orig/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-04 10:53:15.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-04 10:58:36.000000000 +0200
> @@ -211,7 +211,32 @@ static struct i2c_algo_bit_data cx18_i2c
>  	.timeout	= CX18_ALGO_BIT_TIMEOUT*HZ /* jiffies */
>  };
>  
> -/* init + register i2c algo-bit adapter */
> +static void init_cx18_i2c_ir(struct cx18 *cx)
> +{
> +	struct i2c_board_info info;
> +	/* The external IR receiver is at i2c address 0x34 (0x35 for
> +	   reads).  Future Hauppauge cards will have an internal
> +	   receiver at 0x30 (0x31 for reads).  In theory, both can be
> +	   fitted, and Hauppauge suggest an external overrides an
> +	   internal.
> +
> +	   That's why we probe 0x1a (~0x34) first. CB
> +	*/
> +	const unsigned short addr_list[] = {
> +		0x1a, 0x18, 0x64, 0x30,
> +		I2C_CLIENT_END
> +	};


I think this is way out of date for cx18 based boards.  The only IR chip
I know of so far is the Zilog Z8F0811 sitting at 7 bit addresses
0x70-0x74.  I guess 0x71 is the proper address for Rx.  I'll let you
know when I test.


> +	memset(&info, 0, sizeof(struct i2c_board_info));
> +	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
> +
> +	/* The IR receiver device can be on either I2C bus */
> +	if (i2c_new_probed_device(&cx->i2c_adap[0], &info, addr_list))
> +		return;
> +	i2c_new_probed_device(&cx->i2c_adap[1], &info, addr_list);
> +}
> +
> +/* init + register i2c adapters + instantiate IR receiver */
>  int init_cx18_i2c(struct cx18 *cx)
>  {
>  	int i, err;
> @@ -279,6 +304,9 @@ int init_cx18_i2c(struct cx18 *cx)
>  	err = i2c_bit_add_bus(&cx->i2c_adap[1]);
>  	if (err)
>  		goto err_del_bus_0;
> +
> +	/* Instantiate the IR receiver device, if present */
> +	init_cx18_i2c_ir(cx);
>  	return 0;

I have an I2C related question.  If the cx18 or ivtv driver autoloads
"ir-kbd-i2c" and registers an I2C client on the bus, does that preclude
lirc_i2c, lirc_pvr150 or lirc_zilog from using the device?  LIRC users
may notice, if it does.

If that is the case, then we probably shouldn't autoload the ir-kbd
module after the CX23418 i2c adapters are initialized.  

I'm not sure what's the best solution:

1. A module option to the cx18 driver to tell it to call
init_cx18_i2c_ir() from cx18_probe() or not? (Easiest solution)

2. Some involved programmatic way for IR device modules to query bridge
drivers about what IR devices they may have, and on which I2C bus, and
at what addresses to probe, and whether a driver/module has already
claimed that device? (Gold plated solution)

Regards,
Andy

