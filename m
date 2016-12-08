Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37331
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932179AbcLHVfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 16:35:54 -0500
Date: Thu, 8 Dec 2016 19:35:44 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 2/3] [media] em28xx: use usb_interface for dev_foo()
 calls
Message-ID: <20161208193544.23034b2f@vento.lan>
In-Reply-To: <601ee6ba-d34b-5edd-7a6e-b85c34613707@iki.fi>
References: <369dda9476269abb91d4c9f6fb6219ca828d4f5b.1481226194.git.mchehab@s-opensource.com>
        <90f58b920ab099c5e3291a86dbf83cbf9d1139fb.1481226194.git.mchehab@s-opensource.com>
        <601ee6ba-d34b-5edd-7a6e-b85c34613707@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 8 Dec 2016 23:28:14 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Tested both patch 1 and 2 individually and bug is fixed.
> 
> Tested-by: Antti Palosaari <crope@iki.fi>

Thanks for testing it!

> 
> However, some loggings are wrong as error level used instead of info. If 
> you has colors enabled those log levels are printed with different 
> colors, red is error and so.
> 
> These for example are printed as errors:
> em28xx 2-2:1.0: New device PCTV PCTV 292e @ 480 Mbps (2013:025f, 
> interface 0, class 0)
> em28xx 2-2:1.0: DVB interface 0 found: isoc
> em28xx 2-2:1.0: dvb set to isoc mode.
> 
> Not important issue, but probably those could be fixed at some point too.

That's likely like that for a long time... when this driver was written,
it was just using printk() without any level. At some point, we started
fixing it, but never finished, and kept it too verbose.

I'll address it.

> 
> regards
> Antti
> 
> 
> On 12/08/2016 09:43 PM, Mauro Carvalho Chehab wrote:
> > From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > The usb_device->dev is not the right device for dev_foo() calls.
> > Instead, it should use usb_interface->dev.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-audio.c  | 34 ++++++------
> >  drivers/media/usb/em28xx/em28xx-camera.c | 30 +++++------
> >  drivers/media/usb/em28xx/em28xx-cards.c  | 61 ++++++++++-----------
> >  drivers/media/usb/em28xx/em28xx-core.c   | 48 ++++++++---------
> >  drivers/media/usb/em28xx/em28xx-dvb.c    | 61 ++++++++++-----------
> >  drivers/media/usb/em28xx/em28xx-i2c.c    | 92 ++++++++++++++++----------------
> >  drivers/media/usb/em28xx/em28xx-input.c  | 32 +++++------
> >  drivers/media/usb/em28xx/em28xx-vbi.c    |  2 +-
> >  drivers/media/usb/em28xx/em28xx-video.c  | 68 +++++++++++------------
> >  drivers/media/usb/em28xx/em28xx.h        |  1 +
> >  10 files changed, 216 insertions(+), 213 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > index 7060e5146e31..7f8601427b7f 100644
> > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > @@ -56,7 +56,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
> >
> >  #define dprintk(fmt, arg...) do {					\
> >  	if (debug)						\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "video: %s: " fmt, __func__, ## arg);	\
> >  } while (0)
> >
> > @@ -166,7 +166,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
> >
> >  	status = usb_submit_urb(urb, GFP_ATOMIC);
> >  	if (status < 0)
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"resubmit of audio urb failed (error=%i)\n",
> >  			status);
> >  	return;
> > @@ -185,7 +185,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
> >
> >  		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
> >  		if (errCode) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"submit of audio urb failed (error=%i)\n",
> >  				errCode);
> >  			em28xx_deinit_isoc_audio(dev);
> > @@ -322,7 +322,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
> >  err:
> >  	mutex_unlock(&dev->lock);
> >
> > -	dev_err(&dev->udev->dev,
> > +	dev_err(&dev->intf->dev,
> >  		"Error while configuring em28xx mixer\n");
> >  	return ret;
> >  }
> > @@ -761,7 +761,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
> >  	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
> >
> >  	if (intf->num_altsetting <= alt) {
> > -		dev_err(&dev->udev->dev, "alt %d doesn't exist on interface %d\n",
> > +		dev_err(&dev->intf->dev, "alt %d doesn't exist on interface %d\n",
> >  			      dev->ifnum, alt);
> >  		return -ENODEV;
> >  	}
> > @@ -777,14 +777,14 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
> >  	}
> >
> >  	if (!ep) {
> > -		dev_err(&dev->udev->dev, "Couldn't find an audio endpoint");
> > +		dev_err(&dev->intf->dev, "Couldn't find an audio endpoint");
> >  		return -ENODEV;
> >  	}
> >
> >  	ep_size = em28xx_audio_ep_packet_size(dev->udev, ep);
> >  	interval = 1 << (ep->bInterval - 1);
> >
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
> >  		 EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
> >  		 dev->ifnum, alt, interval, ep_size);
> > @@ -824,7 +824,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
> >  	if (urb_size > ep_size * npackets)
> >  		npackets = DIV_ROUND_UP(urb_size, ep_size);
> >
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "Number of URBs: %d, with %d packets and %d size\n",
> >  		 num_urb, npackets, urb_size);
> >
> > @@ -863,7 +863,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
> >  		buf = usb_alloc_coherent(dev->udev, npackets * ep_size, GFP_ATOMIC,
> >  					 &urb->transfer_dma);
> >  		if (!buf) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"usb_alloc_coherent failed!\n");
> >  			em28xx_audio_free_urb(dev);
> >  			return -ENOMEM;
> > @@ -904,16 +904,16 @@ static int em28xx_audio_init(struct em28xx *dev)
> >  		return 0;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Binding audio extension\n");
> > +	dev_info(&dev->intf->dev, "Binding audio extension\n");
> >
> >  	kref_get(&dev->ref);
> >
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "em28xx-audio.c: Copyright (C) 2006 Markus Rechberger\n");
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab\n");
> >
> > -	err = snd_card_new(&dev->udev->dev, index[devnr], "Em28xx Audio",
> > +	err = snd_card_new(&dev->intf->dev, index[devnr], "Em28xx Audio",
> >  			   THIS_MODULE, 0, &card);
> >  	if (err < 0)
> >  		return err;
> > @@ -961,7 +961,7 @@ static int em28xx_audio_init(struct em28xx *dev)
> >  	if (err < 0)
> >  		goto urb_free;
> >
> > -	dev_info(&dev->udev->dev, "Audio extension successfully initialized\n");
> > +	dev_info(&dev->intf->dev, "Audio extension successfully initialized\n");
> >  	return 0;
> >
> >  urb_free:
> > @@ -986,7 +986,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
> >  		return 0;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Closing audio extension\n");
> > +	dev_info(&dev->intf->dev, "Closing audio extension\n");
> >
> >  	if (dev->adev.sndcard) {
> >  		snd_card_disconnect(dev->adev.sndcard);
> > @@ -1010,7 +1010,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
> >  	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Suspending audio extension\n");
> > +	dev_info(&dev->intf->dev, "Suspending audio extension\n");
> >  	em28xx_deinit_isoc_audio(dev);
> >  	atomic_set(&dev->adev.stream_started, 0);
> >  	return 0;
> > @@ -1024,7 +1024,7 @@ static int em28xx_audio_resume(struct em28xx *dev)
> >  	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Resuming audio extension\n");
> > +	dev_info(&dev->intf->dev, "Resuming audio extension\n");
> >  	/* Nothing to do other than schedule_work() ?? */
> >  	schedule_work(&dev->adev.wq_trigger);
> >  	return 0;
> > diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
> > index 2e24b65901ec..89c890ba7dd6 100644
> > --- a/drivers/media/usb/em28xx/em28xx-camera.c
> > +++ b/drivers/media/usb/em28xx/em28xx-camera.c
> > @@ -121,14 +121,14 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
> >  		ret = i2c_master_send(&client, &reg, 1);
> >  		if (ret < 0) {
> >  			if (ret != -ENXIO)
> > -				dev_err(&dev->udev->dev,
> > +				dev_err(&dev->intf->dev,
> >  					"couldn't read from i2c device 0x%02x: error %i\n",
> >  				       client.addr << 1, ret);
> >  			continue;
> >  		}
> >  		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"couldn't read from i2c device 0x%02x: error %i\n",
> >  				client.addr << 1, ret);
> >  			continue;
> > @@ -138,14 +138,14 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
> >  		reg = 0xff;
> >  		ret = i2c_master_send(&client, &reg, 1);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"couldn't read from i2c device 0x%02x: error %i\n",
> >  				client.addr << 1, ret);
> >  			continue;
> >  		}
> >  		ret = i2c_master_recv(&client, (u8 *)&id_be, 2);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"couldn't read from i2c device 0x%02x: error %i\n",
> >  				client.addr << 1, ret);
> >  			continue;
> > @@ -185,16 +185,16 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
> >  			dev->em28xx_sensor = EM28XX_MT9M001;
> >  			break;
> >  		default:
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "unknown Micron sensor detected: 0x%04x\n", id);
> >  			return 0;
> >  		}
> >
> >  		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "unsupported sensor detected: %s\n", name);
> >  		else
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "sensor %s detected\n", name);
> >
> >  		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
> > @@ -225,7 +225,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
> >  		ret = i2c_smbus_read_byte_data(&client, reg);
> >  		if (ret < 0) {
> >  			if (ret != -ENXIO)
> > -				dev_err(&dev->udev->dev,
> > +				dev_err(&dev->intf->dev,
> >  					"couldn't read from i2c device 0x%02x: error %i\n",
> >  					client.addr << 1, ret);
> >  			continue;
> > @@ -234,7 +234,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
> >  		reg = 0x1d;
> >  		ret = i2c_smbus_read_byte_data(&client, reg);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"couldn't read from i2c device 0x%02x: error %i\n",
> >  				client.addr << 1, ret);
> >  			continue;
> > @@ -247,7 +247,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
> >  		reg = 0x0a;
> >  		ret = i2c_smbus_read_byte_data(&client, reg);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"couldn't read from i2c device 0x%02x: error %i\n",
> >  				client.addr << 1, ret);
> >  			continue;
> > @@ -256,7 +256,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
> >  		reg = 0x0b;
> >  		ret = i2c_smbus_read_byte_data(&client, reg);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"couldn't read from i2c device 0x%02x: error %i\n",
> >  				client.addr << 1, ret);
> >  			continue;
> > @@ -296,17 +296,17 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
> >  			name = "OV9655";
> >  			break;
> >  		default:
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "unknown OmniVision sensor detected: 0x%04x\n",
> >  				id);
> >  			return 0;
> >  		}
> >
> >  		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "unsupported sensor detected: %s\n", name);
> >  		else
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "sensor %s detected\n", name);
> >
> >  		dev->i2c_client[dev->def_i2c_bus].addr = client.addr;
> > @@ -331,7 +331,7 @@ int em28xx_detect_sensor(struct em28xx *dev)
> >  	 */
> >
> >  	if (dev->em28xx_sensor == EM28XX_NOSENSOR && ret < 0) {
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "No sensor detected\n");
> >  		return -ENODEV;
> >  	}
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index 50e4c6e51ee7..56739ce6ce16 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -2677,7 +2677,7 @@ static int em28xx_wait_until_ac97_features_equals(struct em28xx *dev,
> >  		msleep(50);
> >  	}
> >
> > -	dev_warn(&dev->udev->dev, "AC97 registers access is not reliable !\n");
> > +	dev_warn(&dev->intf->dev, "AC97 registers access is not reliable !\n");
> >  	return -ETIMEDOUT;
> >  }
> >
> > @@ -2831,7 +2831,7 @@ static int em28xx_hint_board(struct em28xx *dev)
> >  			dev->model = em28xx_eeprom_hash[i].model;
> >  			dev->tuner_type = em28xx_eeprom_hash[i].tuner;
> >
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"Your board has no unique USB ID.\n"
> >  				"A hint were successfully done, based on eeprom hash.\n"
> >  				"This method is not 100%% failproof.\n"
> > @@ -2861,7 +2861,7 @@ static int em28xx_hint_board(struct em28xx *dev)
> >  		if (dev->i2c_hash == em28xx_i2c_hash[i].hash) {
> >  			dev->model = em28xx_i2c_hash[i].model;
> >  			dev->tuner_type = em28xx_i2c_hash[i].tuner;
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"Your board has no unique USB ID.\n"
> >  				"A hint were successfully done, based on i2c devicelist hash.\n"
> >  				"This method is not 100%% failproof.\n"
> > @@ -2874,7 +2874,7 @@ static int em28xx_hint_board(struct em28xx *dev)
> >  		}
> >  	}
> >
> > -	dev_err(&dev->udev->dev,
> > +	dev_err(&dev->intf->dev,
> >  		"Your board has no unique USB ID and thus need a hint to be detected.\n"
> >  		"You may try to use card=<n> insmod option to workaround that.\n"
> >  		"Please send an email with this log to:\n"
> > @@ -2883,10 +2883,10 @@ static int em28xx_hint_board(struct em28xx *dev)
> >  		"Board i2c devicelist hash is 0x%08lx\n",
> >  		dev->hash, dev->i2c_hash);
> >
> > -	dev_err(&dev->udev->dev,
> > +	dev_err(&dev->intf->dev,
> >  		"Here is a list of valid choices for the card=<n> insmod option:\n");
> >  	for (i = 0; i < em28xx_bcount; i++) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"    card=%d -> %s\n", i, em28xx_boards[i].name);
> >  	}
> >  	return -1;
> > @@ -2921,7 +2921,7 @@ static void em28xx_card_setup(struct em28xx *dev)
> >  		 * hash identities which has not been determined as yet.
> >  		 */
> >  		if (em28xx_hint_board(dev) < 0)
> > -			dev_err(&dev->udev->dev, "Board not discovered\n");
> > +			dev_err(&dev->intf->dev, "Board not discovered\n");
> >  		else {
> >  			em28xx_set_model(dev);
> >  			em28xx_pre_card_setup(dev);
> > @@ -2931,7 +2931,7 @@ static void em28xx_card_setup(struct em28xx *dev)
> >  		em28xx_set_model(dev);
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Identified as %s (card=%d)\n",
> > +	dev_info(&dev->intf->dev, "Identified as %s (card=%d)\n",
> >  		dev->board.name, dev->model);
> >
> >  	dev->tuner_type = em28xx_boards[dev->model].tuner_type;
> > @@ -3030,7 +3030,7 @@ static void em28xx_card_setup(struct em28xx *dev)
> >  	}
> >
> >  	if (dev->board.valid == EM28XX_BOARD_NOT_VALIDATED) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"\n\n"
> >  			"The support for this board weren't valid yet.\n"
> >  			"Please send a report of having this working\n"
> > @@ -3161,7 +3161,7 @@ static int em28xx_media_device_init(struct em28xx *dev,
> >  	else if (udev->manufacturer)
> >  		media_device_usb_init(mdev, udev, udev->manufacturer);
> >  	else
> > -		media_device_usb_init(mdev, udev, dev_name(&dev->udev->dev));
> > +		media_device_usb_init(mdev, udev, dev_name(&dev->intf->dev));
> >
> >  	dev->media_dev = mdev;
> >  #endif
> > @@ -3217,7 +3217,7 @@ void em28xx_free_device(struct kref *ref)
> >  {
> >  	struct em28xx *dev = kref_to_dev(ref);
> >
> > -	dev_info(&dev->udev->dev, "Freeing device\n");
> > +	dev_info(&dev->intf->dev, "Freeing device\n");
> >
> >  	if (!dev->disconnected)
> >  		em28xx_release_resources(dev);
> > @@ -3239,6 +3239,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  	const char *chip_name = NULL;
> >
> >  	dev->udev = udev;
> > +	dev->intf = interface;
> >  	mutex_init(&dev->ctrl_urb_lock);
> >  	spin_lock_init(&dev->slock);
> >
> > @@ -3324,10 +3325,10 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  		}
> >  	}
> >  	if (!chip_name)
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "unknown em28xx chip ID (%d)\n", dev->chip_id);
> >  	else
> > -		dev_info(&dev->udev->dev, "chip ID is %s\n", chip_name);
> > +		dev_info(&dev->intf->dev, "chip ID is %s\n", chip_name);
> >
> >  	em28xx_media_device_init(dev, udev);
> >
> > @@ -3346,7 +3347,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  		/* Resets I2C speed */
> >  		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
> >  		if (retval < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  			       "%s: em28xx_write_reg failed! retval [%d]\n",
> >  			       __func__, retval);
> >  			return retval;
> > @@ -3361,7 +3362,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  	else
> >  		retval = em28xx_i2c_register(dev, 0, EM28XX_I2C_ALGO_EM28XX);
> >  	if (retval < 0) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
> >  		       __func__, retval);
> >  		return retval;
> > @@ -3376,7 +3377,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  			retval = em28xx_i2c_register(dev, 1,
> >  						     EM28XX_I2C_ALGO_EM28XX);
> >  		if (retval < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  			       "%s: em28xx_i2c_register bus 1 - error [%d]!\n",
> >  			       __func__, retval);
> >
> > @@ -3417,7 +3418,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  		nr = find_first_zero_bit(em28xx_devused, EM28XX_MAXBOARDS);
> >  		if (nr >= EM28XX_MAXBOARDS) {
> >  			/* No free device slots */
> > -			dev_err(&udev->dev,
> > +			dev_err(&interface->dev,
> >  				"Driver supports up to %i em28xx boards.\n",
> >  			       EM28XX_MAXBOARDS);
> >  			retval = -ENOMEM;
> > @@ -3427,7 +3428,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >
> >  	/* Don't register audio interfaces */
> >  	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
> > -		dev_err(&udev->dev,
> > +		dev_err(&interface->dev,
> >  			"audio device (%04x:%04x): interface %i, class %i\n",
> >  			le16_to_cpu(udev->descriptor.idVendor),
> >  			le16_to_cpu(udev->descriptor.idProduct),
> > @@ -3488,7 +3489,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  					if (usb_endpoint_xfer_isoc(e)) {
> >  						has_vendor_audio = true;
> >  					} else {
> > -						dev_err(&udev->dev,
> > +						dev_err(&interface->dev,
> >  							"error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
> >  					}
> >  					break;
> > @@ -3562,7 +3563,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  		speed = "unknown";
> >  	}
> >
> > -	dev_err(&udev->dev,
> > +	dev_err(&interface->dev,
> >  		"New device %s %s @ %s Mbps (%04x:%04x, interface %d, class %d)\n",
> >  		udev->manufacturer ? udev->manufacturer : "",
> >  		udev->product ? udev->product : "",
> > @@ -3578,8 +3579,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	 * not enough even for most Digital TV streams.
> >  	 */
> >  	if (udev->speed != USB_SPEED_HIGH && disable_usb_speed_check == 0) {
> > -		dev_err(&udev->dev, "Device initialization failed.\n");
> > -		dev_err(&udev->dev,
> > +		dev_err(&interface->dev, "Device initialization failed.\n");
> > +		dev_err(&interface->dev,
> >  			"Device must be connected to a high-speed USB 2.0 port.\n");
> >  		retval = -ENODEV;
> >  		goto err_free;
> > @@ -3593,7 +3594,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	dev->ifnum = ifnum;
> >
> >  	if (has_vendor_audio) {
> > -		dev_err(&udev->dev,
> > +		dev_err(&interface->dev,
> >  			"Audio interface %i found (Vendor Class)\n", ifnum);
> >  		dev->usb_audio_type = EM28XX_USB_AUDIO_VENDOR;
> >  	}
> > @@ -3603,7 +3604,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >
> >  		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
> >  			if (has_vendor_audio)
> > -				dev_err(&udev->dev,
> > +				dev_err(&interface->dev,
> >  					"em28xx: device seems to have vendor AND usb audio class interfaces !\n"
> >  				       "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
> >  			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
> > @@ -3612,12 +3613,12 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	}
> >
> >  	if (has_video)
> > -		dev_err(&udev->dev, "Video interface %i found:%s%s\n",
> > +		dev_err(&interface->dev, "Video interface %i found:%s%s\n",
> >  			ifnum,
> >  			dev->analog_ep_bulk ? " bulk" : "",
> >  			dev->analog_ep_isoc ? " isoc" : "");
> >  	if (has_dvb)
> > -		dev_err(&udev->dev, "DVB interface %i found:%s%s\n",
> > +		dev_err(&interface->dev, "DVB interface %i found:%s%s\n",
> >  			ifnum,
> >  			dev->dvb_ep_bulk ? " bulk" : "",
> >  			dev->dvb_ep_isoc ? " isoc" : "");
> > @@ -3649,7 +3650,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	/* Disable V4L2 if the device doesn't have a decoder */
> >  	if (has_video &&
> >  	    dev->board.decoder == EM28XX_NODECODER && !dev->board.is_webcam) {
> > -		dev_err(&udev->dev,
> > +		dev_err(&interface->dev,
> >  			"Currently, V4L2 is not supported on this model\n");
> >  		has_video = false;
> >  		dev->has_video = false;
> > @@ -3659,13 +3660,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	if (has_video) {
> >  		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
> >  			dev->analog_xfer_bulk = 1;
> > -		dev_err(&udev->dev, "analog set to %s mode.\n",
> > +		dev_err(&interface->dev, "analog set to %s mode.\n",
> >  			dev->analog_xfer_bulk ? "bulk" : "isoc");
> >  	}
> >  	if (has_dvb) {
> >  		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
> >  			dev->dvb_xfer_bulk = 1;
> > -		dev_err(&udev->dev, "dvb set to %s mode.\n",
> > +		dev_err(&interface->dev, "dvb set to %s mode.\n",
> >  			dev->dvb_xfer_bulk ? "bulk" : "isoc");
> >  	}
> >
> > @@ -3713,7 +3714,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
> >
> >  	dev->disconnected = 1;
> >
> > -	dev_err(&dev->udev->dev, "Disconnecting\n");
> > +	dev_err(&dev->intf->dev, "Disconnecting\n");
> >
> >  	flush_request_modules(dev);
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > index 7f1fe5d9d685..f1b4681f3c90 100644
> > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > @@ -52,7 +52,7 @@ MODULE_PARM_DESC(core_debug, "enable debug messages [core and isoc]");
> >
> >  #define em28xx_coredbg(fmt, arg...) do {				\
> >  	if (core_debug)							\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "core: %s: " fmt, __func__, ## arg);		\
> >  } while (0)
> >
> > @@ -63,14 +63,14 @@ MODULE_PARM_DESC(reg_debug, "enable debug messages [URB reg]");
> >
> >  #define em28xx_regdbg(fmt, arg...) do {				\
> >  	if (reg_debug)							\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "reg: %s: " fmt, __func__, ## arg);		\
> >  } while (0)
> >
> >  /* FIXME: don't abuse core_debug */
> >  #define em28xx_isocdbg(fmt, arg...) do {				\
> >  	if (core_debug)							\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "core: %s: " fmt, __func__, ## arg);		\
> >  } while (0)
> >
> > @@ -258,7 +258,7 @@ static int em28xx_is_ac97_ready(struct em28xx *dev)
> >  		msleep(5);
> >  	}
> >
> > -	dev_warn(&dev->udev->dev,
> > +	dev_warn(&dev->intf->dev,
> >  		 "AC97 command still being executed: not handled properly!\n");
> >  	return -EBUSY;
> >  }
> > @@ -352,7 +352,7 @@ static int set_ac97_input(struct em28xx *dev)
> >  			ret = em28xx_write_ac97(dev, inputs[i].reg, 0x8000);
> >
> >  		if (ret < 0)
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "couldn't setup AC97 register %d\n",
> >  				 inputs[i].reg);
> >  	}
> > @@ -437,7 +437,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
> >  		for (i = 0; i < ARRAY_SIZE(outputs); i++) {
> >  			ret = em28xx_write_ac97(dev, outputs[i].reg, 0x8000);
> >  			if (ret < 0)
> > -				dev_warn(&dev->udev->dev,
> > +				dev_warn(&dev->intf->dev,
> >  					 "couldn't setup AC97 register %d\n",
> >  					 outputs[i].reg);
> >  		}
> > @@ -476,7 +476,7 @@ int em28xx_audio_analog_set(struct em28xx *dev)
> >  				ret = em28xx_write_ac97(dev, outputs[i].reg,
> >  							vol);
> >  			if (ret < 0)
> > -				dev_warn(&dev->udev->dev,
> > +				dev_warn(&dev->intf->dev,
> >  					 "couldn't setup AC97 register %d\n",
> >  					 outputs[i].reg);
> >  		}
> > @@ -514,7 +514,7 @@ int em28xx_audio_setup(struct em28xx *dev)
> >
> >  	/* See how this device is configured */
> >  	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
> > -	dev_info(&dev->udev->dev, "Config register raw data: 0x%02x\n", cfg);
> > +	dev_info(&dev->intf->dev, "Config register raw data: 0x%02x\n", cfg);
> >  	if (cfg < 0) { /* Register read error */
> >  		/* Be conservative */
> >  		dev->int_audio_type = EM28XX_INT_AUDIO_AC97;
> > @@ -535,7 +535,7 @@ int em28xx_audio_setup(struct em28xx *dev)
> >  			i2s_samplerates = 5;
> >  		else
> >  			i2s_samplerates = 3;
> > -		dev_info(&dev->udev->dev, "I2S Audio (%d sample rate(s))\n",
> > +		dev_info(&dev->intf->dev, "I2S Audio (%d sample rate(s))\n",
> >  			i2s_samplerates);
> >  		/* Skip the code that does AC97 vendor detection */
> >  		dev->audio_mode.ac97 = EM28XX_NO_AC97;
> > @@ -553,7 +553,7 @@ int em28xx_audio_setup(struct em28xx *dev)
> >  		 * Note: (some) em2800 devices without eeprom reports 0x91 on
> >  		 *	 CHIPCFG register, even not having an AC97 chip
> >  		 */
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "AC97 chip type couldn't be determined\n");
> >  		dev->audio_mode.ac97 = EM28XX_NO_AC97;
> >  		if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
> > @@ -567,13 +567,13 @@ int em28xx_audio_setup(struct em28xx *dev)
> >  		goto init_audio;
> >
> >  	vid = vid1 << 16 | vid2;
> > -	dev_warn(&dev->udev->dev, "AC97 vendor ID = 0x%08x\n", vid);
> > +	dev_warn(&dev->intf->dev, "AC97 vendor ID = 0x%08x\n", vid);
> >
> >  	feat = em28xx_read_ac97(dev, AC97_RESET);
> >  	if (feat < 0)
> >  		goto init_audio;
> >
> > -	dev_warn(&dev->udev->dev, "AC97 features = 0x%04x\n", feat);
> > +	dev_warn(&dev->intf->dev, "AC97 features = 0x%04x\n", feat);
> >
> >  	/* Try to identify what audio processor we have */
> >  	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
> > @@ -585,19 +585,19 @@ int em28xx_audio_setup(struct em28xx *dev)
> >  	/* Reports detected AC97 processor */
> >  	switch (dev->audio_mode.ac97) {
> >  	case EM28XX_NO_AC97:
> > -		dev_info(&dev->udev->dev, "No AC97 audio processor\n");
> > +		dev_info(&dev->intf->dev, "No AC97 audio processor\n");
> >  		break;
> >  	case EM28XX_AC97_EM202:
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "Empia 202 AC97 audio processor detected\n");
> >  		break;
> >  	case EM28XX_AC97_SIGMATEL:
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "Sigmatel audio processor detected (stac 97%02x)\n",
> >  			 vid & 0xff);
> >  		break;
> >  	case EM28XX_AC97_OTHER:
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "Unknown AC97 audio processor detected!\n");
> >  		break;
> >  	default:
> > @@ -882,7 +882,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
> >  	if (mode == EM28XX_DIGITAL_MODE) {
> >  		if ((xfer_bulk && !dev->dvb_ep_bulk) ||
> >  		    (!xfer_bulk && !dev->dvb_ep_isoc)) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"no endpoint for DVB mode and transfer type %d\n",
> >  				xfer_bulk > 0);
> >  			return -EINVAL;
> > @@ -891,14 +891,14 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
> >  	} else if (mode == EM28XX_ANALOG_MODE) {
> >  		if ((xfer_bulk && !dev->analog_ep_bulk) ||
> >  		    (!xfer_bulk && !dev->analog_ep_isoc)) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"no endpoint for analog mode and transfer type %d\n",
> >  				xfer_bulk > 0);
> >  			return -EINVAL;
> >  		}
> >  		usb_bufs = &dev->usb_ctl.analog_bufs;
> >  	} else {
> > -		dev_err(&dev->udev->dev, "invalid mode selected\n");
> > +		dev_err(&dev->intf->dev, "invalid mode selected\n");
> >  		return -EINVAL;
> >  	}
> >
> > @@ -940,7 +940,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
> >  		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
> >  			sb_size, GFP_KERNEL, &urb->transfer_dma);
> >  		if (!usb_bufs->transfer_buffer[i]) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"unable to allocate %i bytes for transfer buffer %i%s\n",
> >  			       sb_size, i,
> >  			       in_interrupt() ? " while in int" : "");
> > @@ -1023,7 +1023,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
> >  	if (xfer_bulk) {
> >  		rc = usb_clear_halt(dev->udev, usb_bufs->urb[0]->pipe);
> >  		if (rc < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
> >  			       rc);
> >  			em28xx_uninit_usb_xfer(dev, mode);
> > @@ -1040,7 +1040,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
> >  	for (i = 0; i < usb_bufs->num_bufs; i++) {
> >  		rc = usb_submit_urb(usb_bufs->urb[i], GFP_ATOMIC);
> >  		if (rc) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"submit of urb %i failed (error=%i)\n", i, rc);
> >  			em28xx_uninit_usb_xfer(dev, mode);
> >  			return rc;
> > @@ -1123,7 +1123,7 @@ int em28xx_suspend_extension(struct em28xx *dev)
> >  {
> >  	const struct em28xx_ops *ops = NULL;
> >
> > -	dev_info(&dev->udev->dev, "Suspending extensions\n");
> > +	dev_info(&dev->intf->dev, "Suspending extensions\n");
> >  	mutex_lock(&em28xx_devlist_mutex);
> >  	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
> >  		if (ops->suspend)
> > @@ -1137,7 +1137,7 @@ int em28xx_resume_extension(struct em28xx *dev)
> >  {
> >  	const struct em28xx_ops *ops = NULL;
> >
> > -	dev_info(&dev->udev->dev, "Resuming extensions\n");
> > +	dev_info(&dev->intf->dev, "Resuming extensions\n");
> >  	mutex_lock(&em28xx_devlist_mutex);
> >  	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
> >  		if (ops->resume)
> > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> > index 445e51db636f..d7cfcbe3bf19 100644
> > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > @@ -75,7 +75,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> >
> >  #define dprintk(level, fmt, arg...) do {				\
> >  	if (debug >= level)						\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "dvb: " fmt, ## arg);			\
> >  } while (0)
> >
> > @@ -736,13 +736,13 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
> >
> >  	ret = gpio_request_one(dvb->lna_gpio, flags, NULL);
> >  	if (ret)
> > -		dev_err(&dev->udev->dev, "gpio request failed %d\n", ret);
> > +		dev_err(&dev->intf->dev, "gpio request failed %d\n", ret);
> >  	else
> >  		gpio_free(dvb->lna_gpio);
> >
> >  	return ret;
> >  #else
> > -	dev_warn(&dev->udev->dev, "%s: LNA control is disabled (lna=%u)\n",
> > +	dev_warn(&dev->intf->dev, "%s: LNA control is disabled (lna=%u)\n",
> >  		 KBUILD_MODNAME, c->lna);
> >  	return 0;
> >  #endif
> > @@ -936,20 +936,20 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
> >  	cfg.ctrl  = &ctl;
> >
> >  	if (!dev->dvb->fe[0]) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"dvb frontend not attached. Can't attach xc3028\n");
> >  		return -EINVAL;
> >  	}
> >
> >  	fe = dvb_attach(xc2028_attach, dev->dvb->fe[0], &cfg);
> >  	if (!fe) {
> > -		dev_err(&dev->udev->dev, "xc3028 attach failed\n");
> > +		dev_err(&dev->intf->dev, "xc3028 attach failed\n");
> >  		dvb_frontend_detach(dev->dvb->fe[0]);
> >  		dev->dvb->fe[0] = NULL;
> >  		return -EINVAL;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "xc3028 attached\n");
> > +	dev_info(&dev->intf->dev, "xc3028 attached\n");
> >
> >  	return 0;
> >  }
> > @@ -966,10 +966,10 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >
> >  	/* register adapter */
> >  	result = dvb_register_adapter(&dvb->adapter,
> > -				      dev_name(&dev->udev->dev), module,
> > +				      dev_name(&dev->intf->dev), module,
> >  				      device, adapter_nr);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "dvb_register_adapter failed (errno = %d)\n",
> >  			 result);
> >  		goto fail_adapter;
> > @@ -988,7 +988,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >  	/* register frontend */
> >  	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "dvb_register_frontend failed (errno = %d)\n",
> >  			 result);
> >  		goto fail_frontend0;
> > @@ -998,7 +998,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >  	if (dvb->fe[1]) {
> >  		result = dvb_register_frontend(&dvb->adapter, dvb->fe[1]);
> >  		if (result < 0) {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "2nd dvb_register_frontend failed (errno = %d)\n",
> >  				 result);
> >  			goto fail_frontend1;
> > @@ -1017,7 +1017,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >
> >  	result = dvb_dmx_init(&dvb->demux);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "dvb_dmx_init failed (errno = %d)\n",
> >  			 result);
> >  		goto fail_dmx;
> > @@ -1028,7 +1028,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >  	dvb->dmxdev.capabilities = 0;
> >  	result = dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "dvb_dmxdev_init failed (errno = %d)\n",
> >  			 result);
> >  		goto fail_dmxdev;
> > @@ -1037,7 +1037,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >  	dvb->fe_hw.source = DMX_FRONTEND_0;
> >  	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_hw);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "add_frontend failed (DMX_FRONTEND_0, errno = %d)\n",
> >  			 result);
> >  		goto fail_fe_hw;
> > @@ -1046,7 +1046,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >  	dvb->fe_mem.source = DMX_MEMORY_FE;
> >  	result = dvb->demux.dmx.add_frontend(&dvb->demux.dmx, &dvb->fe_mem);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "add_frontend failed (DMX_MEMORY_FE, errno = %d)\n",
> >  			 result);
> >  		goto fail_fe_mem;
> > @@ -1054,7 +1054,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
> >
> >  	result = dvb->demux.dmx.connect_frontend(&dvb->demux.dmx, &dvb->fe_hw);
> >  	if (result < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "connect_frontend failed (errno = %d)\n",
> >  			 result);
> >  		goto fail_fe_conn;
> > @@ -1128,7 +1128,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  		return 0;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Binding DVB extension\n");
> > +	dev_info(&dev->intf->dev, "Binding DVB extension\n");
> >
> >  	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
> >  	if (!dvb)
> > @@ -1152,7 +1152,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  					   EM28XX_DVB_NUM_ISOC_PACKETS);
> >  	}
> >  	if (result) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"failed to pre-allocate USB transfer buffers for DVB.\n");
> >  		kfree(dvb);
> >  		dev->dvb = NULL;
> > @@ -1270,7 +1270,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
> >  	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
> >  		dvb->fe[0] = dvb_attach(drxd_attach, &em28xx_drxd, NULL,
> > -					   &dev->i2c_adap[dev->def_i2c_bus], &dev->udev->dev);
> > +					&dev->i2c_adap[dev->def_i2c_bus],
> > +					&dev->intf->dev);
> >  		if (em28xx_attach_xc3028(0x61, dev) < 0) {
> >  			result = -EINVAL;
> >  			goto out_free;
> > @@ -1332,7 +1333,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  			result = gpio_request_one(dvb->lna_gpio,
> >  						  GPIOF_OUT_INIT_LOW, NULL);
> >  			if (result)
> > -				dev_err(&dev->udev->dev,
> > +				dev_err(&dev->intf->dev,
> >  					"gpio request failed %d\n",
> >  					result);
> >  			else
> > @@ -1949,12 +1950,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  		}
> >  		break;
> >  	default:
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"The frontend of your DVB/ATSC card isn't supported yet\n");
> >  		break;
> >  	}
> >  	if (NULL == dvb->fe[0]) {
> > -		dev_err(&dev->udev->dev, "frontend initialization failed\n");
> > +		dev_err(&dev->intf->dev, "frontend initialization failed\n");
> >  		result = -EINVAL;
> >  		goto out_free;
> >  	}
> > @@ -1964,12 +1965,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  		dvb->fe[1]->callback = em28xx_tuner_callback;
> >
> >  	/* register everything */
> > -	result = em28xx_register_dvb(dvb, THIS_MODULE, dev, &dev->udev->dev);
> > +	result = em28xx_register_dvb(dvb, THIS_MODULE, dev, &dev->intf->dev);
> >
> >  	if (result < 0)
> >  		goto out_free;
> >
> > -	dev_info(&dev->udev->dev, "DVB extension successfully initialized\n");
> > +	dev_info(&dev->intf->dev, "DVB extension successfully initialized\n");
> >
> >  	kref_get(&dev->ref);
> >
> > @@ -2009,7 +2010,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
> >  	if (!dev->dvb)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Closing DVB extension\n");
> > +	dev_info(&dev->intf->dev, "Closing DVB extension\n");
> >
> >  	dvb = dev->dvb;
> >
> > @@ -2067,17 +2068,17 @@ static int em28xx_dvb_suspend(struct em28xx *dev)
> >  	if (!dev->board.has_dvb)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Suspending DVB extension\n");
> > +	dev_info(&dev->intf->dev, "Suspending DVB extension\n");
> >  	if (dev->dvb) {
> >  		struct em28xx_dvb *dvb = dev->dvb;
> >
> >  		if (dvb->fe[0]) {
> >  			ret = dvb_frontend_suspend(dvb->fe[0]);
> > -			dev_info(&dev->udev->dev, "fe0 suspend %d\n", ret);
> > +			dev_info(&dev->intf->dev, "fe0 suspend %d\n", ret);
> >  		}
> >  		if (dvb->fe[1]) {
> >  			dvb_frontend_suspend(dvb->fe[1]);
> > -			dev_info(&dev->udev->dev, "fe1 suspend %d\n", ret);
> > +			dev_info(&dev->intf->dev, "fe1 suspend %d\n", ret);
> >  		}
> >  	}
> >
> > @@ -2094,18 +2095,18 @@ static int em28xx_dvb_resume(struct em28xx *dev)
> >  	if (!dev->board.has_dvb)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Resuming DVB extension\n");
> > +	dev_info(&dev->intf->dev, "Resuming DVB extension\n");
> >  	if (dev->dvb) {
> >  		struct em28xx_dvb *dvb = dev->dvb;
> >
> >  		if (dvb->fe[0]) {
> >  			ret = dvb_frontend_resume(dvb->fe[0]);
> > -			dev_info(&dev->udev->dev, "fe0 resume %d\n", ret);
> > +			dev_info(&dev->intf->dev, "fe0 resume %d\n", ret);
> >  		}
> >
> >  		if (dvb->fe[1]) {
> >  			ret = dvb_frontend_resume(dvb->fe[1]);
> > -			dev_info(&dev->udev->dev, "fe1 resume %d\n", ret);
> > +			dev_info(&dev->intf->dev, "fe1 resume %d\n", ret);
> >  		}
> >  	}
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> > index 00e39edc0837..8c472d5adb50 100644
> > --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> > +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> > @@ -46,7 +46,7 @@ MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I
> >
> >  #define dprintk(level, fmt, arg...) do {				\
> >  	if (i2c_debug > level)						\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "i2c: %s: " fmt, __func__, ## arg);		\
> >  } while (0)
> >
> > @@ -78,7 +78,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  	/* trigger write */
> >  	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
> >  	if (ret != 2 + len) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "failed to trigger write to i2c address 0x%x (error=%i)\n",
> >  			    addr, ret);
> >  		return (ret < 0) ? ret : -EIO;
> > @@ -93,7 +93,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "failed to get i2c transfer status from bridge register (error=%i)\n",
> >  				ret);
> >  			return ret;
> > @@ -123,7 +123,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  	buf2[0] = addr;
> >  	ret = dev->em28xx_write_regs(dev, 0x04, buf2, 2);
> >  	if (ret != 2) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "failed to trigger read from i2c address 0x%x (error=%i)\n",
> >  			 addr, ret);
> >  		return (ret < 0) ? ret : -EIO;
> > @@ -140,7 +140,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "failed to get i2c transfer status from bridge register (error=%i)\n",
> >  				 ret);
> >  			return ret;
> > @@ -154,7 +154,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
> >  	/* get the received message */
> >  	ret = dev->em28xx_read_reg_req_len(dev, 0x00, 4-len, buf2, len);
> >  	if (ret != len) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
> >  			 addr, ret);
> >  		return (ret < 0) ? ret : -EIO;
> > @@ -200,12 +200,12 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
> >  	if (ret != len) {
> >  		if (ret < 0) {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "writing to i2c device at 0x%x failed (error=%i)\n",
> >  				 addr, ret);
> >  			return ret;
> >  		} else {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
> >  				 len, addr, ret);
> >  			return -EIO;
> > @@ -223,7 +223,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  			return -ENXIO;
> >  		}
> >  		if (ret < 0) {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "failed to get i2c transfer status from bridge register (error=%i)\n",
> >  				 ret);
> >  			return ret;
> > @@ -244,7 +244,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  		return -ETIMEDOUT;
> >  	}
> >
> > -	dev_warn(&dev->udev->dev,
> > +	dev_warn(&dev->intf->dev,
> >  		 "write to i2c device at 0x%x failed with unknown error (status=%i)\n",
> >  		 addr, ret);
> >  	return -EIO;
> > @@ -268,7 +268,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  	/* Read data from i2c device */
> >  	ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
> >  	if (ret < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "reading from i2c device at 0x%x failed (error=%i)\n",
> >  			 addr, ret);
> >  		return ret;
> > @@ -287,7 +287,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  	if (ret == 0) /* success */
> >  		return len;
> >  	if (ret < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "failed to get i2c transfer status from bridge register (error=%i)\n",
> >  			 ret);
> >  		return ret;
> > @@ -306,7 +306,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
> >  		return -ETIMEDOUT;
> >  	}
> >
> > -	dev_warn(&dev->udev->dev,
> > +	dev_warn(&dev->intf->dev,
> >  		 "write to i2c device at 0x%x failed with unknown error (status=%i)\n",
> >  		 addr, ret);
> >  	return -EIO;
> > @@ -347,12 +347,12 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	ret = dev->em28xx_write_regs_req(dev, 0x06, addr, buf, len);
> >  	if (ret != len) {
> >  		if (ret < 0) {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "writing to i2c device at 0x%x failed (error=%i)\n",
> >  				 addr, ret);
> >  			return ret;
> >  		} else {
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
> >  				 len, addr, ret);
> >  			return -EIO;
> > @@ -398,7 +398,7 @@ static int em25xx_bus_B_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf,
> >  	/* Read value */
> >  	ret = dev->em28xx_read_reg_req_len(dev, 0x06, addr, buf, len);
> >  	if (ret < 0) {
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "reading from i2c device at 0x%x failed (error=%i)\n",
> >  			 addr, ret);
> >  		return ret;
> > @@ -672,7 +672,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  	/* Check if board has eeprom */
> >  	err = i2c_master_recv(&dev->i2c_client[bus], &buf, 0);
> >  	if (err < 0) {
> > -		dev_info(&dev->udev->dev, "board has no eeprom\n");
> > +		dev_info(&dev->intf->dev, "board has no eeprom\n");
> >  		return -ENODEV;
> >  	}
> >
> > @@ -685,7 +685,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  				    dev->eeprom_addrwidth_16bit,
> >  				    len, data);
> >  	if (err != len) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"failed to read eeprom (err=%d)\n", err);
> >  		goto error;
> >  	}
> > @@ -696,7 +696,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  			       16, 1, data, len, true);
> >
> >  		if (dev->eeprom_addrwidth_16bit)
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "eeprom %06x: ... (skipped)\n", 256);
> >  	}
> >
> > @@ -709,12 +709,12 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  		dev->hash = em28xx_hash_mem(data, len, 32);
> >  		mc_start = (data[1] << 8) + 4;	/* usually 0x0004 */
> >
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
> >  			 data[0], data[1], data[2], data[3], dev->hash);
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "EEPROM info:\n");
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "\tmicrocode start address = 0x%04x, boot configuration = 0x%02x\n",
> >  			 mc_start, data[2]);
> >  		/*
> > @@ -734,7 +734,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  		err = em28xx_i2c_read_block(dev, bus, mc_start + 46, 1, 2,
> >  					    data);
> >  		if (err != 2) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"failed to read hardware configuration data from eeprom (err=%d)\n",
> >  				err);
> >  			goto error;
> > @@ -753,7 +753,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  		err = em28xx_i2c_read_block(dev, bus, hwconf_offset, 1, len,
> >  					    data);
> >  		if (err != len) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"failed to read hardware configuration data from eeprom (err=%d)\n",
> >  				err);
> >  			goto error;
> > @@ -763,7 +763,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  		/* NOTE: not all devices provide this type of dataset */
> >  		if (data[0] != 0x1a || data[1] != 0xeb ||
> >  		    data[2] != 0x67 || data[3] != 0x95) {
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "\tno hardware configuration dataset found in eeprom\n");
> >  			kfree(data);
> >  			return 0;
> > @@ -775,13 +775,13 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >  		   data[0] == 0x1a && data[1] == 0xeb &&
> >  		   data[2] == 0x67 && data[3] == 0x95) {
> >  		dev->hash = em28xx_hash_mem(data, len, 32);
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "EEPROM ID = %02x %02x %02x %02x, EEPROM hash = 0x%08lx\n",
> >  			 data[0], data[1], data[2], data[3], dev->hash);
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "EEPROM info:\n");
> >  	} else {
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "unknown eeprom format or eeprom corrupted !\n");
> >  		err = -ENODEV;
> >  		goto error;
> > @@ -793,50 +793,50 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
> >
> >  	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
> >  	case 0:
> > -		dev_info(&dev->udev->dev, "\tNo audio on board.\n");
> > +		dev_info(&dev->intf->dev, "\tNo audio on board.\n");
> >  		break;
> >  	case 1:
> > -		dev_info(&dev->udev->dev, "\tAC97 audio (5 sample rates)\n");
> > +		dev_info(&dev->intf->dev, "\tAC97 audio (5 sample rates)\n");
> >  		break;
> >  	case 2:
> >  		if (dev->chip_id < CHIP_ID_EM2860)
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "\tI2S audio, sample rate=32k\n");
> >  		else
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "\tI2S audio, 3 sample rates\n");
> >  		break;
> >  	case 3:
> >  		if (dev->chip_id < CHIP_ID_EM2860)
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "\tI2S audio, 3 sample rates\n");
> >  		else
> > -			dev_info(&dev->udev->dev,
> > +			dev_info(&dev->intf->dev,
> >  				 "\tI2S audio, 5 sample rates\n");
> >  		break;
> >  	}
> >
> >  	if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
> > -		dev_info(&dev->udev->dev, "\tUSB Remote wakeup capable\n");
> > +		dev_info(&dev->intf->dev, "\tUSB Remote wakeup capable\n");
> >
> >  	if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
> > -		dev_info(&dev->udev->dev, "\tUSB Self power capable\n");
> > +		dev_info(&dev->intf->dev, "\tUSB Self power capable\n");
> >
> >  	switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
> >  	case 0:
> > -		dev_info(&dev->udev->dev, "\t500mA max power\n");
> > +		dev_info(&dev->intf->dev, "\t500mA max power\n");
> >  		break;
> >  	case 1:
> > -		dev_info(&dev->udev->dev, "\t400mA max power\n");
> > +		dev_info(&dev->intf->dev, "\t400mA max power\n");
> >  		break;
> >  	case 2:
> > -		dev_info(&dev->udev->dev, "\t300mA max power\n");
> > +		dev_info(&dev->intf->dev, "\t300mA max power\n");
> >  		break;
> >  	case 3:
> > -		dev_info(&dev->udev->dev, "\t200mA max power\n");
> > +		dev_info(&dev->intf->dev, "\t200mA max power\n");
> >  		break;
> >  	}
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
> >  		 dev_config->string_idx_table,
> >  		 le16_to_cpu(dev_config->string1),
> > @@ -930,7 +930,7 @@ void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus)
> >  		if (rc < 0)
> >  			continue;
> >  		i2c_devicelist[i] = i;
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "found i2c device @ 0x%x on bus %d [%s]\n",
> >  			 i << 1, bus, i2c_devs[i] ? i2c_devs[i] : "???");
> >  	}
> > @@ -956,8 +956,8 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
> >  		return -ENODEV;
> >
> >  	dev->i2c_adap[bus] = em28xx_adap_template;
> > -	dev->i2c_adap[bus].dev.parent = &dev->udev->dev;
> > -	strcpy(dev->i2c_adap[bus].name, dev_name(&dev->udev->dev));
> > +	dev->i2c_adap[bus].dev.parent = &dev->intf->dev;
> > +	strcpy(dev->i2c_adap[bus].name, dev_name(&dev->intf->dev));
> >
> >  	dev->i2c_bus[bus].bus = bus;
> >  	dev->i2c_bus[bus].algo_type = algo_type;
> > @@ -966,7 +966,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
> >
> >  	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
> >  	if (retval < 0) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"%s: i2c_add_adapter failed! retval [%d]\n",
> >  			__func__, retval);
> >  		return retval;
> > @@ -979,7 +979,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
> >  	if (!bus) {
> >  		retval = em28xx_i2c_eeprom(dev, bus, &dev->eedata, &dev->eedata_len);
> >  		if ((retval < 0) && (retval != -ENODEV)) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"%s: em28xx_i2_eeprom failed! retval [%d]\n",
> >  				__func__, retval);
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> > index a1904e2230ea..0082ea6d6c08 100644
> > --- a/drivers/media/usb/em28xx/em28xx-input.c
> > +++ b/drivers/media/usb/em28xx/em28xx-input.c
> > @@ -43,7 +43,7 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
> >
> >  #define dprintk( fmt, arg...) do {					\
> >  	if (ir_debug)							\
> > -		dev_printk(KERN_DEBUG, &ir->dev->udev->dev,		\
> > +		dev_printk(KERN_DEBUG, &ir->dev->intf->dev,		\
> >  			   "input: %s: " fmt, __func__, ## arg);	\
> >  } while (0)
> >
> > @@ -459,7 +459,7 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
> >  	case CHIP_ID_EM28178:
> >  		return em2874_ir_change_protocol(rc_dev, rc_type);
> >  	default:
> > -		dev_err(&ir->dev->udev->dev,
> > +		dev_err(&ir->dev->intf->dev,
> >  			"Unrecognized em28xx chip id 0x%02x: IR not supported\n",
> >  			dev->chip_id);
> >  		return -EINVAL;
> > @@ -569,7 +569,7 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
> >  	struct input_dev *input_dev;
> >  	int err;
> >
> > -	dev_info(&dev->udev->dev, "Registering snapshot button...\n");
> > +	dev_info(&dev->intf->dev, "Registering snapshot button...\n");
> >  	input_dev = input_allocate_device();
> >  	if (!input_dev)
> >  		return -ENOMEM;
> > @@ -589,11 +589,11 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
> >  	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
> >  	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
> >  	input_dev->id.version = 1;
> > -	input_dev->dev.parent = &dev->udev->dev;
> > +	input_dev->dev.parent = &dev->intf->dev;
> >
> >  	err = input_register_device(input_dev);
> >  	if (err) {
> > -		dev_err(&dev->udev->dev, "input_register_device failed\n");
> > +		dev_err(&dev->intf->dev, "input_register_device failed\n");
> >  		input_free_device(input_dev);
> >  		return err;
> >  	}
> > @@ -633,7 +633,7 @@ static void em28xx_init_buttons(struct em28xx *dev)
> >  		} else if (button->role == EM28XX_BUTTON_ILLUMINATION) {
> >  			/* Check sanity */
> >  			if (!em28xx_find_led(dev, EM28XX_LED_ILLUMINATION)) {
> > -				dev_err(&dev->udev->dev,
> > +				dev_err(&dev->intf->dev,
> >  					"BUG: illumination button defined, but no illumination LED.\n");
> >  				goto next_button;
> >  			}
> > @@ -670,7 +670,7 @@ static void em28xx_shutdown_buttons(struct em28xx *dev)
> >  	dev->num_button_polling_addresses = 0;
> >  	/* Deregister input devices */
> >  	if (dev->sbutton_input_dev != NULL) {
> > -		dev_info(&dev->udev->dev, "Deregistering snapshot button\n");
> > +		dev_info(&dev->intf->dev, "Deregistering snapshot button\n");
> >  		input_unregister_device(dev->sbutton_input_dev);
> >  		dev->sbutton_input_dev = NULL;
> >  	}
> > @@ -699,7 +699,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >  		i2c_rc_dev_addr = em28xx_probe_i2c_ir(dev);
> >  		if (!i2c_rc_dev_addr) {
> >  			dev->board.has_ir_i2c = 0;
> > -			dev_warn(&dev->udev->dev,
> > +			dev_warn(&dev->intf->dev,
> >  				 "No i2c IR remote control device found.\n");
> >  			return -ENODEV;
> >  		}
> > @@ -707,12 +707,12 @@ static int em28xx_ir_init(struct em28xx *dev)
> >
> >  	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
> >  		/* No remote control support */
> > -		dev_warn(&dev->udev->dev,
> > +		dev_warn(&dev->intf->dev,
> >  			 "Remote control support is not available for this card.\n");
> >  		return 0;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Registering input extension\n");
> > +	dev_info(&dev->intf->dev, "Registering input extension\n");
> >
> >  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> >  	if (!ir)
> > @@ -797,7 +797,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >
> >  	/* init input device */
> >  	snprintf(ir->name, sizeof(ir->name), "%s IR",
> > -		 dev_name(&dev->udev->dev));
> > +		 dev_name(&dev->intf->dev));
> >
> >  	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
> >  	strlcat(ir->phys, "/input0", sizeof(ir->phys));
> > @@ -808,7 +808,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >  	rc->input_id.version = 1;
> >  	rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
> >  	rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
> > -	rc->dev.parent = &dev->udev->dev;
> > +	rc->dev.parent = &dev->intf->dev;
> >  	rc->driver_name = MODULE_NAME;
> >
> >  	/* all done */
> > @@ -816,7 +816,7 @@ static int em28xx_ir_init(struct em28xx *dev)
> >  	if (err)
> >  		goto error;
> >
> > -	dev_info(&dev->udev->dev, "Input extension successfully initalized\n");
> > +	dev_info(&dev->intf->dev, "Input extension successfully initalized\n");
> >
> >  	return 0;
> >
> > @@ -837,7 +837,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
> >  		return 0;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Closing input extension\n");
> > +	dev_info(&dev->intf->dev, "Closing input extension\n");
> >
> >  	em28xx_shutdown_buttons(dev);
> >
> > @@ -866,7 +866,7 @@ static int em28xx_ir_suspend(struct em28xx *dev)
> >  	if (dev->is_audio_only)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Suspending input extension\n");
> > +	dev_info(&dev->intf->dev, "Suspending input extension\n");
> >  	if (ir)
> >  		cancel_delayed_work_sync(&ir->work);
> >  	cancel_delayed_work_sync(&dev->buttons_query_work);
> > @@ -883,7 +883,7 @@ static int em28xx_ir_resume(struct em28xx *dev)
> >  	if (dev->is_audio_only)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Resuming input extension\n");
> > +	dev_info(&dev->intf->dev, "Resuming input extension\n");
> >  	/* if suspend calls ir_raw_event_unregister(), the should call
> >  	   ir_raw_event_register() */
> >  	if (ir)
> > diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
> > index 1b21d001cc7e..0bac552bbe87 100644
> > --- a/drivers/media/usb/em28xx/em28xx-vbi.c
> > +++ b/drivers/media/usb/em28xx/em28xx-vbi.c
> > @@ -65,7 +65,7 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
> >  	size = v4l2->vbi_width * v4l2->vbi_height * 2;
> >
> >  	if (vb2_plane_size(vb, 0) < size) {
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "%s data will not fit into plane (%lu < %lu)\n",
> >  			 __func__, vb2_plane_size(vb, 0), size);
> >  		return -EINVAL;
> > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > index 2d282ed9aac0..4780f6492329 100644
> > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > @@ -66,13 +66,13 @@ MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
> >
> >  #define em28xx_videodbg(fmt, arg...) do {				\
> >  	if (video_debug)						\
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "video: %s: " fmt, __func__, ## arg);	\
> >  } while (0)
> >
> >  #define em28xx_isocdbg(fmt, arg...) do {\
> >  	if (isoc_debug) \
> > -		dev_printk(KERN_DEBUG, &dev->udev->dev,			\
> > +		dev_printk(KERN_DEBUG, &dev->intf->dev,			\
> >  			   "isoc: %s: " fmt, __func__, ## arg);		\
> >  } while (0)
> >
> > @@ -413,7 +413,7 @@ static int em28xx_set_alternate(struct em28xx *dev)
> >  			dev->alt, dev->max_pkt_size);
> >  	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> >  	if (errCode < 0) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"cannot change alternate number to %d (error=%i)\n",
> >  			dev->alt, errCode);
> >  		return errCode;
> > @@ -926,7 +926,7 @@ static int em28xx_enable_analog_tuner(struct em28xx *dev)
> >
> >  		ret = media_entity_setup_link(link, flags);
> >  		if (ret) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"Couldn't change link %s->%s to %s. Error %d\n",
> >  				source->name, sink->name,
> >  				flags ? "enabled" : "disabled",
> > @@ -958,7 +958,7 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
> >  	v4l2->video_pad.flags = MEDIA_PAD_FL_SINK;
> >  	ret = media_entity_pads_init(&v4l2->vdev.entity, 1, &v4l2->video_pad);
> >  	if (ret < 0)
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"failed to initialize video media entity!\n");
> >
> >  	if (em28xx_vbi_supported(dev)) {
> > @@ -966,7 +966,7 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
> >  		ret = media_entity_pads_init(&v4l2->vbi_dev.entity, 1,
> >  					     &v4l2->vbi_pad);
> >  		if (ret < 0)
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"failed to initialize vbi media entity!\n");
> >  	}
> >
> > @@ -1000,12 +1000,12 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
> >
> >  		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
> >  		if (ret < 0)
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"failed to initialize input pad[%d]!\n", i);
> >
> >  		ret = media_device_register_entity(dev->media_dev, ent);
> >  		if (ret < 0)
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"failed to register input entity %d!\n", i);
> >  	}
> >  #endif
> > @@ -2053,7 +2053,7 @@ static int em28xx_v4l2_open(struct file *filp)
> >
> >  	ret = v4l2_fh_open(filp);
> >  	if (ret) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"%s: v4l2_fh_open() returned error %d\n",
> >  		       __func__, ret);
> >  		mutex_unlock(&dev->lock);
> > @@ -2109,7 +2109,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
> >  	if (v4l2 == NULL)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Closing video extension\n");
> > +	dev_info(&dev->intf->dev, "Closing video extension\n");
> >
> >  	mutex_lock(&dev->lock);
> >
> > @@ -2120,17 +2120,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
> >  	em28xx_v4l2_media_release(dev);
> >
> >  	if (video_is_registered(&v4l2->radio_dev)) {
> > -		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
> > +		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
> >  			video_device_node_name(&v4l2->radio_dev));
> >  		video_unregister_device(&v4l2->radio_dev);
> >  	}
> >  	if (video_is_registered(&v4l2->vbi_dev)) {
> > -		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
> > +		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
> >  			video_device_node_name(&v4l2->vbi_dev));
> >  		video_unregister_device(&v4l2->vbi_dev);
> >  	}
> >  	if (video_is_registered(&v4l2->vdev)) {
> > -		dev_info(&dev->udev->dev, "V4L2 device %s deregistered\n",
> > +		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
> >  			video_device_node_name(&v4l2->vdev));
> >  		video_unregister_device(&v4l2->vdev);
> >  	}
> > @@ -2160,7 +2160,7 @@ static int em28xx_v4l2_suspend(struct em28xx *dev)
> >  	if (!dev->has_video)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Suspending video extension\n");
> > +	dev_info(&dev->intf->dev, "Suspending video extension\n");
> >  	em28xx_stop_urbs(dev);
> >  	return 0;
> >  }
> > @@ -2173,7 +2173,7 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
> >  	if (!dev->has_video)
> >  		return 0;
> >
> > -	dev_info(&dev->udev->dev, "Resuming video extension\n");
> > +	dev_info(&dev->intf->dev, "Resuming video extension\n");
> >  	/* what do we do here */
> >  	return 0;
> >  }
> > @@ -2210,7 +2210,7 @@ static int em28xx_v4l2_close(struct file *filp)
> >  		em28xx_videodbg("setting alternate 0\n");
> >  		errCode = usb_set_interface(dev->udev, 0, 0);
> >  		if (errCode < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"cannot change alternate number to 0 (error=%i)\n",
> >  				errCode);
> >  		}
> > @@ -2345,7 +2345,7 @@ static void em28xx_vdev_init(struct em28xx *dev,
> >  		vfd->tvnorms = 0;
> >
> >  	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
> > -		 dev_name(&dev->udev->dev), type_name);
> > +		 dev_name(&dev->intf->dev), type_name);
> >
> >  	video_set_drvdata(vfd, dev);
> >  }
> > @@ -2429,7 +2429,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  		return 0;
> >  	}
> >
> > -	dev_info(&dev->udev->dev, "Registering V4L2 extension\n");
> > +	dev_info(&dev->intf->dev, "Registering V4L2 extension\n");
> >
> >  	mutex_lock(&dev->lock);
> >
> > @@ -2445,9 +2445,9 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  #ifdef CONFIG_MEDIA_CONTROLLER
> >  	v4l2->v4l2_dev.mdev = dev->media_dev;
> >  #endif
> > -	ret = v4l2_device_register(&dev->udev->dev, &v4l2->v4l2_dev);
> > +	ret = v4l2_device_register(&dev->intf->dev, &v4l2->v4l2_dev);
> >  	if (ret < 0) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"Call to v4l2_device_register() failed!\n");
> >  		goto err;
> >  	}
> > @@ -2532,7 +2532,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  	/* Configure audio */
> >  	ret = em28xx_audio_setup(dev);
> >  	if (ret < 0) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"%s: Error while setting audio - error [%d]!\n",
> >  			__func__, ret);
> >  		goto unregister_dev;
> > @@ -2561,7 +2561,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  		/* Send a reset to other chips via gpio */
> >  		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xf7);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"%s: em28xx_write_reg - msp34xx(1) failed! error [%d]\n",
> >  				__func__, ret);
> >  			goto unregister_dev;
> > @@ -2570,7 +2570,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >
> >  		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"%s: em28xx_write_reg - msp34xx(2) failed! error [%d]\n",
> >  				__func__, ret);
> >  			goto unregister_dev;
> > @@ -2673,7 +2673,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  	ret = video_register_device(&v4l2->vdev, VFL_TYPE_GRABBER,
> >  				    video_nr[dev->devno]);
> >  	if (ret) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"unable to register video device (error=%i).\n", ret);
> >  		goto unregister_dev;
> >  	}
> > @@ -2703,7 +2703,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  		ret = video_register_device(&v4l2->vbi_dev, VFL_TYPE_VBI,
> >  					    vbi_nr[dev->devno]);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"unable to register vbi device\n");
> >  			goto unregister_dev;
> >  		}
> > @@ -2715,11 +2715,11 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
> >  					    radio_nr[dev->devno]);
> >  		if (ret < 0) {
> > -			dev_err(&dev->udev->dev,
> > +			dev_err(&dev->intf->dev,
> >  				"can't register radio device\n");
> >  			goto unregister_dev;
> >  		}
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "Registered radio device as %s\n",
> >  			 video_device_node_name(&v4l2->radio_dev));
> >  	}
> > @@ -2730,19 +2730,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  #ifdef CONFIG_MEDIA_CONTROLLER
> >  	ret = v4l2_mc_create_media_graph(dev->media_dev);
> >  	if (ret) {
> > -		dev_err(&dev->udev->dev,
> > +		dev_err(&dev->intf->dev,
> >  			"failed to create media graph\n");
> >  		em28xx_v4l2_media_release(dev);
> >  		goto unregister_dev;
> >  	}
> >  #endif
> >
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "V4L2 video device registered as %s\n",
> >  		 video_device_node_name(&v4l2->vdev));
> >
> >  	if (video_is_registered(&v4l2->vbi_dev))
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "V4L2 VBI device registered as %s\n",
> >  			 video_device_node_name(&v4l2->vbi_dev));
> >
> > @@ -2752,7 +2752,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >  	/* initialize videobuf2 stuff */
> >  	em28xx_vb2_setup(dev);
> >
> > -	dev_info(&dev->udev->dev,
> > +	dev_info(&dev->intf->dev,
> >  		 "V4L2 extension successfully initialized\n");
> >
> >  	kref_get(&dev->ref);
> > @@ -2762,19 +2762,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
> >
> >  unregister_dev:
> >  	if (video_is_registered(&v4l2->radio_dev)) {
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "V4L2 device %s deregistered\n",
> >  			 video_device_node_name(&v4l2->radio_dev));
> >  		video_unregister_device(&v4l2->radio_dev);
> >  	}
> >  	if (video_is_registered(&v4l2->vbi_dev)) {
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "V4L2 device %s deregistered\n",
> >  			 video_device_node_name(&v4l2->vbi_dev));
> >  		video_unregister_device(&v4l2->vbi_dev);
> >  	}
> >  	if (video_is_registered(&v4l2->vdev)) {
> > -		dev_info(&dev->udev->dev,
> > +		dev_info(&dev->intf->dev,
> >  			 "V4L2 device %s deregistered\n",
> >  			 video_device_node_name(&v4l2->vdev));
> >  		video_unregister_device(&v4l2->vdev);
> > diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> > index 3e5ace497a4e..5182b1bf0d15 100644
> > --- a/drivers/media/usb/em28xx/em28xx.h
> > +++ b/drivers/media/usb/em28xx/em28xx.h
> > @@ -678,6 +678,7 @@ struct em28xx {
> >
> >  	/* usb transfer */
> >  	struct usb_device *udev;	/* the usb device */
> > +	struct usb_interface *intf;	/* the usb interface */
> >  	u8 ifnum;		/* number of the assigned usb interface */
> >  	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
> >  	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
> >  
> 



Thanks,
Mauro
