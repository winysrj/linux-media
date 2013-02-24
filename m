Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60605 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759357Ab3BXXuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 18:50:08 -0500
Message-ID: <512AA70B.4000500@iki.fi>
Date: Mon, 25 Feb 2013 01:49:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org, poma <pomidorabelisima@gmail.com>
Subject: Re: [PATCH] af9015: do not use buffers from stack for usb_bulk_msg()
References: <1361749181-27059-1-git-send-email-crope@iki.fi>
In-Reply-To: <1361749181-27059-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ooops, I think it will not work properly for the long ran as there is no 
lock to serialize access to that buffer early enough.

I have to rethink whole situation and maybe try to move "usb_mutex" from 
the dvb_usbv2_generic_rw() to the device driver. Or add totally new mutex.


regards
Antti

On 02/25/2013 01:39 AM, Antti Palosaari wrote:
> WARNING: at lib/dma-debug.c:947 check_for_stack+0xa7/0xf0()
> ehci-pci 0000:00:04.1: DMA-API: device driver maps memory fromstack
>
> Reported-by: poma <pomidorabelisima@gmail.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/usb/dvb-usb-v2/af9015.c | 34 ++++++++++++++++------------------
>   drivers/media/usb/dvb-usb-v2/af9015.h |  2 ++
>   2 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
> index b86d0f2..28983aa 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.c
> @@ -30,22 +30,20 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>
>   static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>   {
> -#define BUF_LEN 63
>   #define REQ_HDR_LEN 8 /* send header size */
>   #define ACK_HDR_LEN 2 /* rece header size */
>   	struct af9015_state *state = d_to_priv(d);
>   	int ret, wlen, rlen;
> -	u8 buf[BUF_LEN];
>   	u8 write = 1;
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
>   	switch (req->cmd) {
>   	case GET_CONFIG:
> @@ -55,14 +53,14 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>   		break;
>   	case READ_I2C:
>   		write = 0;
> -		buf[2] |= 0x01; /* set I2C direction */
> +		state->buf[2] |= 0x01; /* set I2C direction */
>   	case WRITE_I2C:
> -		buf[0] = READ_WRITE_I2C;
> +		state->buf[0] = READ_WRITE_I2C;
>   		break;
>   	case WRITE_MEMORY:
>   		if (((req->addr & 0xff00) == 0xff00) ||
>   		    ((req->addr & 0xff00) == 0xae00))
> -			buf[0] = WRITE_VIRTUAL_MEMORY;
> +			state->buf[0] = WRITE_VIRTUAL_MEMORY;
>   	case WRITE_VIRTUAL_MEMORY:
>   	case COPY_FIRMWARE:
>   	case DOWNLOAD_FIRMWARE:
> @@ -90,7 +88,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>   	rlen = ACK_HDR_LEN;
>   	if (write) {
>   		wlen += req->data_len;
> -		memcpy(&buf[REQ_HDR_LEN], req->data, req->data_len);
> +		memcpy(&state->buf[REQ_HDR_LEN], req->data, req->data_len);
>   	} else {
>   		rlen += req->data_len;
>   	}
> @@ -99,21 +97,21 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
>   	if (req->cmd == DOWNLOAD_FIRMWARE || req->cmd == RECONNECT_USB)
>   		rlen = 0;
>
> -	ret = dvb_usbv2_generic_rw(d, buf, wlen, buf, rlen);
> +	ret = dvb_usbv2_generic_rw(d, state->buf, wlen, state->buf, rlen);
>   	if (ret)
>   		goto error;
>
>   	/* check status */
> -	if (rlen && buf[1]) {
> +	if (rlen && state->buf[1]) {
>   		dev_err(&d->udev->dev, "%s: command failed=%d\n",
> -				KBUILD_MODNAME, buf[1]);
> +				KBUILD_MODNAME, state->buf[1]);
>   		ret = -EIO;
>   		goto error;
>   	}
>
>   	/* read request, copy returned data to return buf */
>   	if (!write)
> -		memcpy(req->data, &buf[ACK_HDR_LEN], req->data_len);
> +		memcpy(req->data, &state->buf[ACK_HDR_LEN], req->data_len);
>   error:
>   	return ret;
>   }
> diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
> index 533637d..3a6f3ad 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9015.h
> +++ b/drivers/media/usb/dvb-usb-v2/af9015.h
> @@ -115,7 +115,9 @@ enum af9015_ir_mode {
>   	AF9015_IR_MODE_POLLING, /* just guess */
>   };
>
> +#define BUF_LEN 63
>   struct af9015_state {
> +	u8 buf[BUF_LEN]; /* bulk USB control message */
>   	u8 ir_mode;
>   	u8 rc_repeat;
>   	u32 rc_keycode;
>


-- 
http://palosaari.fi/
