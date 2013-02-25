Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab3BYLOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Feb 2013 06:14:40 -0500
Date: Mon, 25 Feb 2013 08:14:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, poma <pomidorabelisima@gmail.com>
Subject: Re: [PATCH] af9015: do not use buffers from stack for
 usb_bulk_msg()
Message-ID: <20130225081427.36f0c530@redhat.com>
In-Reply-To: <1361749181-27059-1-git-send-email-crope@iki.fi>
References: <1361749181-27059-1-git-send-email-crope@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Feb 2013 01:39:41 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> WARNING: at lib/dma-debug.c:947 check_for_stack+0xa7/0xf0()
> ehci-pci 0000:00:04.1: DMA-API: device driver maps memory fromstack
> 
> Reported-by: poma <pomidorabelisima@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/af9015.c | 34 ++++++++++++++++------------------
>  drivers/media/usb/dvb-usb-v2/af9015.h |  2 ++
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
> index b86d0f2..28983aa 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c
> @@ -30,22 +30,20 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
>  static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>  {
> -#define BUF_LEN 63
>  #define REQ_HDR_LEN 8 /* send header size */
>  #define ACK_HDR_LEN 2 /* rece header size */
>  	struct af9015_state *state = d_to_priv(d);
>  	int ret, wlen, rlen;
> -	u8 buf[BUF_LEN];
>  	u8 write = 1;
>  
> -	buf[0] = req->cmd;
> -	buf[1] = state->seq++;
> -	buf[2] = req->i2c_addr;
> -	buf[3] = req->addr >> 8;
> -	buf[4] = req->addr & 0xff;
> -	buf[5] = req->mbox;
> -	buf[6] = req->addr_len;
> -	buf[7] = req->data_len;
> +	state->buf[0] = req->cmd;
> +	state->buf[1] = state->seq++;
> +	state->buf[2] = req->i2c_addr;
> +	state->buf[3] = req->addr >> 8;
> +	state->buf[4] = req->addr & 0xff;
> +	state->buf[5] = req->mbox;
> +	state->buf[6] = req->addr_len;
> +	state->buf[7] = req->data_len;
>  
>  	switch (req->cmd) {
>  	case GET_CONFIG:
> @@ -55,14 +53,14 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>  		break;
>  	case READ_I2C:
>  		write = 0;
> -		buf[2] |= 0x01; /* set I2C direction */
> +		state->buf[2] |= 0x01; /* set I2C direction */
>  	case WRITE_I2C:
> -		buf[0] = READ_WRITE_I2C;
> +		state->buf[0] = READ_WRITE_I2C;
>  		break;
>  	case WRITE_MEMORY:
>  		if (((req->addr & 0xff00) == 0xff00) ||
>  		    ((req->addr & 0xff00) == 0xae00))
> -			buf[0] = WRITE_VIRTUAL_MEMORY;
> +			state->buf[0] = WRITE_VIRTUAL_MEMORY;
>  	case WRITE_VIRTUAL_MEMORY:
>  	case COPY_FIRMWARE:
>  	case DOWNLOAD_FIRMWARE:
> @@ -90,7 +88,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>  	rlen = ACK_HDR_LEN;
>  	if (write) {
>  		wlen += req->data_len;
> -		memcpy(&buf[REQ_HDR_LEN], req->data, req->data_len);
> +		memcpy(&state->buf[REQ_HDR_LEN], req->data, req->data_len);
>  	} else {
>  		rlen += req->data_len;
>  	}
> @@ -99,21 +97,21 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>  	if (req->cmd == DOWNLOAD_FIRMWARE || req->cmd == RECONNECT_USB)
>  		rlen = 0;
>  
> -	ret = dvb_usbv2_generic_rw(d, buf, wlen, buf, rlen);
> +	ret = dvb_usbv2_generic_rw(d, state->buf, wlen, state->buf, rlen);
>  	if (ret)
>  		goto error;
>  
>  	/* check status */
> -	if (rlen && buf[1]) {
> +	if (rlen && state->buf[1]) {
>  		dev_err(&d->udev->dev, "%s: command failed=%d\n",
> -				KBUILD_MODNAME, buf[1]);
> +				KBUILD_MODNAME, state->buf[1]);
>  		ret = -EIO;
>  		goto error;
>  	}
>  
>  	/* read request, copy returned data to return buf */
>  	if (!write)
> -		memcpy(req->data, &buf[ACK_HDR_LEN], req->data_len);
> +		memcpy(req->data, &state->buf[ACK_HDR_LEN], req->data_len);

Now that you're using just one buffer here, you'll need to protect this
routine with a mutex, as af9015_rc_query() may be called by a kthread 
while af9015_ctrl_msg() is running. As the RC polling code will also call
af9015_ctrl_msg() and both will be filling the very same state->buf, a
race condition happens.

-- 

Cheers,
Mauro
