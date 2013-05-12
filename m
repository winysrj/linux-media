Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54996 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751421Ab3ELHee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 May 2013 03:34:34 -0400
Date: Sun, 12 May 2013 10:34:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [Q] Querying Y/Gb Average Level in a sensor.
Message-ID: <20130512073431.GB6748@valkosipuli.retiisi.org.uk>
References: <CACKLOr2t84A8OVXBd1AEcK2U7bg0ufKZ7gZQZemX8uznz3_bgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr2t84A8OVXBd1AEcK2U7bg0ufKZ7gZQZemX8uznz3_bgg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

My apologies for the late reply.

On Mon, Jan 21, 2013 at 12:20:23PM +0100, javier Martin wrote:
> Hi,
> ov7670 and ov7675 sensors have the possibility of querying the average
> value of the Y/Cb components of the image reading a register. This
> could be useful for applications such as calise [1]. This program
> grabs frames from a video camera, calculates the average brightness
> and then adjusts screen's backlight accordingly.
> 
> If the user could query the value of this register t in cameras that
> support it we could save a lot of processing effort.
> 
> The first idea that came into my mind was to define a new v4l2-ctrl
> for this but I'm not sure if it is a common feature in other sensors.
> Is it worth it to define a new v4l2-ctrl for this or should I use a
> private ctrl instead?

Is this register something you can just read back from the sensor, or is it
associated to a particular frame?

In general the information sounds like such that it should be part of the
frame metadata, but I don't think the driver should read the value back from
the sensor just to provide the metadata to the user space. I could imagine
that most of the time the user space wouldn't be even interested in that at
all, but only in very specific situations. (Related to the recent frame
metadata discussion, not to your proposal.)

So I'm also leaning towards having a control for the purpose. I haven't seen
a sensor which would implement the same (anyone else?) so I'd probably start
with a private control.

Cc Hans and Laurent.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
