Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:53421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1FMGfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 02:35:46 -0400
Date: Mon, 13 Jun 2011 08:35:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	laurent.pinchart@ideasonboard.com, leiwen@marvell.com,
	qingx@marvell.com
Subject: Re: soc_camera_set_fmt in soc_camera_open
In-Reply-To: <BANLkTikVKmSu6DjGNafqFynjj9-jYR=HsA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106130813480.10101@axis700.grange>
References: <BANLkTikg_MqmbL_7d2SY7zVALbm447b4Mw@mail.gmail.com>
 <BANLkTinQ0bDt-9f53fkfiUo1u26ahPsO-w@mail.gmail.com>
 <Pine.LNX.4.64.1106101114120.12671@axis700.grange>
 <BANLkTikVKmSu6DjGNafqFynjj9-jYR=HsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 13 Jun 2011, Kassey Lee wrote:

> On Fri, Jun 10, 2011 at 5:16 PM, Guennadi Liakhovetski <
> g.liakhovetski@gmx.de> wrote:
> 
> > On Fri, 10 Jun 2011, Kassey Lee wrote:
> >
> > > hi, Guennadi:
> > >
> > >           in drivers/media/video/soc_camera.c
> > > static int soc_camera_open(struct file *file)
> > >
> > > it will call soc_camera_set_fmt to configure the sensor and host
> > controller.
> > > for sensor, this means it will trigger download setting, this may take
> > quite
> > > time through i2c or SPI.
> > > I complain about this, because after we open,  request, s_param, S_FMT,
> > > DQBUF,
> > > in S_FMT, we will download the setting again.
> > >
> > > how do you think ?
> >
> > If it's a concern for you, you might consider moving most of your sensor
> > set up from .s_(mbus_)fmt() to .s_stream(). Would that solve your problem?
> >
> 
> .s_stream can not pass the fmt info, because we need download different
> setting  depends on the format(UYVY, resolution, JPEG)

Of course it cannot. You would have to store it in your .s_(mbus_)fmt() 
method and use during .s_stream().

> what I can figure out in open is power up sensor, why we need to .s_fmt() in
> open ?

The ideas behind this decision were to (1) make it simple for the drivers 
to comply with the specification's requirements to preserve the 
configuration across close() / open() calls, to be able to start streaming 
data directly after open() without any S_FMT ioctl()s, and to allow the 
hardware to be powered down when unused, and to (2) initialise internal 
format translation tables and other data. We could try to slightly 
optimise this by only calling soc_camera_set_fmt() during STREAMON _if_ no 
S_FMT has been called explicitly. But that would be a larger change, than 
just adjusting your driver. You could do another optimisation yourself 
too: if the new configuration is equal to the currently configured one, 
you don't issue any i2c commands.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
