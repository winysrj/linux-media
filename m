Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36528 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab1FPTot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 15:44:49 -0400
Received: by eyx24 with SMTP id 24so680845eyx.19
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 12:44:48 -0700 (PDT)
Message-ID: <4DFA5D2B.5090701@gmail.com>
Date: Thu, 16 Jun 2011 21:44:43 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Kassey Lee <kassey1216@gmail.com>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	qingx@marvell.com, ytang5@marvell.com
Subject: Re: [PATCH 8/8] marvell-cam: Basic working MMP camera driver
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>	<1307814409-46282-9-git-send-email-corbet@lwn.net>	<BANLkTi=rZzEQp0iNBdrTBCeWM=h+nq49sw@mail.gmail.com> <20110616091720.22962c5c@bike.lwn.net>
In-Reply-To: <20110616091720.22962c5c@bike.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On 06/16/2011 05:17 PM, Jonathan Corbet wrote:
> On Thu, 16 Jun 2011 10:37:37 +0800
> Kassey Lee<kassey1216@gmail.com>  wrote:
> 
>>> +static void mmpcam_power_down(struct mcam_camera *mcam)
>>> +{
>>> +       struct mmp_camera *cam = mcam_to_cam(mcam);
>>> +       struct mmp_camera_platform_data *pdata;
>>> +/*
>>> + * Turn off clocks and set reset lines
>>> + */
>>> +       iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
>>> +       iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
>>> +/*
>>> + * Shut down the sensor.
>>> + */
>>> +       pdata = cam->pdev->dev.platform_data;
>>> +       gpio_set_value(pdata->sensor_power_gpio, 0);
>>> +       gpio_set_value(pdata->sensor_reset_gpio, 0);
> 
>> it is better to have a callback function to controller sensor power on/off.
>> and place the callback function in board.c

It might be more convenient for the driver writer but I do not think
it is generally better. Platform callbacks cannot really be migrated 
to FDT. For reasons pointed out by Jon below I have also been trying
to avoid callbacks in sensors' platform data.

> 
> This is an interesting question, actually.  The problem is that board
> files are on their way out; it's going to be very hard to get any more
> board files into the mainline going forward.
> 
> The mmp-camera driver does depend on a board file, but I've been careful
> to restrict things to basic platform data which can just as easily be put
> into a device tree.  Power management callbacks don't really qualify.
> 
> So it seems that we need to figure out a way to push this kind of
> pin/power management down into the sensor-specific code.  Looking at the
> subdev stuff, it looks like a bit of thought has been put into that
> direction; there's the s_io_pin_config() callback to describe pins to the

But having sensor's GPIOs configured by bridge driver does not help us
much here, does it? The bridge driver would still need to retrieve the
sensor configuration from somewhere, since it is machine/board specific.
And it's the subdev driver that will know how the GPIOs should be handled,
the timing constraints, etc. So as long as we can pass gpio numbers from
a device tree to subdevs we probably do not need an additional subdev operation. 
I guess when there come more subdev drivers dealing with GPIOs we could try
and see what could be generalized.

> sensor.  But it's almost entirely unused.
> 
> There is no "power up/down" callback, currently.  We could ponder on

We have the subdev s_power core operation in struct v4l2_subdev_core_ops.
However it seems that its semantic is not yet clearly documented.

> whether one should be added, or whether this should be handled through the
> existing power management code somehow.  I honestly don't know what the
> best answer is on this one - will have to do some digging.  Suggestions
> welcome.

--
Regards,
Sylwester

