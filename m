Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0CST5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 15:57:36 -0400
Message-ID: <4BA3D722.1010709@redhat.com>
Date: Fri, 19 Mar 2010 16:57:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>	 <201003190904.53867.laurent.pinchart@ideasonboard.com>	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>	 <4BA38088.1020006@redhat.com>	 <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>	 <4BA3B7A9.2050405@redhat.com> <30353c3d1003191100q2446edeekb161dba45624489a@mail.gmail.com>
In-Reply-To: <30353c3d1003191100q2446edeekb161dba45624489a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ellingsworth wrote:
> On Fri, Mar 19, 2010 at 1:43 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> David Ellingsworth wrote:
>>> On Fri, Mar 19, 2010 at 9:47 AM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> The V4L1 drivers that lasts are the ones without maintainers and probably without
>>>> a large users base. So, basically legacy hardware. So, their removals make sense.
>>>>
>>> In many ways the above statement is a catch 22. Most, if not all the
>>> v4l1 drivers are currently broken or unmaintained. However, this does
>>> not mean there are users who would not be using these drivers if they
>>> actually worked or had been properly maintained. I know this to be a
>>> fact of the ibmcam driver. It is both broken and unmaintained. Because
>>> of this I'm sure no one is currently using it.
>> It makes sense. However, considering that no new V4L1 driver is committed
>> since 2006, this means that those are old drivers for old hardware.
>>
>>> I happen to have a USB
>>> camera which is supposedly supported by the ibmcam driver.
>> In the specific case of ibmcam, we had only 10 commits on -hg since its
>> addition, back in 2006.
>>
>> Just using it as an example about the remaining drivers, for today's hardware,
>> an ibmusb model 3 webcam has 640x480x3fps, according to his driver. Other models
>> have QCIF or QVGA as their maximum resolution. I can easily buy a 640x480x30fps
>> camera (or even something better than that) for US$12,00 on a close shopping.
> 
> The limitation on the frame rate within the driver is not an issue
> with the camera itself per-say. The camera I have supports
> 640x480x30fps but the ibmcam driver lacks support for the video mode
> used to achieve that rate. Specifically speaking, the camera uses a
> proprietary compressed image format that the current v4l1 ibmcam
> driver does not support for several reasons.

Ah, ok.

> First and foremost, the
> original author stated that he did not have time to reverse engineer
> the compressed format. Second even if he had, the code to do so
> doesn't belong in the driver itself.

As we're just talking about V4L1->V4L2 conversion, even if someone convert
or fix the driver, this issue will remain. Only finding someone to maintain
it, this issue will be fixed.
> 
> Yes it is an old camera, but that does not mean there aren't people
> out there who still own cameras which would otherwise be usable if the
> driver worked. And sure people could just buy another camera.. but why
> replace hardware that's obviously not broken?

If you want/need a webcam in Linux, have a broken driver, an old hardware
and a new hardware costs less than 15 bucks, why not just buy a new camera?
Many users likely did it already with the remaining V4L1 drivers. With less
users/developers running Linux with this hardware, less chances that someone
would take the maintainership of the driver and fix/convert it.

We're talking about removal of those drivers for about two years, and nobody,
except for the existing developers that found some way to buy legacy used
hardware sent patches.

Anyway, I see your point. 

The better alternative would be if someone could borrow or donate hardware 
to Hans de Goede and/or another developers that may be interested and let 
them convert the driver and hopefully break the proprietary protocols, 
implementing them at libv4l.

Cheers,
Mauro
