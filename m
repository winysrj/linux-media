Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1GBOal (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 10:30:41 -0400
Message-ID: <4E0F2BD3.3050803@redhat.com>
Date: Sat, 02 Jul 2011 16:31:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com> <201107011821.33960.hverkuil@xs4all.nl> <4E0EF2D3.8030109@redhat.com> <201107021310.25562.hverkuil@xs4all.nl>
In-Reply-To: <201107021310.25562.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 07/02/2011 01:10 PM, Hans Verkuil wrote:
> On Saturday, July 02, 2011 12:28:35 Hans de Goede wrote:
>> Hi,
>>
>> <snip snip snip>
>>
>> Ok, thinking about this some more and reading Hans V's comments
>> I think that the current code in Hans V's core8c branch is fine,
>> and should go to 3.1 (rather then be delayed to 3.2).
>>
>> As for the fundamental question what to do with foo
>> controls when autofoo goes from auto to manual, as discussed
>> there are 2 options:
>> 1) Restore the last known / previous manual setting
>> 2) Keep foo at the current setting, iow the last setting
>>      configured by autofoo
>
> Or option 3:
>
> Just don't report the automatic foo values at all. What possible purpose
> does it serve?
Reporting should be seen separate of what to do with the actual
setting of for example gain as in use by the device when autogain
gets turned off, that is what I'm talking about here, when autogain
gets turned off (iow gain gets set to manual) there are 2 and only
2 options

1) leave the gain at the value last set by the devices
    autogain function (this may not be supported on all hardware)
2) restore the last known manual gain setting

What we report or not report for gain while autogain is active
is irrelevant for this choice, when switching to manual we can
either leave gain as is, or we restore the last known setting.
Independent of any values we may have reported.

 > It is my impression that drivers implement it 'just because
 > they can', and not because it is meaningful.

Well it is drivers responsibility to export hardware functionality
(in a standardized manner), then it is up to applications whether
they use it or not. And it is actually quite meaning full, you
are very much thinking TV and not webcams here, being able to
see that the autofoo is actually doing something, and what
it is doing is very useful for webcams. For example maybe it is
choosing a low exposure (to get highframerate) high gain, which
leads to more noise in the picture then the user wants

webcams are like photography, you've a shutter and a sensitivity
(iso) setting being able to see what a camera chooses in full
auto mode is quite useful.

> I'm not aware of any application that actually refreshes e.g. gain values
> when autogain is on, so end-users never see it anyway.

v4l2ucp has an option to update the ctrl readings every 1 / 2 / 5
seconds. And I use this often to track what the autofoo is doing
and / or to verify that it doing anything at all.

> But I think we should stop supporting volatile writable controls.

NACK, and note that we already don't do that, what we do is switch
a control from volatile read only (inactive) to non volatile rw-mode
and back. The only question is what to do at the transition.

Regards,

Hans
