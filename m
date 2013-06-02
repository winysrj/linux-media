Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35376 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab3FBTat (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 15:30:49 -0400
Message-ID: <51AB9D3F.4030804@iki.fi>
Date: Sun, 02 Jun 2013 22:30:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	mkrufky@linuxtv.org
Subject: Re: [PATCH] rtl28xxu: fix buffer overflow when probing Rafael Micro
 r820t tuner
References: <1370199364-30060-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1370199364-30060-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2013 09:56 PM, Gianluca Gennari wrote:
> req_r820t wants a buffer with a size of 5 bytes, but the buffer 'buf'
> has a size of 2 bytes.
>
> This patch fixes the kernel oops with the r820t driver on old kernels
> during the probe stage.
> Successfully tested on a 2.6.32 32 bit kernel (Ubuntu 10.04).
> Hopefully it will also help with the random stability issues reported
> by some user on the linux-media list.
>
> This patch and https://patchwork.kernel.org/patch/2524651/
> should go in the next 3.10-rc release, as they fix potential kernel crashes.
>
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
> ---
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 22015fe..48f2e6f 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -360,7 +360,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
>   {
>   	struct rtl28xxu_priv *priv = d_to_priv(d);
>   	int ret;
> -	u8 buf[2];
> +	u8 buf[5];
>   	/* open RTL2832U/RTL2832 I2C gate */
>   	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
>   	/* close RTL2832U/RTL2832 I2C gate */
>

Gianluca, could you make that probe to check chip id as usually. Read 
register 0x00 and check value 0x69. Also, please test if writing to that 
address different value will not change register value to see it is 
really chip id.

regards
Antti

-- 
http://palosaari.fi/
