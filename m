Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40891 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0HZPdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 11:33:32 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nataraju, Kiran" <knataraju@ti.com>
Date: Thu, 26 Aug 2010 10:33:28 -0500
Subject: RE: [omap3camera] How does a lens subdevice get powered up?
Message-ID: <A24693684029E5489D1D202277BE894463BA8603@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894463BA7E30@dlee02.ent.ti.com>
 <201008260930.43141.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894463BA852B@dlee02.ent.ti.com>
 <201008261704.05834.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008261704.05834.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, August 26, 2010 10:04 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org; Nataraju, Kiran
> Subject: Re: [omap3camera] How does a lens subdevice get powered up?
> 
> Hi Sergio,
> 
> On Thursday 26 August 2010 16:54:37 Aguirre, Sergio wrote:
> > On Thursday, August 26, 2010 2:31 AM Laurent Pinchart wrote:
> > > On Wednesday 25 August 2010 22:15:36 Aguirre, Sergio wrote:
> > > >
> > > > I see that usually a sensor is powered up on attempting a
> > > > VIDIOC_STREAMON at the capture endpoint of the pipeline, in which
> the
> > > > sensor is linked.
> > > >
> > > > Now, what I don't understand quite well is, the Lens driver is a
> > > > separate subdevice, BUT it's obviously not linked to the sensor, nor
> the
> > > > pipeline.
> > > >
> > > > How would the lens driver know when to power up?
> > >
> > > At the moment a userspace application needs to keep the lens subdev
> open
> > > to power-up the lens controller.
> >
> > I see... So in that case, does it make sense to consider it as a media
> > entity?
> >
> > I mean, there's no link, nor pad operations involved, so it doesn't
> really
> > add any value...
> >
> > What do you think?
> 
> Even if not part of the image pipeline, the lens controller is still part
> of
> the media device. I think it makes sense to expose it as an entity and a
> V4L2
> subdevice.

Hmm... I don't know what I was thinking... you're right. :)

Now that I rethink what I just said vs your answer, I think you have a point, so I'll drop that thought...

However, I think still there's something that could be done here...

Imagine a scenario in which you have 2 sensors, each one with a different
Coil motor driver to control each sensor's lens position.

Should we have a way to register some sort of association between
Sensor and lens subdevices? That way, by querying the media device, an app
can know which lens is associated with what sensor, without any hardcoding.

That would be very similar to the case in which you would want to associate
an audio capturing subdev with a video capturing subdev. They are not technically sharing the same data, but they are related.

Is this kind of association considered in the Media Controller framework
implementation currently?

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
