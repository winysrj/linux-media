Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:40969 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaBDT0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 14:26:22 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N0H00MHDKNXDU40@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 04 Feb 2014 14:26:21 -0500 (EST)
Date: Tue, 04 Feb 2014 17:26:15 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] [media] mceusb: remove redundant function and defines
Message-id: <20140204172615.3f494373@samsung.com>
In-reply-to: <1390255844-21826-1-git-send-email-sean@mess.org>
References: <1390255844-21826-1-git-send-email-sean@mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

Em Mon, 20 Jan 2014 22:10:43 +0000
Sean Young <sean@mess.org> escreveu:

Could you please provide a patch description? Even simple ones should have,
and this one is everything but trivial...

Also, you should likely break it into smaller changesets. For example, the
last hunk adding a usb_kill_urb() looks more like a bugfix than a pure
cleanup change.

Thanks!
Mauro

> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/mceusb.c | 92 +++++++++++++++--------------------------------
>  1 file changed, 28 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index a25bb15..3a4f95f 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -166,15 +166,6 @@ static bool debug;
>  			dev_info(dev, fmt, ## __VA_ARGS__);	\
>  	} while (0)
>  
> -/* general constants */
> -#define SEND_FLAG_IN_PROGRESS	1
> -#define SEND_FLAG_COMPLETE	2
> -#define RECV_FLAG_IN_PROGRESS	3
> -#define RECV_FLAG_COMPLETE	4
> -
> -#define MCEUSB_RX		1
> -#define MCEUSB_TX		2
> -
>  #define VENDOR_PHILIPS		0x0471
>  #define VENDOR_SMK		0x0609
>  #define VENDOR_TATUNG		0x1460
> @@ -452,7 +443,6 @@ struct mceusb_dev {
>  	} flags;
>  
>  	/* transmit support */
> -	int send_flags;
>  	u32 carrier;
>  	unsigned char tx_mask;
>  
> @@ -731,45 +721,29 @@ static void mce_async_callback(struct urb *urb)
>  
>  /* request incoming or send outgoing usb packet - used to initialize remote */
>  static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
> -			       int size, int urb_type)
> +			       int size)
>  {
>  	int res, pipe;
>  	struct urb *async_urb;
>  	struct device *dev = ir->dev;
>  	unsigned char *async_buf;
>  
> -	if (urb_type == MCEUSB_TX) {
> -		async_urb = usb_alloc_urb(0, GFP_KERNEL);
> -		if (unlikely(!async_urb)) {
> -			dev_err(dev, "Error, couldn't allocate urb!\n");
> -			return;
> -		}
> -
> -		async_buf = kzalloc(size, GFP_KERNEL);
> -		if (!async_buf) {
> -			dev_err(dev, "Error, couldn't allocate buf!\n");
> -			usb_free_urb(async_urb);
> -			return;
> -		}
> +	async_urb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (unlikely(!async_urb))
> +		return;
>  
> -		/* outbound data */
> -		pipe = usb_sndintpipe(ir->usbdev,
> -				      ir->usb_ep_out->bEndpointAddress);
> -		usb_fill_int_urb(async_urb, ir->usbdev, pipe,
> -			async_buf, size, mce_async_callback,
> -			ir, ir->usb_ep_out->bInterval);
> -		memcpy(async_buf, data, size);
> -
> -	} else if (urb_type == MCEUSB_RX) {
> -		/* standard request */
> -		async_urb = ir->urb_in;
> -		ir->send_flags = RECV_FLAG_IN_PROGRESS;
> -
> -	} else {
> -		dev_err(dev, "Error! Unknown urb type %d\n", urb_type);
> +	async_buf = kmalloc(size, GFP_KERNEL);
> +	if (!async_buf) {
> +		usb_free_urb(async_urb);
>  		return;
>  	}
>  
> +	/* outbound data */
> +	pipe = usb_sndintpipe(ir->usbdev, ir->usb_ep_out->bEndpointAddress);
> +	usb_fill_int_urb(async_urb, ir->usbdev, pipe, async_buf, size,
> +			mce_async_callback, ir, ir->usb_ep_out->bInterval);
> +	memcpy(async_buf, data, size);
> +
>  	mce_dbg(dev, "receive request called (size=%#x)\n", size);
>  
>  	async_urb->transfer_buffer_length = size;
> @@ -789,19 +763,14 @@ static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
>  
>  	if (ir->need_reset) {
>  		ir->need_reset = false;
> -		mce_request_packet(ir, DEVICE_RESUME, rsize, MCEUSB_TX);
> +		mce_request_packet(ir, DEVICE_RESUME, rsize);
>  		msleep(10);
>  	}
>  
> -	mce_request_packet(ir, data, size, MCEUSB_TX);
> +	mce_request_packet(ir, data, size);
>  	msleep(10);
>  }
>  
> -static void mce_flush_rx_buffer(struct mceusb_dev *ir, int size)
> -{
> -	mce_request_packet(ir, NULL, size, MCEUSB_RX);
> -}
> -
>  /* Send data out the IR blaster port(s) */
>  static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  {
> @@ -1040,7 +1009,6 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  static void mceusb_dev_recv(struct urb *urb)
>  {
>  	struct mceusb_dev *ir;
> -	int buf_len;
>  
>  	if (!urb)
>  		return;
> @@ -1051,18 +1019,10 @@ static void mceusb_dev_recv(struct urb *urb)
>  		return;
>  	}
>  
> -	buf_len = urb->actual_length;
> -
> -	if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
> -		ir->send_flags = SEND_FLAG_COMPLETE;
> -		mce_dbg(ir->dev, "setup answer received %d bytes\n",
> -			buf_len);
> -	}
> -
>  	switch (urb->status) {
>  	/* success */
>  	case 0:
> -		mceusb_process_ir_data(ir, buf_len);
> +		mceusb_process_ir_data(ir, urb->actual_length);
>  		break;
>  
>  	case -ECONNRESET:
> @@ -1250,7 +1210,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
>  	struct usb_endpoint_descriptor *ep_in = NULL;
>  	struct usb_endpoint_descriptor *ep_out = NULL;
>  	struct mceusb_dev *ir = NULL;
> -	int pipe, maxp, i;
> +	int pipe, maxp, i, res;
>  	char buf[63], name[128] = "";
>  	enum mceusb_model_type model = id->driver_info;
>  	bool is_gen3;
> @@ -1346,19 +1306,21 @@ static int mceusb_dev_probe(struct usb_interface *intf,
>  		snprintf(name + strlen(name), sizeof(name) - strlen(name),
>  			 " %s", buf);
>  
> -	ir->rc = mceusb_init_rc_dev(ir);
> -	if (!ir->rc)
> -		goto rc_dev_fail;
> -
>  	/* wire up inbound data handler */
>  	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
>  				mceusb_dev_recv, ir, ep_in->bInterval);
>  	ir->urb_in->transfer_dma = ir->dma_in;
>  	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>  
> -	/* flush buffers on the device */
> -	mce_dbg(&intf->dev, "Flushing receive buffers\n");
> -	mce_flush_rx_buffer(ir, maxp);
> +	res = usb_submit_urb(ir->urb_in, GFP_KERNEL);
> +	if (res) {
> +		dev_err(&intf->dev, "failed to submit urb: %d\n", res);
> +		goto usb_submit_fail;
> +	}
> +
> +	ir->rc = mceusb_init_rc_dev(ir);
> +	if (!ir->rc)
> +		goto rc_dev_fail;
>  
>  	/* figure out which firmware/emulator version this hardware has */
>  	mceusb_get_emulator_version(ir);
> @@ -1393,6 +1355,8 @@ static int mceusb_dev_probe(struct usb_interface *intf,
>  
>  	/* Error-handling path */
>  rc_dev_fail:
> +	usb_kill_urb(ir->urb_in);
> +usb_submit_fail:
>  	usb_free_urb(ir->urb_in);
>  urb_in_alloc_fail:
>  	usb_free_coherent(dev, maxp, ir->buf_in, ir->dma_in);


-- 

Cheers,
Mauro
