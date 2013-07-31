Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:14044 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100Ab3GaHhu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 03:37:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: Question about v4l2-compliance: cap->readbuffers
Date: Wed, 31 Jul 2013 09:37:34 +0200
Cc: linux-media@vger.kernel.org
References: <CAPybu_1kw0CjtJxt-ivMheJSeSEi95ppBbDcG1yXOLLRaR4tRg@mail.gmail.com> <51F7E712.40103@xs4all.nl> <CAPybu_22T6fNAMKEqyjX3FHQ-hgKiHytc9y=3Dh75FvSWje49w@mail.gmail.com>
In-Reply-To: <CAPybu_22T6fNAMKEqyjX3FHQ-hgKiHytc9y=3Dh75FvSWje49w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307310937.34431.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 31 July 2013 09:09:05 Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> Thanks for the explanation. I have tried changing the controls to
> inactive and the are shown disabled on the gui, just as you say, but
> they are there :S. I personally liked better the previous behaviour,
> when the controls where not shown at all. But it is just that, a
> taste, if it is more correct showing them as inactive they will be
> inactive :).

The problem with removing them dynamically is that that means that a GUI
also has to refresh itself whenever that happens. That's an expensive
operation and that generally also means that the layout of the controls
changes, which is very confusing for the user.

Note that the DISABLED flag is meant for situations where a control was
simply invalid for the particular hardware version, i.e. the flag was
static and would never change. With the control framework it is much
easier to just not add the control in the first place.

> For a case where a option is only available at a specific format: I
> was also disablig the control (now inactiving it), and returning
> -EINVAL if the user tried to set the control on an incompatible
> format. Apparently the v4l2-compilance dont like that either, is this
> a false positive or I should behave differently?.

The general approach in a driver is that you can still set an inactive
control. The new value will simply be stored and only becomes active
when the control becomes active as well. In some cases that doesn't
make sense, and in that case the driver will just ignore the new value,
but it still returns 0.

There are good reasons for this behavior: it allows you to get the values
of all controls (active and inactive) and set them as well. This is useful
for a program that saves the state of controls and restores them on startup.

Regards,

	Hans

> 
> Thank you again!
> 
> 
> 
> 
> On Tue, Jul 30, 2013 at 6:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Ricardo,
> >
> > On 07/30/2013 05:46 PM, Ricardo Ribalda Delgado wrote:
> >> Hello
> >>
> >> I have a camera that works on two modes: Mono and colour. On color
> >> mode it has 3 gains, on mono mode it has 1 gain.
> >>
> >> When the user sets the output to mono I disable the color controls
> >> (and the other way around).
> >>
> >> Also on color mode the hflip and vflip do not work, therefore I dont show them.
> >>
> >> I could return -EINVAL, but I rather not show the controls to the user.
> >>
> >> What would be the proper way to do this?
> >
> > Use the INACTIVE flag, that's the way it is typically done. You can still set
> > such controls, but the new value won't be active until you switch back to a
> > mode where they do work.
> >
> > Using INACTIVE will show such controls as disabled in a GUI like qv4l2. I highly
> > recommend using qv4l2 for testing this since it is the reference implementation
> > of how GUIs should interpret control flags.
> >
> > Regards,
> >
> >         Hans
> >
> >>
> >>
> >> Thanks gain.
> >>
> >>
> >>
> >>
> >>
> >> On Tue, Jul 30, 2013 at 5:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> On Tue 30 July 2013 17:18:58 Ricardo Ribalda Delgado wrote:
> >>>> Thanks for the explanation Hans!
> >>>>
> >>>> I finaly manage to pass that one ;)
> >>>>
> >>>> Just one more question. Why the compliance test checks if the DISABLED
> >>>> flag is on on for qctrls?
> >>>>
> >>>> http://git.linuxtv.org/v4l-utils.git/blob/3ae390e54a0ba627c9e74953081560192b996df4:/utils/v4l2-compliance/v4l2-test-controls.cpp#l137
> >>>>
> >>>>  137         if (fl & V4L2_CTRL_FLAG_DISABLED)
> >>>>  138                 return fail("DISABLED flag set\n");
> >>>>
> >>>> Apparently that has been added on:
> >>>> http://git.linuxtv.org/v4l-utils.git/commit/0a4d4accea7266d7b5f54dea7ddf46cce8421fbb
> >>>>
> >>>> But I have failed to find a reason
> >>>
> >>> It shouldn't be used anymore in drivers. With the control framework there is
> >>> no longer any reason to use the DISABLED flag.
> >>>
> >>> If something has a valid use case for it, then I'd like to know what it is.
> >>>
> >>> Regards,
> >>>
> >>>         Hans
> >>
> >>
> >>
> 
> 
> 
> 
