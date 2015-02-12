Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41899 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbbBLJmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 04:42:50 -0500
Date: Thu, 12 Feb 2015 07:42:44 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC] dvb-usb-v2: add support for the media controller at
 USB driver
Message-ID: <20150212074244.1a0e0799@recife.lan>
In-Reply-To: <1423699484-8733-1-git-send-email-chehabrafael@gmail.com>
References: <1423699484-8733-1-git-send-email-chehabrafael@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Feb 2015 22:04:44 -0200
Rafael Lourenço de Lima Chehab  <chehabrafael@gmail.com> escreveu:

> Create a struct media_device and add it to the dvb adapter.
> 
> Please notice that the tuner is not mapped yet by the dvb core.
> 
> Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
> ---
>  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  5 +++
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 61 +++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> index 14e111e13e54..b273250d0e31 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> @@ -25,6 +25,7 @@
>  #include <linux/usb/input.h>
>  #include <linux/firmware.h>
>  #include <media/rc-core.h>
> +#include <media/media-device.h>
>  
>  #include "dvb_frontend.h"
>  #include "dvb_demux.h"
> @@ -389,6 +390,10 @@ struct dvb_usb_device {
>  	struct delayed_work rc_query_work;
>  
>  	void *priv;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_device *media_dev;
> +#endif
>  };
>  
>  extern int dvb_usbv2_probe(struct usb_interface *,
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> index 1950f37df835..ea4d7bec8fc1 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -86,6 +86,8 @@ static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
>  		goto err;
>  	}
>  
> +	dvb_create_media_graph(d->media_dev);
> +
>  	return 0;


Hmm... this is being called too early. It should be called, instead, at
dvb_usbv2_adapter_frontend_init():

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index f3d1211..0fd184c 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -86,8 +86,6 @@ static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
 		goto err;
 	}
 
-	dvb_create_media_graph(d->media_dev);
-
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
@@ -703,6 +701,8 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		}
 	}
 
+	dvb_create_media_graph(d->media_dev);
+
 	return 0;
 
 err_dvb_unregister_frontend:

With the above change, the patch looks OK on my eyes.

I did a quick test here with two devices:

$ media-ctl -p
Media controller API version 0.1.0

Media device information
------------------------
driver          usb
model           TerraTec Cinergy T Stick RC
serial          010101010600001
bus info        1.2
hw revision     0x200
driver version  3.19.0

Device topology
- entity 1: demux (2 pads, 2 links)
            type Node subtype DVB DEMUX flags 0
            device node name /dev/dvb/adapter0/demux0
	pad0: Sink
		<- "Afatech AF9013":1 [ENABLED]
	pad1: Source
		-> "dvr":0 [ENABLED]

- entity 2: dvr (1 pad, 1 link)
            type Node subtype DVB DVR flags 0
            device node name /dev/dvb/adapter0/dvr0
	pad0: Sink
		<- "demux":1 [ENABLED]

- entity 3: dvb net (0 pad, 0 link)
            type Node subtype DVB NET flags 0
            device node name /dev/dvb/adapter0/net0

- entity 4: Afatech AF9013 (2 pads, 1 link)
            type Node subtype DVB FE flags 0
            device node name /dev/dvb/adapter0/frontend0
	pad0: Sink
	pad1: Source
		-> "demux":0 [ENABLED]

$ media-ctl -p -d /dev/media1
Media controller API version 0.1.0

Media device information
------------------------
driver          usb
model           DVBSky S960CI
serial          20130508
bus info        2
hw revision     0x0
driver version  3.19.0

Device topology
- entity 1: demux (2 pads, 3 links)
            type Node subtype DVB DEMUX flags 0
            device node name /dev/dvb/adapter1/demux0
	pad0: Sink
		<- "Montage M88DS3103":1 [ENABLED]
	pad1: Source
		-> "dvr":0 [ENABLED]
		-> "ca_en50221":0 [ENABLED]

- entity 2: dvr (1 pad, 1 link)
            type Node subtype DVB DVR flags 0
            device node name /dev/dvb/adapter1/dvr0
	pad0: Sink
		<- "demux":1 [ENABLED]

- entity 3: dvb net (0 pad, 0 link)
            type Node subtype DVB NET flags 0
            device node name /dev/dvb/adapter1/net0

- entity 4: ca_en50221 (2 pads, 1 link)
            type Node subtype DVB CA flags 0
            device node name /dev/dvb/adapter1/ca0
	pad0: Sink
		<- "demux":1 [ENABLED]
	pad1: Source

- entity 5: Montage M88DS3103 (2 pads, 1 link)
            type Node subtype DVB FE flags 0
            device node name /dev/dvb/adapter1/frontend0
	pad0: Sink
	pad1: Source
		-> "demux":0 [ENABLED]

Both devices are OK on my eyes.

Regards,
Mauro
