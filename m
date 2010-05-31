Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46949 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab0EaSTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 14:19:07 -0400
Subject: Re: question about v4l2_subdev
From: Andy Walls <awalls@md.metrocast.net>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
In-Reply-To: <4C03D80B.5090009@atmel.com>
References: <4C03D80B.5090009@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 14:19:07 -0400
Message-ID: <1275329947.2261.19.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-05-31 at 17:38 +0200, Sedji Gaouaou wrote:
> Hi,
> 
> I am currently working on the atmel video driver, and I am facing a issue.
> I have written a driver for the ov2640 omnivison sensor(enclosed). In 
> the ov2640 driver I am using the v4l2_subdev API. The point is I don't 
> how how can I access it in my video driver?
> How to register the subdev struct in the atmel driver, so I could access 
> the s_ftm function for instance.

That depends.  Is the atmel video driver instantiating a v4l_device for
itself, or is it using some frame work that instantiates one for it?


The details of using the v4l2 framework are in

	linux/Documentation/video4linux/v4l2-framework.txt

but, typically

1. Something first should call v4l2_device_register() on a v4l2_device
object.  (Typically there is only one v4l2_device object per "bridge"
chip between the PCI, PCIe, or USB bus and the subdevices, even if that
bridge chip has more than one I2C master implementation.)

2. Then, for subdevices connected to the bridge chip via I2C, something
needs to call v4l2_i2c_new_subdev() with the v4l2_device pointer as one
of the arguments, to get back a v4l2_subdevice instance pointer.

3. After that, v4l2_subdev_call() with the v4l2_subdev pointer as one of
the arguments can be used to invoke the subdevice methods.

TV Video capture drivers do this work themselves.  Drivers using a
camera framework may have the framework doing some of the work for them.


Regards,
Andy


