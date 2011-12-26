Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1LZMSi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 07:18:38 -0500
Message-ID: <4EF86614.8050702@redhat.com>
Date: Mon, 26 Dec 2011 10:18:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Holger Nelson <hnelson@hnelson.de>
CC: Dennis Sperlich <dsperlich@googlemail.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com> <4EF767CB.10705@redhat.com> <4EF78896.1060908@gmail.com> <alpine.DEB.2.02.1112260627170.17197@nova.crius.de>
In-Reply-To: <alpine.DEB.2.02.1112260627170.17197@nova.crius.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26-12-2011 03:55, Holger Nelson wrote:
> Hi!
> 
> On Sun, 25 Dec 2011, Dennis Sperlich wrote:
> 
>> I just tried, replacing
>>    max_dvb_packet_size = em28xx_isoc_dvb_max_packetsize(dev);
>> by
>>    max_dvb_packet_size = dev->alt_max_pkt_size[1];
>>
>> but it did not work. Was this the correct replacement?
>>
>>    printk(KERN_INFO "dev->alt_max_pkt_size[1] is %i\n",dev->alt_max_pkt_size[1]);
>>
>> then said, dev->alt_max_pkt_size[1] is 0.
>>
>> I also attachted  a lsusb -v output for the Terratec Cinergy HTC Stick. I don't know, which of these endpoints the dvb-c part is, but it may be anyway usefull.
> 
> Is it possible, that dev->alt_max_pkt_size gets the maximum packet sizes for the analog video input endpoint (0x82 in lsusb output)? The patch below worked during a small test, but I doubt that it is the best way to do it.
> 
> While still looking at it: Is there a reason to allocate 32 bytes per alternate interface configuration if we only store one unsigned int per configuration in it? - I just copied the allocation code from above.
> 
> Holger
> 
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 1704da0..70866c5 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -3269,6 +3273,30 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>          dev->alt_max_pkt_size[i] = size;
>      }
> 
> +    dev->alt_dvb_max_pkt_size = kmalloc(32 * dev->num_alt, GFP_KERNEL);

It is likely over-allocating memory. The proper way would be to replace 32 by
sizeof(dev->alt_dvb_max_pkt_size[0]).

> +
> +    if (dev->alt_dvb_max_pkt_size == NULL) {
> +        em28xx_errdev("out of memory!\n");
> +        kfree(dev);
> +        retval = -ENOMEM;
> +        goto err;
> +    }
> +
> +    for (i = 0; i < dev->num_alt ; i++) {
> +            int ep;
> +        for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
> +            struct usb_host_endpoint *e = &interface->altsetting[i].endpoint[ep];
> +            if (e->desc.bEndpointAddress == 0x84) {

Yeah, this looks correct. 
Yet, I would avoid create another loop here. Also, there are too many
hacks at the em28xx probe utility. Take a look at the tm6000-cards.c.
It used to be similar to em28xx probe, but the code now looks better.

IMO, we should add, at em28xx-regs:

#define EM28XX_EP_ANALOG	0x82
#define EM28XX_EP_AUDIO		0x83
#define EM28XX_EP_DIGITAL	0x84

and use those macros a	

> +                u16 tmp = le16_to_cpu(e->desc.wMaxPacketSize);
> +                unsigned int size = tmp & 0x7ff;
> +                if (udev->speed == USB_SPEED_HIGH)
> +                    size = size * hb_mult(tmp);
> +
> +                dev->alt_dvb_max_pkt_size[i] = size;
> +            }
> +        }
> +    }
> +
>      if ((card[nr] >= 0) && (card[nr] < em28xx_bcount))
>          dev->model = card[nr];
> 
> @@ -3281,6 +3309,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>      retval = em28xx_init_dev(&dev, udev, interface, nr);
>      if (retval) {
>          mutex_unlock(&dev->lock);
> +        kfree(dev->alt_dvb_max_pkt_size);
>          kfree(dev->alt_max_pkt_size);
>          kfree(dev);
>          goto err;
> @@ -3365,6 +3394,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
>      em28xx_close_extension(dev);
> 
>      if (!dev->users) {
> +        kfree(dev->alt_dvb_max_pkt_size);
>          kfree(dev->alt_max_pkt_size);
>          kfree(dev);
>      }
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index 804a4ab..e7d3541 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -1157,7 +1157,7 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
>           * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
>           * but not enough for 44 Mbit DVB-C.
>           */
> -        packet_size = 752;
> +        packet_size = dev->alt_dvb_max_pkt_size[1];
>      }
> 
>      return packet_size;
> diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> index 9b4557a..2491a2c 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -2254,6 +2254,7 @@ static int em28xx_v4l2_close(struct file *filp)
>             free the remaining resources */
>          if (dev->state & DEV_DISCONNECTED) {
>              em28xx_release_resources(dev);
> +            kfree(dev->alt_dvb_max_pkt_size);
>              kfree(dev->alt_max_pkt_size);
>              kfree(dev);
>              return 0;
> diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
> index b1199ef..793c85a 100644
> --- a/drivers/media/video/em28xx/em28xx.h
> +++ b/drivers/media/video/em28xx/em28xx.h
> @@ -597,6 +597,7 @@ struct em28xx {
>      int max_pkt_size;    /* max packet size of isoc transaction */
>      int num_alt;        /* Number of alternative settings */
>      unsigned int *alt_max_pkt_size;    /* array of wMaxPacketSize */
> +    unsigned int *alt_dvb_max_pkt_size;
>      struct urb *urb[EM28XX_NUM_BUFS];    /* urb for isoc transfers */
>      char *transfer_buffer[EM28XX_NUM_BUFS];    /* transfer buffers for isoc
>                             transfer */

The above code looks promising.

I'm currently without time right now to work on a patch, but I think that several hacks
inside the em28xx probe should be removed, including the one that detects the endpoint
based on the packet size.

As it is easier to code than to explain in words, the code below could be
a start (ok, it doesn't compile, doesn't remove all hacks, doesn't free memory, etc...)
Feel free to use it as a start for a real patch, if you wish.


diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 1704da0..1bd4ef5 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3087,8 +3087,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	struct usb_device *udev;
 	struct em28xx *dev = NULL;
 	int retval;
-	bool is_audio_only = false, has_audio = false;
-	int i, nr, isoc_pipe;
+	bool has_audio = false, has_video = false, has_dvb = false;
+	int i, nr, sizedescr, size;
 	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
 	char descr[255] = "";
@@ -3120,6 +3120,32 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err;
 	}
 
+	/* allocate memory for our device state and initialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		em28xx_err(DRIVER_NAME ": out of memory!\n");
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	/* compute alternate max packet sizes */
+	dev->alt_max_pkt_size = kmalloc(sizeof(dev->alt_max_pkt_size[0] *  interface->num_altsetting, GFP_KERNEL);
+	if (dev->alt_max_pkt_size == NULL) {
+		em28xx_errdev("out of memory!\n");
+		kfree(dev);
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	dev->alt_dvb_pkt_size = kmalloc(sizeof(dev->alt_max_pkt_size[0] *  interface->num_altsetting, GFP_KERNEL);
+	if (dev->alt_dvb_pkt_size == NULL) {
+		em28xx_errdev("out of memory!\n");
+		kfree();
+		kfree(dev);
+		retval = -ENOMEM;
+		goto err;
+	}
+
 	/* Get endpoints */
 	for (i = 0; i < interface->num_altsetting; i++) {
 		int ep;
@@ -3128,8 +3154,23 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			struct usb_host_endpoint	*e;
 			e = &interface->altsetting[i].endpoint[ep];
 
-			if (e->desc.bEndpointAddress == 0x83)
+			sizedescr = le16_to_cpu(interface->altsetting[i].endpoint[ep].desc.wMaxPacketSize);
+			size = sizedescr & 0x7fff;
+			if (udev->speed == USB_SPEED_HIGH)
+				size = size * hb_mult(sizedescr);
+
+			switch (e->desc.bEndpointAddress) {
+			case EM28XX_EP_AUDIO:
 				has_audio = true;
+				break;
+			case EM28XX_EP_ANALOG:
+				has_video = true;
+				dev->alt_max_pkt_size[i] = size;
+				break;
+			case EM28XX_EP_DIGITAL:
+				has_dvb = true;
+				dev->alt_dvb_pkt_size[i] = size;
+				break;
 		}
 	}
 
@@ -3223,14 +3264,6 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto err;
 	}
 
-	/* allocate memory for our device state and initialize it */
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		em28xx_err(DRIVER_NAME ": out of memory!\n");
-		retval = -ENOMEM;
-		goto err;
-	}
-
 	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 804a4ab..b73aaa5 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1070,7 +1070,7 @@ int em28xx_init_isoc(struct em28xx *dev, int max_packets,
 			should also be using 'desc.bInterval'
 		 */
 		pipe = usb_rcvisocpipe(dev->udev,
-			dev->mode == EM28XX_ANALOG_MODE ? 0x82 : 0x84);
+			dev->mode == EM28XX_ANALOG_MODE ? EM28XX_EP_ANALOG : EM28XX_EP_DIGITAL);
 
 		usb_fill_int_urb(urb, dev->udev, pipe,
 				 dev->isoc_ctl.transfer_buffer[i], sb_size,
diff --git a/drivers/media/video/em28xx/em28xx-reg.h b/drivers/media/video/em28xx/em28xx-reg.h
index 66f7923..2f62685 100644
--- a/drivers/media/video/em28xx/em28xx-reg.h
+++ b/drivers/media/video/em28xx/em28xx-reg.h
@@ -12,6 +12,11 @@
 #define EM_GPO_2   (1 << 2)
 #define EM_GPO_3   (1 << 3)
 
+/* em28xx endpoints */
+#define EM28XX_EP_ANALOG	0x82
+#define EM28XX_EP_AUDIO		0x83
+#define EM28XX_EP_DIGITAL	0x84
+
 /* em2800 registers */
 #define EM2800_R08_AUDIOSRC 0x08
 
