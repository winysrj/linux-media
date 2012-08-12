Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab2HLAfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 20:35:43 -0400
Message-ID: <5026FA51.9080600@redhat.com>
Date: Sat, 11 Aug 2012 21:35:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net
Subject: Re: [PATCH] [media] iguanair: various fixes
References: <1343731061-9901-1-git-send-email-sean@mess.org>
In-Reply-To: <1343731061-9901-1-git-send-email-sean@mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-07-2012 07:37, Sean Young escreveu:
> This fixes:
>  - rx_overflow while holding down any down button on a nec remote
>  - suspend/resume
>  - stop receiver on rmmod
>  - advertise rx_resolution and timeout properly
>  - code simplify
>  - ignore unsupported firmware versions

Please don't mix several different things on the same patch; it makes
harder for review and, if any of these changes break, a git revert would
change a lot of unrelated things. It also makes hard for bug disect.

Tip: "git citool" helps a lot to break messy patches into smaller, concise
ones.

Thanks!
Mauro

> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/Kconfig    |   8 +-
>  drivers/media/rc/iguanair.c | 206 ++++++++++++++++++++++----------------------
>  2 files changed, 107 insertions(+), 107 deletions(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 5180390..fa1745c 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -264,8 +264,12 @@ config IR_IGUANA
>  	depends on RC_CORE
>  	select USB
>  	---help---
> -	   Say Y here if you want to use the IgaunaWorks USB IR Transceiver.
> -	   Both infrared receive and send are supported.
> +	   Say Y here if you want to use the IguanaWorks USB IR Transceiver.
> +	   Both infrared receive and send are supported. If you want to
> +	   change the ID or the pin config, use the user space driver from
> +	   IguanaWorks.
> +
> +	   Only firmware 0x0205 and later is supported.
>  
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called iguanair.
> diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
> index 5e2eaf8..aa7f34f 100644
> --- a/drivers/media/rc/iguanair.c
> +++ b/drivers/media/rc/iguanair.c
> @@ -35,9 +35,9 @@ struct iguanair {
>  	struct device *dev;
>  	struct usb_device *udev;
>  
> -	int pipe_in, pipe_out;
> +	int pipe_out;
> +	uint16_t version;
>  	uint8_t bufsize;
> -	uint8_t version[2];
>  
>  	struct mutex lock;
>  
> @@ -61,20 +61,21 @@ struct iguanair {
>  };
>  
>  #define CMD_GET_VERSION		0x01
> -#define CMD_GET_BUFSIZE		0x11
>  #define CMD_GET_FEATURES	0x10
> +#define CMD_GET_BUFSIZE		0x11
> +#define CMD_RECEIVER_ON		0x12
> +#define CMD_RECEIVER_OFF	0x14
>  #define CMD_SEND		0x15
> -#define CMD_EXECUTE		0x1f
> +#define CMD_GET_ID		0x1f
>  #define CMD_RX_OVERFLOW		0x31
>  #define CMD_TX_OVERFLOW		0x32
> -#define CMD_RECEIVER_ON		0x12
> -#define CMD_RECEIVER_OFF	0x14
>  
>  #define DIR_IN			0xdc
>  #define DIR_OUT			0xcd
>  
>  #define MAX_PACKET_SIZE		8u
>  #define TIMEOUT			1000
> +#define RX_RESOLUTION		21330
>  
>  struct packet {
>  	uint16_t start;
> @@ -82,11 +83,6 @@ struct packet {
>  	uint8_t cmd;
>  };
>  
> -struct response_packet {
> -	struct packet header;
> -	uint8_t data[4];
> -};
> -
>  struct send_packet {
>  	struct packet header;
>  	uint8_t length;
> @@ -96,10 +92,46 @@ struct send_packet {
>  	uint8_t payload[0];
>  };
>  
> +/*
> + * The hardware advertises a polling interval of 10ms. This is far too
> + * slow and will cause regular rx overflows.
> + */
> +static int int_urb_interval(struct usb_device *udev)
> +{
> +	switch (udev->speed) {
> +	case USB_SPEED_HIGH:
> +		return 4;
> +	case USB_SPEED_LOW:
> +		return 1;
> +	case USB_SPEED_FULL:
> +	default:
> +		return 1;
> +	}
> +}
> +
>  static void process_ir_data(struct iguanair *ir, unsigned len)
>  {
>  	if (len >= 4 && ir->buf_in[0] == 0 && ir->buf_in[1] == 0) {
>  		switch (ir->buf_in[3]) {
> +		case CMD_GET_VERSION:
> +			if (len == 6) {
> +				ir->version = (ir->buf_in[5] << 8) |
> +							ir->buf_in[4];
> +				complete(&ir->completion);
> +			}
> +			break;
> +		case CMD_GET_BUFSIZE:
> +			if (len >= 5) {
> +				ir->bufsize = ir->buf_in[4];
> +				complete(&ir->completion);
> +			}
> +			break;
> +		case CMD_GET_FEATURES:
> +			if (len > 5) {
> +				ir->cycle_overhead = ir->buf_in[5];
> +				complete(&ir->completion);
> +			}
> +			break;
>  		case CMD_TX_OVERFLOW:
>  			ir->tx_overflow = true;
>  		case CMD_RECEIVER_OFF:
> @@ -109,6 +141,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
>  			break;
>  		case CMD_RX_OVERFLOW:
>  			dev_warn(ir->dev, "receive overflow\n");
> +			ir_raw_event_reset(ir->rc);
>  			break;
>  		default:
>  			dev_warn(ir->dev, "control code %02x received\n",
> @@ -128,7 +161,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
>  			} else {
>  				rawir.pulse = (ir->buf_in[i] & 0x80) == 0;
>  				rawir.duration = ((ir->buf_in[i] & 0x7f) + 1) *
> -									 21330;
> +								 RX_RESOLUTION;
>  			}
>  
>  			ir_raw_event_store_with_filter(ir->rc, &rawir);
> @@ -141,6 +174,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
>  static void iguanair_rx(struct urb *urb)
>  {
>  	struct iguanair *ir;
> +	int rc;
>  
>  	if (!urb)
>  		return;
> @@ -166,34 +200,27 @@ static void iguanair_rx(struct urb *urb)
>  		break;
>  	}
>  
> -	usb_submit_urb(urb, GFP_ATOMIC);
> +	rc = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (rc && rc != -ENODEV)
> +		dev_warn(ir->dev, "failed to resubmit urb: %d\n", rc);
>  }
>  
> -static int iguanair_send(struct iguanair *ir, void *data, unsigned size,
> -			struct response_packet *response, unsigned *res_len)
> +static int iguanair_send(struct iguanair *ir, void *data, unsigned size)
>  {
> -	unsigned offset, len;
>  	int rc, transferred;
>  
> -	for (offset = 0; offset < size; offset += MAX_PACKET_SIZE) {
> -		len = min(size - offset, MAX_PACKET_SIZE);
> +	INIT_COMPLETION(ir->completion);
>  
> -		if (ir->tx_overflow)
> -			return -EOVERFLOW;
> +	rc = usb_interrupt_msg(ir->udev, ir->pipe_out, data, size,
> +							&transferred, TIMEOUT);
> +	if (rc)
> +		return rc;
>  
> -		rc = usb_interrupt_msg(ir->udev, ir->pipe_out, data + offset,
> -						len, &transferred, TIMEOUT);
> -		if (rc)
> -			return rc;
> +	if (transferred != size)
> +		return -EIO;
>  
> -		if (transferred != len)
> -			return -EIO;
> -	}
> -
> -	if (response) {
> -		rc = usb_interrupt_msg(ir->udev, ir->pipe_in, response,
> -					sizeof(*response), res_len, TIMEOUT);
> -	}
> +	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0)
> +		return -ETIMEDOUT;
>  
>  	return rc;
>  }
> @@ -201,66 +228,43 @@ static int iguanair_send(struct iguanair *ir, void *data, unsigned size,
>  static int iguanair_get_features(struct iguanair *ir)
>  {
>  	struct packet packet;
> -	struct response_packet response;
> -	int rc, len;
> +	int rc;
>  
>  	packet.start = 0;
>  	packet.direction = DIR_OUT;
>  	packet.cmd = CMD_GET_VERSION;
>  
> -	rc = iguanair_send(ir, &packet, sizeof(packet), &response, &len);
> +	rc = iguanair_send(ir, &packet, sizeof(packet));
>  	if (rc) {
>  		dev_info(ir->dev, "failed to get version\n");
>  		goto out;
>  	}
>  
> -	if (len != 6) {
> -		dev_info(ir->dev, "failed to get version\n");
> -		rc = -EIO;
> +	if (ir->version < 0x205) {
> +		dev_err(ir->dev, "firmware 0x%04x is too old\n", ir->version);
> +		rc = -ENODEV;
>  		goto out;
>  	}
>  
> -	ir->version[0] = response.data[0];
> -	ir->version[1] = response.data[1];
>  	ir->bufsize = 150;
>  	ir->cycle_overhead = 65;
>  
>  	packet.cmd = CMD_GET_BUFSIZE;
>  
> -	rc = iguanair_send(ir, &packet, sizeof(packet), &response, &len);
> +	rc = iguanair_send(ir, &packet, sizeof(packet));
>  	if (rc) {
>  		dev_info(ir->dev, "failed to get buffer size\n");
>  		goto out;
>  	}
>  
> -	if (len != 5) {
> -		dev_info(ir->dev, "failed to get buffer size\n");
> -		rc = -EIO;
> -		goto out;
> -	}
> -
> -	ir->bufsize = response.data[0];
> -
> -	if (ir->version[0] == 0 || ir->version[1] == 0)
> -		goto out;
> -
>  	packet.cmd = CMD_GET_FEATURES;
>  
> -	rc = iguanair_send(ir, &packet, sizeof(packet), &response, &len);
> +	rc = iguanair_send(ir, &packet, sizeof(packet));
>  	if (rc) {
>  		dev_info(ir->dev, "failed to get features\n");
>  		goto out;
>  	}
>  
> -	if (len < 5) {
> -		dev_info(ir->dev, "failed to get features\n");
> -		rc = -EIO;
> -		goto out;
> -	}
> -
> -	if (len > 5 && ir->version[0] >= 4)
> -		ir->cycle_overhead = response.data[1];
> -
>  out:
>  	return rc;
>  }
> @@ -269,17 +273,11 @@ static int iguanair_receiver(struct iguanair *ir, bool enable)
>  {
>  	struct packet packet = { 0, DIR_OUT, enable ?
>  				CMD_RECEIVER_ON : CMD_RECEIVER_OFF };
> -	int rc;
> -
> -	INIT_COMPLETION(ir->completion);
> -
> -	rc = iguanair_send(ir, &packet, sizeof(packet), NULL, NULL);
> -	if (rc)
> -		return rc;
>  
> -	wait_for_completion_timeout(&ir->completion, TIMEOUT);
> +	if (enable)
> +		ir_raw_event_reset(ir->rc);
>  
> -	return 0;
> +	return iguanair_send(ir, &packet, sizeof(packet));
>  }
>  
>  /*
> @@ -406,17 +404,10 @@ static int iguanair_tx(struct rc_dev *dev, unsigned *txbuf, unsigned count)
>  
>  	ir->tx_overflow = false;
>  
> -	INIT_COMPLETION(ir->completion);
> -
> -	rc = iguanair_send(ir, packet, size + 8, NULL, NULL);
> +	rc = iguanair_send(ir, packet, size + 8);
>  
> -	if (rc == 0) {
> -		wait_for_completion_timeout(&ir->completion, TIMEOUT);
> -		if (ir->tx_overflow)
> -			rc = -EOVERFLOW;
> -	}
> -
> -	ir->tx_overflow = false;
> +	if (rc == 0 && ir->tx_overflow)
> +		rc = -EOVERFLOW;
>  
>  	if (ir->receiver_on) {
>  		if (iguanair_receiver(ir, true))
> @@ -437,8 +428,6 @@ static int iguanair_open(struct rc_dev *rdev)
>  
>  	mutex_lock(&ir->lock);
>  
> -	usb_submit_urb(ir->urb_in, GFP_KERNEL);
> -
>  	BUG_ON(ir->receiver_on);
>  
>  	rc = iguanair_receiver(ir, true);
> @@ -459,11 +448,9 @@ static void iguanair_close(struct rc_dev *rdev)
>  
>  	rc = iguanair_receiver(ir, false);
>  	ir->receiver_on = false;
> -	if (rc)
> +	if (rc && rc != -ENODEV)
>  		dev_warn(ir->dev, "failed to disable receiver: %d\n", rc);
>  
> -	usb_kill_urb(ir->urb_in);
> -
>  	mutex_unlock(&ir->lock);
>  }
>  
> @@ -473,7 +460,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
>  	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct iguanair *ir;
>  	struct rc_dev *rc;
> -	int ret;
> +	int ret, pipein;
>  	struct usb_host_interface *idesc;
>  
>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> @@ -502,28 +489,29 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
>  	ir->rc = rc;
>  	ir->dev = &intf->dev;
>  	ir->udev = udev;
> -	ir->pipe_in = usb_rcvintpipe(udev,
> -				idesc->endpoint[0].desc.bEndpointAddress);
>  	ir->pipe_out = usb_sndintpipe(udev,
>  				idesc->endpoint[1].desc.bEndpointAddress);
>  	mutex_init(&ir->lock);
>  	init_completion(&ir->completion);
>  
> -	ret = iguanair_get_features(ir);
> +	pipein = usb_rcvintpipe(udev, idesc->endpoint[0].desc.bEndpointAddress);
> +	usb_fill_int_urb(ir->urb_in, udev, pipein, ir->buf_in,
> +		MAX_PACKET_SIZE, iguanair_rx, ir, int_urb_interval(udev));
> +	ir->urb_in->transfer_dma = ir->dma_in;
> +	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	ret = usb_submit_urb(ir->urb_in, GFP_KERNEL);
>  	if (ret) {
> -		dev_warn(&intf->dev, "failed to get device features");
> +		dev_warn(&intf->dev, "failed to submit urb: %d\n", ret);
>  		goto out;
>  	}
>  
> -	usb_fill_int_urb(ir->urb_in, ir->udev, ir->pipe_in, ir->buf_in,
> -		MAX_PACKET_SIZE, iguanair_rx, ir,
> -		idesc->endpoint[0].desc.bInterval);
> -	ir->urb_in->transfer_dma = ir->dma_in;
> -	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +	ret = iguanair_get_features(ir);
> +	if (ret)
> +		goto out2;
>  
>  	snprintf(ir->name, sizeof(ir->name),
> -		"IguanaWorks USB IR Transceiver version %d.%d",
> -		ir->version[0], ir->version[1]);
> +		"IguanaWorks USB IR Transceiver version 0x%04x", ir->version);
>  
>  	usb_make_path(ir->udev, ir->phys, sizeof(ir->phys));
>  
> @@ -540,21 +528,23 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
>  	rc->s_tx_carrier = iguanair_set_tx_carrier;
>  	rc->tx_ir = iguanair_tx;
>  	rc->driver_name = DRIVER_NAME;
> -	rc->map_name = RC_MAP_EMPTY;
> +	rc->map_name = RC_MAP_RC6_MCE;
> +	rc->timeout = MS_TO_NS(100);
> +	rc->rx_resolution = RX_RESOLUTION;
>  
>  	iguanair_set_tx_carrier(rc, 38000);
>  
>  	ret = rc_register_device(rc);
>  	if (ret < 0) {
>  		dev_err(&intf->dev, "failed to register rc device %d", ret);
> -		goto out;
> +		goto out2;
>  	}
>  
>  	usb_set_intfdata(intf, ir);
>  
> -	dev_info(&intf->dev, "Registered %s", ir->name);
> -
>  	return 0;
> +out2:
> +	usb_kill_urb(ir->urb_in);
>  out:
>  	if (ir) {
>  		usb_free_urb(ir->urb_in);
> @@ -570,12 +560,11 @@ static void __devexit iguanair_disconnect(struct usb_interface *intf)
>  {
>  	struct iguanair *ir = usb_get_intfdata(intf);
>  
> +	rc_unregister_device(ir->rc);
>  	usb_set_intfdata(intf, NULL);
> -
>  	usb_kill_urb(ir->urb_in);
>  	usb_free_urb(ir->urb_in);
>  	usb_free_coherent(ir->udev, MAX_PACKET_SIZE, ir->buf_in, ir->dma_in);
> -	rc_unregister_device(ir->rc);
>  	kfree(ir);
>  }
>  
> @@ -592,6 +581,8 @@ static int iguanair_suspend(struct usb_interface *intf, pm_message_t message)
>  			dev_warn(ir->dev, "failed to disable receiver for suspend\n");
>  	}
>  
> +	usb_kill_urb(ir->urb_in);
> +
>  	mutex_unlock(&ir->lock);
>  
>  	return rc;
> @@ -604,6 +595,10 @@ static int iguanair_resume(struct usb_interface *intf)
>  
>  	mutex_lock(&ir->lock);
>  
> +	rc = usb_submit_urb(ir->urb_in, GFP_KERNEL);
> +	if (rc)
> +		dev_warn(&intf->dev, "failed to submit urb: %d\n", rc);
> +
>  	if (ir->receiver_on) {
>  		rc = iguanair_receiver(ir, true);
>  		if (rc)
> @@ -627,7 +622,8 @@ static struct usb_driver iguanair_driver = {
>  	.suspend = iguanair_suspend,
>  	.resume = iguanair_resume,
>  	.reset_resume = iguanair_resume,
> -	.id_table = iguanair_table
> +	.id_table = iguanair_table,
> +	.soft_unbind = 1	/* we want to disable receiver on unbind */
>  };
>  
>  module_usb_driver(iguanair_driver);
> 

