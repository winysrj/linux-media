Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59510 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab0F3VMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 17:12:53 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 30 Jun 2010 16:12:48 -0500
Subject: RE: [Query] How to preserve soc_camera and still use a sensor for
 media controller?
Message-ID: <A24693684029E5489D1D202277BE8944563902E3@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89445638FD0E@dlee02.ent.ti.com>
 <Pine.LNX.4.64.1006302048310.17489@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1006302048310.17489@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: Wednesday, June 30, 2010 1:53 PM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: [Query] How to preserve soc_camera and still use a sensor for
> media controller?
> 
> Hi Sergio
> 
> On Wed, 30 Jun 2010, Aguirre, Sergio wrote:
> 
> > Hi all,
> >
> > Is it possible to keep a sensor chip driver compatible with 2
> interfaces?
> >
> > I'm particularly interested in mt9t112 sensor.
> >
> > Has this been done before with other driver?
> 
> You can try looking at this thread:
> http://thread.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/16311

Very interesting thread :)

> and remembering our discussions at the mini-summit;) You can also look at
> Hans' report of summit's results. A few people know, what has to be done,
> but noone has done it yet... The world is still looking for a hero to do
> the job:)

OK, thanks for the info :)

I'll think about that...

Regards,
Sergio
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
