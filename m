Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:47330 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0HZPEH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 11:04:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [omap3camera] How does a lens subdevice get powered up?
Date: Thu, 26 Aug 2010 17:04:05 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nataraju, Kiran" <knataraju@ti.com>
References: <A24693684029E5489D1D202277BE894463BA7E30@dlee02.ent.ti.com> <201008260930.43141.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894463BA852B@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894463BA852B@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008261704.05834.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Sergio,

On Thursday 26 August 2010 16:54:37 Aguirre, Sergio wrote:
> On Thursday, August 26, 2010 2:31 AM Laurent Pinchart wrote:
> > On Wednesday 25 August 2010 22:15:36 Aguirre, Sergio wrote:
> > > 
> > > I see that usually a sensor is powered up on attempting a
> > > VIDIOC_STREAMON at the capture endpoint of the pipeline, in which the
> > > sensor is linked.
> > > 
> > > Now, what I don't understand quite well is, the Lens driver is a
> > > separate subdevice, BUT it's obviously not linked to the sensor, nor the
> > > pipeline.
> > >
> > > How would the lens driver know when to power up?
> > 
> > At the moment a userspace application needs to keep the lens subdev open
> > to power-up the lens controller.
> 
> I see... So in that case, does it make sense to consider it as a media
> entity?
> 
> I mean, there's no link, nor pad operations involved, so it doesn't really
> add any value...
> 
> What do you think?

Even if not part of the image pipeline, the lens controller is still part of 
the media device. I think it makes sense to expose it as an entity and a V4L2 
subdevice.

-- 
Regards,

Laurent Pinchart
