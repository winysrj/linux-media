Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752509Ab0BVQqS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:46:18 -0500
Date: Mon, 22 Feb 2010 17:46:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Richard =?iso-8859-15?Q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: adv7180 as SoC camera device
In-Reply-To: <20100222161507.GN21778@enneenne.com>
Message-ID: <Pine.LNX.4.64.1002221743090.4120@axis700.grange>
References: <20100219174451.GH21778@enneenne.com> <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
 <20100222160139.GL21778@enneenne.com> <201002221711.18874.hverkuil@xs4all.nl>
 <20100222161507.GN21778@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Feb 2010, Rodolfo Giometti wrote:

> On Mon, Feb 22, 2010 at 05:11:18PM +0100, Hans Verkuil wrote:
> > 
> > The long-term goal is to remove the last soc-camera API dependencies from
> > the sensor subdev drivers. Subdevice (usually i2c) drivers should be fully
> > reusable and a dependency on soc-camera defeats that goal.
> > 
> > I think the only missing piece is low-level bus setup (i.e. sync polarities,
> > rising/falling edge sampling, etc.). Some proposals were made, but basically
> > nobody has had the time to actually implement this.
> > 
> > Right now, if you want to use your sensor with soc-camera, then you need to
> > support the soc-camera API (or what is left of it) in your subdev driver as
> > well.
> 
> But with the goal to remove the last soc-camera API dependencies I
> suppose is better I try to change the pxa_camera driver in something
> compatible with the API of the adv7180 driver...

No. As Hans said, one of important things, that is present in soc-camera, 
but absent from v4l2-subdev is bus-parameter configuration. So, to remove 
those dependencies one would have to develop a generic bus-configuration 
API for V4L2, and then convert soc-camera core and all soc-camera drivers 
to it. Feel free to submit patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
