Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1IWW0C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 18:26:02 -0400
Message-ID: <4E7D0774.1050202@redhat.com>
Date: Fri, 23 Sep 2011 19:25:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 7/17]DVB:Siano drivers -  Support flexiable usb endpoint
 rather than hard-cored numbers.
References: <1316514677.5199.85.camel@Doron-Ubuntu>
In-Reply-To: <1316514677.5199.85.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:31, Doron Cohen escreveu:
> Hi,
> This patch changes the usb driver to support flexiable usb endpoint
> rather than hard-cored numbers.

Also looked ok, except for the whitespace mangling.

> 
> Thanks,
> Doron Cohen
> 
> --------------
> 
> 
> 
>>From e4134fa357d3f41476b8ff33ebbcb69c399641dc Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Mon, 19 Sep 2011 13:58:43 +0300
> Subject: [PATCH 10/21] Support flexible endpoint numbering for various
> SMS devices 9instead of hard coded values)
> 
> ---
>  drivers/media/dvb/siano/smsusb.c |  240
> +++++++++++++++++++++++--------------
>  1 files changed, 149 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/smsusb.c
> b/drivers/media/dvb/siano/smsusb.c
> index b1c38a2..d7ef147 100644
> --- a/drivers/media/dvb/siano/smsusb.c
> +++ b/drivers/media/dvb/siano/smsusb.c
> @@ -2,7 +2,7 @@
>  
>  Siano Mobile Silicon, Inc.
>  MDTV receiver kernel modules.
> -Copyright (C) 2005-2009, Uri Shkolnik, Anatoly Greenblat
> +Copyright (C) 2006-2011, Doron Cohen Cohen
>  
>  This program is free software: you can redistribute it and/or modify
>  it under the terms of the GNU General Public License as published by
> @@ -29,21 +29,93 @@ along with this program.  If not, see
> <http://www.gnu.org/licenses/>.
>  #include "sms-cards.h"
>  #include "smsendian.h"
>  
> -static int sms_dbg;
> -module_param_named(debug, sms_dbg, int, 0644);
> +int sms_debug;
> +module_param_named(debug, sms_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
>  
>  #define USB1_BUFFER_SIZE		0x1000
> -#define USB2_BUFFER_SIZE		0x4000
> +#define USB2_BUFFER_SIZE		0x2000
>  
>  #define MAX_BUFFERS		50
>  #define MAX_URBS		10
>  
> +
> +struct usb_device_id smsusb_id_table[] = {
> +	{ USB_DEVICE(0x187f, 0x0010),
> +		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR_ROM },
> +	{ USB_DEVICE(0x187f, 0x0100),
> +		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> +	{ USB_DEVICE(0x187f, 0x0200),
> +		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_A },
> +	{ USB_DEVICE(0x187f, 0x0201),
> +		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_B },
> +	{ USB_DEVICE(0x187f, 0x0300),
> +		.driver_info = SMS1XXX_BOARD_SIANO_VEGA },
> +	{ USB_DEVICE(0x2040, 0x1700),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT },
> +	{ USB_DEVICE(0x2040, 0x1800),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A },
> +	{ USB_DEVICE(0x2040, 0x1801),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B },
> +	{ USB_DEVICE(0x2040, 0x2000),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2009),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 },
> +	{ USB_DEVICE(0x2040, 0x200a),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2010),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2019),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x5500),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5510),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5520),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5530),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5580),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5590),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x187f, 0x0202),
> +		.driver_info = SMS1XXX_BOARD_SIANO_NICE },
> +	{ USB_DEVICE(0x187f, 0x0301),
> +		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
> +	{ USB_DEVICE(0x187f, 0x0302),
> +		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
> +	{ USB_DEVICE(0x187f, 0x0310),
> +		.driver_info = SMS1XXX_BOARD_SIANO_MING },	
> +	{ USB_DEVICE(0x187f, 0x0500),
> +		.driver_info = SMS1XXX_BOARD_SIANO_PELE },			
> +	{ USB_DEVICE(0x187f, 0x0600),
> +		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
> +	{ USB_DEVICE(0x187f, 0x0700),
> +		.driver_info = SMS1XXX_BOARD_SIANO_DENVER_2160 },	
> +	{ USB_DEVICE(0x187f, 0x0800),
> +		.driver_info = SMS1XXX_BOARD_SIANO_DENVER_1530 },     
> +	{ USB_DEVICE(0x19D2, 0x0086),
> +		.driver_info = SMS1XXX_BOARD_ZTE_DVB_DATA_CARD },
> +	{ USB_DEVICE(0x19D2, 0x0078),
> +		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
> +	{ } /* Terminating entry */
> +	};
> +
> +MODULE_DEVICE_TABLE(usb, smsusb_id_table);
> +
> +enum smsusb_state {
> +	SMSUSB_DISCONNECTED,
> +	SMSUSB_SUSPENDED,
> +	SMSUSB_ACTIVE
> +};
> +
>  struct smsusb_device_t;
>  
>  struct smsusb_urb_t {
> +	struct list_head entry;
>  	struct smscore_buffer_t *cb;
> -	struct smsusb_device_t	*dev;
> +	struct smsusb_device_t *dev;
>  
>  	struct urb urb;
>  };
> @@ -54,13 +126,26 @@ struct smsusb_device_t {
>  
>  	struct smsusb_urb_t 	surbs[MAX_URBS];
>  
> -	int		response_alignment;
> -	int		buffer_size;
> +	int response_alignment;
> +	int buffer_size;
> +	unsigned char in_ep;
> +	unsigned char out_ep;
> +	enum smsusb_state state;	
>  };
>  
>  static int smsusb_submit_urb(struct smsusb_device_t *dev,
>  			     struct smsusb_urb_t *surb);
>  
> +/**
> + * Completing URB's callback handler - top half (interrupt context)
> +
> + * adds completing sms urb to the global surbs list and activtes the
> worker  
> + * thread the surb
> + * IMPORTANT - blocking functions must not be called from here !!!
> +
> + * @param urb pointer to a completing urb object
> + */
> +
>  static void smsusb_onresponse(struct urb *urb)
>  {
>  	struct smsusb_urb_t *surb = (struct smsusb_urb_t *) urb->context;
> @@ -121,6 +206,7 @@ exit_and_resubmit:
>  	smsusb_submit_urb(dev, surb);
>  }
>  
> +
>  static int smsusb_submit_urb(struct smsusb_device_t *dev,
>  			     struct smsusb_urb_t *surb)
>  {
> @@ -135,7 +221,7 @@ static int smsusb_submit_urb(struct smsusb_device_t
> *dev,
>  	usb_fill_bulk_urb(
>  		&surb->urb,
>  		dev->udev,
> -		usb_rcvbulkpipe(dev->udev, 0x81),
> +		usb_rcvbulkpipe(dev->udev, dev->in_ep),
>  		surb->cb->p,
>  		dev->buffer_size,
>  		smsusb_onresponse,
> @@ -182,6 +268,9 @@ static int smsusb_sendrequest(void *context, void
> *buffer, size_t size)
>  	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
>  	int dummy;
>  
> +	if (dev->state != SMSUSB_ACTIVE)
> +		return -ENOENT;
> +		
>  	smsendian_handle_message_header((struct SmsMsgHdr_S *)buffer);
>  	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
>  			    buffer, size, &dummy, 1000);
> @@ -291,15 +380,16 @@ static void smsusb_term_device(struct
> usb_interface *intf)
>  	struct smsusb_device_t *dev = usb_get_intfdata(intf);
>  
>  	if (dev) {
> +		dev->state = SMSUSB_DISCONNECTED;
> +		
>  		smsusb_stop_streaming(dev);
>  
>  		/* unregister from smscore */
>  		if (dev->coredev)
>  			smscore_unregister_device(dev->coredev);
>  
> +		sms_info("device 0x%p destroyed", dev);
>  		kfree(dev);
> -
> -		sms_info("device %p destroyed", dev);
>  	}
>  
>  	usb_set_intfdata(intf, NULL);
> @@ -321,6 +411,7 @@ static int smsusb_init_device(struct usb_interface
> *intf, int board_id)
>  	memset(&params, 0, sizeof(params));
>  	usb_set_intfdata(intf, dev);
>  	dev->udev = interface_to_usbdev(intf);
> +	dev->state = SMSUSB_DISCONNECTED;
>  
>  	params.device_type = sms_get_board(board_id)->type;
>  
> @@ -337,6 +428,8 @@ static int smsusb_init_device(struct usb_interface
> *intf, int board_id)
>  	case SMS_NOVA_A0:
>  	case SMS_NOVA_B0:
>  	case SMS_VEGA:
> +	case SMS_VENICE:
> +	case SMS_DENVER_1530:
>  		dev->buffer_size = USB2_BUFFER_SIZE;
>  		dev->response_alignment =
>  		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
> @@ -346,6 +439,18 @@ static int smsusb_init_device(struct usb_interface
> *intf, int board_id)
>  		break;
>  	}
>  
> +	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) 
> +		if (intf->cur_altsetting->endpoint[i].desc.
> +			bEndpointAddress & USB_DIR_IN)
> +			dev->in_ep = intf->cur_altsetting->endpoint[i].desc.
> +			bEndpointAddress;
> +		else
> +			dev->out_ep = intf->cur_altsetting->endpoint[i].desc.
> +			bEndpointAddress;
> +
> +	sms_info("in_ep = %02x, out_ep = %02x",
> +		dev->in_ep, dev->out_ep);
> +
>  	params.device = &dev->udev->dev;
>  	params.buffer_size = dev->buffer_size;
>  	params.num_buffers = MAX_BUFFERS;
> @@ -377,6 +482,8 @@ static int smsusb_init_device(struct usb_interface
> *intf, int board_id)
>  		return rc;
>  	}
>  
> +	dev->state = SMSUSB_ACTIVE;
> +	
>  	rc = smscore_start_device(dev->coredev);
>  	if (rc < 0) {
>  		sms_err("smscore_start_device(...) failed");
> @@ -384,7 +491,7 @@ static int smsusb_init_device(struct usb_interface
> *intf, int board_id)
>  		return rc;
>  	}
>  
> -	sms_info("device %p created", dev);
> +	sms_info("device 0x%p created", dev);
>  
>  	return rc;
>  }
> @@ -396,12 +503,21 @@ static int __devinit smsusb_probe(struct
> usb_interface *intf,
>  	char devpath[32];
>  	int i, rc;
>  
> -	rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x81));
> -	rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x02));
> +	sms_info("interface number %d",
> +		 intf->cur_altsetting->desc.bInterfaceNumber);
>  
> -	if (intf->num_altsetting > 0) {
> -		rc = usb_set_interface(
> -			udev, intf->cur_altsetting->desc.bInterfaceNumber, 0);
> +	if (sms_get_board(id->driver_info)->intf_num != 
> +		intf->cur_altsetting->desc.bInterfaceNumber) {
> +		sms_err("interface number is %d expecting %d",
> +			sms_get_board(id->driver_info)->intf_num, 
> +			intf->cur_altsetting->desc.bInterfaceNumber);
> +		return -ENODEV;
> +	}
> +
> +	if (intf->num_altsetting > 1) {
> +		rc = usb_set_interface(udev,
> +				intf->cur_altsetting->desc.
> +				bInterfaceNumber, 0);
>  		if (rc < 0) {
>  			sms_err("usb_set_interface failed, rc %d", rc);
>  			return rc;
> @@ -411,18 +527,24 @@ static int __devinit smsusb_probe(struct
> usb_interface *intf,
>  	sms_info("smsusb_probe %d",
>  	       intf->cur_altsetting->desc.bInterfaceNumber);
>  	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++)
> +	{
>  		sms_info("endpoint %d %02x %02x %d", i,
>  		       intf->cur_altsetting->endpoint[i].desc.bEndpointAddress,
>  		       intf->cur_altsetting->endpoint[i].desc.bmAttributes,
>  		       intf->cur_altsetting->endpoint[i].desc.wMaxPacketSize);
> -
> -	if ((udev->actconfig->desc.bNumInterfaces == 2) &&
> -	    (intf->cur_altsetting->desc.bInterfaceNumber == 0)) {
> -		sms_err("rom interface 0 is not used");
> -		return -ENODEV;
> +		if (intf->cur_altsetting->endpoint[i].desc.
> +			bEndpointAddress & USB_DIR_IN)
> +			rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev, 
> +				intf->cur_altsetting->endpoint[i].desc.
> +				bEndpointAddress));
> +		else
> +			rc = usb_clear_halt(udev, usb_sndbulkpipe(udev, 
> +				intf->cur_altsetting->endpoint[i].desc.
> +				bEndpointAddress));
>  	}
>  
> -	if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
> +	if (id->driver_info == SMS1XXX_BOARD_SIANO_STELLAR_ROM) {
> +		sms_info("stellar device was found.");
>  		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
>  			 udev->bus->busnum, udev->devpath);
>  		sms_info("stellar device was found.");
> @@ -445,7 +567,9 @@ static void smsusb_disconnect(struct usb_interface
> *intf)
>  static int smsusb_suspend(struct usb_interface *intf, pm_message_t msg)
>  {
>  	struct smsusb_device_t *dev = usb_get_intfdata(intf);
> -	printk(KERN_INFO "%s: Entering status %d.\n", __func__, msg.event);
> +	printk(KERN_INFO "%s  Entering status %d.\n", __func__, msg.event);
> +	dev->state = SMSUSB_SUSPENDED;
> +	/*smscore_set_power_mode(dev, SMS_POWER_MODE_SUSPENDED);*/
>  	smsusb_stop_streaming(dev);
>  	return 0;
>  }
> @@ -457,8 +581,8 @@ static int smsusb_resume(struct usb_interface *intf)
>  	struct usb_device *udev = interface_to_usbdev(intf);
>  
>  	printk(KERN_INFO "%s: Entering.\n", __func__);
> -	usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x81));
> -	usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x02));
> +	usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->in_ep));
> +	usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->out_ep));
>  
>  	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++)
>  		printk(KERN_INFO "endpoint %d %02x %02x %d\n", i,
> @@ -481,72 +605,6 @@ static int smsusb_resume(struct usb_interface
> *intf)
>  	return 0;
>  }
>  
> -static const struct usb_device_id smsusb_id_table[] __devinitconst = {
> -	{ USB_DEVICE(0x187f, 0x0010),
> -		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> -	{ USB_DEVICE(0x187f, 0x0100),
> -		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> -	{ USB_DEVICE(0x187f, 0x0200),
> -		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_A },
> -	{ USB_DEVICE(0x187f, 0x0201),
> -		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_B },
> -	{ USB_DEVICE(0x187f, 0x0300),
> -		.driver_info = SMS1XXX_BOARD_SIANO_VEGA },
> -	{ USB_DEVICE(0x2040, 0x1700),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT },
> -	{ USB_DEVICE(0x2040, 0x1800),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A },
> -	{ USB_DEVICE(0x2040, 0x1801),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B },
> -	{ USB_DEVICE(0x2040, 0x2000),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2009),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 },
> -	{ USB_DEVICE(0x2040, 0x200a),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2010),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2011),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2019),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x5500),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5510),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5520),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5530),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5580),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5590),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x187f, 0x0202),
> -		.driver_info = SMS1XXX_BOARD_SIANO_NICE },
> -	{ USB_DEVICE(0x187f, 0x0301),
> -		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
> -	{ USB_DEVICE(0x2040, 0xb900),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xb910),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xb980),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xb990),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xc000),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xc010),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xc080),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0xc090),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ } /* Terminating entry */
> -	};
> -
> -MODULE_DEVICE_TABLE(usb, smsusb_id_table);
> -
>  static struct usb_driver smsusb_driver = {
>  	.name			= "smsusb",
>  	.probe			= smsusb_probe,

