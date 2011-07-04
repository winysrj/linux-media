Return-path: <mchehab@pedra>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:23650 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab1GDJna (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 05:43:30 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Some comments on the new autocluster patches
Date: Mon, 4 Jul 2011 11:43:13 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E0DE283.2030107@redhat.com> <201107021310.25562.hverkuil@xs4all.nl> <4E0F2BD3.3050803@redhat.com>
In-Reply-To: <4E0F2BD3.3050803@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041143.13458.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, July 02, 2011 16:31:47 Hans de Goede wrote:
> Hi,
> 
> On 07/02/2011 01:10 PM, Hans Verkuil wrote:
> > On Saturday, July 02, 2011 12:28:35 Hans de Goede wrote:
> >> Hi,
> >>
> >> <snip snip snip>
> >>
> >> Ok, thinking about this some more and reading Hans V's comments
> >> I think that the current code in Hans V's core8c branch is fine,
> >> and should go to 3.1 (rather then be delayed to 3.2).
> >>
> >> As for the fundamental question what to do with foo
> >> controls when autofoo goes from auto to manual, as discussed
> >> there are 2 options:
> >> 1) Restore the last known / previous manual setting
> >> 2) Keep foo at the current setting, iow the last setting
> >>      configured by autofoo
> >
> > Or option 3:
> >
> > Just don't report the automatic foo values at all. What possible purpose
> > does it serve?
> Reporting should be seen separate of what to do with the actual
> setting of for example gain as in use by the device when autogain
> gets turned off, that is what I'm talking about here, when autogain
> gets turned off (iow gain gets set to manual) there are 2 and only
> 2 options
> 
> 1) leave the gain at the value last set by the devices
>     autogain function (this may not be supported on all hardware)
> 2) restore the last known manual gain setting
> 
> What we report or not report for gain while autogain is active
> is irrelevant for this choice, when switching to manual we can
> either leave gain as is, or we restore the last known setting.
> Independent of any values we may have reported.

It is relevant. Take an application that saves the current state of all 
controls and restores it the next time it is started. If you report the 
device's autogain value instead of the manual gain, then that manual gain 
value is lost. I consider this a major drawback.
 
>  > It is my impression that drivers implement it 'just because
>  > they can', and not because it is meaningful.
> 
> Well it is drivers responsibility to export hardware functionality
> (in a standardized manner), then it is up to applications whether
> they use it or not. And it is actually quite meaning full, you
> are very much thinking TV and not webcams here, being able to
> see that the autofoo is actually doing something, and what
> it is doing is very useful for webcams. For example maybe it is
> choosing a low exposure (to get highframerate) high gain, which
> leads to more noise in the picture then the user wants
> 
> webcams are like photography, you've a shutter and a sensitivity
> (iso) setting being able to see what a camera chooses in full
> auto mode is quite useful.

OK, but it is not useful that this means that you don't see the manual value 
anymore.

> > I'm not aware of any application that actually refreshes e.g. gain values
> > when autogain is on, so end-users never see it anyway.
> 
> v4l2ucp has an option to update the ctrl readings every 1 / 2 / 5
> seconds. And I use this often to track what the autofoo is doing
> and / or to verify that it doing anything at all.

OK, good to know.

> > But I think we should stop supporting volatile writable controls.
> 
> NACK, and note that we already don't do that, what we do is switch
> a control from volatile read only (inactive) to non volatile rw-mode
> and back. The only question is what to do at the transition.

No, the question is also what to return.

How many 'autofoo' controls are there anyway?

V4L2_CID_AUTO_WHITE_BALANCE
V4L2_CID_AUTOGAIN
V4L2_CID_EXPOSURE_AUTO
V4L2_CID_AUTOBRIGHTNESS
V4L2_CID_HUE_AUTO

Those last two are used in only two drivers (gspca and uvc respectively).

The first three would require four extra read-only volatile controls:

V4L2_CID_AUTOWB_RED_BALANCE
V4L2_CID_AUTOWB_BLUE_BALANCE
V4L2_CID_AUTOGAIN_GAIN
V4L2_CID_AUTOEXP_EXPOSURE

Simple and straightforward. Applications can show the manual value and the 
autofoo value together so you can compare them easily. No unexpected 
transitions since turning off the autofoo will restore the manual foo value.

And apps that save/restore controls will always get/set the proper manual foo 
values.

The most difficult part will be to come up with a decent description of these 
controls:

"Gain, Automatic Value"
"Gain, Computed Value"
"Gain, Current Value"
"Gain, Current"

Hmm, those last two aren't so bad since that would fit equally whether 
autogain is on or off.

That suggests better CID naming as well:

V4L2_CID_RED_BALANCE_CUR ("Red Balance, Current")
V4L2_CID_BLUE_BALANCE_CUR ("Blue Balance, Current")
V4L2_CID_GAIN_CUR ("Gain, Current")
V4L2_CID_EXPOSURE_CUR ("Exposure, Current")

Simple, straightforward, no confusion.

Regards,

	Hans
