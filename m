Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46834 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1CCLt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 06:49:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Thu, 3 Mar 2011 12:50:09 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <201103021919.30003.hverkuil@xs4all.nl> <1299114300.22292.21.camel@localhost>
In-Reply-To: <1299114300.22292.21.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031250.10495.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Thursday 03 March 2011 02:05:00 Andy Walls wrote:
> On Wed, 2011-03-02 at 19:19 +0100, Hans Verkuil wrote:
> > On Wednesday, March 02, 2011 18:51:43 Guennadi Liakhovetski wrote:
> > > ...Just occurred to me:
> > > 
> > > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > > > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > > > > On Mon, 28 Feb 2011, Hans Verkuil wrote:
> > > > > 
> > > > > These are not the features, that we _have_ to implement, these are
> > > > > just the ones, that are related to the snapshot mode:
> > > > > 
> > > > > * flash strobe (provided, we do not want to control its timing from
> > > > > 
> > > > > 	generic controls, and leave that to "reasonable defaults" or to
> > > > > 	private controls)
> 
> I consider a flash strobe to be an illuminator.  I modifies the subject
> matter to be captured in the image.
> 
> > > Wouldn't it be a good idea to also export an LED (drivers/leds/) API
> > > from our flash implementation? At least for applications like torch.
> > > Downside: the LED API itself is not advanced enough for all our uses,
> > > and exporting two interfaces to the same device is usually a bad idea.
> > > Still, conceptually it seems to be a good fit.
> > 
> > I believe we discussed LEDs before (during a discussion about adding
> > illuminator controls). I think the preference was to export LEDs as V4L
> > controls.
> 
> That is certainly my preference, especially for LED's integrated into
> what the end user considers a discrete, consumer electronics device:
> e.g. a USB connected webcam or microscope.
> 
> I cannot imagine a real use-case repurposing the flash strobe of a
> camera purposes other than subject matter illumination.  (Inducing
> seizures?  An intrusion detection systems alarm that doesn't use the
> camera to which the flash is connected?)
> 
> For laptop frame integrated webcam LEDs, I can understand the desire to
> perhaps co-opt the LED for some other indicator purpose.  A WLAN NIC
> traffic indicator was suggested previously.
> 
> Does anyone know of any example where it could possibly make sense to
> repurpose the LED of a discrete external camera or capture device for
> some indication other than the camera/capture function?  (I consider
> both extisngishing the LED for lighting purposes, and manipulating the
> LED for the purpose of deception of the actual state of the
> camera/capture function, still related to the camera function.)

What about using the flash LED on a cellphone as a torch ?

-- 
Regards,

Laurent Pinchart
