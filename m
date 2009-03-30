Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4075 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZC3KDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 06:03:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>
Subject: Re: [patch 5/5] saa7121 driver for s6000 data port
Date: Mon, 30 Mar 2009 12:03:02 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org
References: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl> <49D09749.507@emlix.com>
In-Reply-To: <49D09749.507@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301203.02327.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 March 2009 11:56:25 Daniel Glöckner wrote:
> On 03/26/2009 04:08 PM, Hans Verkuil wrote:
> > I've been working on a new framework for devices like this and almost
> > all i2c v4l drivers are now converted to v4l2_subdev in our v4l-dvb
> > tree. It will also be merged in 2.6.30. Please take a look at
> > v4l2-framework.txt in the v4l-dvb repository for more information.
> >
> > I'm sure you will have questions later, please don't hesitate to ask!
> > It's a recent development but very much needed. Otherwise we will end
> > up with a lot of duplicate i2c drivers, each tied to their own platform
> > or framework. That's clearly something we do not want.
>
> Hi Hans,
>
> the problem I see with the v4l2-framework in this case is that in its
> current state it does not allow to exchange information regarding the bus
> parameters between the sub device and the controller.

What exactly do you need? If there is something missing, then it should be 
added. But my guess is that you can pass such information via the s_routing 
callback. That's what all other drivers that use v4l2_subdev do.

> It seems the soc-camera framework is a better choice here, but to make it
> work with the saa7121 one would first have to implement support for video
> output.

This framework will also be converted to use v4l2_subdev for the 
communication with i2c drivers.

> What do you recommend?

Actually, I recommend that you first look at the existing saa7127.c source. 
I don't know how many differences there are between the saa7121 and 
saa7127, but perhaps support for the saa7121 can be added there rather than 
introducing a new driver. Of course, that only works if the differences are 
not too big.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
