Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1HTMeM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 08:34:12 -0400
Message-ID: <4E4FA9BA.1020306@redhat.com>
Date: Sat, 20 Aug 2011 05:34:02 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 2/2] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com> <4E4F9E86.7030001@yahoo.com>
In-Reply-To: <4E4F9E86.7030001@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2011 04:46, Chris Rankin escreveu:
> The final patch removes the unplug/replug deadlock by not holding the device mutex during dvb_init(). However, this mutex has already been locked during device initialisation by em28xx_usb_probe() and is not released again until all extensions have been initialised successfully.

No. The extension load can happen after the usb probe phase. In practice,
the only case where the extension init will happen together with the
usb probe phase is when the em28xx modules are compiled builtin, as the
module load is done asynchronously, and generally happens after the em28xx
core to load.

> The device mutex is not held during either em28xx_register_extension() or em28xx_unregister_extension() any more. More importantly, I don't believe it can safely be held by these functions because they must both - by their nature - acquire the device list mutex before they can iterate through the device list. In other words, while usb_probe() and usb_disconnect() acquire the device mutex followed by the device list mutex, the register/unregister_extension() functions would need to acquire these mutexes in the opposite order. And that sounds like a potential deadlock.
> 
> On the other hand, the new situation is a definite improvement :-).

No, it is a regression for a known bug.

This patch can cause troubles. The point is that, after initializing the
analog part, the device can be accessed via the V4L2 API, while it is
still initializing the DVB part. This actually happens in practice, as
when udev detects a new device, it opens it and calls VIDIOC_QUERYCAP.

So, it ends by having a race issue, as at V4L2 open, or at some analog mode
ioctl's, there are calls for em28xx_set_mode(dev, EM28XX_ANALOG_MODE).

In order words, if the DVB initialization is still happening, the driver
should not allow any V4L2 call, otherwise the DVB detection breaks.

Maybe the proper fix would be to change the logic under em28xx_usb_probe()
to not hold dev->lock anymore when the device is loading the extensions.
> 
> Signed-off-by: Chris Rankin <rankincj@yahoo.com>
> 
> 
> EM28xx-replug-deadlock.diff
> 
> 
> --- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-19 00:50:41.000000000 +0100
> +++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-19 00:51:03.000000000 +0100
> @@ -542,7 +542,6 @@
>  	dev->dvb = dvb;
>  	dvb->fe[0] = dvb->fe[1] = NULL;
>  
> -	mutex_lock(&dev->lock);
>  	em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
>  	/* init frontend */
>  	switch (dev->model) {
> @@ -711,7 +710,6 @@
>  	em28xx_info("Successfully loaded em28xx-dvb\n");
>  ret:
>  	em28xx_set_mode(dev, EM28XX_SUSPEND);
> -	mutex_unlock(&dev->lock);
>  	return result;
>  
>  out_free:

