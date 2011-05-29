Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab1E2Nag (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 09:30:36 -0400
Message-ID: <4DE24A84.5030909@redhat.com>
Date: Sun, 29 May 2011 15:30:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DE120D1.2020805@redhat.com> <4DE19AF7.2000401@redhat.com> <201105291319.47207.hverkuil@xs4all.nl> <4DE233EA.2000400@redhat.com> <4DE2455C.1070303@redhat.com>
In-Reply-To: <4DE2455C.1070303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 05/29/2011 03:08 PM, Mauro Carvalho Chehab wrote:
> Em 29-05-2011 08:54, Hans de Goede escreveu:
>> Hi,
>>
>> On 05/29/2011 01:19 PM, Hans Verkuil wrote:
>>> Hi Mauro,
>>>
>>> Thanks for the RFC! Some initial comments below. I'll hope to do some more
>>> testing and reviewing in the coming week.
>>>
>>
>> <Snip>
>>
>>>> c) get_not_associated_device: Returns the next device not associated with
>>>>                    an specific device type.
>>>>
>>>> char *get_not_associated_device(void *opaque,
>>>>                  char *last_seek,
>>>>                  enum device_type desired_type,
>>>>                  enum device_type not_desired_type);
>>>>
>>>> The parameters are:
>>>>
>>>> opaque:            media devices opaque descriptor
>>>> last_seek:        last seek result. Use NULL to get the first result
>>>> desired_type:        type of the desired device
>>>> not_desired_type:    type of the seek device
>>>>
>>>> This function seeks inside the media_devices struct for the next physical
>>>> device that doesn't support a non_desired type.
>>>> This method is useful for example to return the audio devices that are
>>>> provided by the motherboard.
>>>
>>> Hmmm. What you really want IMHO is to iterate over 'media hardware', and for
>>> each piece of hardware you can find the associated device nodes.
>>>
>>> It's what you expect to see in an application: a list of USB/PCI/Platform
>>> devices to choose from.
>>
>> This is exactly what I was thinking, I was think along the lines of making
>> the device_type enum bitmasks instead, and have a list devices functions,
>> which lists all the "physical" media devices as "describing string",
>> capabilities pairs, where capabilities would include things like sound
>> in / sound out, etc.
>
> A bitmask for device_type in practice means that we'll have just 32 (or 64)
> types of devices. Not sure if this is enough in the long term.
>

Ok, so we may need to use a different mechanism. I'm trying to think from
the pov of what the average app needs when it comes to media device discovery,
and what it needs is a list of devices which have the capabilities it needs
(like for example video input). As mentioned in this thread earlier it might
be an idea to add an option to this new lib to filter the discovered
devices. We could do that, but with a bitmask containing capabilities, the
user of the lib can easily iterate over all found devices itself and
discard unwanted ones itself.

> Grouping the discovered information together is not hard, but there's one
> issue if we'll be opening devices to retrieve additional info: some devices
> do weird stuff at open, like retrieving firmware, when the device is waking
> from a suspend state. So, the discover procedure that currently happens in
> usecs may take seconds. Ok, this is, in fact, a driver and/or hardware trouble,
> but I think that having a separate method for it is a good idea.

WRT detection speed I agree we should avoid opening the nodes where possible,
so I guess that also means we may want a second "give me more detailed info"
call which an app can do an a per device (function) basis, or we could
leave this to the apps themselves.

WRT grouping together, I think that the grouping view should be the primary
view / API, as that is what most apps will want to use ...




>
>> And then a function to get a device string (be it a device node
>> or an alsa device string, whatever is appropriate) for each capability
>> of a device.
>
> get_associated_device()/fget_associated_device() does it. It is generic enough to
> work with all types of devices. So, having an alsa device, it can be used
> to get the video device associated, or vice-versa.

This is very topology / association detection oriented, as said before
I don't think that is what the average app wants / needs, for example tvtime/xawtv
want:
1) Give me a list v4l2 input devices with a tuner
2) Give me the sound device to read sound from associated to
    v4l2 input device foo (the one the user just selected).

I realize that this can be done with the current API too, I'm just
saying that it might be better to give the enumeration of physical devices
a more prominent role, as well as getting a user friendly name for
the physical device.

Regards,

Hans
