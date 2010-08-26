Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41211 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0HZPih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 11:38:37 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nataraju, Kiran" <knataraju@ti.com>
Date: Thu, 26 Aug 2010 10:38:33 -0500
Subject: RE: [omap3camera] How does a lens subdevice get powered up?
Message-ID: <A24693684029E5489D1D202277BE894463BA861E@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894463BA7E30@dlee02.ent.ti.com>
 <201008261704.05834.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE894463BA8603@dlee02.ent.ti.com>
 <201008261736.17915.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008261736.17915.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, August 26, 2010 10:36 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org; Nataraju, Kiran
> Subject: Re: [omap3camera] How does a lens subdevice get powered up?
> 
> Hi Sergio,
> 
> On Thursday 26 August 2010 17:33:28 Aguirre, Sergio wrote:
> > On Thursday, August 26, 2010 10:04 AM Laurent Pinchart wrote:
> > >
> > > Even if not part of the image pipeline, the lens controller is still
> part
> > > of the media device. I think it makes sense to expose it as an entity
> and
> > > a V4L2 subdevice.
> >
> > Hmm... I don't know what I was thinking... you're right. :)
> >
> > Now that I rethink what I just said vs your answer, I think you have a
> > point, so I'll drop that thought...
> >
> > However, I think still there's something that could be done here...
> >
> > Imagine a scenario in which you have 2 sensors, each one with a
> different
> > Coil motor driver to control each sensor's lens position.
> >
> > Should we have a way to register some sort of association between
> > Sensor and lens subdevices? That way, by querying the media device, an
> app
> > can know which lens is associated with what sensor, without any
> hardcoding.
> >
> > That would be very similar to the case in which you would want to
> associate
> > an audio capturing subdev with a video capturing subdev. They are not
> > technically sharing the same data, but they are related.
> >
> > Is this kind of association considered in the Media Controller framework
> > implementation currently?
> 
> It's implemented in the latest media controller RFC :-)
> 
> Entities now have a group ID that the driver can set to report
> associations
> such as sensor-coil-flash or video-audio.

Oh ok, I see.

Perfect!

Thanks for clarifying that.

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
