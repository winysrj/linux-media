Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:57332 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab2DDPnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2012 11:43:17 -0400
Message-ID: <4F7C6C0F.3010803@kolumbus.fi>
Date: Wed, 04 Apr 2012 18:43:11 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
CC: linux-media@vger.kernel.org,
	"Steinar H. Gunderson" <sesse@samfundet.no>
Subject: Re: [PATCH 04/11] Show timeouts on I2C transfers.
References: <20120401155330.GA31901@uio.no> <1333295631-31866-4-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <1333295631-31866-4-git-send-email-sgunderson@bigfoot.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I had a plan to rework I2C handling a lot more,
than log the changes.

I wrote a patch that uses I2C IRQ.
I had a feeling that it worked well (with old single CPU desktop computer):
framerate with HDTV was low, but it was glitchless.

Do you want to have the patch to be sent for you?
I think that I solved in the patch "robust I2C command + exact IRQ response for that command",
so that those two will not get out of sync.

I tried to rework the patch to make a bit smaller patch,
but I couldn't test the new one: hardware is too broken.

Regards,
Marko

01.04.2012 18:53, Steinar H. Gunderson kirjoitti:
> From: "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> On I2C reads and writes, show if we had any timeouts in the debug output.
> 
> Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
> ---
>  drivers/media/dvb/mantis/mantis_i2c.c |   26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/mantis/mantis_i2c.c b/drivers/media/dvb/mantis/mantis_i2c.c
> index e779451..ddd1922 100644
> --- a/drivers/media/dvb/mantis/mantis_i2c.c
> +++ b/drivers/media/dvb/mantis/mantis_i2c.c
> @@ -38,6 +38,7 @@
>  static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
>  {
>  	u32 rxd, i, stat, trials;
> +	u32 timeouts = 0;
>  
>  	dprintk(MANTIS_INFO, 0, "        %s:  Address=[0x%02x] <R>[ ",
>  		__func__, msg->addr);
> @@ -60,6 +61,9 @@ static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
>  			if (stat & MANTIS_INT_I2CDONE)
>  				break;
>  		}
> +		if (trials == TRIALS) {
> +			++timeouts;
> +		}
>  
>  		dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
>  
> @@ -69,6 +73,9 @@ static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
>  			if (stat & MANTIS_INT_I2CRACK)
>  				break;
>  		}
> +		if (trials == TRIALS) {
> +			++timeouts;
> +		}
>  
>  		dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
>  
> @@ -76,7 +83,11 @@ static int mantis_i2c_read(struct mantis_pci *mantis, const struct i2c_msg *msg)
>  		msg->buf[i] = (u8)((rxd >> 8) & 0xFF);
>  		dprintk(MANTIS_INFO, 0, "%02x ", msg->buf[i]);
>  	}
> -	dprintk(MANTIS_INFO, 0, "]\n");
> +	if (timeouts) {
> +		dprintk(MANTIS_INFO, 0, "] %d timeouts\n", timeouts);
> +	} else {
> +		dprintk(MANTIS_INFO, 0, "]\n");
> +	}
>  
>  	return 0;
>  }
> @@ -85,6 +96,7 @@ static int mantis_i2c_write(struct mantis_pci *mantis, const struct i2c_msg *msg
>  {
>  	int i;
>  	u32 txd = 0, stat, trials;
> +	u32 timeouts = 0;
>  
>  	dprintk(MANTIS_INFO, 0, "        %s: Address=[0x%02x] <W>[ ",
>  		__func__, msg->addr);
> @@ -108,6 +120,9 @@ static int mantis_i2c_write(struct mantis_pci *mantis, const struct i2c_msg *msg
>  			if (stat & MANTIS_INT_I2CDONE)
>  				break;
>  		}
> +		if (trials == TRIALS) {
> +			++timeouts;
> +		}
>  
>  		dprintk(MANTIS_TMG, 0, "I2CDONE: trials=%d\n", trials);
>  
> @@ -117,10 +132,17 @@ static int mantis_i2c_write(struct mantis_pci *mantis, const struct i2c_msg *msg
>  			if (stat & MANTIS_INT_I2CRACK)
>  				break;
>  		}
> +		if (trials == TRIALS) {
> +			++timeouts;
> +		}
>  
>  		dprintk(MANTIS_TMG, 0, "I2CRACK: trials=%d\n", trials);
>  	}
> -	dprintk(MANTIS_INFO, 0, "]\n");
> +	if (timeouts) {
> +		dprintk(MANTIS_INFO, 0, "] %d timeouts\n", timeouts);
> +	} else {
> +		dprintk(MANTIS_INFO, 0, "]\n");
> +	}
>  
>  	return 0;
>  }

