Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:48343 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab1FPPRW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 11:17:22 -0400
Date: Thu, 16 Jun 2011 09:17:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <kassey1216@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	qingx@marvell.com, ytang5@marvell.com
Subject: Re: [PATCH 8/8] marvell-cam: Basic working MMP camera driver
Message-ID: <20110616091720.22962c5c@bike.lwn.net>
In-Reply-To: <BANLkTi=rZzEQp0iNBdrTBCeWM=h+nq49sw@mail.gmail.com>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-9-git-send-email-corbet@lwn.net>
	<BANLkTi=rZzEQp0iNBdrTBCeWM=h+nq49sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 16 Jun 2011 10:37:37 +0800
Kassey Lee <kassey1216@gmail.com> wrote:

> > +static void mmpcam_power_down(struct mcam_camera *mcam)
> > +{
> > +       struct mmp_camera *cam = mcam_to_cam(mcam);
> > +       struct mmp_camera_platform_data *pdata;
> > +/*
> > + * Turn off clocks and set reset lines
> > + */
> > +       iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
> > +       iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
> > +/*
> > + * Shut down the sensor.
> > + */
> > +       pdata = cam->pdev->dev.platform_data;
> > +       gpio_set_value(pdata->sensor_power_gpio, 0);
> > +       gpio_set_value(pdata->sensor_reset_gpio, 0);  

> it is better to have a callback function to controller sensor power on/off.
> and place the callback function in board.c

This is an interesting question, actually.  The problem is that board
files are on their way out; it's going to be very hard to get any more
board files into the mainline going forward.

The mmp-camera driver does depend on a board file, but I've been careful
to restrict things to basic platform data which can just as easily be put
into a device tree.  Power management callbacks don't really qualify.

So it seems that we need to figure out a way to push this kind of
pin/power management down into the sensor-specific code.  Looking at the
subdev stuff, it looks like a bit of thought has been put into that
direction; there's the s_io_pin_config() callback to describe pins to the
sensor.  But it's almost entirely unused.

There is no "power up/down" callback, currently.  We could ponder on
whether one should be added, or whether this should be handled through the
existing power management code somehow.  I honestly don't know what the
best answer is on this one - will have to do some digging.  Suggestions
welcome.

Thanks,

jon
