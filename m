Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34140 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0BVQPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:15:20 -0500
Date: Mon, 22 Feb 2010 17:15:07 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Richard =?iso-8859-15?Q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-ID: <20100222161507.GN21778@enneenne.com>
References: <20100219174451.GH21778@enneenne.com>
 <Pine.LNX.4.64.1002192018170.5860@axis700.grange>
 <20100222160139.GL21778@enneenne.com>
 <201002221711.18874.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002221711.18874.hverkuil@xs4all.nl>
Subject: Re: adv7180 as SoC camera device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2010 at 05:11:18PM +0100, Hans Verkuil wrote:
> 
> The long-term goal is to remove the last soc-camera API dependencies from
> the sensor subdev drivers. Subdevice (usually i2c) drivers should be fully
> reusable and a dependency on soc-camera defeats that goal.
> 
> I think the only missing piece is low-level bus setup (i.e. sync polarities,
> rising/falling edge sampling, etc.). Some proposals were made, but basically
> nobody has had the time to actually implement this.
> 
> Right now, if you want to use your sensor with soc-camera, then you need to
> support the soc-camera API (or what is left of it) in your subdev driver as
> well.

But with the goal to remove the last soc-camera API dependencies I
suppose is better I try to change the pxa_camera driver in something
compatible with the API of the adv7180 driver...

I'm sorry but I'm a bit confused. :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
