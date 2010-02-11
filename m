Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37103 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0BKAJL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 19:09:11 -0500
Message-ID: <4B734A9E.7030502@iki.fi>
Date: Thu, 11 Feb 2010 02:09:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Douglas Schilling Landgraf via Mercurial <dougsland@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] af9015: backported to kernel <
 2.6.22
References: <E1NdwHi-0006vv-K9@mail.linuxtv.org>
In-Reply-To: <E1NdwHi-0006vv-K9@mail.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve,
Short question, would it be easier to add GOLDEN_RATIO_PRIME_32 to 
compat.h ?

regards
Antti

On 02/07/2010 03:50 AM, Patch from Douglas Schilling Landgraf wrote:
> The patch number 14160 was added via Douglas Schilling Landgraf<dougsland@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
>
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List<linux-media@vger.kernel.org>
>
> ------
>
> From: Douglas Schilling Landgraf<dougsland@redhat.com>
> af9015: backported to kernel<  2.6.22
>
>
> backport for hash - kernel<  2.6.22
>
> Priority: normal
>
> Signed-off-by: Douglas Schilling Landgraf<dougsland@redhat.com>
>
>
> ---
>
>   linux/drivers/media/dvb/dvb-usb/af9015.c |   37 +++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
>
> diff -r 7d09c32065a4 -r 8c0dbfae05ff linux/drivers/media/dvb/dvb-usb/af9015.c
> --- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Fri Feb 05 16:18:29 2010 -0200
> +++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Sat Feb 06 23:44:20 2010 -0200
> @@ -20,9 +20,11 @@
>    *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>    *
>    */
> +#if LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 22)
>
>   #include<linux/hash.h>
>
> +#endif
>   #include "af9015.h"
>   #include "af9013.h"
>   #include "mt2060.h"
> @@ -558,15 +560,37 @@
>   	return ret;
>   }
>
> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 22)
> +static int af9015_eeprom_dump(struct dvb_usb_device *d)
> +#else
>   /* hash (and dump) eeprom */
>   static int af9015_eeprom_hash(struct usb_device *udev)
> +#endif
>   {
> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 22)
> +	u8 reg, val;
> +#else
>   	static const unsigned int eeprom_size = 256;
>   	unsigned int reg;
>   	int ret;
>   	u8 val, *eeprom;
>   	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1,&val};
> +#endif
>
> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 22)
> +	for (reg = 0; ; reg++) {
> +		if (reg % 16 == 0) {
> +			if (reg)
> +				deb_info(KERN_CONT "\n");
> +			deb_info(KERN_DEBUG "%02x:", reg);
> +		}
> +		if (af9015_read_reg_i2c(d, AF9015_I2C_EEPROM, reg,&val) == 0)
> +			deb_info(KERN_CONT " %02x", val);
> +		else
> +			deb_info(KERN_CONT " --");
> +		if (reg == 0xff)
> +			break;
> +#else
>   	eeprom = kmalloc(eeprom_size, GFP_KERNEL);
>   	if (eeprom == NULL)
>   		return -ENOMEM;
> @@ -577,8 +601,13 @@
>   		if (ret)
>   			goto free;
>   		eeprom[reg] = val;
> +#endif
>   	}
>
> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 22)
> +	deb_info(KERN_CONT "\n");
> +	return 0;
> +#else
>   	if (dvb_usb_af9015_debug&  0x01)
>   		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, eeprom,
>   				eeprom_size);
> @@ -597,6 +626,7 @@
>   free:
>   	kfree(eeprom);
>   	return ret;
> +#endif
>   }
>
>   static int af9015_download_ir_table(struct dvb_usb_device *d)
> @@ -873,10 +903,12 @@
>   	if (ret)
>   		goto error;
>
> +#if LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 22)
>   	ret = af9015_eeprom_hash(udev);
>   	if (ret)
>   		goto error;
>
> +#endif
>   	deb_info("%s: IR mode:%d\n", __func__, val);
>   	for (i = 0; i<  af9015_properties_count; i++) {
>   		if (val == AF9015_IR_MODE_DISABLED) {
> @@ -1129,6 +1161,11 @@
>
>   		deb_info("%s: init I2C\n", __func__);
>   		ret = af9015_i2c_init(adap->dev);
> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 22)
> +		ret = af9015_eeprom_dump(adap->dev);
> +		if (ret)
> +			return ret;
> +#endif
>   	} else {
>   		/* select I2C adapter */
>   		i2c_adap =&state->i2c_adap;
>
>
> ---
>
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/8c0dbfae05fff3ee3ddacb0c9f1799b6f1815c2b
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits


-- 
http://palosaari.fi/
