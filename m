Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:53327 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754056Ab0CCAOo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Mar 2010 19:14:44 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Tue, 2 Mar 2010 16:14:42 -0800
Message-ID: <4B8DA9F3.2090407@xenotime.net>
Date: Tue, 02 Mar 2010 16:14:43 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: imunsie@au1.ibm.com
CC: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	Martin Samek <martin@marsark.sytes.net>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove large struct from stack in DVB dib3000mc and dib7000p
 drivers
References: <1267574404-5874-1-git-send-email-imunsie@au.ibm.com>
In-Reply-To: <1267574404-5874-1-git-send-email-imunsie@au.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/10 16:00, imunsie@au1.ibm.com wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> Compiling these drivers results in the following compiler warnings on
> PowerPC 64 bit:
> 
> drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2208 bytes is larger than 2048 bytes
> drivers/media/dvb/frontends/dib7000p.c:1367: warning: the frame size of 2288 bytes is larger than 2048 bytes
> 
> The <driver>_i2c_enumeration functions use a large struct to hold the
> state, which is stored on the stack.
> 
> This patch allocates that structure dynamically instead, thereby
> conserving the driver's use of the stack.

Is this the same as the already-submitted patches?

Please see http://patchwork.kernel.org/patch/77892/
and http://patchwork.kernel.org/patch/77891/

and in general, use http://patchwork.kernel.org/ and
http://patchwork.ozlabs.org/ and/or mailing lists to see if patches
have already been submitted so that you don't waste time.
Or you could comments on my patches. ;)


> There is now the possibility that these functions will return -ENOMEM in
> case the dynamic memory allocation fails and while a useful message will
> show up in dmesg, at the moment the -ENOMEM condition is not relayed
> all the way back to userspace and it will receive an -ENODEV instead.
> Is it worth pursuing returning the correct error all the way up to
> userspace?
> 
> Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
> ---
>  drivers/media/dvb/frontends/dib3000mc.c |   43 +++++++++++++++++++-----------
>  drivers/media/dvb/frontends/dib7000p.c  |   44 +++++++++++++++++++-----------
>  2 files changed, 55 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
> index fa85160..78c2813 100644
> --- a/drivers/media/dvb/frontends/dib3000mc.c
> +++ b/drivers/media/dvb/frontends/dib3000mc.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/i2c.h>
> +#include <linux/slab.h>
>  
>  #include "dvb_frontend.h"
>  
> @@ -813,43 +814,53 @@ EXPORT_SYMBOL(dib3000mc_set_config);
>  
>  int dib3000mc_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib3000mc_config cfg[])
>  {
> -	struct dib3000mc_state st = { .i2c_adap = i2c };
> +	struct dib3000mc_state *st;
>  	int k;
>  	u8 new_addr;
> -
>  	static u8 DIB3000MC_I2C_ADDRESS[] = {20,22,24,26};
> +	int ret = 0;
> +
> +	st = kzalloc(sizeof(struct dib3000mc_state), GFP_KERNEL);
> +	if (!st) {
> +		dprintk(KERN_ERR "Out of memory allocating dib3000mc_state in %s", __func__);
> +		return -ENOMEM;
> +	}
> +	st->i2c_adap = i2c;
>  
>  	for (k = no_of_demods-1; k >= 0; k--) {
> -		st.cfg = &cfg[k];
> +		st->cfg = &cfg[k];
>  
>  		/* designated i2c address */
>  		new_addr          = DIB3000MC_I2C_ADDRESS[k];
> -		st.i2c_addr = new_addr;
> -		if (dib3000mc_identify(&st) != 0) {
> -			st.i2c_addr = default_addr;
> -			if (dib3000mc_identify(&st) != 0) {
> +		st->i2c_addr = new_addr;
> +		if (dib3000mc_identify(st) != 0) {
> +			st->i2c_addr = default_addr;
> +			if (dib3000mc_identify(st) != 0) {
>  				dprintk("-E-  DiB3000P/MC #%d: not identified\n", k);
> -				return -ENODEV;
> +				ret = -ENODEV;
> +				goto out;
>  			}
>  		}
>  
> -		dib3000mc_set_output_mode(&st, OUTMODE_MPEG2_PAR_CONT_CLK);
> +		dib3000mc_set_output_mode(st, OUTMODE_MPEG2_PAR_CONT_CLK);
>  
>  		// set new i2c address and force divstr (Bit 1) to value 0 (Bit 0)
> -		dib3000mc_write_word(&st, 1024, (new_addr << 3) | 0x1);
> -		st.i2c_addr = new_addr;
> +		dib3000mc_write_word(st, 1024, (new_addr << 3) | 0x1);
> +		st->i2c_addr = new_addr;
>  	}
>  
>  	for (k = 0; k < no_of_demods; k++) {
> -		st.cfg = &cfg[k];
> -		st.i2c_addr = DIB3000MC_I2C_ADDRESS[k];
> +		st->cfg = &cfg[k];
> +		st->i2c_addr = DIB3000MC_I2C_ADDRESS[k];
>  
> -		dib3000mc_write_word(&st, 1024, st.i2c_addr << 3);
> +		dib3000mc_write_word(st, 1024, st->i2c_addr << 3);
>  
>  		/* turn off data output */
> -		dib3000mc_set_output_mode(&st, OUTMODE_HIGH_Z);
> +		dib3000mc_set_output_mode(st, OUTMODE_HIGH_Z);
>  	}
> -	return 0;
> +out:
> +	kfree(st);
> +	return ret;
>  }
>  EXPORT_SYMBOL(dib3000mc_i2c_enumeration);
>  
> diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
> index 750ae61..08d47f2 100644
> --- a/drivers/media/dvb/frontends/dib7000p.c
> +++ b/drivers/media/dvb/frontends/dib7000p.c
> @@ -9,6 +9,7 @@
>   */
>  #include <linux/kernel.h>
>  #include <linux/i2c.h>
> +#include <linux/slab.h>
>  
>  #include "dvb_math.h"
>  #include "dvb_frontend.h"
> @@ -1323,47 +1324,58 @@ EXPORT_SYMBOL(dib7000p_pid_filter);
>  
>  int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
>  {
> -	struct dib7000p_state st = { .i2c_adap = i2c };
> +	struct dib7000p_state *st;
>  	int k = 0;
>  	u8 new_addr = 0;
> +	int ret = 0;
> +
> +	st = kzalloc(sizeof(struct dib7000p_state), GFP_KERNEL);
> +	if (!st) {
> +		dprintk(KERN_ERR "Out of memory allocating dib7000p_state in %s", __func__);
> +		return -ENOMEM;
> +	}
> +	st->i2c_adap = i2c;
>  
>  	for (k = no_of_demods-1; k >= 0; k--) {
> -		st.cfg = cfg[k];
> +		st->cfg = cfg[k];
>  
>  		/* designated i2c address */
>  		new_addr          = (0x40 + k) << 1;
> -		st.i2c_addr = new_addr;
> -		dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
> -		if (dib7000p_identify(&st) != 0) {
> -			st.i2c_addr = default_addr;
> -			dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
> -			if (dib7000p_identify(&st) != 0) {
> +		st->i2c_addr = new_addr;
> +		dib7000p_write_word(st, 1287, 0x0003); /* sram lead in, rdy */
> +		if (dib7000p_identify(st) != 0) {
> +			st->i2c_addr = default_addr;
> +			dib7000p_write_word(st, 1287, 0x0003); /* sram lead in, rdy */
> +			if (dib7000p_identify(st) != 0) {
>  				dprintk("DiB7000P #%d: not identified\n", k);
> -				return -EIO;
> +				ret = -EIO;
> +				goto out;
>  			}
>  		}
>  
>  		/* start diversity to pull_down div_str - just for i2c-enumeration */
> -		dib7000p_set_output_mode(&st, OUTMODE_DIVERSITY);
> +		dib7000p_set_output_mode(st, OUTMODE_DIVERSITY);
>  
>  		/* set new i2c address and force divstart */
> -		dib7000p_write_word(&st, 1285, (new_addr << 2) | 0x2);
> +		dib7000p_write_word(st, 1285, (new_addr << 2) | 0x2);
>  
>  		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
>  	}
>  
>  	for (k = 0; k < no_of_demods; k++) {
> -		st.cfg = cfg[k];
> -		st.i2c_addr = (0x40 + k) << 1;
> +		st->cfg = cfg[k];
> +		st->i2c_addr = (0x40 + k) << 1;
>  
>  		// unforce divstr
> -		dib7000p_write_word(&st, 1285, st.i2c_addr << 2);
> +		dib7000p_write_word(st, 1285, st->i2c_addr << 2);
>  
>  		/* deactivate div - it was just for i2c-enumeration */
> -		dib7000p_set_output_mode(&st, OUTMODE_HIGH_Z);
> +		dib7000p_set_output_mode(st, OUTMODE_HIGH_Z);
>  	}
>  
> -	return 0;
> +out:
> +	kfree(st);
> +	return ret;
>  }
>  EXPORT_SYMBOL(dib7000p_i2c_enumeration);
>  


-- 
~Randy
