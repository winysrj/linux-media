Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1549 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0IIG4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 02:56:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Thu, 9 Sep 2010 08:55:52 +0200
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele> <201009071730.33642.hverkuil@xs4all.nl> <4C86AB22.7020206@redhat.com>
In-Reply-To: <4C86AB22.7020206@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009090855.53072.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tuesday, September 07, 2010 23:14:10 Hans de Goede wrote:
> Hi,
> 
> On 09/07/2010 05:30 PM, Hans Verkuil wrote:
> > On Tuesday, September 07, 2010 15:04:55 Hans de Goede wrote:
> >> Hi,
> >>
> >> On 09/07/2010 04:50 PM, Hans Verkuil wrote:
> 
> <snip>
> 
> >>>> Both off
> >>>> Top on, Bottom off
> >>>> Top off, Bottom on
> >>>> Both on
> >>>>
> >>>> Which raises the question do we leave this as is, or do we make this 2 boolean
> >>>> controls. I personally would like to vote for keeping it as is, as both lamps
> >>>> illuminate the same substrate in this case, and esp. switching between
> >>>> Top on, Bottom off to Top off, Bottom on in one go is a good feature to have
> >>>> UI wise (iow switch from top to bottom lighting or visa versa.
> >>>
> >>> The problem with having one control is that while this makes sense for this
> >>> particular microscope, it doesn't make sense in general.
> >>>
> >>
> >> Actual it does atleast for microscopes in general a substrate under a microscope
> >> usually is either illuminated from above or below.
> >>
> >>> Standard controls such as proposed by this patch should have a fixed type
> >>
> >> Although I agree with that sentiment in general I don't see this as an absolute
> >> need, apps should get the type by doing a query ctrl not by assuming they
> >> know it based on the cid.
> >>
> >> And esp. for menu controls this is not true, for example
> >> most devices have a light freq filter menu of:
> >> off
> >> 50 hz
> >> 60 hz
> >>
> >> Which matches what is documented in videodev2.h
> >>
> >> Where as some have:
> >> off
> >> 50 hz
> >> 60 hz
> >> auto hz
> >>
> >> Because they can (and default to) detect the light frequency automatically.
> >
> > The v4l2 api allows drivers to selectively enable items from a menu. So this
> > control has a fixed menu type and a fixed menu contents. Some of the menu
> > choices are just not available for some drivers.
> 
> This is not possible:
> 
> Quoting from:
> http://www.linuxtv.org/downloads/v4l-dvb-apis/re61.html
> "Menu items are enumerated by calling VIDIOC_QUERYMENU with successive index values from struct v4l2_queryctrl minimum (0) to maximum, inclusive."

Actually it is possible, although not well described in the spec (I thought
it was much better described, but looking at it it clearly needs improvement)
and in fact it is in use for years: 

You enumerate menu items from 'minimum' to 'maximum', but if a particular index
is not supported the driver can return -EINVAL.

It's used heavily for the MPEG controls where menus are often a list of options
as defined by the MPEG standard and drivers support only a subset of those.

The control framework also has support for this: drivers just provide a mask to
the framework of the menu items that have to be skipped.

> And many apps are coded this way, so we cannot simply skip values in a
> menu enum just because a driver does not support them, this would
> break apps as they (rightfully) don't expect an error when
> calling VIDIOC_QUERYMENU with an index between minimum and
> maximum, so given for example:

It is true that many apps are coded that way (unless they support the MPEG
controls). With the control framework in place it would be quite easy to map
the menu indices into a contiguous range. But then you loose the ability to
hardcode specific menu items.

> 
> enum v4l2_led {
>           V4L2_LED_AUTO = 0,
> 	 V4L2_LED_BLINK = 1,
>           V4L2_LED_OFF = 2,
>           V4L2_LED_ON = 3,
> };
> 
> Drivers which do not support blink would still need to report a minimum
> and maximum of 0 and 3, making any control apps expect 4 menu items not
> 3 !
> 
> And this example is exactly why I'm arguing against defining standard
> meanings for standard controls with a menu type.
> 
> Also note that at least with the uvc driver that due to how extension
> unit controls are working (the uvcvideo driver gets told about these
> vendor specific controls from a userspace helper), the menu index is
> the value which gets written to the hardware! So one cannot simply
> make this match some random enum.

I actually consider that a bug. The userspace helper *does* know about the
menu mapping and should do the right thing here.

It's not a big deal in practice, but it would actually be nice if this could
be changed at some time in the future.
 
> >
> > There are several advantages of sticking to one standard menu for standard
> > controls:
> >
> > 1) The contents of the menu can be defined centrally in v4l2-ctrls.c, which
> >     ensures consistency. Not only of the menu texts, but also of how the
> >     control behaves in various drivers.
> 
> No they cannot as v4l2-ctrls.c will not know when to return -EINVAL to
> indicate that in the example case the driver does not support blink, and
> moreover an app will not expect this and maybe decide to not show the
> menu at all, or ...
> 
> > 2) It makes it possible to set the control directly from within a program.
> >     This is currently true for *all* standard controls
> 
> No this is not true, programs still need to know minimum and maximum values
> for all integer standard controls, brightness may be 0-15 on one device
> and 0-65535 on another, so they cannot simply bang in any value they need to
> take into account the query ctrl results.

I strongly disagree. If an app wants to program the brightness to 50%, then that
is easy to do: get the min and max values and set the brightness to (max - min) / 2.

Now try the same with a menu. Without known menu indices there is no way you can
ever do this.

The extended controls in particular work like this and with the increasing
importance of embedded v4l drivers it is really important we can support this
use case.

After all, the application running on an embedded system will be responsible
for controlling many of the controls that in e.g. timetv are set by the user.
Other than simple controls like brightness, contrast, etc. Those will often
still be exposed to the end-user.
 
> > This looks pretty decent IMHO:
> >
> > enum v4l2_illuminator {
> >          V4L2_ILLUMINATOR_OFF = 0,
> >          V4L2_ILLUMINATOR_ON = 1,
> > };
> > #define V4L2_CID_ILLUMINATOR_0              (V4L2_CID_BASE+37)
> > #define V4L2_CID_ILLUMINATOR_1              (V4L2_CID_BASE+38)
> >
> 
> I don't like this, as explained before most microscopes have a top
> and a bottom light, and you want to switch between them, or to
> all off, or to all on. So having a menu with 4 options for this
> makes a lot more sense then having 2 separate controls. Defining
> these values as standard values would take away the option for drivers
> to do something other then a simple on / off control here. Again
> what is wrong with with not defining standard meanings for standard
> controls with a menu type. This means less stuff in videodev2.h
> and more flexibility wrt using these control ids.

I've reconsidered as well. These controls should become booleans (as per the
original proposal). If we need more complex behavior, then we should add
new controls for that. E.g., suppose the brightness can be controlled: then
we should add an ILLUMINATOR_BRIGHTNESS_0 control. Or if we use this to control
the flash of a camera: in that case we need probably a ILLUMINATOR_FLASH_DURATION
control and a ILLUMINATOR_FLASH button control.

But for basic on/off functionality it is much better to have a standard boolean.
And as an added bonus that also makes sense from a GUI perspective.

> 
> 
> I think we should not even define a type for this one. If we
> get microscopes with pwm control for the lights we will want this
> to be an integer using one control per light.
> 
> We have this excellent infrastructure to automatically discover
> control types, ranges and menu item meaning. Why would it be
> forbidden to use this for standard controls.

Well, the problem is that we actually do not have infrastructure to discover
menu item meaning. We can show the user the menu items, but we (i.e. the app)
has no idea about the menu item meaning, unless we have enums as well that
correspond 1-to-1 to the menu item.

And that's the way it currently works. So breaking the 1-to-1 mapping (let alone
allowing any type) will also break any possibility of setting it from an
application. This wasn't much of a consideration several years ago (and definitely
not when the API was designed), but it is now with all the embedded systems.

Having to care for embedded systems makes life more interesting :-), but I
think it is a good thing. Because anything added to the API now has to make
sense for both SoCs and 'regular' webcams/capture boards. That forces us to
think about it just that extra bit and in the end makes the API better than
it would otherwise be.

> Either we need to drop our aversion for private controls, or
> allow somewhat more flexible standard controls!

I don't have an aversion against private controls. In fact, they will become
much more prominent in embedded systems and sub-devices. But too often private
controls are added for no good reason. Either because they shouldn't be exposed
in the first place, or because they should be a standard control, or because
it is the wrong tool for the job. Past experience made it a bit of a red flag
for me, requiring more scrutiny than usual.

> 
> > enum v4l2_led {
> >          V4L2_LED_AUTO = 0,
> >          V4L2_LED_OFF = 1,
> >          V4L2_LED_ON = 2,
> > };
> > #define V4L2_CID_LED_0              (V4L2_CID_BASE+39)
> >
> > Simple and straightforward.
> 
> Until a cam comes along which only supports auto and on, and
> we have a whole in our menu range with the standard does not
> allow!
> 
> >>> consistent behavior. Note that I am also wondering whether it wouldn't be a
> >>> good idea to use a menu for this, just as for the LEDs.
> >>
> >> I do agree that the illuminator ctrls should be a menu, that way the driver
> >> author can also choose wether to group 2 together in a single control or not
> >> we simply should not specify the menu values in the spec (the same can
> >> be said for the led case).
> >
> > See above. Just because you can do it, doesn't mean you should. In this case
> > I think it is a bad idea. Standard controls should have standard behavior.
> 
> How about a compromise, we add a set of standard defines for menu
> index meanings, with a note that these are present as a way to standardize
> things between drivers, but that some drivers may deviate and that
> apps should always use VIDIOC_QUERYMENU ?

Let's use boolean for these illuminator controls instead. Problem solved :-)

LED controls are a separate issue, see the discussion elsewhere.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
