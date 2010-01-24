Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53883 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0AXQQd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 11:16:33 -0500
Message-ID: <4B5C7258.1010605@iki.fi>
Date: Sun, 24 Jan 2010 18:16:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] media: dvb/af9015, implement eeprom hashing
References: <4B4F6BE5.2040102@iki.fi> <1264173055-14787-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1264173055-14787-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hei,
Comments below.

On 01/22/2010 05:10 PM, Jiri Slaby wrote:
> We read the eeprom anyway for dumping. Switch the dumping to
> print_hex_dump_bytes and compute hash above that by
> hash = 0;
> for (u32 VAL) in (eeprom):
>    hash *= GOLDEN_RATIO_PRIME_32
>    hash += VAL; // while preserving endinaness
>
> The computation is moved earlier to the flow, namely from
> af9015_af9013_frontend_attach to af9015_read_config, so that
> we can access the sum in af9015_read_config already.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Antti Palosaari<crope@iki.fi>
> Cc: Mauro Carvalho Chehab<mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> ---
>   drivers/media/dvb/dvb-usb/af9015.c |   65 +++++++++++++++++++++++------------
>   drivers/media/dvb/dvb-usb/af9015.h |    1 +
>   2 files changed, 44 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index a365c05..616b3ba 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -21,6 +21,8 @@
>    *
>    */
>
> +#include<linux/hash.h>
> +
>   #include "af9015.h"
>   #include "af9013.h"
>   #include "mt2060.h"
> @@ -553,26 +555,45 @@ exit:
>   	return ret;
>   }
>
> -/* dump eeprom */
> -static int af9015_eeprom_dump(struct dvb_usb_device *d)
> +/* hash (and dump) eeprom */
> +static int af9015_eeprom_hash(struct usb_device *udev)
>   {
> -	u8 reg, val;
> +	static const unsigned int eeprom_size = 256;
> +	unsigned int reg;
> +	int ret;
> +	u8 val, *eeprom;
> +	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1,&val};
>
> -	for (reg = 0; ; reg++) {
> -		if (reg % 16 == 0) {
> -			if (reg)
> -				deb_info(KERN_CONT "\n");
> -			deb_info(KERN_DEBUG "%02x:", reg);
> -		}
> -		if (af9015_read_reg_i2c(d, AF9015_I2C_EEPROM, reg,&val) == 0)
> -			deb_info(KERN_CONT " %02x", val);
> -		else
> -			deb_info(KERN_CONT " --");
> -		if (reg == 0xff)
> -			break;
> +	eeprom = kmalloc(eeprom_size, GFP_KERNEL);
> +	if (eeprom == NULL)
> +		return -ENOMEM;
> +
> +	for (reg = 0; reg<  eeprom_size; reg++) {
> +		req.addr = reg;
> +		ret = af9015_rw_udev(udev,&req);
> +		if (ret)
> +			goto free;
> +		eeprom[reg] = val;
>   	}
> -	deb_info(KERN_CONT "\n");
> -	return 0;
> +
> +	if (dvb_usb_af9015_debug&  0x01)
> +		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, eeprom,
> +				eeprom_size);
> +
> +	BUG_ON(eeprom_size % 4);
> +
> +	af9015_config.eeprom_sum = 0;
> +	for (reg = 0; reg<  eeprom_size / sizeof(u32); reg++) {
> +		af9015_config.eeprom_sum *= GOLDEN_RATIO_PRIME_32;
> +		af9015_config.eeprom_sum += le32_to_cpu(((u32 *)eeprom)[reg]);
> +	}
> +
> +	deb_info("%s: eeprom sum=%.8x\n", __func__, af9015_config.eeprom_sum);

Does this sum contain all 256 bytes from EEPROM? 256/4 is 64.

regards
Antti
-- 
http://palosaari.fi/
