Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hnelson.de ([83.169.43.49]:48852 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1LZFz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 00:55:27 -0500
Date: Mon, 26 Dec 2011 06:55:24 +0100 (CET)
From: Holger Nelson <hnelson@hnelson.de>
To: Dennis Sperlich <dsperlich@googlemail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
In-Reply-To: <4EF78896.1060908@gmail.com>
Message-ID: <alpine.DEB.2.02.1112260627170.17197@nova.crius.de>
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com> <4EF767CB.10705@redhat.com> <4EF78896.1060908@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Sun, 25 Dec 2011, Dennis Sperlich wrote:

> I just tried, replacing
>    max_dvb_packet_size = em28xx_isoc_dvb_max_packetsize(dev);
> by
>    max_dvb_packet_size = dev->alt_max_pkt_size[1];
>
> but it did not work. Was this the correct replacement?
>
>    printk(KERN_INFO "dev->alt_max_pkt_size[1] is 
> %i\n",dev->alt_max_pkt_size[1]);
>
> then said, dev->alt_max_pkt_size[1] is 0.
>
> I also attachted  a lsusb -v output for the Terratec Cinergy HTC Stick. I 
> don't know, which of these endpoints the dvb-c part is, but it may be anyway 
> usefull.

Is it possible, that dev->alt_max_pkt_size gets the maximum packet sizes 
for the analog video input endpoint (0x82 in lsusb output)? The patch 
below worked during a small test, but I doubt that it is the best way to 
do it.

While still looking at it: Is there a reason to allocate 32 bytes per 
alternate interface configuration if we only store one unsigned int per 
configuration in it? - I just copied the allocation code from above.

Holger

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 1704da0..70866c5 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3269,6 +3273,30 @@ static int em28xx_usb_probe(struct usb_interface *interface,
  		dev->alt_max_pkt_size[i] = size;
  	}

+	dev->alt_dvb_max_pkt_size = kmalloc(32 * dev->num_alt, GFP_KERNEL);
+
+	if (dev->alt_dvb_max_pkt_size == NULL) {
+		em28xx_errdev("out of memory!\n");
+		kfree(dev);
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	for (i = 0; i < dev->num_alt ; i++) {
+	        int ep;
+		for (ep = 0; ep < interface->altsetting[i].desc.bNumEndpoints; ep++) {
+			struct usb_host_endpoint *e = &interface->altsetting[i].endpoint[ep];
+			if (e->desc.bEndpointAddress == 0x84) {
+				u16 tmp = le16_to_cpu(e->desc.wMaxPacketSize);
+				unsigned int size = tmp & 0x7ff;
+				if (udev->speed == USB_SPEED_HIGH)
+					size = size * hb_mult(tmp);
+
+				dev->alt_dvb_max_pkt_size[i] = size;
+			}
+		}
+	}
+
  	if ((card[nr] >= 0) && (card[nr] < em28xx_bcount))
  		dev->model = card[nr];

@@ -3281,6 +3309,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
  	retval = em28xx_init_dev(&dev, udev, interface, nr);
  	if (retval) {
  		mutex_unlock(&dev->lock);
+		kfree(dev->alt_dvb_max_pkt_size);
  		kfree(dev->alt_max_pkt_size);
  		kfree(dev);
  		goto err;
@@ -3365,6 +3394,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
  	em28xx_close_extension(dev);

  	if (!dev->users) {
+		kfree(dev->alt_dvb_max_pkt_size);
  		kfree(dev->alt_max_pkt_size);
  		kfree(dev);
  	}
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 804a4ab..e7d3541 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1157,7 +1157,7 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
  		 * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
  		 * but not enough for 44 Mbit DVB-C.
  		 */
-		packet_size = 752;
+		packet_size = dev->alt_dvb_max_pkt_size[1];
  	}

  	return packet_size;
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 9b4557a..2491a2c 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2254,6 +2254,7 @@ static int em28xx_v4l2_close(struct file *filp)
  		   free the remaining resources */
  		if (dev->state & DEV_DISCONNECTED) {
  			em28xx_release_resources(dev);
+			kfree(dev->alt_dvb_max_pkt_size);
  			kfree(dev->alt_max_pkt_size);
  			kfree(dev);
  			return 0;
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index b1199ef..793c85a 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -597,6 +597,7 @@ struct em28xx {
  	int max_pkt_size;	/* max packet size of isoc transaction */
  	int num_alt;		/* Number of alternative settings */
  	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
+	unsigned int *alt_dvb_max_pkt_size;
  	struct urb *urb[EM28XX_NUM_BUFS];	/* urb for isoc transfers */
  	char *transfer_buffer[EM28XX_NUM_BUFS];	/* transfer buffers for isoc
  						   transfer */
