Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1HDMk1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 08:40:27 -0400
Message-ID: <4E3A9332.1060404@redhat.com>
Date: Thu, 04 Aug 2011 09:40:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com>	<alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu> <4E39B150.40108@redhat.com> <4E3A84F0.5050208@redhat.com>
In-Reply-To: <4E3A84F0.5050208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 08:39, Hans de Goede escreveu:
> Hi,
> 
> On 08/03/2011 10:36 PM, Mauro Carvalho Chehab wrote:
>> Em 03-08-2011 16:53, Theodore Kilgore escreveu:
> 
> <snip snip>
> 
>>> Mauro,
>>>
>>> Not saying that you need to change the program for this session to deal
>>> with this topic, but an old and vexing problem is dual-mode devices. It is
>>> an issue which needs some kind of unified approach, and, in my opinion,
>>> consensus about policy and methodology.
>>>
>>> As a very good example if this problem, several of the cameras that I have
>>> supported as GSPCA devices in their webcam modality are also still cameras
>>> and are supported, as still cameras, in Gphoto. This can cause a collision
>>> between driver software in userspace which functions with libusb, and on
>>> the other hand with a kernel driver which tries to grab the device.
>>>
>>> Recent attempts to deal with this problem involve the incorporation of
>>> code in libusb which disables a kernel module that has already grabbed the
>>> device, allowing the userspace driver to function. This has made life a
>>> little bit easier for some people, but not for everybody. For, the device
>>> needs to be re-plugged in order to re-activate the kernel support. But
>>> some of the "user-friencly" desktop setups used by some distros will
>>> automatically start up a dual-mode camera with a gphoto-based program,
>>> thereby making it impossible for the camera to be used as a webcam unless
>>> the user goes for a crash course in how to disable the "feature" which has
>>> been so thoughtfully (thoughtlessly?) provided.
>>>
>>> As the problem is not confined to cameras but also affects some other
>>> devices, such as DSL modems which have a partition on them and are thus
>>> seen as Mass Storage devices, perhaps it is time to try to find a
>>> systematic approach to problems like this.
>>>
>>> There are of course several possible approaches.
>>>
>>> 1. A kernel module should handle everything related to connecting up the
>>> hardware. In that case, the existing userspace driver has to be modified
>>> to use the kernel module instead of libusb. Those who support this option
>>> would say that it gets everything under the control of the kernel, where
>>> it belongs. OTOG, the possible result is to create a minor mess in
>>> projects like Gphoto.
>>>
>>> 2. The kernel module should be abolished, and all of its functionality
>>> moved to userspace. This would of course involve difficulties
>>> approximately equivalent to item 1. An advantage, in the eyes of some,
>>> would be to cut down on the
>>> yet-another-driver-for-yet-another-piece-of-peculiar-hardware syndrome
>>> which obviously contributes to an in principle unlimited increase in the
>>> size of the kernel codebase. A disadvantage would be that it would create
>>> some disruption in webcam support.
>>>
>>> 3. A further modification to libusb reactivates the kernel module
>>> automatically, as soon as the userspace app which wanted to access the
>>> device through a libusb-based driver library is closed. This seems
>>> attractive, but it has certain deficiencies as well. One of them is that
>>> it can not necessarily provide a smooth and informative user experience,
>>> since circumstances can occur in which something appears to go wrong, but
>>> the user gets no clear message saying what the problem is. In other words,
>>> it is a patchwork solution which only slightly refines the current
>>> patchwork solution in libusb, which is in itself only a slight improvement
>>> on the original, unaddressed problem.
>>>
>>> 4. ???
>>>
>>> Several people are interested in this problem, but not much progress has
>>> been made at this time. I think that the topic ought to be put somehow on
>>> the front burner so that lots of people will try to think of the best way
>>> to handle it. Many eyes, and all that.
>>>
>>> Not saying change your schedule, as I said. Have a nice conference. I wish
>>> I could attend. But I do hope by this message to raise some general
>>> concern about this problem.
>>
>> That's an interesting issue.
>>
>> A solution like (3) is a little bit out of scope, as it is a pure userspace
>> (or a mixed userspace USB stack) solution.
>>
>> Technically speaking, letting the same device being handled by either an
>> userspace or a kernelspace driver doesn't seem smart to me, due to:
>>     - Duplicated efforts to maintain both drivers;
>>     - It is hard to sync a kernel driver with an userspace driver,
>> as you've pointed.
>>
>> So, we're between (1) or (2).
>>
>> Moving the solution entirely to userspace will have, additionally, the
>> problem of having two applications trying to access the same hardware
>> using two different userspace instances (for example, an incoming videoconf
>> call while Gphoto is opened, assuming that such videoconf call would also
>> have an userspace driver).
>>
>> IMO, the right solution is to work on a proper snapshot mode, in kernelspace,
>> and moving the drivers that have already a kernelspace out of Gphoto.
>>
> 
> I agree that solution 1) so all the driver bits in kernelspace is the right
> solution. This is unrelated to snapshot mode though, snapshot mode is all
> about taking live snapshots. Where as in this case we are downloading
> pictures which have already been taken (perhaps days ago) from device memory.
> 
> What we need for this is a simple API (new v4l ioctl's I guess) for the
> stillcam mode of these dual mode cameras (stillcam + webcam). So that the
> webcam drivers can grow code to also allow access to the stored pictures,
> which were taken in standalone (iow not connected to usb) stillcam mode.
> 
> This API does not need to be terribly complex. AFAIK all of the currently
> supported dual cam cameras don't have filenames only picture numbers,
> so the API could consist of a simple, get highest picture nr, is picture
> X present (some slots may contain deleted pictures), get picture X,
> delete picture X, delete all API.

That sounds to work. I would map it on a way close to the controls API
(or like the DVB FE_[GET|SET]_PROPERTY API), as this would make easier to expand
it in the future, if we start to see webcams with file names or other things
like that.

> 
> If others are  willing to help flesh out an API for this, I can write
> a proposal and submit it a few weeks before the Media Subsystem Workshop
> starts.
> 
> Regards,
> 
> Hans

