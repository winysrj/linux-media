Return-path: <mchehab@pedra>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51014 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab1CFNt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Mar 2011 08:49:59 -0500
Message-ID: <4D739104.7030007@fastmail.fm>
Date: Sun, 06 Mar 2011 13:49:56 +0000
From: Jack Stone <jwjstone@fastmail.fm>
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
References: <1299410212-24897-1-git-send-email-florian@mickler.org>
In-Reply-To: <1299410212-24897-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/03/2011 11:16, Florian Mickler wrote:
> This should fix warnings seen by some:
> 	WARNING: at lib/dma-debug.c:866 check_for_stack
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: linux-media@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: Greg Kroah-Hartman <greg@kroah.com>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Maciej Rutecki <maciej.rutecki@gmail.com>
> ---
> @@ -101,8 +109,19 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
>  
>  int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
>  {
> -	u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
> -	return dib0700_ctrl_wr(d, buf, sizeof(buf));
> +	s16 ret;
> +	u8 *buf = kmalloc(3, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	buf[0] = REQUEST_SET_GPIO;
> +	buf[1] = gpio;
> +	buf[2] = ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6);
> +
> +	ret = dib0700_ctrl_wr(d, buf, sizeof(buf));

Shouldn't this sizeof be changed as well?

Thanks,

Jack
