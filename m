Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:54799 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0FAIPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 04:15:08 -0400
Message-ID: <4C04C17D.8020702@atmel.com>
Date: Tue, 01 Jun 2010 10:14:53 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: question about v4l2_subdev
References: <4C03D80B.5090009@atmel.com> <1275329947.2261.19.camel@localhost>
In-Reply-To: <1275329947.2261.19.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


>
> 1. Something first should call v4l2_device_register() on a v4l2_device
> object.  (Typically there is only one v4l2_device object per "bridge"
> chip between the PCI, PCIe, or USB bus and the subdevices, even if that
> bridge chip has more than one I2C master implementation.)
>
> 2. Then, for subdevices connected to the bridge chip via I2C, something
> needs to call v4l2_i2c_new_subdev() with the v4l2_device pointer as one
> of the arguments, to get back a v4l2_subdevice instance pointer.
>
> 3. After that, v4l2_subdev_call() with the v4l2_subdev pointer as one of
> the arguments can be used to invoke the subdevice methods.
>
> TV Video capture drivers do this work themselves.  Drivers using a
> camera framework may have the framework doing some of the work for them.
>
>
> Regards,
> Andy
>
>
>


Is there a sensor driver which is using this method?

To write the ov2640 driver I have just copied the ov7670.c file, and I 
didn't find the v4l2_i2c_new_subdev in it...

Regards,
Sedji

