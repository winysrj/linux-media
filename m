Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1BWPag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 10:30:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 16:30:42 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <cover.1298368924.git.svarbanov@mm-sol.com> <Pine.LNX.4.64.1102231020330.8880@axis700.grange> <A24693684029E5489D1D202277BE894488C57571@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894488C57571@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231630.43759.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 23 February 2011 15:06:49 Aguirre, Sergio wrote:
> <snip>
> 
> > > The only static data I am concerned about are those that affect signal
> > > integrity.
> > 
> > > After thinking carefully about this I realized that there is really
> > > only one setting that is relevant to that: the sampling edge. The
> > > polarities do not matter in this.
> 
> I respectfully disagree.

So do I. Sampling edge is related to polarities, so you need to take both into 
account.

> AFAIK, There is not such thing as sampling edge configuration for MIPI
> Receivers, and the polarities DO matter, since it's a differential
> signal.
> 
> > Ok, this is much better! I'm still not perfectly happy having to punish
> > all just for the sake of a couple of broken boards, but I can certainly
> > much better live with this, than with having to hard-code each and every
> > bit. Thanks, Hans!
> > 
> > So, I think, we can proceed with this, let's see the code now, shall
> > we?;)
> > 
> > Currently soc-camera auto-configures the following parameters:
> > 
> > hsync polarity
> > vsync polarity
> > data polarity
> > master / slave mode

What do you mean by master/slave mode ?

> > data bus width

The data bus width can already be configured through the media bus format. Do 
we need to set it explicitly ?

> > pixel clock polarity
> >
> > (see include/media/soc_camera.h::soc_camera_bus_param_compatible() and
> > drivers/media/video/soc_camera.c::soc_camera_apply_sensor_flags()).
> > Removing the pixclk polarity, the rest we can use as a basis for a new
> > subdev-based implementation.
> 
> Don't we need to move this out from soc_camera and make it available in
> v4l2_subdev ops? (I'm talking about both parallel and the "new" MIPI
> support)
> 
> That way both SoC_Camera, and Media Controller frameworks can use that.

-- 
Regards,

Laurent Pinchart
