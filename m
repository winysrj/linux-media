Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37559 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaAEKuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 05:50:37 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so7405309eek.40
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 02:50:36 -0800 (PST)
Message-ID: <52C93940.5060402@googlemail.com>
Date: Sun, 05 Jan 2014 11:51:44 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 06/22] [media] em28xx: add warn messages for timeout
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-7-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> changeset 45f04e82d035 added a logic to check if em28xx got
> a timeout on an I2C transfer.
>
> That patch started to produce a series of errors that is present
> with HVR-950, like:
>
> [ 4032.218656] xc2028 19-0061: Error on line 1299: -19
>
> However, as there are several places where -ENODEV is produced,
> there's no way to know what's happening.
>
> So, let's add a printk to report what error condition was reached:
>
> [ 4032.218652] em2882/3 #0: I2C transfer timeout on writing to addr 0xc2
> [ 4032.218656] xc2028 19-0061: Error on line 1299: -19
>
> Interesting enough, when connected to an USB3 port, the number of
> errors increase:
>
> [ 4249.941375] em2882/3 #0: I2C transfer timeout on writing to addr 0xb8
> [ 4249.941378] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
> [ 4250.023854] em2882/3 #0: I2C transfer timeout on writing to addr 0xc2
> [ 4250.023857] xc2028 19-0061: Error on line 1299: -19
>
> Due to that, I suspect that the logic in the driver is wrong: instead
> of just returning an error if 0x10 is returned, it should be waiting for
> a while and read the I2C status register again.
>
> However, more tests are needed.
The patch description isn't up-to-date.
It turned out that the bug is in the xc2028 driver.

See
http://www.spinics.net/lists/linux-media/msg71107.html

>
> For now, instead of just returning -ENODEV, output an error message
> to help debug what's happening.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index c4ff9739a7ae..9e6a11d01858 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -80,6 +80,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		if (ret == 0x80 + len - 1) {
>  			return len;
>  		} else if (ret == 0x94 + len - 1) {
> +			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
>  			return -ENODEV;
>  		} else if (ret < 0) {
>  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> @@ -123,6 +124,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
>  		if (ret == 0x84 + len - 1) {
>  			break;
>  		} else if (ret == 0x94 + len - 1) {
> +			em28xx_warn("R05 returned 0x%02x: I2C timeout", ret);
>  			return -ENODEV;
>  		} else if (ret < 0) {
>  			em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
> @@ -198,6 +200,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  		if (ret == 0) { /* success */
>  			return len;
>  		} else if (ret == 0x10) {
> +			em28xx_warn("I2C transfer timeout on writing to addr 0x%02x", addr);
>  			return -ENODEV;
>  		} else if (ret < 0) {
>  			em28xx_warn("failed to read i2c transfer status from bridge (error=%i)\n",
> @@ -255,6 +258,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
>  	}
>  	if (ret > 0) {
>  		if (ret == 0x10) {
> +			em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
>  			return -ENODEV;
>  		} else {
>  			em28xx_warn("unknown i2c error (status=%i)\n", ret);
> @@ -316,8 +320,10 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	 */
>  	if (!ret)
>  		return len;
> -	else if (ret > 0)
> +	else if (ret > 0) {
> +		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
>  		return -ENODEV;
> +	}
>  
>  	return ret;
>  	/*
> @@ -367,8 +373,10 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>  	 */
>  	if (!ret)
>  		return len;
> -	else if (ret > 0)
> +	else if (ret > 0) {
> +		em28xx_warn("Bus B R08 returned 0x%02x: I2C timeout", ret);
>  		return -ENODEV;
> +	}
>  
>  	return ret;
>  	/*
NACK.
This will spam the system log on i2c device probing (especially with
sensors).

