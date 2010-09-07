Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2517 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab0IGOuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 10:50:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Tue, 7 Sep 2010 16:50:20 +0200
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele> <201009071147.22643.hverkuil@xs4all.nl> <4C862917.5050903@redhat.com>
In-Reply-To: <4C862917.5050903@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009071650.21029.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tuesday, September 07, 2010 13:59:19 Hans de Goede wrote:
> Hi all,
> 
> On 09/07/2010 11:47 AM, Hans Verkuil wrote:
> > On Tuesday, September 07, 2010 11:44:18 Hans de Goede wrote:
> >> Replying to myself.
> >>
> >> On 09/07/2010 11:42 AM, Hans de Goede wrote:
> >>> Hi,
> >>>
> >>> On 09/07/2010 09:30 AM, Hans Verkuil wrote:
> >>>> On Monday, September 06, 2010 20:11:05 Jean-Francois Moine wrote:
> >>>>> Hi,
> >>>>>
> >>>>> This new proposal cancels the previous 'LED control' patch.
> >>>>>
> >>>>> Cheers.
> >>>>>
> >>>>>
> >>>>
> >>>> Hi Jean-Francois,
> >>>>
> >>>> You must also add support for these new controls in v4l2-ctrls.c in
> >>>> v4l2_ctrl_get_menu(), v4l2_ctrl_get_name() and v4l2_ctrl_fill().
> >>>>
> >>>> How is CID_ILLUMINATORS supposed to work in the case of multiple lights?
> >>>> Wouldn't a bitmask type be more suitable to this than a menu type? There
> >>>> isn't a bitmask type at the moment, but this seems to be a pretty good
> >>>> candidate for a type like that.
> >>>>
> >>>> Actually, for the status led I would also use a bitmask since there may be
> >>>> multiple leds. I guess you would need two bitmasks: one to select auto vs
> >>>> manual, and one for the manual settings.
> >>>>
> >>>
> >>> So far I've not seen cameras with multiple status leds, I do have seen camera
> >>> which have the following settings for their 1 led (logitech uvc cams):
> >>> auto
> >>> on
> >>> off
> >>> blinking
> >>>
> >>> So I think a menu type is better suited, and that is what the current (private)
> >>> uvc control uses.
> >>
> >> The same argument more or less goes for the CID_ILLIMUNATORS controls. Also given
> >> that we currently don't have a bitmask type I think introducing one without a really
> >> really good reason is a bad idea as any exiting apps won't know how to deal with it.
> >
> > But I can guarantee that we will get video devices with multiple leds in the
> > future. So we need to think *now* about how to do this. One simple option is of course
> > to name the controls CID_ILLUMINATOR0 and CID_LED0. That way we can easily add LED1,
> > LED2, etc. later without running into weird inconsistent control names.
> >
> 
> Naming them LED0 and ILLUMINATOR0 works for me. Note about the illuminator one,
> if you look at the patch it made the illuminator control a menu with the following
> options:

Where in the patch? Am I missing something?

> 
> Both off
> Top on, Bottom off
> Top off, Bottom on
> Both on
> 
> Which raises the question do we leave this as is, or do we make this 2 boolean
> controls. I personally would like to vote for keeping it as is, as both lamps
> illuminate the same substrate in this case, and esp. switching between
> Top on, Bottom off to Top off, Bottom on in one go is a good feature to have
> UI wise (iow switch from top to bottom lighting or visa versa.

The problem with having one control is that while this makes sense for this
particular microscope, it doesn't make sense in general.

Standard controls such as proposed by this patch should have a fixed type and
consistent behavior. Note that I am also wondering whether it wouldn't be a
good idea to use a menu for this, just as for the LEDs. In fact, perhaps they
should use the same menu. While their purpose is different, they are quite similar
in behavior.

BTW, lovely word: 'illuminator'.

Regards,

	Hans

> 
> Regards,
> 
> Hans
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
