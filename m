Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:35880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1GLNXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 09:23:48 -0400
Message-ID: <4E1C4B2E.7010403@redhat.com>
Date: Tue, 12 Jul 2011 15:25:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com> <201107021310.25562.hverkuil@xs4all.nl> <4E0F2BD3.3050803@redhat.com> <201107041143.13458.hansverk@cisco.com>
In-Reply-To: <201107041143.13458.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On 07/04/2011 11:43 AM, Hans Verkuil wrote:
> On Saturday, July 02, 2011 16:31:47 Hans de Goede wrote:
>> Hi,
>>
>> On 07/02/2011 01:10 PM, Hans Verkuil wrote:
>>> On Saturday, July 02, 2011 12:28:35 Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> <snip snip snip>
>>>>
>>>> Ok, thinking about this some more and reading Hans V's comments
>>>> I think that the current code in Hans V's core8c branch is fine,
>>>> and should go to 3.1 (rather then be delayed to 3.2).
>>>>
>>>> As for the fundamental question what to do with foo
>>>> controls when autofoo goes from auto to manual, as discussed
>>>> there are 2 options:
>>>> 1) Restore the last known / previous manual setting
>>>> 2) Keep foo at the current setting, iow the last setting
>>>>       configured by autofoo
>>>
>>> Or option 3:
>>>
>>> Just don't report the automatic foo values at all. What possible purpose
>>> does it serve?
>> Reporting should be seen separate of what to do with the actual
>> setting of for example gain as in use by the device when autogain
>> gets turned off, that is what I'm talking about here, when autogain
>> gets turned off (iow gain gets set to manual) there are 2 and only
>> 2 options
>>
>> 1) leave the gain at the value last set by the devices
>>      autogain function (this may not be supported on all hardware)
>> 2) restore the last known manual gain setting
>>
>> What we report or not report for gain while autogain is active
>> is irrelevant for this choice, when switching to manual we can
>> either leave gain as is, or we restore the last known setting.
>> Independent of any values we may have reported.
>
> It is relevant. Take an application that saves the current state of all
> controls and restores it the next time it is started. If you report the
> device's autogain value instead of the manual gain, then that manual gain
> value is lost. I consider this a major drawback.

If autogain is on, then the gain is RO, so it should not be saved. Let alone
restored.

>
>>   >  It is my impression that drivers implement it 'just because
>>   >  they can', and not because it is meaningful.
>>
>> Well it is drivers responsibility to export hardware functionality
>> (in a standardized manner), then it is up to applications whether
>> they use it or not. And it is actually quite meaning full, you
>> are very much thinking TV and not webcams here, being able to
>> see that the autofoo is actually doing something, and what
>> it is doing is very useful for webcams. For example maybe it is
>> choosing a low exposure (to get highframerate) high gain, which
>> leads to more noise in the picture then the user wants
>>
>> webcams are like photography, you've a shutter and a sensitivity
>> (iso) setting being able to see what a camera chooses in full
>> auto mode is quite useful.
>
> OK, but it is not useful that this means that you don't see the manual value
> anymore.
>

In normal webcam use the lighting conditions are constantly changing, so
the gain value manually set 5 minutes ago is of little value, as it
is likely wrong for the current situation.

>>> I'm not aware of any application that actually refreshes e.g. gain values
>>> when autogain is on, so end-users never see it anyway.
>>
>> v4l2ucp has an option to update the ctrl readings every 1 / 2 / 5
>> seconds. And I use this often to track what the autofoo is doing
>> and / or to verify that it doing anything at all.
>
> OK, good to know.
>
>>> But I think we should stop supporting volatile writable controls.
>>
>> NACK, and note that we already don't do that, what we do is switch
>> a control from volatile read only (inactive) to non volatile rw-mode
>> and back. The only question is what to do at the transition.
>
> No, the question is also what to return.

What to return sort of follows from what you do when turning
of autogain, if you keep the last autogain set gain, then it
makes sense to return the autogain set value when reading gain, if
you switch back to the last manually set gain, then it
makes sense to just report the last manually set gain as long
as autogain is on.

I still believe that everything boils down to 2 possible scenarios,
and the rest follows from that. With the 2 scenarios being:

1) There is a manual setting which is constant until explicitly
changed, when (ie) gain switches from auto mode to manual mode
then the actual used gain is reset to this manual setting

2) There is a single gain setting / register, which is r/w when the
control is in manual mode and ro when in auto mode. When auto mode
gets switched off, the gain stays at the last value set by auto mode.

2) Is what most webcam sensors (and the pwc firmware) implement at
the hardware level, and what to me also makes the most sense for webcams.

To me this whole discussion centers around these 2 scenarios, with you
being a proponent of 1), and I guess that for video capture boards 1 makes
a lot of sense, and me being a proponent of 2.

Proposal: lets agree that these 2 methods of handling autofoo controls
both exist and both have merits in certain cases, this means letting
it be up to the driver to choose which method to implement.

If we can agree on this, then the next step would be to document both
methods, as well as how the controls should behave in either scenario.
I'm willing to write up a first draft for this.


> How many 'autofoo' controls are there anyway?
>
> V4L2_CID_AUTO_WHITE_BALANCE
> V4L2_CID_AUTOGAIN
> V4L2_CID_EXPOSURE_AUTO
> V4L2_CID_AUTOBRIGHTNESS
> V4L2_CID_HUE_AUTO
>
> Those last two are used in only two drivers (gspca and uvc respectively).
>
> The first three would require four extra read-only volatile controls:
>
> V4L2_CID_AUTOWB_RED_BALANCE
> V4L2_CID_AUTOWB_BLUE_BALANCE
> V4L2_CID_AUTOGAIN_GAIN
> V4L2_CID_AUTOEXP_EXPOSURE
>

I can see this making sense for drivers which choose to implement
scenario 1, but I see no value for drivers which choose to implement
scenario 2, it is just another control cluttering the control applet.

> Simple and straightforward. Applications can show the manual value and the
> autofoo value together so you can compare them easily. No unexpected
> transitions since turning off the autofoo will restore the manual foo value.

I would actually consider that an unexpected transition. Lets consider
auto exposure, and the last manual exposure was set during daytime, iow with
lots of daylight, so a low exposure setting. Now there is a stream active,
and being recorded in the evening. The user is not completely happy with the
autoexposure chosen value, and turns of autoexposure. The very low exposure
from the day gets restored, which is much too low, the image turns black,
and the recording is ruined, not good.

Or the exposure stays at its last automatically set value, the user can make
a small adjustment and all is well ... Note that this is exactly what most
hardware does, to avoid the scenario above.

We just seem to come at this from 2 completely different mindsets, to me
going from the autofoo foo value to some manual value which may be completely
unappropriate is an unexpected transition. IOW to me restoring the manual
foo value is the unexpected thing to do.

I think we need to agree that we disagree :)

Regards,

Hans
