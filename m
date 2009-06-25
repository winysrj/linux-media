Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60556 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZFYLNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 07:13:53 -0400
Subject: Re: v4l2_subdev GPIO and Pin Control ops (Re: PxDVR3200 H LinuxTV
 v4l-dvb patch : Pull GPIO-20 low for DVB-T)
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <200906250839.40916.hverkuil@xs4all.nl>
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
	 <1245897611.24270.19.camel@palomino.walls.org>
	 <200906250839.40916.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 07:15:43 -0400
Message-Id: <1245928543.4172.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-25 at 08:39 +0200, Hans Verkuil wrote:
> On Thursday 25 June 2009 04:40:11 Andy Walls wrote:
> > On Tue, 2009-06-23 at 14:33 +0200, Hans Verkuil wrote:
> > > > On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
> > > >
> > 
> > > There is already an s_gpio in the core ops. It would be simple to add a
> > > g_gpio as well if needed.
> > 
> > Hans,
> > 
> > As you probably know
> > 
> > 	int (*s_gpio)(v4l2_subdev *sd, u32 val);
> > 
> > is a little too simple for initial setup of GPIO pins.  With the
> > collection of chips & cores supported by cx25840 module, setting the
> > GPIO configuration also requires:
> > 
> > 	direction: In or Out
> > 	multiplexed pins: GPIO or some other function
> > 
> > I could tack on direction as an argument to s_gpio(), but I think that
> > is a bit inconvenient..  I'd rather have a 
> > 
> > 	int (*s_gpio_config)(v4l2_subdev *sd, u32 dir, u32 initval);
> > 
> > but that leaves out the method for multiplexed pin/pad configuration.
> > Perhaps explicity setting a GPIO direction to OUT could be an implicit
> > indication that a multiplexed pin should be set to it's GPIO function.
> > However, that doesn't help for GPIO inputs that might have their pins
> > multiplexed with other functions.
> > 
> > Here's an idea on how to specify multiplexed pin configuration
> > information and it could involve pins that multiplex functions other
> > than GPIO (the CX25843 is quite flexible in this regard):
> > 
> > 	int (*s_pin_function)(v4l2_subdev *sd, u32 pin_id, u32 function);
> > 
> > The type checking ends up pretty weak, but I figured it was better than
> > a 'void *config' that had a subdev specific collection of pin
> > configuration information.
> > 
> > Comments?
> 
> Hi Andy,
> 
> Is there any driver that needs to setup the multiplex functions? If not, then
> I would not add support for this at the moment.

Well, the group of GPIO pins in question for the CX23885 are all
multiplexed with other functions.  We could just initialize the CX23885
to have those pins set as GPIOs, but I have to check the cx23885 driver
to make sure that's safe.


> Adding unused code is a bad
> idea in general.

Yes.

> In addition, such information should only be needed at initialization time,
> and since we now have the new v4l2_i2c_new_subdev_cfg function I think that
> that is the right way to do this. The same approach can be used for setting
> the gpio pin directions. That too is something you setup at config time.


Yup. OK, thanks.

Regards,
Andy

> Regards,
> 
> 	Hans
> 

