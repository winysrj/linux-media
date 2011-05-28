Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1E1M0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 08:26:32 -0400
Message-ID: <4DE0EA00.3010603@redhat.com>
Date: Sat, 28 May 2011 14:26:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl> <BANLkTikFROSj8LBeCs=Ep1R-HFEEFGOYZw@mail.gmail.com> <201105260853.31065.hverkuil@xs4all.nl> <4DE0E7D5.9070000@redhat.com>
In-Reply-To: <4DE0E7D5.9070000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 05/28/2011 02:17 PM, Mauro Carvalho Chehab wrote:
> Em 26-05-2011 03:53, Hans Verkuil escreveu:
>> On Tuesday, May 24, 2011 16:57:22 Devin Heitmueller wrote:
>>> On Tue, May 24, 2011 at 2:50 AM, Hans Verkuil<hverkuil@xs4all.nl>  wrote:
>>>> On Monday, May 23, 2011 22:17:06 Mauro Carvalho Chehab wrote:
>>>>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
>>>>> during the weekend, I decided to add alsa support also on xawtv3, basically
>>>>> to provide a real usecase example. Of course, for it to work, it needs the
>>>>> very latest v4l2-utils version from the git tree.
>>>>
>>>> Please, please add at the very least some very big disclaimer in libv4l2util
>>>> that the API/ABI is likely to change. As mentioned earlier, this library is
>>>> undocumented, has not gone through any peer-review, and I am very unhappy with
>>>> it and with the decision (without discussion it seems) to install it.
>>>>
>>>> Once you install it on systems it becomes much harder to change.
>>
>> I wanted to do a review of this library, but Devin did it for me in his
>> comments below.
>>
>> I completely agree with his comments.
>>
>> Once I have all the control framework stuff that is in my queue done, then
>> I want to go through as many drivers as I can and bring them all up to
>> the latest V4L2 standards (using v4l2-compliance to verify correctness).
>>
>> It is my intention to create some helper functions to implement a MC node for
>> these simple legacy drivers. Eventually all V4L drivers should have a MC node.
>
> Converting all devices to use MC won't help, as the alsa device is implemented
> on some cases by independent drivers (snd-usb-alsa). As I said before, forcing
> all drivers to implement MC is silly. They just don't need it. Let's focus the MC
> stuff where it really belongs: SoC designs and very complex devices, were you
> should need to know and to change the internal routes and V4L2 API is not enough
> for it.
>
>> Writing a library like the one proposed here would then be much easier and
>> it would function as a front-end for the MC.
>
> The design of the library methods should be independent of MC or sysfs.
> That's what I did: the methods there provide the basic information about
> the media devices without exporting sysfs struct to it.
>
> Once we have the library stable, it can be extended to also implement
> device discovery via MC (or even using both).
>
> Yet, MC is an optional feature, and still not ready to handle inter-subsystem
> dependencies.
>
> As there isn't even a single patch adding MC API for sound or dvb, it is
> clear that it will take at least 2 development kernel cycles (e. g. about
> 6 months) for this to start happening.
>
> In other words, you're arguing against using what's currently provided by
> the Kernel, on a standard way, in favour of something that will take at
> least 6 months having the basic API added for the other subsystems to be able
> to report their device trees, plus the time to port all drivers to use it.
> This doesn't sound like a good plan to me.
>
> Once having MC completed, an optional extension to the library may allow
> its usage also for MC device info methods, where available at the driver(s).
>

I've to side with Mauro here, I agree that the important thing is having
a userspace library which can be used by other userspace apps to find out which
sound / vbi device belongs to a video node.

This libraries API should not export knowledge about how this information
is gathered. For now if can use sysfs to make things at least work with
simple devices (and in the future still use sysfs when running on older
kernels). Once we actually have a better kernel userspace API for this,
and devices which implement this API, we could make the library try that first,
and fall back to using sysfs when that new API is not available.

I said before I hope to release a new v4l-utils soon. After that I want to
start working towards a first 0.9.0 devel release, which will contain the
v4l plugin patches done by Nokia, and could very well also contain some
API for this.

Therefor I would like to focus on defining a sane API for discovering
video nodes, and associated nodes. As said before I'm not completely
sold on the current API of Mauro's mini lib, but to be honest I've not
really studied either the current API or the problem it solves too
closely.

Regards,

Hans
