Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab0CVIkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 04:40:35 -0400
Message-ID: <4BA72D46.70503@redhat.com>
Date: Mon, 22 Mar 2010 09:41:42 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert
 apps.
References: <201003201021.05426.hverkuil@xs4all.nl> <4BA556D1.1090602@redhat.com> <201003220911.36035.hverkuil@xs4all.nl>
In-Reply-To: <201003220911.36035.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/22/2010 09:11 AM, Hans Verkuil wrote:
> On Sunday 21 March 2010 00:14:25 Hans de Goede wrote:
>> Hi,
>>
>> On 03/20/2010 10:21 AM, Hans Verkuil wrote:
>>> Hi all!
>>>
>>> The second phase that needs to be done to remove the v4l1 support from the
>>> kernel is that libv4l1 should replace the v4l1-compat code from the kernel.
>>>
>>> I do not know how complete the libv4l1 code is right now. I would like to
>>> know in particular whether the VIDIOCGMBUF/mmap behavior can be faked in
>>> libv4l1 if drivers do not support the cgmbuf vidioc call.
>>>
>>
>> Yes it can, this for example already happens when using v4l1 apps with
>> uvcvideo (which is not possible without libv4l1).
>
> In what way does libv4l1 still depend on the kernel's v4l1 compat layer?

It depends on some of the ioctl compatibility stuff, which lives in
drivers/media/video/v4l1-compat.c

Basically it depends on:

v4l_compat_translate_ioctl()

 From that file and on what that depends on in turn. Note that it does not
depend on v4l_compat_translate_ioctl() for all ioctl's. It handles
some of them in its own, see:
lib/libv4l1/libv4l1.c

In v4l-utils git, specifically the v4l1_ioctl() function. Note that simply
checking which one are listed in the switch case is not enough to determine
which ones are already handled by libv4l, some still call
v4l_compat_translate_ioctl() (by doing the v4l1 ioctl) and then munge the
results.

Currently it is mainly targeted and tested with webcam using apps, so no
overlay, input switching, vbi or tuning support.

Adding input switching, vbi and tuning support, should be easy I think.
Overlay has me worried as the v4l1 API does not clearly separate between
overlay and capture. Since overlay does not really work out of the box
on any distro's anyways (in my experience), I think the best thing to
do would be to just hide the overlay capability for v4l1 apps.

Note that the default: case which passes the ioctl through to libv4l2,
will end up passing v4l1 ioctl's to the kernel, as libv4l2 will pass
unknown ioctl's to the kernel unmodified.

 > And
> what is needed to remove that dependency?
>

Someone to:
- add emulation of the not yet emulated ioctl's; and
- remove the limits of not working on complex devices,
   see libv4l1.c line 295 (in v4l1_open, marked IMPROVEME */; and
- remove the dependency of some already emulated ioctl's on the
   the kernels v4l_compat_translate_ioctl(), for example
   the VIDIOCGCAP emulation calls the kernel, then overrides some
   results.


Note that all emulation needs to be re-implemented, not copied from
the kernel as the kernel is GPLv2 and libv4l1 LGPLv2+, an alternative
approach would be to find out who holds the copyrights and ask them
for permission.

> Because I think that that is the best approach.
>

Ack.

Regards,

Hans
