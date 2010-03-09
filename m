Return-path: <linux-media-owner@vger.kernel.org>
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:63061 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0CIQfq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 11:35:46 -0500
Subject: Re: [RFC, PATCH 1/3] gspca: add LEDs subsystem connection
From: Richard Purdie <rpurdie@rpsys.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <201003091227.54229.laurent.pinchart@ideasonboard.com>
References: <4B8A2158.6020701@freemail.hu> <20100301101806.7c7986be@tele>
	 <4B8DA25F.10602@freemail.hu>
	 <201003091227.54229.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 08:02:18 -0800
Message-ID: <1268150538.1734.24.camel@rex>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-03-09 at 12:27 +0100, Laurent Pinchart wrote:
> Hi Màrton,
> 
> Thanks for the patch.
> 
> On Wednesday 03 March 2010 00:42:23 Németh Márton wrote:
> > From: Márton Németh <nm127@freemail.hu>
> > 
> > On some webcams one or more LEDs can be found. One type of these LEDs
> > are feedback LEDs: they usually shows the state of streaming mode.
> > The LED can be programmed to constantly switched off state (e.g. for
> > power saving reasons, preview mode) or on state (e.g. the application
> > shows motion detection or "on-air").
> > 
> > The second type of LEDs are used to create enough light for the sensor
> > for example visible or in infra-red light.
> > 
> > Both type of these LEDs can be handled using the LEDs subsystem. This
> > patch add support to connect a gspca based driver to the LEDs subsystem.
> 
> They can indeed, but I'm not sure if the LEDs subsystem was designed for that 
> kind of use cases.

The LED subsystem was designed to support LED lights and the above
scenarios can certainly fit that. It provides a nice system where
default use cases should just work (power light on a laptop) but the
system has the control to override than and do other interesting things
with it if it so wishes.

> The LED framework was developed to handle LEDs found in embedded systems 
> (usually connected to GPIOs) that needed to be connected to software triggers 
> or controlled by drivers and/or specific userspace applications.

Its used by many laptops so its not just embedded systems.

>  Webcam LEDs 
> seem a bit out of scope to me, especially the "light" LED that might be better 
> handled by a V4L2 set of controls (we're currently missing controls for camera 
> flashes, be they LEDs or Xenon based).
> 
> I'll let Richard speak on this.

I'm not going to push one way or another and its up to individual
subsystems to way up the benefits and drawbacks and make their decision.
There is nothing in the design of the system which would stop it working
or being used in this case though. If the susystsme needs improvements
to work well, I'm happy to accept patches too.

Cheers,

Richard





