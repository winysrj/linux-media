Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:24208 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab0IESog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 14:44:36 -0400
Subject: Re: [PATCH] LED control
From: Andy Walls <awalls@md.metrocast.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
In-Reply-To: <4C83A12F.1070009@redhat.com>
References: <20100904131048.6ca207d1@tele>	<4C834D46.5030801@redhat.com>
	 <20100905105627.0d5d3dab@tele>  <4C83A12F.1070009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 14:43:27 -0400
Message-ID: <1283712207.2057.77.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, 2010-09-05 at 15:54 +0200, Hans de Goede wrote:
> Hi,
> 
> On 09/05/2010 10:56 AM, Jean-Francois Moine wrote:
> > On Sun, 05 Sep 2010 09:56:54 +0200
> > Hans de Goede<hdegoede@redhat.com>  wrote:
> >
> >> I think that using one control for both status leds (which is what we
> >> are usually talking about) and illuminator(s) is a bad idea. I'm fine
> >> with standardizing these, but can we please have 2 CID's one for
> >> status lights and one for the led. Esp, as I can easily see us
> >> supporting a microscope in the future where the microscope itself or
> >> other devices with the same bridge will have a status led, so then we
> >> will need 2 separate controls anyways.
> >
> > Hi Hans,
> >
> > I was not thinking about the status light (I do not see any other usage
> > for it), but well about illuminators which I saw only in microscopes.
> >
> 
> Ah, ok thanks for clarifying. For some more on this see p.s. below.
> 
> > So, which is the better name? V4L2_CID_LAMPS? V4L2_CID_ILLUMINATORS?
> 
> I think that V4L2_CID_ILLUMINATORS together with a comment in the .h
> and explanation in the spec that this specifically applies to microscopes
> would be good.

I concur with ILLUMINATORS.  The word makes it very clear the control is
about actively putting light on a subject.  A quick Goggle search shows
that the term 'illuminator" appears to apply to photography and IR
cameras as well.


> Regards,
> 
> Hans
> 
> p.s.
> 
> I think it would be good to have a V4L2_CID_STATUS_LED too. In many drivers
> we are explicitly controlling the led by register writes. Some people may very
> well prefer the led to always be off. I know that uvc logitech cameras have
> controls for the status led through the extended uvc controls. Once we have
> a standardized LED control, we can move the logitech uvc cams over from
> using their own private one to this one.

I saw two use cases mentioned for status LEDs:

1. always off
2. driver automatically controls the LEDs.

Can't that choice be handled with a module option, is there a case where
one needs more control?

Regards,
Andy

> Once this is in place I would like to build some framework in to gspca
> for supporting this control in gspca (the control would be handled by the core,
> and sub drivers would have an sd_set_led function).
> 
> While at it could you write a proposal / patch for adding this control to the
> spec as well ?


