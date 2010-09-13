Return-path: <mchehab@localhost.localdomain>
Received: from perceval.irobotique.be ([92.243.18.41]:43792 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0IMGnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 02:43:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH] LED control
Date: Mon, 13 Sep 2010 08:43:52 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100904131048.6ca207d1@tele> <4C83A12F.1070009@redhat.com> <1283712207.2057.77.camel@morgan.silverblock.net>
In-Reply-To: <1283712207.2057.77.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130843.53344.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi Andy,

On Sunday 05 September 2010 20:43:27 Andy Walls wrote:
> On Sun, 2010-09-05 at 15:54 +0200, Hans de Goede wrote:
> > On 09/05/2010 10:56 AM, Jean-Francois Moine wrote:
> > > On Sun, 05 Sep 2010 09:56:54 +0200 Hans de Goede wrote:
> > >> I think that using one control for both status leds (which is what we
> > >> are usually talking about) and illuminator(s) is a bad idea. I'm fine
> > >> with standardizing these, but can we please have 2 CID's one for
> > >> status lights and one for the led. Esp, as I can easily see us
> > >> supporting a microscope in the future where the microscope itself or
> > >> other devices with the same bridge will have a status led, so then we
> > >> will need 2 separate controls anyways.
> > > 
> > > Hi Hans,
> > > 
> > > I was not thinking about the status light (I do not see any other usage
> > > for it), but well about illuminators which I saw only in microscopes.
> > 
> > Ah, ok thanks for clarifying. For some more on this see p.s. below.
> > 
> > > So, which is the better name? V4L2_CID_LAMPS? V4L2_CID_ILLUMINATORS?
> > 
> > I think that V4L2_CID_ILLUMINATORS together with a comment in the .h
> > and explanation in the spec that this specifically applies to microscopes
> > would be good.
> 
> I concur with ILLUMINATORS.  The word makes it very clear the control is
> about actively putting light on a subject.  A quick Goggle search shows
> that the term 'illuminator" appears to apply to photography and IR
> cameras as well.
> 
> > Regards,
> > 
> > Hans
> > 
> > p.s.
> > 
> > I think it would be good to have a V4L2_CID_STATUS_LED too. In many
> > drivers we are explicitly controlling the led by register writes. Some
> > people may very well prefer the led to always be off. I know that uvc
> > logitech cameras have controls for the status led through the extended
> > uvc controls. Once we have a standardized LED control, we can move the
> > logitech uvc cams over from using their own private one to this one.
> 
> I saw two use cases mentioned for status LEDs:
> 
> 1. always off
> 2. driver automatically controls the LEDs.
> 
> Can't that choice be handled with a module option, is there a case where
> one needs more control?

On Logitech UVC cameras, the status led can be set to

- always on
- always off
- controlled by the camera
- blinking (with a configurable frequency)

-- 
Regards,

Laurent Pinchart
