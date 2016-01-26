Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51463 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966890AbcAZRIZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 12:08:25 -0500
Date: Tue, 26 Jan 2016 15:08:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] [media] em28xx: add MEDIA_TUNER dependency
Message-ID: <20160126150819.04cab5a9@recife.lan>
In-Reply-To: <5775609.WPlM7VCgVr@wuerfel>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
	<6929423.KuNZKsBgHV@wuerfel>
	<20160126143644.1d104040@recife.lan>
	<5775609.WPlM7VCgVr@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 17:51:11 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Tuesday 26 January 2016 14:36:44 Mauro Carvalho Chehab wrote:
> > Em Tue, 26 Jan 2016 16:53:38 +0100
> > Arnd Bergmann <arnd@arndb.de> escreveu:  
> > > On Tuesday 26 January 2016 12:33:08 Mauro Carvalho Chehab wrote:  
> > > > Em Tue, 26 Jan 2016 15:10:00 +0100
> > > > Advanced users may, instead, manually select the media tuner that his
> > > > hardware needs. In such case, it doesn't matter if MEDIA_TUNER
> > > > is enabled or not.
> > > > 
> > > > As this is due to a Kconfig limitation, I've no idea how to fix or get
> > > > hid of it, but making em28xx dependent of MEDIA_TUNER is wrong.    
> > > 
> > > I don't understand what limitation you see here.   
> > 
> > Before MEDIA_TUNER, what we had was something like:
> > 
> > 	config MEDIA_driver_foo
> > 	select VIDEO_tuner_bar if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_frontend_foobar if MEDIA_SUBDRV_AUTOSELECT
> > 	...
> > 
> > However, as different I2C drivers had different dependencies, this
> > used to cause lots of troubles. So, one of the Kbuild maintainers
> > came out with the idea of converting from select into depends on.
> > The MEDIA_TUNER is just an ancillary invisible option to make it
> > work at the tuner's side, as usually what we want is to have all
> > tuners selected, as we don't have a one to one mapping about what
> > driver supports what tuner (nor we wanted to do it, as this would
> > mean lots of work for not much gain).  
> 
> Ok
> 
> > > The definition
> > > of the VIDEO_TUNER symbol is an empty 'tristate' symbol with a
> > > dependency on MEDIA_TUNER to ensure we get a warning if MEDIA_TUNER
> > > is not enabled, and to ensure it is set to 'm' if MEDIA_TUNER=m and
> > > a "bool" driver selects VIDEO_TUNER.  
> > 
> > No, VIDEO_TUNER is there because we wanted to be able to use select
> > to enable V4L2 tuner core support and let people to manually select
> > the needed I2C devices with MEDIA_SUBDRV_AUTOSELECT unselected.  
> 
> I meant what the dependency is there for, not the symbol itself.
> It's clear what the symbol does.
> 
> > > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> > > index 9beece00869b..1050bdf1848f 100644
> > > --- a/drivers/media/v4l2-core/Kconfig
> > > +++ b/drivers/media/v4l2-core/Kconfig
> > > @@ -37,7 +37,11 @@ config VIDEO_PCI_SKELETON
> > >  # Used by drivers that need tuner.ko
> > >  config VIDEO_TUNER
> > >  	tristate
> > > -	depends on MEDIA_TUNER
> > > +
> > > +config VIDEO_TUNER_MODULE
> > > +	tristate # must not be built-in if MEDIA_TUNER=m because of I2C
> > > +	default y if VIDEO_TUNER=y || MEDIA_TUNER=y
> > > +	default m if VIDEO_TUNER=m  
> > 
> > Doesn't need to worry about that, because all drivers that select VIDEO_TUNER
> > depend on I2C:
> >   
> 
> Ok, then the dependency does not do anything other than generate a
> warning.
> 
> > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> > index 9beece00869b..b30e1c879a57 100644
> > --- a/drivers/media/v4l2-core/Kconfig
> > +++ b/drivers/media/v4l2-core/Kconfig
> > @@ -37,7 +37,7 @@ config VIDEO_PCI_SKELETON
> >  # Used by drivers that need tuner.ko
> >  config VIDEO_TUNER
> >  	tristate
> > -	depends on MEDIA_TUNER
> > +	default MEDIA_TUNER
> >  
> >  # Used by drivers that need v4l2-mem2mem.ko
> >  config V4L2_MEM2MEM_DEV  
> 
> So this means it's now enabled if MEDIA_TUNER is enabled, whereas
> before it was only enabled when explicitly selected. That sounds
> like a useful change, but it also seems unrelated to the warning
> fix, and should probably be a separate change, while for now
> we can simply remove the 'depends on' line without any replacement.

True.

> > Ok, if we'll have platform drivers for analog TV using the I2C bus
> > at directly in SoC, then your solution is better, but the tuner core
> > driver may not be the best way of doing it. So, for now, I would use
> > the simpler version.  
> 
> Ok. Do you want me to submit a new version or do you prefer to write
> one yourself? With or without the 'default'?

Feel free to submit a new version without the default.

Thanks!
Mauro
