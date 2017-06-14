Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752654AbdFNVUT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 17:20:19 -0400
Date: Thu, 15 Jun 2017 00:19:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 5/8] v4l2-flash: Flash ops aren't mandatory
Message-ID: <20170614211939.GR12407@valkosipuli.retiisi.org.uk>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
 <3e0a8823-a8b4-3f78-25e0-22d8cb8ad090@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e0a8823-a8b4-3f78-25e0-22d8cb8ad090@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Jun 14, 2017 at 11:14:13PM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 06/14/2017 11:47 AM, Sakari Ailus wrote:
> > None of the flash operations are not mandatory and therefore there should
> > be no need for the flash ops structure either. Accept NULL.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-flash-led-class.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> > index 6d69119..fdb79da 100644
> > --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> > +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> > @@ -18,7 +18,7 @@
> >  #include <media/v4l2-flash-led-class.h>
> >  
> >  #define has_flash_op(v4l2_flash, op)				\
> > -	(v4l2_flash && v4l2_flash->ops->op)
> > +	(v4l2_flash && v4l2_flash->ops && v4l2_flash->ops->op)
> 
> This change doesn't seem to be related to the patch subject.

Yes, it is: if there's a chance that ops is NULL, then you have to test here
you actually have the ops struct around. The test is no longer in
v4l2_flash_init().

> 
> >  #define call_flash_op(v4l2_flash, op, arg)			\
> >  		(has_flash_op(v4l2_flash, op) ?			\
> > @@ -618,7 +618,7 @@ struct v4l2_flash *v4l2_flash_init(
> >  	struct v4l2_subdev *sd;
> >  	int ret;
> >  
> > -	if (!fled_cdev || !ops || !config)
> > +	if (!fled_cdev || !config)
> >  		return ERR_PTR(-EINVAL);
> >  
> >  	led_cdev = &fled_cdev->led_cdev;
> > 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
