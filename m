Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab0CSTFf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 15:05:35 -0400
Message-ID: <4BA3CB38.4090903@redhat.com>
Date: Fri, 19 Mar 2010 20:06:32 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: RFC: Drop V4L1 support in V4L2 drivers
References: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>	 <201003190904.53867.laurent.pinchart@ideasonboard.com>	 <50cd74a798bbf96501cd40b90d2a2b93.squirrel@webmail.xs4all.nl>	 <4BA38088.1020006@redhat.com> <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
In-Reply-To: <30353c3d1003190849v35b57dcai9ab11ff1362b4f46@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/19/2010 04:49 PM, David Ellingsworth wrote:
> On Fri, Mar 19, 2010 at 9:47 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> The V4L1 drivers that lasts are the ones without maintainers and probably without
>> a large users base. So, basically legacy hardware. So, their removals make sense.
>>
>
> In many ways the above statement is a catch 22. Most, if not all the
> v4l1 drivers are currently broken or unmaintained.

Ack, which is why I've been working actively on moving them all over to
gspca, but I need hardware access for that, see below.

However this thread is about removing support for v4l1 applications, and
there are actually still quite a few v4l1 apps out there, so we should
not do that!

 > However, this does
> not mean there are users who would not be using these drivers if they
> actually worked or had been properly maintained. I know this to be a
> fact of the ibmcam driver. It is both broken and unmaintained. Because
> of this I'm sure no one is currently using it. I happen to have a USB
> camera which is supposedly supported by the ibmcam driver.
> Unfortunately, I have not the time nor expertise needed to
> update/fix/replace this driver, though I have previously tried. If
> someone on this list is willing to collaborate with me to make a
> functional v4l2 driver to replace the existing ibmcam driver, I'd be
> more than willing to expend more time and energy in doing so.

Great! I've bene looking for someone with such a cam. As you may know
I've been slowly porting over all the remaining v4l1 usb webcam drivers
to gspca (removing a lot of code duplication and making them v4l2 drivers).

By far the easiest way to get the driver for this camera converted to
a gspca using v4l2 driver is to send it to me, would you be willing to
do that ?

Regards,

Hans
