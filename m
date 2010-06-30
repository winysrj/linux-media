Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49732 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0F3WjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 18:39:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Query] How to preserve soc_camera and still use a sensor for media controller?
Date: Thu, 1 Jul 2010 00:39:34 +0200
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE89445638FD0E@dlee02.ent.ti.com> <Pine.LNX.4.64.1006302048310.17489@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1006302048310.17489@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007010039.35479.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio and Guennadi,

On Wednesday 30 June 2010 20:53:24 Guennadi Liakhovetski wrote:
> On Wed, 30 Jun 2010, Aguirre, Sergio wrote:
> > 
> > Is it possible to keep a sensor chip driver compatible with 2 interfaces?
> > 
> > I'm particularly interested in mt9t112 sensor.
> > 
> > Has this been done before with other driver?
> 
> You can try looking at this thread:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/16311
> and remembering our discussions at the mini-summit;) You can also look at
> Hans' report of summit's results. A few people know, what has to be done,
> but noone has done it yet... The world is still looking for a hero to do
> the job:)

I wish I had time to be a hero ;-)

To use the MT9T112 with the OMAP3 ISP, you will need to implement pad-level 
subdev operations. As the sensor driver is used by bridge drivers not aware of 
the pad-level operations, you will need to keep the video operations as well. 
This shouldn't be too difficult, most of the code can probably be shared 
between the two sets of operations.

What might be a bit more complex is bus parameters configuration. As Guennadi 
mentioned, the soc_camera bus parameters autoconfiguration should be replaced 
by a V4L2 manual configuration coming from board code. That's basically a 
structure, embedded in the sensor's platform data, that describes the signal 
polarities, timings, bus width, ... A proposal needs to be made, but I don't 
think that's a huge job.

-- 
Regards,

Laurent Pinchart
