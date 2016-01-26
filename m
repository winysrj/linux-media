Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51331 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190AbcAZPl7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 10:41:59 -0500
Date: Tue, 26 Jan 2016 13:41:53 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] [media] go7007: add MEDIA_CAMERA_SUPPORT dependency
Message-ID: <20160126134153.2273c1a1@recife.lan>
In-Reply-To: <20160126130403.768e9af4@recife.lan>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
	<1453817424-3080054-7-git-send-email-arnd@arndb.de>
	<20160126130403.768e9af4@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 13:04:03 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Tue, 26 Jan 2016 15:10:01 +0100
> Arnd Bergmann <arnd@arndb.de> escreveu:
> 
> > If MEDIA_SUBDRV_AUTOSELECT and VIDEO_GO7007 are both set, we
> > automatically select VIDEO_OV7640, but that depends on MEDIA_CAMERA_SUPPORT,
> > so we get a Kconfig warning if that is disabled:
> > 
> > warning: (VIDEO_GO7007) selects VIDEO_OV7640 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT)
> > 
> > This adds another dependency so we don't accidentally select
> > it when it is unavailable.  
> 
> This is another bogus warning.
> 
> The MEDIA_foo_SUPPORT actually controls what drivers are visible,
> but it doesn't enable any driver. They just control the visibility
> of the drivers, and the APIs that will be enabled (V4L2 and/or DVB).
> 
> The aim of MEDIA_foo_SUPPORT is to make life easier to end users,
> making easier for them to filter the drivers that they may need.
> 
> If one selects MEDIA_VIDEO_SUPPORT, the V4L2 API (and V4L core) will be 
> enabled, and all drivers that support a camera should appear at the 
> menu, including drivers that *also* support other features (like TV
> and/or stream support).
> 
> That's the case of go7007.
> 
> That has nothing to do with the features selection for such driver.
> 
> Once go7007 driver is selected, if MEDIA_SUBDRV_AUTOSELECT, all
> i2c drivers that cope together with go7007 are selected, making the
> driver to fully support all devices it knows.
> 
> Advanced users may unselect MEDIA_SUBDRV_AUTOSELECT and add there just
> the I2C driver(s) it needs for his specific hardware.
> 
> Despite the warning, the Kconfig will do the right thing, not
> allowing invalid configurations.
> 
> Regards,
> Mauro
> 
> 
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/media/usb/go7007/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/go7007/Kconfig b/drivers/media/usb/go7007/Kconfig
> > index 95a3af644a92..af1d02430931 100644
> > --- a/drivers/media/usb/go7007/Kconfig
> > +++ b/drivers/media/usb/go7007/Kconfig
> > @@ -11,7 +11,7 @@ config VIDEO_GO7007
> >  	select VIDEO_TW2804 if MEDIA_SUBDRV_AUTOSELECT
> >  	select VIDEO_TW9903 if MEDIA_SUBDRV_AUTOSELECT
> >  	select VIDEO_TW9906 if MEDIA_SUBDRV_AUTOSELECT
> > -	select VIDEO_OV7640 if MEDIA_SUBDRV_AUTOSELECT
> > +	select VIDEO_OV7640 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT

Hmm... on a second thought, it could make sense to only auto-select
the sensor drivers if MEDIA_CAMERA_SUPPORT, and to only auto-select
tuners if MEDIA_*_TV_SUPPORT is selected.

However, in this case, we'll need to dig into all Kconfig autoselect
options in order to make it right.

I guess we should also likely need to document to the user that the
driver won't be fully supported, as we'll be changing the behavior
of the menus.

Comments?

Regards,
Mauro
