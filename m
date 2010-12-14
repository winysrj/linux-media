Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38686 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab0LNJni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 04:43:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: Translation Faults on OMAP ISP update
Date: Tue, 14 Dec 2010 10:44:31 +0100
Cc: Lane Brooks <lane@brooks.nu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4CF6CAF7.1090807@brooks.nu> <4CF7D893.1070803@brooks.nu> <A24693684029E5489D1D202277BE8944856314F8@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944856314F8@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141044.32232.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

On Friday 03 December 2010 01:32:08 Aguirre, Sergio wrote:
> On Thursday, December 02, 2010 11:34 AM Lane Brooks wrote:
> > On 12/02/2010 07:35 AM, Laurent Pinchart wrote:
> > [snip]
> > 
> > > > Any ideas on the problem? Is there a way to force a reset to the CCDC
> > > > so that it will become IDLE?
> > > 
> > > Would you expect the ISP to recover gracefully if you removed the
> > > OMAP3530 or the RAM from the board and plugged it back ? The same
> > > applies to the sensor :-)
> > > 
> > > Long story short, once started, the CCDC can't be stopped before the
> > > end of the image. When you unplug the sensor the CCDC will wait forever
> > > for the end of frame. When restarted it will resume working to the
> > > previous, no longer mapped buffer, leading to IOMMU faults.
> > > The CCDC, like most ISP blocks, can't be reset individually. You need
> > > to reset the whole ISP to recover from this (blame whoever decided that
> > > individual block resets were not useful). This was done before on
> > > streamoff, but now that the ISP driver supports running multiple
> > > pipelines in parallel we can't do it anymore.
> > > 
> > > It might be possible to write a clean patch to reset the ISP when all
> > > streams are stopped. In the meantime you can rmmod/modprobe the driver.
> > 
> > Laurent,
> > 
> > Thanks for the feedback. The behavior makes perfect sense now. I can
> > take it from here. Given the user *can* unplug the sensor module in our
> > hardware, I need to do something, as locking up the kernel is not
> > acceptable. I will first look to see if an ISP reset on stream off
> > works, as we can sacrifice multiple pipeline support (for now).
> 
> Laurent,
> 
> Just a question on this:
> 
> Do we ever plan to support dynamic v4l2_subdevs
> registration/unregistration?
> 
> I guess we'll require to "notify" the media controller device, so we add
> it, (or remove it) from the pipeline, and refresh the links.
> 
> I think that is going to become an important requirement, as like Lane is
> doing (unloading a module).
> 
> It's very likely that we can interchange camera modules, like in the
> Beagleboard xM, and we don't have a real reason to really not support
> that.
> 
> It would be very cool to be able to:
> 
> 1. Plug Aptina 5MP camera sensor.
> 2. Load the kernel module
> 3. Use the camera
> 4. Unload the kernel module
> 5. Interchange the camera board for a VGA sensor
> 6. Load the appropriate sensor driver.
> 
> All that without needing to restart the board.
> 
> Does that really sound _that_ crazy to everyone? :)

Totally :-)

One good reason not to support that is that the busses used by the sensors 
(I2C and CCDC parallel interface) are not hot-pluggable. You can't get 
connect/disconnect events, you can't discover devices dynamically, and 
connecting/disconnected a sensor while the system is powered on might damage 
both the sensor and the processor. Is that a good enough reason ? :-)

-- 
Regards,

Laurent Pinchart
