Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:56316
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbZBPWg1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 17:36:27 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: Adding a control for Sensor Orientation
Date: Mon, 16 Feb 2009 22:36:23 +0000
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	kilgota@banach.math.auburn.edu,
	"Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"Olivier Lorin" <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <59373.62.70.2.252.1234773218.squirrel@webmail.xs4all.nl>
In-Reply-To: <59373.62.70.2.252.1234773218.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162236.23516.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of snipping below so I hope I get the attributions correct.

On Monday 16 February 2009, Hans Verkuil wrote:
>
> We are talking about a core change, so some careful thought should go into
> this.

Agreed, a few days or even weeks spent getting the right solution is far 
better than having to update lots of drivers and apps if we get it wrong.

>
> > So Adam, kilgota, please ignore the rest of this thread and move forward
> > with the driver, just add the necessary buffer flags to videodev2.h as
> > part of  your patch (It is usually to submit new API stuff with the same
> > patch which introduces the first users of this API.
>
> Don't ignore it yet :-)
>

I've tried twice to write some code when I thought the discussion had died 
down - I'll wait a while before attempting version 3.

> Hans de Goede <hdegoede@redhat.com> wrote:
> > I welcome libv4l patches to use these flags.

Olivier Lorin submitted a patch to use the flags to support the 180 degree 
rotation - it was pretty trivial but 

a) didn't allow v4lconvert_flags to over-ride it to support kernels that don't 
specify behaviour for those cameras
b) only coped with HFLIP and VFLIP both being set

Given an agreed solution I intend to fix both of those problems.


> Hans Verkuil wrote:
> > I think we have to distinguish between two separate types of data: fixed
> > ('the sensor is mounted upside-down', or 'the sensor always requires a
> > hflip/vflip') and dynamic ('the user pivoted the camera 270 degrees').
> >

Agreed they are different cases that potentially need different handling

> > The first is static data and I think we can just reuse the existing
> > HFLIP/VFLIP controls: just make them READONLY to tell libv4l that libv4l
> > needs to do the flipping.
> >
> > The second is dynamic data and should be passed through v4l2_buffer since
> > this can change on a per-frame basis. In this case add two bits to the
> > v4l2_buffer's flags field:

I'm not sure how Olivier Lorin's Genesys gl860 case should be handled in this 
scenario - It feels to me that this should be treated as the sensor being 
mounted upside down when it is turned away from the user as it is due to a 
hardware limitation that the picture is upside down in that case and the user 
would want libv4l to fix it - pivoting I see as being more a case of a user 
creative activity and automatically correcting it isn't necessarily good. The 
gl860 case is clearly dynamic data though.

On Monday 16 February 2009, Trent Piepho wrote:
> HFLIP and VFLIP are only good for 0 and 180 degrees.  90 and 270 isn't the
> same as flipping.

Agreed - but I think 90 and 270 will only apply to the user pivot case and 
HFLIP / VFLIP only to the sensor mounting. The fact that HFLIP + VFLIP == 
pivot 180 should probably be ignored. Some of the sq905 camera variants 
provide examples of the sensor data being VFLIPed but not HFLIPed.

On Monday 16 February 2009, Hans de Goede wrote:
>
> I agree that we have static and dynamic camera properties, and that we may
> want to have 2 API's for them. I disagree the control API is the proper API
> to expose static properties, many existing applications will not handle
> this well.

I certainly agree that re-using the existing controls doesn't seem like a good 
idea - it seems to combine the case of "the user made a creative decision to 
produce flipped video" with "this hardware always creates flipped video so 
please fix it" If the sensor mounting is going to go in a control then it 
ought to be a new one and I rather see just 1 control with 2 bits as I 
wouldn't want to see a camera be able to tell us only part of the info, that 
just complicates the code unnecessarily. Also having the info possibly 
available via 2 different routes is bound to cause problems.

Where does all of that leave us?

We need to decide if sensor mounting should be considered static info - if it 
should then putting it in a new control seems reasonable. The presence of 
that control then definitively indicates if the driver is providing this 
info. If we say that the gl860 case means this is dynamic info (which is the 
way I'm leaning at the moment) then using 2 bits of buffer flags seems the 
best option as dynamic info shouldn't be in controls.

Unless anyone has evidence to the contrary we don't yet know of any cameras 
that provide pivot info. If any do it is likely that they are in embedded 
devices which may well make the info available via the input mechanism rather 
than as part of the camera. If we do ever get pivot info it might even be 
from some fancy camera mount that provides pitch, yaw and roll so it would be 
premature to attempt to design for it now. Currently we know neither what 
data might be available or how it might be used and the supply of suitable 
crystal balls is limited.

