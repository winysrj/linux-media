Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab0IGO7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Sep 2010 10:59:09 -0400
Message-ID: <4C863877.3000005@redhat.com>
Date: Tue, 07 Sep 2010 15:04:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
References: <20100906201105.4029d7e7@tele> <201009071147.22643.hverkuil@xs4all.nl> <4C862917.5050903@redhat.com> <201009071650.21029.hverkuil@xs4all.nl>
In-Reply-To: <201009071650.21029.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/07/2010 04:50 PM, Hans Verkuil wrote:
> On Tuesday, September 07, 2010 13:59:19 Hans de Goede wrote:
>> Hi all,
>>
>> On 09/07/2010 11:47 AM, Hans Verkuil wrote:
>>> On Tuesday, September 07, 2010 11:44:18 Hans de Goede wrote:
>>>> Replying to myself.
>>>>
>>>> On 09/07/2010 11:42 AM, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 09/07/2010 09:30 AM, Hans Verkuil wrote:
>>>>>> On Monday, September 06, 2010 20:11:05 Jean-Francois Moine wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> This new proposal cancels the previous 'LED control' patch.
>>>>>>>
>>>>>>> Cheers.
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Hi Jean-Francois,
>>>>>>
>>>>>> You must also add support for these new controls in v4l2-ctrls.c in
>>>>>> v4l2_ctrl_get_menu(), v4l2_ctrl_get_name() and v4l2_ctrl_fill().
>>>>>>
>>>>>> How is CID_ILLUMINATORS supposed to work in the case of multiple lights?
>>>>>> Wouldn't a bitmask type be more suitable to this than a menu type? There
>>>>>> isn't a bitmask type at the moment, but this seems to be a pretty good
>>>>>> candidate for a type like that.
>>>>>>
>>>>>> Actually, for the status led I would also use a bitmask since there may be
>>>>>> multiple leds. I guess you would need two bitmasks: one to select auto vs
>>>>>> manual, and one for the manual settings.
>>>>>>
>>>>>
>>>>> So far I've not seen cameras with multiple status leds, I do have seen camera
>>>>> which have the following settings for their 1 led (logitech uvc cams):
>>>>> auto
>>>>> on
>>>>> off
>>>>> blinking
>>>>>
>>>>> So I think a menu type is better suited, and that is what the current (private)
>>>>> uvc control uses.
>>>>
>>>> The same argument more or less goes for the CID_ILLIMUNATORS controls. Also given
>>>> that we currently don't have a bitmask type I think introducing one without a really
>>>> really good reason is a bad idea as any exiting apps won't know how to deal with it.
>>>
>>> But I can guarantee that we will get video devices with multiple leds in the
>>> future. So we need to think *now* about how to do this. One simple option is of course
>>> to name the controls CID_ILLUMINATOR0 and CID_LED0. That way we can easily add LED1,
>>> LED2, etc. later without running into weird inconsistent control names.
>>>
>>
>> Naming them LED0 and ILLUMINATOR0 works for me. Note about the illuminator one,
>> if you look at the patch it made the illuminator control a menu with the following
>> options:
>
> Where in the patch? Am I missing something?
>
>>
>> Both off
>> Top on, Bottom off
>> Top off, Bottom on
>> Both on
>>
>> Which raises the question do we leave this as is, or do we make this 2 boolean
>> controls. I personally would like to vote for keeping it as is, as both lamps
>> illuminate the same substrate in this case, and esp. switching between
>> Top on, Bottom off to Top off, Bottom on in one go is a good feature to have
>> UI wise (iow switch from top to bottom lighting or visa versa.
>
> The problem with having one control is that while this makes sense for this
> particular microscope, it doesn't make sense in general.
>

Actual it does atleast for microscopes in general a substrate under a microscope
usually is either illuminated from above or below.

> Standard controls such as proposed by this patch should have a fixed type

Although I agree with that sentiment in general I don't see this as an absolute
need, apps should get the type by doing a query ctrl not by assuming they
know it based on the cid.

And esp. for menu controls this is not true, for example
most devices have a light freq filter menu of:
off
50 hz
60 hz

Which matches what is documented in videodev2.h

Where as some have:
off
50 hz
60 hz
auto hz

Because they can (and default to) detect the light frequency automatically.

> consistent behavior. Note that I am also wondering whether it wouldn't be a
> good idea to use a menu for this, just as for the LEDs.

I do agree that the illuminator ctrls should be a menu, that way the driver
author can also choose wether to group 2 together in a single control or not
we simply should not specify the menu values in the spec (the same can
be said for the led case).

Regards,

Hams
