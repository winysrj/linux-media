Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1GZNuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 09:50:19 -0400
Message-ID: <4E2EC67E.6010300@redhat.com>
Date: Tue, 26 Jul 2011 15:51:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com> <201107041143.13458.hansverk@cisco.com> <4E1C4B2E.7010403@redhat.com> <201107261126.22285.hverkuil@xs4all.nl>
In-Reply-To: <201107261126.22285.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/26/2011 11:26 AM, Hans Verkuil wrote:
> OK, I'm back to work after my vacation, so it's time to go through the
> backlog...
>

Welcome back :)

> On Tuesday, July 12, 2011 15:25:02 Hans de Goede wrote:
>> Hi,
>>
>> On 07/04/2011 11:43 AM, Hans Verkuil wrote:

<snip snip>

>>> It is relevant. Take an application that saves the current state of all
>>> controls and restores it the next time it is started. If you report the
>>> device's autogain value instead of the manual gain, then that manual gain
>>> value is lost. I consider this a major drawback.
>>
>> If autogain is on, then the gain is RO, so it should not be saved. Let alone
>> restored.
>
> Marking gain as inactive is fine, but marking it as read-only is not so clear.
> Currently the RO flag is static. This allows control panels to use e.g. a text
> field instead of an input field to show the value.
>
> I would like to keep that functionality. If we make the RO flag dynamic, then
> GUIs won't know whether to show it as a disabled input field or as a text field.
>
> Whereas with the inactive flag they will know that it has to be a disabled
> input field.
>

Agreed, where I wrote read only I meant inactive, which does make it less clear
that the control should not be saved / restored by a save / restore app.

> When the inactive flag is set, it is still allowed to set the value. However,
> if we add a volatile flag as well, then we may want to have the combination
> 'inactive and volatile' return an error when an application attempts to set the
> value.

I think that is a good solution to indicate dynamic-readonly ness (more or less),
and thus to indicate that the control should not be written (and thus not saved/
restored).

> Or is this too complex and should we just discard the value in a case like that?

I would prefer returning an error, so that things don't silently fail, also
unless we actually return an error many apps are likely to get this wrong.

<snip snip>

>> I still believe that everything boils down to 2 possible scenarios,
>> and the rest follows from that. With the 2 scenarios being:
>>
>> 1) There is a manual setting which is constant until explicitly
>> changed, when (ie) gain switches from auto mode to manual mode
>> then the actual used gain is reset to this manual setting
>>
>> 2) There is a single gain setting / register, which is r/w when the
>> control is in manual mode and ro when in auto mode. When auto mode
>> gets switched off, the gain stays at the last value set by auto mode.
>>
>> 2) Is what most webcam sensors (and the pwc firmware) implement at
>> the hardware level, and what to me also makes the most sense for webcams.
>>
>> To me this whole discussion centers around these 2 scenarios, with you
>> being a proponent of 1), and I guess that for video capture boards 1 makes
>> a lot of sense, and me being a proponent of 2.
>>
>> Proposal: lets agree that these 2 methods of handling autofoo controls
>> both exist and both have merits in certain cases, this means letting
>> it be up to the driver to choose which method to implement.
>
> OK.
>
>> If we can agree on this, then the next step would be to document both
>> methods, as well as how the controls should behave in either scenario.
>> I'm willing to write up a first draft for this.
>
> I can do that as well, see below.

Ah great, you just saved me some work I always like it when people
save me work :)

<snip snip>

>> I think we need to agree that we disagree :)
>
> Actually, I agree with much of what you wrote :-)
>

Good :)

> OK, so we have two scenarios:
>
> 1) There is a manual setting which is constant until explicitly changed, when e.g.
> gain switches from auto mode to manual mode then the actual used gain is reset to
> this manual setting.
>
> In this case the e.g. gain control is *not* marked volatile, but just inactive.
> If the hardware can return the gain as set by the autogain circuit, then that has
> to be exported as a separate read-only control (e.g. 'Current Gain').
>
>
> 2) There is a single gain setting / register, which is active when the control is in
> manual mode and inactive and volatile when in auto mode. When auto mode gets switched
> off, the gain stays at the last value set by auto mode.
>
> This scenario is only possible, of course, if you can obtain the gain value as set
> by the autogain circuitry.
>

I fully agree with the above, +1

> An open question is whether writing to an inactive and volatile control should return
> an error or not.

I would prefer an error return.

> Webcams should follow scenario 2 (if possible).
>
> It is less obvious what to recommend for video capture devices. I'd leave it up to
> the driver for now.

Sounds good to me.

Regards,

Hans
