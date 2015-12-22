Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35927 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbLVNAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 08:00:39 -0500
Date: Tue, 22 Dec 2015 13:00:33 +0000
From: Okash Khawaja <okash.khawaja@gmail.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] next: media: cx231xx: add #ifdef to fix compile error
Message-ID: <20151222130033.GA24691@bytefire-computer>
References: <20151222102721.GA1892@bytefire-computer>
 <5679461B.6020402@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5679461B.6020402@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 22, 2015 at 09:46:19AM -0300, Javier Martinez Canillas wrote:
> Hello Okash,
> 
> On 12/22/2015 07:27 AM, Okash Khawaja wrote:
> > Compiling linux-next gave this warning:
> > 
> > drivers/media/usb/cx231xx/cx231xx-cards.c: In function
> > ‘cx231xx_usb_probe’:
> > drivers/media/usb/cx231xx/cx231xx-cards.c:1754:36: error: ‘struct
> > cx231xx’ has no member named ‘media_dev’
> >   retval = media_device_register(dev->media_dev);
> > 
> > Looking at the refactoring in past two commits, following seems like a
> > decent fix, i.e. to surround dev->media_dev by #ifdef
> > CONFIG_MEDIA_CONTROLLER.
> > 
> > Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>
> > ---
> >  drivers/media/usb/cx231xx/cx231xx-cards.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> > index 35692d1..220a5db 100644
> > --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> > +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> > @@ -1751,7 +1751,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
> >  	if (retval < 0)
> >  		goto done;
> >  
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> >  	retval = media_device_register(dev->media_dev);
> > +#endif
> >  
> >  done:
> >  	if (retval < 0)
> >
> 
> Thanks for your patch, I've posted the same fix already:
> 
> https://lkml.org/lkml/2015/12/21/270
> 
> Best regards,
> -- 
> Javier Martinez Canillas
> Open Source Group
> Samsung Research America

Cool. There was another similar compile error

https://lkml.org/lkml/2015/12/22/196

Thanks,
Okash
