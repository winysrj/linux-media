Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:43274 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0HZOyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 10:54:44 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nataraju, Kiran" <knataraju@ti.com>
Date: Thu, 26 Aug 2010 09:54:37 -0500
Subject: RE: [omap3camera] How does a lens subdevice get powered up?
Message-ID: <A24693684029E5489D1D202277BE894463BA852B@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894463BA7E30@dlee02.ent.ti.com>
 <201008260930.43141.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201008260930.43141.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, August 26, 2010 2:31 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org; Nataraju, Kiran
> Subject: Re: [omap3camera] How does a lens subdevice get powered up?
> 
> Hi Sergio,
> 
> On Wednesday 25 August 2010 22:15:36 Aguirre, Sergio wrote:
> > Hi Laurent,
> >
> > I see that usually a sensor is powered up on attempting a
> VIDIOC_STREAMON
> > at the capture endpoint of the pipeline, in which the sensor is linked.
> >
> > Now, what I don't understand quite well is, the Lens driver is a
> separate
> > subdevice, BUT it's obviously not linked to the sensor, nor the
> pipeline.
> >
> > How would the lens driver know when to power up?
> 
> At the moment a userspace application needs to keep the lens subdev open
> to
> power-up the lens controller.

I see... So in that case, does it make sense to consider it as a media entity?

I mean, there's no link, nor pad operations involved, so it doesn't really
add any value...

What do you think?

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
