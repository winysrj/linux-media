Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51020 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab1CCBFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 20:05:12 -0500
Subject: Re: [RFC] snapshot mode, flash capabilities and control
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
In-Reply-To: <201103021919.30003.hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
	 <Pine.LNX.4.64.1102282340480.17525@axis700.grange>
	 <Pine.LNX.4.64.1103021841140.29360@axis700.grange>
	 <201103021919.30003.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 20:05:00 -0500
Message-ID: <1299114300.22292.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-03-02 at 19:19 +0100, Hans Verkuil wrote:
> On Wednesday, March 02, 2011 18:51:43 Guennadi Liakhovetski wrote:
> > ...Just occurred to me:
> > 
> > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > 
> > > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > > 
> > > > On Mon, 28 Feb 2011, Hans Verkuil wrote:

> > > > These are not the features, that we _have_ to implement, these are just 
> > > > the ones, that are related to the snapshot mode:
> > > > 
> > > > * flash strobe (provided, we do not want to control its timing from 
> > > > 	generic controls, and leave that to "reasonable defaults" or to 
> > > > 	private controls)

I consider a flash strobe to be an illuminator.  I modifies the subject
matter to be captured in the image.

 
> > Wouldn't it be a good idea to also export an LED (drivers/leds/) API from 
> > our flash implementation? At least for applications like torch. Downside: 
> > the LED API itself is not advanced enough for all our uses, and exporting 
> > two interfaces to the same device is usually a bad idea. Still, 
> > conceptually it seems to be a good fit.
> 
> I believe we discussed LEDs before (during a discussion about adding illuminator
> controls). I think the preference was to export LEDs as V4L controls.

That is certainly my preference, especially for LED's integrated into
what the end user considers a discrete, consumer electronics device:
e.g. a USB connected webcam or microscope.

I cannot imagine a real use-case repurposing the flash strobe of a
camera purposes other than subject matter illumination.  (Inducing
seizures?  An intrusion detection systems alarm that doesn't use the
camera to which the flash is connected?)

For laptop frame integrated webcam LEDs, I can understand the desire to
perhaps co-opt the LED for some other indicator purpose.  A WLAN NIC
traffic indicator was suggested previously.

Does anyone know of any example where it could possibly make sense to
repurpose the LED of a discrete external camera or capture device for
some indication other than the camera/capture function?  (I consider
both extisngishing the LED for lighting purposes, and manipulating the
LED for the purpose of deception of the actual state of the
camera/capture function, still related to the camera function.)



> In general I am no fan of exporting multiple interfaces. It only leads to double
> maintenance and I see no noticable advantage to userspace, only confusion.

I agree.

Regards,
Andy


