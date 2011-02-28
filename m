Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:52326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1B1L57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:57:59 -0500
Date: Mon, 28 Feb 2011 12:57:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <Pine.LNX.4.64.1102252135480.26361@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102281255400.11156@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
 <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
 <201102251105.06026.laurent.pinchart@ideasonboard.com>
 <20110225135314.GF23853@valkosipuli.localdomain> <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
 <20110225185511.GG23853@valkosipuli.localdomain> <Pine.LNX.4.64.1102252135480.26361@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 25 Feb 2011, Guennadi Liakhovetski wrote:

> On Fri, 25 Feb 2011, Sakari Ailus wrote:
> 
> > On Fri, Feb 25, 2011 at 06:08:07PM +0100, Guennadi Liakhovetski wrote:
> > 
> > > What we could also do, we could add an optional callback to subdev (core?) 
> > > operations, which, if activated, the host would call on each frame 
> > > completion.
> > 
> > It's not quite that simple. The exposure of the next frame has started long
> > time before that. This requires much more thought probably --- in the case
> > of lack of hardware support, when the parameters need to be actually given
> > to the sensor depend somewhat on sensors, I suppose.
> 
> Yes, that's right. I seem to remember, there was a case, for which such a 
> callback would have been useful... Don't remember what that was though.

I remember now:) I meant to use it to trigger the next frame from the 
software per sensor I2C command, if no hardware trigger is available.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
