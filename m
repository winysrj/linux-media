Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap0.codethink.co.uk ([185.43.218.159]:35357 "EHLO
        imap0.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdFBK3H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 06:29:07 -0400
Message-ID: <1496399330.1989.3.camel@codethink.co.uk>
Subject: Re: [PATCH 4.4 058/103] [media] ttusb2: limit messages to buffer
 size
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Alyssa Milburn <amilburn@zall.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 02 Jun 2017 11:28:50 +0100
In-Reply-To: <20170523200901.523568677@linuxfoundation.org>
References: <20170523200856.903752266@linuxfoundation.org>
         <20170523200901.523568677@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Dropped cc to stable and LKML.]

On Tue, 2017-05-23 at 22:09 +0200, Greg Kroah-Hartman wrote:
> 4.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alyssa Milburn <amilburn@zall.org>
> 
> commit a12b8ab8c5ff7ccd7b107a564743507c850a441d upstream.
> 
> Otherwise ttusb2_i2c_xfer can read or write beyond the end of static and
> heap buffers.

This function has another problem: it uses per-device mutexes to guard
access to static buffers.  This only works as long as there's a single
device.  It should be using per-device buffers (or a static mutex, but
that's less good).

Ben.

> Signed-off-by: Alyssa Milburn <amilburn@zall.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/media/usb/dvb-usb/ttusb2.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> --- a/drivers/media/usb/dvb-usb/ttusb2.c
> +++ b/drivers/media/usb/dvb-usb/ttusb2.c
> @@ -78,6 +78,9 @@ static int ttusb2_msg(struct dvb_usb_dev
>  	u8 *s, *r = NULL;
>  	int ret = 0;
>  
> +	if (4 + rlen > 64)
> +		return -EIO;
> +
>  	s = kzalloc(wlen+4, GFP_KERNEL);
>  	if (!s)
>  		return -ENOMEM;
> @@ -381,6 +384,22 @@ static int ttusb2_i2c_xfer(struct i2c_ad
>  		write_read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
>  		read = msg[i].flags & I2C_M_RD;
>  
> +		if (3 + msg[i].len > sizeof(obuf)) {
> +			err("i2c wr len=%d too high", msg[i].len);
> +			break;
> +		}
> +		if (write_read) {
> +			if (3 + msg[i+1].len > sizeof(ibuf)) {
> +				err("i2c rd len=%d too high", msg[i+1].len);
> +				break;
> +			}
> +		} else if (read) {
> +			if (3 + msg[i].len > sizeof(ibuf)) {
> +				err("i2c rd len=%d too high", msg[i].len);
> +				break;
> +			}
> +		}
> +
>  		obuf[0] = (msg[i].addr << 1) | (write_read | read);
>  		if (read)
>  			obuf[1] = 0;
> 
> 
> 

-- 
Ben Hutchings
Software Developer, Codethink Ltd.
