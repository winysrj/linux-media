Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0CVOHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 10:07:32 -0400
Message-ID: <4BA77998.4090004@infradead.org>
Date: Mon, 22 Mar 2010 11:07:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert
 apps.
References: <201003201021.05426.hverkuil@xs4all.nl> <4BA556D1.1090602@redhat.com> <201003220911.36035.hverkuil@xs4all.nl> <4BA72D46.70503@redhat.com>
In-Reply-To: <4BA72D46.70503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 03/22/2010 09:11 AM, Hans Verkuil wrote:
>> On Sunday 21 March 2010 00:14:25 Hans de Goede wrote:
>>> Hi,
>>>
>>> On 03/20/2010 10:21 AM, Hans Verkuil wrote:
>>>> Hi all!
>>>>
>>>> The second phase that needs to be done to remove the v4l1 support
>>>> from the
>>>> kernel is that libv4l1 should replace the v4l1-compat code from the
>>>> kernel.
>>>>
>>>> I do not know how complete the libv4l1 code is right now. I would
>>>> like to
>>>> know in particular whether the VIDIOCGMBUF/mmap behavior can be
>>>> faked in
>>>> libv4l1 if drivers do not support the cgmbuf vidioc call.
>>>>
>>>
>>> Yes it can, this for example already happens when using v4l1 apps with
>>> uvcvideo (which is not possible without libv4l1).
>>
>> In what way does libv4l1 still depend on the kernel's v4l1 compat layer?
> 
> It depends on some of the ioctl compatibility stuff, which lives in
> drivers/media/video/v4l1-compat.c
> 
> Basically it depends on:
> 
> v4l_compat_translate_ioctl()
> 
> From that file and on what that depends on in turn. Note that it does not
> depend on v4l_compat_translate_ioctl() for all ioctl's. It handles
> some of them in its own, see:
> lib/libv4l1/libv4l1.c
> 
> In v4l-utils git, specifically the v4l1_ioctl() function. Note that simply
> checking which one are listed in the switch case is not enough to determine
> which ones are already handled by libv4l, some still call
> v4l_compat_translate_ioctl() (by doing the v4l1 ioctl) and then munge the
> results.
> 
> Currently it is mainly targeted and tested with webcam using apps, so no
> overlay, input switching, vbi or tuning support.

Probably no radio. Radio is not that different from tuning, but, as radio uses
tuning on a different way (it needs only a subset of ioctl's), you may see 
troubles on radio applications with V4L1 even when the driver works with TV with V4L1.
We had this issue when ported the radio drivers from V4L1 to V4L2: we had to
implement some dummy V4L2 ioctls, for the V4L1 compat logic to work.

> Adding input switching, vbi and tuning support, should be easy I think.
> Overlay has me worried as the v4l1 API does not clearly separate between
> overlay and capture. Since overlay does not really work out of the box
> on any distro's anyways (in my experience), I think the best thing to
> do would be to just hide the overlay capability for v4l1 apps.

The last time I tested overlay, it worked perfectly. You need to be sure
that you're not running it on a machine with Via or Sys chipsets, as those
chips have bugs with pci2pci data transfers, so the PCI quirk code disables
overlay with broken north bridge chipsets.

Cheers,
Mauro
