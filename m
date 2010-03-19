Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0CSRnZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 13:43:25 -0400
Message-ID: <4BA3B7A9.2050405@redhat.com>
Date: Fri, 19 Mar 2010 14:43:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>	 <201003190904.53867.laurent.pinchart@ideasonboard.com>	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>	 <4BA38088.1020006@redhat.com> <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
In-Reply-To: <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ellingsworth wrote:
> On Fri, Mar 19, 2010 at 9:47 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> The V4L1 drivers that lasts are the ones without maintainers and probably without
>> a large users base. So, basically legacy hardware. So, their removals make sense.
>>
> 
> In many ways the above statement is a catch 22. Most, if not all the
> v4l1 drivers are currently broken or unmaintained. However, this does
> not mean there are users who would not be using these drivers if they
> actually worked or had been properly maintained. I know this to be a
> fact of the ibmcam driver. It is both broken and unmaintained. Because
> of this I'm sure no one is currently using it.

It makes sense. However, considering that no new V4L1 driver is committed
since 2006, this means that those are old drivers for old hardware.

> I happen to have a USB
> camera which is supposedly supported by the ibmcam driver.

In the specific case of ibmcam, we had only 10 commits on -hg since its
addition, back in 2006.

Just using it as an example about the remaining drivers, for today's hardware,
an ibmusb model 3 webcam has 640x480x3fps, according to his driver. Other models
have QCIF or QVGA as their maximum resolution. I can easily buy a 640x480x30fps
camera (or even something better than that) for US$12,00 on a close shopping.

So, even if the driver would be 100% functional, I doubt that you would find too
many users of this webcam, simply because people would need a faster frame rate
or wanted a higher resolution.

> Unfortunately, I have not the time nor expertise needed to
> update/fix/replace this driver, though I have previously tried. If
> someone on this list is willing to collaborate with me to make a
> functional v4l2 driver to replace the existing ibmcam driver, I'd be
> more than willing to expend more time and energy in doing so.
> Hopefully someday I'll actually be able to use the camera that I own,
> considering as is it barely works under Windows.

I agree that it would be interesting to port it to V4L2, instead of just
dropping it. Maybe Hans Geode or someone else with some spare time
could help you on this task.

-- 

Cheers,
Mauro
