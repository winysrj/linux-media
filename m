Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab1HDUe0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 16:34:26 -0400
Message-ID: <4E3B0237.7010209@redhat.com>
Date: Thu, 04 Aug 2011 17:33:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu> <4E39B150.40108@redhat.com> <4E3A84F0.5050208@redhat.com> <4E3A9332.1060404@redhat.com> <20110804184020.6edb96d8@tele> <Pine.LNX.4.64.1108042052070.31239@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108042052070.31239@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 16:02, Guennadi Liakhovetski escreveu:
> (re-adding all from the original CC-list, please, don't drop anyone)
> 
> On Thu, 4 Aug 2011, Jean-Francois Moine wrote:
> 
>> On Thu, 04 Aug 2011 09:40:18 -0300
>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>
>>>> What we need for this is a simple API (new v4l ioctl's I guess) for the
>>>> stillcam mode of these dual mode cameras (stillcam + webcam). So that the
>>>> webcam drivers can grow code to also allow access to the stored pictures,
>>>> which were taken in standalone (iow not connected to usb) stillcam mode.
>>>>
>>>> This API does not need to be terribly complex. AFAIK all of the currently
>>>> supported dual cam cameras don't have filenames only picture numbers,
>>>> so the API could consist of a simple, get highest picture nr, is picture
>>>> X present (some slots may contain deleted pictures), get picture X,
>>>> delete picture X, delete all API.  
>>>
>>> That sounds to work. I would map it on a way close to the controls API
>>> (or like the DVB FE_[GET|SET]_PROPERTY API), as this would make easier to expand
>>> it in the future, if we start to see webcams with file names or other things
>>> like that.
>>
>> I did not follow all the thread, but I was wondering about an other
>> solution: what about offering both USB mass storage and webcam accesses?

Because not all devices export an USB mas storage.

>> When a dual-mode webcam is plugged in, the driver creates two devices,
>> the video device /dev/videox and the volume /dev/sdx. When the webcam is
>> opened, the volume cannot be mounted. When the volume is mounted, the
>> webcam cannot be opened. There is no need for a specific API. As Mauro
>> said:
>>
>>> For those, we may eventually need some sort of locking between
>>> the USB storage and V4L.
>>
>> That's all. By where am I wrong?
> 
> That'd also be my understanding. There are already several standard ways 
> to access data on still cameras: mass-storage, PTP, MTP, why invent Yet 
> Another One? "Just" learn to share a device between several existing 
> drivers.

For those that can export data into some fs-like way, this may be the better
way. It seems that gvfs does something like that. I've no idea how easy
or difficult would be to write Kernel driver for it.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

