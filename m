Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44824 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab0L2NkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 08:40:14 -0500
Subject: Re: [PATCH 1/3] hdpvr: Add I2C and ir-kdb-i2c registration of the
 Zilog Z8 IR chip
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	bcjenkins@tvwhere.com
In-Reply-To: <4D1B16C9.6070502@redhat.com>
References: <1293587067.3098.10.camel@localhost>
	 <1293587173.3098.12.camel@localhost>  <4D1B16C9.6070502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 08:40:39 -0500
Message-ID: <1293630039.2091.40.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 2010-12-29 at 09:08 -0200, Mauro Carvalho Chehab wrote:
> Em 28-12-2010 23:46, Andy Walls escreveu:
> > 
> > Add I2C registration of the Zilog Z8F0811 IR microcontroller for either
> > lirc_zilog or ir-kbd-i2c to use.  This is a required step in removing
> > lirc_zilog's use of the deprecated struct i2c_adapter.id field.
> > 
> > Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> > ---
> >  drivers/media/video/hdpvr/hdpvr-core.c |    5 +++
> >  drivers/media/video/hdpvr/hdpvr-i2c.c  |   53 ++++++++++++++++++++++++++++++++
> >  drivers/media/video/hdpvr/hdpvr.h      |    6 +++
> >  3 files changed, 64 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
> > index b70d6af..f7d1ee5 100644
> > --- a/drivers/media/video/hdpvr/hdpvr-core.c
> > +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> > @@ -385,6 +385,11 @@ static int hdpvr_probe(struct usb_interface *interface,
> >  		v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
> >  		goto error;
> >  	}
> > +
> > +	/* until i2c is working properly */
> > +	retval = 0; /* hdpvr_register_i2c_ir(dev); */
> 
> Hmm... It seems that this will just disable the IR logic... Why do you need it?
> Your comment is not clear to me.
>
> > +	if (retval < 0)
> > +		v4l2_err(&dev->v4l2_dev, "registering i2c IR devices failed\n");
> >  #endif /* CONFIG_I2C */

The diff did not provide you with all the context you needed.  See:

http://git.linuxtv.org/awalls/media_tree.git?a=blob;f=drivers/media/video/hdpvr/hdpvr-core.c;h=f7d1ee55185a527c4b0302acdbd30c5b5f523c1c;hb=15a40f5388f382243b6bc41c6874e1549324e789#l380

Note just before my addition, that the I2C adapter of the HD PVR is not
currently being registered in the existing hdpvr code:

 382         /* until i2c is working properly */
 383         retval = 0; /* hdpvr_register_i2c_adapter(dev); */
 384         if (retval < 0) {
 385                 v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
 386                 goto error;
 387         }
 388 
 389         /* until i2c is working properly */
 390         retval = 0; /* hdpvr_register_i2c_ir(dev); */
 391         if (retval < 0)
 392                 v4l2_err(&dev->v4l2_dev, "registering i2c IR devices failed\n");

A few years ago, Brandon Jenkins was able to trigger a USB/I2C related
Oops when both the hdpvr and cx18 drivers were loaded in his system.  At
the time Janne determined it would be prudent to disable hdpvr I2C
support.

I'd really like Janne to comment on this, but it may be that hdpvr I2C
problems are no longer an issue(?). See this thread:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg09163.html
  
If hdpvr I2C functionality is ever going to be re-enabled, these IR
changes make hdpvr consistent with what ivtv and cx18 do for their Zilog
Z8F0811 IR controller.

IF hdpvr I2C functionality is *never* going to be re-enabled, then this
whole patch can be dropped.

> >  	/* let the user know what node this device is now attached to */
> > diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
> > index 409de11..24966aa 100644
> > --- a/drivers/media/video/hdpvr/hdpvr-i2c.c
> > +++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
> > @@ -4,6 +4,9 @@
> >   *
> >   * Copyright (C) 2008      Janne Grunau (j@jannau.net)
> >   *
> > + * IR device registration code is
> > + * Copyright (C) 2010	Andy Walls <awalls@md.metrocast.net>
> > + *
> >   *	This program is free software; you can redistribute it and/or
> >   *	modify it under the terms of the GNU General Public License as
> >   *	published by the Free Software Foundation, version 2.
> > @@ -22,6 +25,56 @@
> >  #define REQTYPE_I2C_WRITE	0xb0
> >  #define REQTYPE_I2C_WRITE_STATT	0xd0
> >  
> > +#define Z8F0811_IR_TX_I2C_ADDR	0x70
> > +#define Z8F0811_IR_RX_I2C_ADDR	0x71
> > +
> > +static const u8 ir_i2c_addrs[] = {
> > +	Z8F0811_IR_TX_I2C_ADDR,
> > +	Z8F0811_IR_RX_I2C_ADDR,
> > +};
> > +
> > +static const char * const ir_devicenames[] = {
> > +	"ir_tx_z8f0811_hdpvr",
> > +	"ir_rx_z8f0811_hdpvr",
> > +};
> > +
> > +static int hdpvr_new_i2c_ir(struct hdpvr_device *dev, struct i2c_adapter *adap,
> > +			    const char *type, u8 addr)
> > +{
> > +	struct i2c_board_info info;
> > +	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
> > +	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
> > +
> > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > +	strlcpy(info.type, type, I2C_NAME_SIZE);
> > +
> > +	/* Our default information for ir-kbd-i2c.c to use */
> > +	switch (addr) {
> > +	case Z8F0811_IR_RX_I2C_ADDR:
> > +		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
> > +		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> > +		init_data->type = RC_TYPE_RC5;
> > +		init_data->name = "HD PVR";
> > +		info.platform_data = init_data;
> > +		break;
> > +	}
> > +
> > +	return i2c_new_probed_device(adap, &info, addr_list, NULL) == NULL ?
> > +	       -1 : 0;
> > +}

For comparison of the above with cx18 (very similar) and ivtv (similar
but more complex), see:

http://git.linuxtv.org/awalls/media_tree.git?a=blob;f=drivers/media/video/cx18/cx18-i2c.c;h=c330fb917b50bfd0ea1f3f22fb3d378d9fe3f2b0;hb=79254c3618ed214e7750c54dcd6c8c591314c385#l86
http://git.linuxtv.org/awalls/media_tree.git?a=blob;f=drivers/media/video/ivtv/ivtv-i2c.c;h=68170924448c3894dfa0db524b975eddee0ee8c0;hb=79254c3618ed214e7750c54dcd6c8c591314c385#l148


Regards,
Andy

> > +int hdpvr_register_i2c_ir(struct hdpvr_device *dev)
> > +{
> > +	int i;
> > +	int ret = 0;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ir_i2c_addrs); i++)
> > +		ret += hdpvr_new_i2c_ir(dev, dev->i2c_adapter,
> > +					ir_devicenames[i], ir_i2c_addrs[i]);
> > +
> > +	return ret;
> > +}
> > +
> >  static int hdpvr_i2c_read(struct hdpvr_device *dev, unsigned char addr,
> >  			  char *data, int len)
> >  {
> > diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
> > index 5efc963..37f1e4c 100644
> > --- a/drivers/media/video/hdpvr/hdpvr.h
> > +++ b/drivers/media/video/hdpvr/hdpvr.h
> > @@ -16,6 +16,7 @@
> >  #include <linux/videodev2.h>
> >  
> >  #include <media/v4l2-device.h>
> > +#include <media/ir-kbd-i2c.h>
> >  
> >  #define HDPVR_MAJOR_VERSION 0
> >  #define HDPVR_MINOR_VERSION 2
> > @@ -109,6 +110,9 @@ struct hdpvr_device {
> >  	/* I2C lock */
> >  	struct mutex		i2c_mutex;
> >  
> > +	/* For passing data to ir-kbd-i2c */
> > +	struct IR_i2c_init_data	ir_i2c_init_data;
> > +
> >  	/* usb control transfer buffer and lock */
> >  	struct mutex		usbc_mutex;
> >  	u8			*usbc_buf;
> > @@ -306,6 +310,8 @@ int hdpvr_cancel_queue(struct hdpvr_device *dev);
> >  /* i2c adapter registration */
> >  int hdpvr_register_i2c_adapter(struct hdpvr_device *dev);
> >  
> > +int hdpvr_register_i2c_ir(struct hdpvr_device *dev);
> > +
> >  /*========================================================================*/
> >  /* buffer management */
> >  int hdpvr_free_buffers(struct hdpvr_device *dev);
> 


