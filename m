Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731162AbeHNPuX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 11:50:23 -0400
Date: Tue, 14 Aug 2018 10:03:12 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: petrcvekcz@gmail.com, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: [BUG, RFC] media: Wrong module gets acquired
Message-ID: <20180814100312.096672fb@coco.lan>
In-Reply-To: <20180814083501.cml3fpxekbnyeois@paasikivi.fi.intel.com>
References: <d2bc538126492151ad325fa653924ca158a39b07.1534177949.git.petrcvekcz@gmail.com>
        <20180814083501.cml3fpxekbnyeois@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 11:35:01 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Pert,
> 
> On Mon, Aug 13, 2018 at 06:33:12PM +0200, petrcvekcz@gmail.com wrote:
> > From: Petr Cvek <petrcvekcz@gmail.com>
> > 
> > When transferring a media sensor driver from the soc_camera I've found
> > the controller module can get removed (which will cause a stack dump
> > because the sensor driver depends on resources from the controller driver).  
> 
> There may be a kernel oops if a resource used by another driver goes away.
> But the right fix isn't to prevent unloading that module. Instead, one way
> to address the problem would be to have persistent clock objects that would
> not be dependent on the driver that provides them.
> 
> > 
> > When I've tried to remove the driver module of the sensor it said the
> > resource was busy (without a reference name) though is should be
> > possible to remove the sensor driver because it is at the end of
> > the dependency list and not to remove the controller driver.  
> 
> That might be one day possible but it is not today.
> 
> You'll still need to acquire the sensor module as well as it registers a
> media entity as well as a sub-device.

Let put my 2 cents here.

Usually, the same problem of removing modules happen if you just
ask the driver's core to unbind a module (with can be done via
sysfs).

Removing/unbinding a driver that uses media controller should work,
if the unbinding code at the driver (e. g. i2c_driver::remove field)
would delete the media controller entities, and the caller driver
doesn't cache it.

The USB drivers whose exports their topology via the media controller
(like em28xx) supports removing an I2C driver without crashing.

Btw, em28xx is an interesting example, as it has a main driver, several
sub-drivers and several I2C drivers.

There, basically, em28xx loads their sub-drivers, with causes the
sub-drivers to increment their device refcount. The same applies
to the I2C drivers. If one wants to remove em28xx from the memory,
it need to remove first the I2C drivers, then the em28xx-foo
sub-drivers, and finally em28xx itself. 

This use to work pretty well (except when some unbind regression gets
introduced).

I use this a lot when testing usb drivers, as it prevents me to boot
the Kernel every time.

-

It could be harder when it has cross-dependencies with other stuff
that aren't properly mapped (clock, gpio, etc). On such cases, the
best way is to use i2c_driver::suppress_bind_attrs, instead of
hacking the v4l2 core.

I didn't look into details (nor did any tests on this RFC patch),
but whatever is there at the core, it should be allowing unbinding
a module, if they don't use suppress_bind_attrs=true.

> 
> > 
> > I've dig into the called functions and I've found this in
> > drivers/media/v4l2-core/v4l2-device.c:
> > 
> > 	/*
> > 	 * The reason to acquire the module here is to avoid unloading
> > 	 * a module of sub-device which is registered to a media
> > 	 * device. To make it possible to unload modules for media
> > 	 * devices that also register sub-devices, do not
> > 	 * try_module_get() such sub-device owners.
> > 	 */
> > 	sd->owner_v4l2_dev = v4l2_dev->dev && v4l2_dev->dev->driver &&
> > 		sd->owner == v4l2_dev->dev->driver->owner;
> > 
> > 	if (!sd->owner_v4l2_dev && !try_module_get(sd->owner))
> > 		return -ENODEV;
> > 
> > It basicaly checks if subdevice (=sensor) is a same module as the media
> > device (=controller) and if they are different it acquires the module.
> > 
> > The acquired module is the one in sd->owner, which is the same module from
> > which the function is called (-> sensor aquires itself). Is this
> > functionality valid (should the subdevice really be unloadable)? When
> > I've patched the module to aquire the controller instead the module, the
> > removal worked as expected (sensor free to go, controller not).
> > 
> > If this is really a bug (= there isn't a sensor which cannot be unloaded from
> > a controller?) then I send a new patch with reworded commentary.
> > 
> > Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-device.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> > index 3940e55c72f1..1dec61cd560c 100644
> > --- a/drivers/media/v4l2-core/v4l2-device.c
> > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > @@ -173,7 +173,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> >  	sd->owner_v4l2_dev = v4l2_dev->dev && v4l2_dev->dev->driver &&
> >  		sd->owner == v4l2_dev->dev->driver->owner;
> >  
> > -	if (!sd->owner_v4l2_dev && !try_module_get(sd->owner))
> > +	if (!sd->owner_v4l2_dev &&
> > +		!try_module_get(v4l2_dev->dev->driver->owner))
> >  		return -ENODEV;
> >  
> >  	sd->v4l2_dev = v4l2_dev;
> > @@ -209,7 +210,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> >  #endif
> >  error_module:
> >  	if (!sd->owner_v4l2_dev)
> > -		module_put(sd->owner);
> > +		module_put(v4l2_dev->dev->driver->owner);
> >  	sd->v4l2_dev = NULL;
> >  	return err;
> >  }
> > @@ -318,6 +319,6 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
> >  #endif
> >  	video_unregister_device(sd->devnode);
> >  	if (!sd->owner_v4l2_dev)
> > -		module_put(sd->owner);
> > +		module_put(v4l2_dev->dev->driver->owner);
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> > -- 
> > 2.18.0
> >   
> 



Thanks,
Mauro
