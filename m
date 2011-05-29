Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1E2LyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 07:54:10 -0400
Message-ID: <4DE233EA.2000400@redhat.com>
Date: Sun, 29 May 2011 13:54:18 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices -
 was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <4DE120D1.2020805@redhat.com> <4DE19AF7.2000401@redhat.com> <201105291319.47207.hverkuil@xs4all.nl>
In-Reply-To: <201105291319.47207.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 05/29/2011 01:19 PM, Hans Verkuil wrote:
> Hi Mauro,
>
> Thanks for the RFC! Some initial comments below. I'll hope to do some more
> testing and reviewing in the coming week.
>

<Snip>

>> c) get_not_associated_device: Returns the next device not associated with
>> 			      an specific device type.
>>
>> char *get_not_associated_device(void *opaque,
>> 			    char *last_seek,
>> 			    enum device_type desired_type,
>> 			    enum device_type not_desired_type);
>>
>> The parameters are:
>>
>> opaque:			media devices opaque descriptor
>> last_seek:		last seek result. Use NULL to get the first result
>> desired_type:		type of the desired device
>> not_desired_type:	type of the seek device
>>
>> This function seeks inside the media_devices struct for the next physical
>> device that doesn't support a non_desired type.
>> This method is useful for example to return the audio devices that are
>> provided by the motherboard.
>
> Hmmm. What you really want IMHO is to iterate over 'media hardware', and for
> each piece of hardware you can find the associated device nodes.
>
> It's what you expect to see in an application: a list of USB/PCI/Platform
> devices to choose from.

This is exactly what I was thinking, I was think along the lines of making
the device_type enum bitmasks instead, and have a list devices functions,
which lists all the "physical" media devices as "describing string",
capabilities pairs, where capabilities would include things like sound
in / sound out, etc.

And then a function to get a device string (be it a device node
or an alsa device string, whatever is appropriate) for each capability
of a device.

This does need some more thought for more complex devices though ...

Regards,

Hans
