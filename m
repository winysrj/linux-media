Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1302 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab1CBSTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 13:19:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Wed, 2 Mar 2011 19:19:29 +0100
Cc: Hans Verkuil <hansverk@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <Pine.LNX.4.64.1102282340480.17525@axis700.grange> <Pine.LNX.4.64.1103021841140.29360@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103021841140.29360@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103021919.30003.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, March 02, 2011 18:51:43 Guennadi Liakhovetski wrote:
> ...Just occurred to me:
> 
> On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> 
> > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > 
> > > On Mon, 28 Feb 2011, Hans Verkuil wrote:
> > > 
> > > > Does anyone know which drivers stop capture if there are no buffers available? 
> > > > I'm not aware of any.
> > > 
> > > Many soc-camera hosts do that.
> > > 
> > > > I think this is certainly a good initial approach.
> > > > 
> > > > Can someone make a list of things needed for flash/snapshot? So don't look yet 
> > > > at the implementation, but just start a list of functionalities that we need 
> > > > to support. I don't think I have seen that yet.
> > > 
> > > These are not the features, that we _have_ to implement, these are just 
> > > the ones, that are related to the snapshot mode:
> > > 
> > > * flash strobe (provided, we do not want to control its timing from 
> > > 	generic controls, and leave that to "reasonable defaults" or to 
> > > 	private controls)
> 
> Wouldn't it be a good idea to also export an LED (drivers/leds/) API from 
> our flash implementation? At least for applications like torch. Downside: 
> the LED API itself is not advanced enough for all our uses, and exporting 
> two interfaces to the same device is usually a bad idea. Still, 
> conceptually it seems to be a good fit.

I believe we discussed LEDs before (during a discussion about adding illuminator
controls). I think the preference was to export LEDs as V4L controls.

In general I am no fan of exporting multiple interfaces. It only leads to double
maintenance and I see no noticable advantage to userspace, only confusion.

Just my 2 cents.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> > > * trigger pin / command
> > > * external exposure
> > > * exposure mode (ERS, GRR,...)
> > > * use "trigger" or "shutter" for readout
> > > * number of frames to capture
> > 
> > Add
> > 
> > * multiple videobuffer queues
> > 
> > to the list
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
