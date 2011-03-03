Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33199 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758269Ab1CCN4D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2011 08:56:03 -0500
Subject: Re: [RFC] snapshot mode, flash capabilities and control
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
In-Reply-To: <201103031250.10495.laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
	 <201103021919.30003.hverkuil@xs4all.nl>
	 <1299114300.22292.21.camel@localhost>
	 <201103031250.10495.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 08:56:25 -0500
Message-ID: <1299160585.2037.59.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-03-03 at 12:50 +0100, Laurent Pinchart wrote:
> Hi Andy,
> 
> On Thursday 03 March 2011 02:05:00 Andy Walls wrote:
> > On Wed, 2011-03-02 at 19:19 +0100, Hans Verkuil wrote:
> > > On Wednesday, March 02, 2011 18:51:43 Guennadi Liakhovetski wrote:
> > > > ...Just occurred to me:
> > > > 
> > > > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > > > > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > > > > > On Mon, 28 Feb 2011, Hans Verkuil wrote:
> > > > > > 
> > > > > > These are not the features, that we _have_ to implement, these are
> > > > > > just the ones, that are related to the snapshot mode:
> > > > > > 
> > > > > > * flash strobe (provided, we do not want to control its timing from
> > > > > > 
> > > > > > 	generic controls, and leave that to "reasonable defaults" or to
> > > > > > 	private controls)
> > 
> > I consider a flash strobe to be an illuminator.  I modifies the subject
> > matter to be captured in the image.
> > 
> > > > Wouldn't it be a good idea to also export an LED (drivers/leds/) API
> > > > from our flash implementation? At least for applications like torch.
> > > > Downside: the LED API itself is not advanced enough for all our uses,
> > > > and exporting two interfaces to the same device is usually a bad idea.
> > > > Still, conceptually it seems to be a good fit.
> > > 
> > > I believe we discussed LEDs before (during a discussion about adding
> > > illuminator controls). I think the preference was to export LEDs as V4L
> > > controls.
> > 
> > That is certainly my preference, especially for LED's integrated into
> > what the end user considers a discrete, consumer electronics device:
> > e.g. a USB connected webcam or microscope.
> > 
> > I cannot imagine a real use-case repurposing the flash strobe of a
> > camera purposes other than subject matter illumination.  (Inducing
> > seizures?  An intrusion detection systems alarm that doesn't use the
> > camera to which the flash is connected?)
> > 
> > For laptop frame integrated webcam LEDs, I can understand the desire to
> > perhaps co-opt the LED for some other indicator purpose.  A WLAN NIC
> > traffic indicator was suggested previously.
> > 
> > Does anyone know of any example where it could possibly make sense to
> > repurpose the LED of a discrete external camera or capture device for
> > some indication other than the camera/capture function?  (I consider
> > both extisngishing the LED for lighting purposes, and manipulating the
> > LED for the purpose of deception of the actual state of the
> > camera/capture function, still related to the camera function.)

Hi Laurent,

> What about using the flash LED on a cellphone as a torch ?

Yes, it could be the case that the flash LED is used as a flashlight
(American English for "torch").

I use the LCD screen myself:
http://socialnmobile.blogspot.com/2009/06/android-app-color-flashlight-flashlight.html 



With embedded platforms, like a mobile phone, are the LEDs really tied
to the camera device: controlled by the GPIOs from the camera bridge
chip or sensor chip?  Or are they more general purpose peripherals, not
necessarily tied to the camera?

On mobile phone platforms, I'm assuming the manufacturers are in a much
better position to take care of any discovery and association problems.
Given the controlled nature of the hardware and deployed OS, I assume
they use platform-configuration information and abstraction layers to
handle the problem for all applications.

Desktop and laptop machines normally don't have such vendor support.
Nor is the hardware configuration fixed as it is on a mobile phone.


Now to go way beyond your answer:

Since it is relatively easy to add an LED interface to a driver,

	http://linuxtv.org/hg/~awalls/qx3/

we could just let V4L2 devices that can be on embedded platform
implement the LED API, while V4L2 devices that are computer peripherals
implement the V4L2 control API.

IMO the answer need not be a choice between the V4L2 API or the LED API.
Why not either or both, given the two domains of embedded vs. computer
peripheral?


My prototype changes for the QX3 microscope implemented both the V4L2
Control API and the LED API for the illuminators.

Like all sysfs interfaces, the names I chose for the LED API sysfs nodes
were mostly arbitrary, but followed the guidelines in the LED API
document.  They showed up in sysfs like this:


        /sys/class/leds/video0:white:illuminator0

        /sys/class/leds/video0:white:illuminator0/device/video4linux/video0

        /sys/class/video4linux/video0/device/leds/video0:white:illuminator0
     
	/sys/bus/pci/devices/0000:00:12.0/usb3/3-2/3-2:1.0/leds/video0:white:illuminator0

        /sys/bus/pci/devices/0000:00:12.0/usb3/3-2/3-2:1.0/video4linux/video0

and similar results for video0:white:illuminator1.

I don't know who is going to write applications that hunt those down,
just to figure out if the video device even has an LED, what type of LED
it is, or how to set the timing parameters for a flash LED.

Given that the driver can arbitrarily choose the name of the LEDs in
sysfs; and also provide additional, driver-specific, custom control
nodes is sysfs; I really think the LED API is a dead-end for desktop
video and camera applications.

Regards,
Andy

