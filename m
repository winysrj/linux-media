Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:63250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab1CBRvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 12:51:49 -0500
Date: Wed, 2 Mar 2011 18:51:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <Pine.LNX.4.64.1102282340480.17525@axis700.grange>
Message-ID: <Pine.LNX.4.64.1103021841140.29360@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102281148310.11156@axis700.grange>
 <201102281207.34106.laurent.pinchart@ideasonboard.com>
 <201102281217.12538.hansverk@cisco.com> <Pine.LNX.4.64.1102281237250.11156@axis700.grange>
 <Pine.LNX.4.64.1102282340480.17525@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

...Just occurred to me:

On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:

> On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> 
> > On Mon, 28 Feb 2011, Hans Verkuil wrote:
> > 
> > > Does anyone know which drivers stop capture if there are no buffers available? 
> > > I'm not aware of any.
> > 
> > Many soc-camera hosts do that.
> > 
> > > I think this is certainly a good initial approach.
> > > 
> > > Can someone make a list of things needed for flash/snapshot? So don't look yet 
> > > at the implementation, but just start a list of functionalities that we need 
> > > to support. I don't think I have seen that yet.
> > 
> > These are not the features, that we _have_ to implement, these are just 
> > the ones, that are related to the snapshot mode:
> > 
> > * flash strobe (provided, we do not want to control its timing from 
> > 	generic controls, and leave that to "reasonable defaults" or to 
> > 	private controls)

Wouldn't it be a good idea to also export an LED (drivers/leds/) API from 
our flash implementation? At least for applications like torch. Downside: 
the LED API itself is not advanced enough for all our uses, and exporting 
two interfaces to the same device is usually a bad idea. Still, 
conceptually it seems to be a good fit.

Thanks
Guennadi

> > * trigger pin / command
> > * external exposure
> > * exposure mode (ERS, GRR,...)
> > * use "trigger" or "shutter" for readout
> > * number of frames to capture
> 
> Add
> 
> * multiple videobuffer queues
> 
> to the list

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
