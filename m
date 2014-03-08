Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55376 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaCHKuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Mar 2014 05:50:22 -0500
Received: by mail-ea0-f171.google.com with SMTP id n15so2781918ead.30
        for <linux-media@vger.kernel.org>; Sat, 08 Mar 2014 02:50:21 -0800 (PST)
Message-ID: <531AF62B.8000005@googlemail.com>
Date: Sat, 08 Mar 2014 11:51:23 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] em28xx: Only deallocate struct em28xx after finishing
 all extensions
References: <52FBB6BC.7030102@googlemail.com> <1394029372-5322-1-git-send-email-m.chehab@samsung.com> <5319FC34.5000602@googlemail.com> <20140307143803.61543333@samsung.com>
In-Reply-To: <20140307143803.61543333@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 07.03.2014 18:38, schrieb Mauro Carvalho Chehab:
>>> static int em28xx_usb_suspend(struct usb_interface *interface,
>>> > > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
>>> > > index d4986bdfbdc3..6dbc71ba2820 100644
>>> > > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>>> > > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>>> > > @@ -1043,7 +1043,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
>>> > >  	em28xx_info("Binding DVB extension\n");
>>> > >  
>>> > >  	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
>>> > > -
>>> > >  	if (dvb == NULL) {
>>> > >  		em28xx_info("em28xx_dvb: memory allocation failed\n");
>>> > >  		return -ENOMEM;
>>> > > @@ -1521,6 +1520,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
>>> > >  	dvb->adapter.mfe_shared = mfe_shared;
>>> > >  
>>> > >  	em28xx_info("DVB extension successfully initialized\n");
>>> > > +
>>> > > +	kref_get(&dev->ref);
>>> > > +
>> > 
>> > The fini() functions are always called, even if an error occured in init().
>> > So (in opposition to the open()/close() functions) kref_get() needs to
>> > be called at the beginning of the init() methods.
>> > 
>> > "dev->is_audio_only" and "!dev->board.has_dvb" is checked in both
>> > functions (init+fini), so the right place here is one line before or after
>> > 
>> >     em28xx_info("Binding DVB extension\n");
>> > 
>> > 
>> > Everything else looks good.
> I actually prefer to fix it the other way, at the code for kref_put()...
> see below
...
>> > 
>> > Regards,
>> > Frank
>> > 
>>> > >  ret:
>>> > >  	em28xx_set_mode(dev, EM28XX_SUSPEND);
>>> > >  	mutex_unlock(&dev->lock);
>>> > > @@ -1579,6 +1581,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
>>> > >  		dev->dvb = NULL;
> Putting the kref_put() here. This part of the code is only called if
> dev->dvb it not NULL, and this is only possible to happen if the
> DVB is properly initialized.
Yes, that works, too.

Regards,
Frank

>
>>> > >  	}
>>> > >  
>>> > > +	kref_put(&dev->ref, em28xx_free_device);
>>> > > +
>>> > >  	return 0;
>>> > >  }

