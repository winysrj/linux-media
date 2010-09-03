Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:24182 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab0ICPfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Sep 2010 11:35:42 -0400
Subject: Re: [PATCH] gspca_cpia1: Add lamp control for Intel Play QX3
 microscope
From: Andy Walls <awalls@md.metrocast.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdgoede@redhat.com>
In-Reply-To: <20100903103838.23d759c9@tele>
References: <1283476182.17527.4.camel@morgan.silverblock.net>
	 <20100903103838.23d759c9@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 11:35:26 -0400
Message-ID: <1283528126.12583.80.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 2010-09-03 at 10:38 +0200, Jean-Francois Moine wrote:
> On Thu, 02 Sep 2010 21:09:42 -0400
> Andy Walls <awalls@md.metrocast.net> wrote:
> 	[snip]
> > Add a v4l2 control to get the lamp control code working for the Intel
> > Play QX3 microscope.  My daughter in middle school thought it was
> > cool, and is now examining the grossest specimens she can find.
> 	[snip]
> > -		u8 toplight;            /* top light lit , R/W */
> > -		u8 bottomlight;         /* bottom light lit, R/W */
> > +		u8 toplamp;             /* top lamp lit , R/W */
> > +		u8 bottomlamp;          /* bottom lamp lit, R/W */
> 	[snip]
> > +#define V4L2_CID_LAMPS (V4L2_CID_PRIVATE_BASE+1)
> 	[snip]
> 
> Hi Andy,
> 
> First, I do not see why you changed the name 'light' to 'lamp' while
> 'light' is used in the other cpia driver (cpia2).

Hi Jean-Francois,

My primary reason was slightly easier maintenance of gspca_cpia1.

A case-insensitive search for "lamp" will find only the code related to
controlling the lamps.  The string "light" is used in at least one other
context in the driver.

Other reasons for using "lamp":

The QX3 actually uses incandescent bulbs with slow turn on circuitry to
meet USB surge limit requirements.  The light sources really are lamps
in that sense, not just lights.

"Illuminator" seems to be the proper microscopy term for the assembly
that provides light from below/behind the specimen, but it is harder to
type than "lamp". ;)   I'm not sure what term applies to light sources
above/afore the specimen.




> Then, you used a private control ID, and linux-media people don't like
> that.

I knew that going in, however:

The gspca_cpia module already uses a private control.

The cpia2 driver uses 7 private controls, one of which is
CPIA2_CID_LIGHTS for controlling the lamps, er, lights. ;)

The cpia2 driver used the same menu labels I did -
"Off", "Top", "Bottom", "Both" - just in a slightly different order.

So the QX5 microscope can use a private control, but the QX3 microscope
can't use a private control?

It seems like there's a strong precedent here, since such an API is
already presented to user-space for controlling a device, the QX5, that
is functionally and physically nearly identical to the QX3.


I don't quite understand the aversion to well written private controls.
A private control under V4L2 appears to mean "not used by another bridge
driver", but what end user cares about that? 

The V4L2 Control API is so well specified, that user space needs no
apriori knowledge of a driver's controls, and yet applications can still
present a GUI for every control useful for a user to manipulate. I put
forward 'v4l2-ctl -L' and 'qv4l2' as examples of how users need not ever
care if a control is private or not.

V4L2 applications that would be capturing video or stills from
microscopes already know how to manipulate V4L2 controls, so why not let
them control the illumination with the same interface.  Why make them
rummage around with some other API?
 
Using V4L2 controls to control the image processing, but prohibiting
applications from using them to control the subject matter environment,
doesn't make a lot of sense from an application writing perspective.

We're tying our hands behind our back for the sake of "API idealism".
So we have a flexible, well specified V4L2 control API and then don't
let people use it, because we haven't figured out how to make lighting
controls common across 200 video capture implementations and a crappy
LED interface exists somewhere else in the kernel?  Does that make sense
to anyone?  What are the benefits?




> As many gspca users are waiting for a light/LED/illuminator/lamp
> control, I tried to define a standard one in March 2009:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/3095
> 
> A second, but more restrictive, attempt was done by Németh Márton in
> February 2010:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16705
> 
> The main objection to that proposals was that the sysfs LED interface
> should be used instead:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/3114
> 
> A patch in this way was done by Németh Márton in February 2010:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16670
> 
> but it was rather complex, and there was no consensus
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17111

I see I'm preaching to the choir then.

I do not have time, nor desire to play the "bring m a rock" game for the
API for controlling lights - especially when multiple people have been
playing it already.

It's a shame.  The Intel Play QX3 is a nice microscope and is readily
found on eBay.  My daughter absolutely loves it.  However, the unit is
close to useless without control of the lights.

If users are losing out because of inability to agree on an
implementation, then something is wrong with the process.


</rant>

Regards,
Andy

> So, I don't think that your patch could be accepted...
> 
> Best regards.
> 


