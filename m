Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1HEHA7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2011 03:00:59 -0400
Message-ID: <4E3B9597.4040307@redhat.com>
Date: Fri, 05 Aug 2011 09:02:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com>	<alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu>	<4E39B150.40108@redhat.com>	<alpine.LNX.2.00.1108031750241.16520@banach.math.auburn.edu> <4E3A91D1.1040000@redhat.com>
In-Reply-To: <4E3A91D1.1040000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 08/04/2011 02:34 PM, Mauro Carvalho Chehab wrote:
> Em 03-08-2011 20:20, Theodore Kilgore escreveu:

<snip snip>

>> Yes, that kind of thing is an obvious problem. Actually, though, it may be
>> that this had just better not happen. For some of the hardware that I know
>> of, it could be a real problem no matter what approach would be taken. For
>> example, certain specific dual-mode cameras will delete all data stored on
>> the camera if the camera is fired up in webcam mode. To drop Gphoto
>> suddenly in order to do the videoconf call would, on such cameras, result
>> in the automatic deletion of all photos on the camera even if those photos
>> had not yet been downloaded. Presumably, one would not want to do that.
>
> So, in other words, the Kernel driver should return -EBUSY if on such
> cameras, if there are photos stored on them, and someone tries to stream.
>

Agreed.

>>> IMO, the right solution is to work on a proper snapshot mode, in kernelspace,
>>> and moving the drivers that have already a kernelspace out of Gphoto.
>>
>> Well, the problem with that is, a still camera and a webcam are entirely
>> different beasts. Still photos stored in the memory of an external device,
>> waiting to be downloaded, are not snapshots. Thus, access to those still
>> photos is not access to snapshots. Things are not that simple.
>
> Yes, stored photos require a different API, as Hans pointed. I think that some cameras
> just export them as a USB storage.

Erm, that is not what I tried to say, or do you mean another
Hans?

<snip snip>

> If I understood you well, there are 4 possible ways:
>
> 1) UVC + USB mass storage;
> 2) UVC + Vendor Class mass storage;
> 3) Vendor Class video + USB mass storage;
> 4) Vendor Class video + Vendor Class mass storage.
>

Actually the cameras Theodore and I are talking about here all
fall into category 4. I expect devices which do any of 1-3 to
properly use different interfaces for this, actually the different
class specifications mandate that they use different interfaces
for this.

> This sounds to be a good theme for the Workshop, or even to KS/2011.
>

Agreed, although we don't need to talk about this for very long, the solution
is basically:
1) Define a still image retrieval API for v4l2 devices (there is only 1
   interface for both functions on these devices, so only 1 driver, and to
   me it makes sense to extend the existing drivers to also do still image
   retrieval).
2) Modify existing kernel v4l2 drivers to provide this API
3) Write a new libgphoto driver which talks this interface (only need to
   do one driver since all dual mode cams will export the same API).

1) is something to discuss at the workshop.

Regards,

Hans
