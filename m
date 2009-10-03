Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58954 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbZJCNRP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 09:17:15 -0400
Subject: Re: AVerTV MCE 116 Plus remote
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>
In-Reply-To: <20091002214909.GA4761@moon>
References: <20091002214909.GA4761@moon>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Oct 2009 09:19:07 -0400
Message-Id: <1254575947.3169.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-10-03 at 00:49 +0300, Aleksandr V. Piskunov wrote:
> Preliminary version of patch adding support for AVerTV MCE 116 Plus remote.
> This board has an IR sensor is connected to EM78P153S, general purpose 8-bit
> microcontroller with a 1024 × 13 bits of OTP-ROM. According to i2cdetect, it is
> sitting on address 0x40.
> 
> Patch allows ir-kbd-i2c to probe cx2341x boards for this address. Manually
> loading ir-kbd-i2c now detects remote, every key is working as expected.
> 
> As I understand, current I2C/probing code is being redesigned/refactored. Sheer
> amount of #ifdefs for every second kernel version is making my eyes bleed, so
> please somebody involved check if patch is ok. 


Aleksandr,


> Should I also add the 0x40 address to addr_list[] in ivtv-i2c.c? How to point
> ivtv to this remote and autoload ir-kbd-i2c?

No.


At first glance, this patch doesn't look safe for all ivtv boards so:

	Naked-by: Andy Walls <awalls@radix.net>


In ivtv-i2c.c I see:

	#define IVTV_MSP3400_I2C_ADDR           0x40

It is probably not good to assume that only an IR microcontroller could
be at I2C address 0x40 for a CX2341x adapter.

I will work up an ivtv specific change similar to what I did in
cx18-cards.c and cx18-i2c.c for IR on the HVR-1600 for bringing up the
IR for the M116 cards alone.

What kernel version do you use?

Regards,
Andy


> diff --git a/linux/drivers/media/video/ir-kbd-i2c.c b/linux/drivers/media/video/ir-kbd-i2c.c
> --- a/linux/drivers/media/video/ir-kbd-i2c.c
> +++ b/linux/drivers/media/video/ir-kbd-i2c.c
> @@ -461,7 +461,7 @@
>  		}
>  		break;
>  	case 0x40:
> -		name        = "AVerMedia Cardbus remote";
> +		name        = "AVerMedia RM-FP/RM-KH remote";
>  		ir->get_key = get_key_avermedia_cardbus;
>  		ir_type     = IR_TYPE_OTHER;
>  		ir_codes    = &ir_codes_avermedia_cardbus_table;
> @@ -706,8 +706,12 @@
>  			ir_attach(adap, msg.addr, 0, 0);
>  	}
>  
> -	/* Special case for AVerMedia Cardbus remote */
> -	if (adap->id == I2C_HW_SAA7134) {
> +	/* Special case for AVerMedia remotes:
> +	   * AVerTV Hybrid+FM Cardbus
> +	   * AVerTV MCE 116 Plus
> +	   * probably others with RM-FP, RM-KH remotes and microcontroller
> +	     chip @ 0x40 */
> +	if ((adap->id == I2C_HW_SAA7134) || (adap->id == I2C_HW_B_CX2341X)) {
>  		unsigned char subaddr, data;
>  		struct i2c_msg msg[] = { { .addr = 0x40, .flags = 0,
>  					   .buf = &subaddr, .len = 1},


