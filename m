Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:23332 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab0FEB12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 21:27:28 -0400
Subject: Re: question about v4l2_subdev
From: Andy Walls <awalls@md.metrocast.net>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
In-Reply-To: <4C04C17D.8020702@atmel.com>
References: <4C03D80B.5090009@atmel.com>
	 <1275329947.2261.19.camel@localhost>  <4C04C17D.8020702@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 21:27:38 -0400
Message-ID: <1275701258.2247.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-06-01 at 10:14 +0200, Sedji Gaouaou wrote:
> Hi,
> 
> 
> >
> > 1. Something first should call v4l2_device_register() on a v4l2_device
> > object.  (Typically there is only one v4l2_device object per "bridge"
> > chip between the PCI, PCIe, or USB bus and the subdevices, even if that
> > bridge chip has more than one I2C master implementation.)
> >
> > 2. Then, for subdevices connected to the bridge chip via I2C, something
> > needs to call v4l2_i2c_new_subdev() with the v4l2_device pointer as one
> > of the arguments, to get back a v4l2_subdevice instance pointer.
> >
> > 3. After that, v4l2_subdev_call() with the v4l2_subdev pointer as one of
> > the arguments can be used to invoke the subdevice methods.
> >
> > TV Video capture drivers do this work themselves.  Drivers using a
> > camera framework may have the framework doing some of the work for them.
> >
> >
> > Regards,
> > Andy
> >
> >
> >
> 
> 
> Is there a sensor driver which is using this method?
> 
> To write the ov2640 driver I have just copied the ov7670.c file, and I 
> didn't find the v4l2_i2c_new_subdev in it...

Subdev driver modules, like ov7670.c, don't attach themselves; the
bridge chip driver attaches an instance to an I2C bus.

Look at

	drivers/media/video/cafe_ccic.c

And examine cafe_pci_probe() and the definition and use of the
sensor_call() macro.

Also note

$ grep -Ril ov7670 drivers/media/video/*

will show you in what drivers, the ov7670 might be used.


Regards,
Andy

> Regards,
> Sedji



