Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4734 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZIQGeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 02:34:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: RFCv2: Media controller proposal
Date: Thu, 17 Sep 2009 08:34:23 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909100913.09065.hverkuil@xs4all.nl> <20090916175043.0d462a18@pedra.chehab.org> <A69FA2915331DC488A831521EAE36FE40155157118@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155157118@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909170834.23449.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 September 2009 00:28:38 Karicheri, Muralidharan wrote:
> >
> >> And as I explained above, a v4l2_subdev just implements an interface. It
> >has
> >> no relation to devices. And yes, I'm beginning to agree with you that
> >subdevice
> >> was a bad name because it suggested something that it simply isn't.
> >>
> >> That said, I also see some advantages in doing this. For statistics or
> >> histogram sub-devices you can implement a read() call to read the data
> >> instead of using ioctl. It is more flexible in that respect.
> >
> >I think this will be more flexible and will be less complex than creating a
> >proxy
> >device. For example, as you'll be directly addressing a device, you don't
> >need to
> >have any locking to avoid the risk that different threads accessing
> >different
> >sub-devices at the same time would result on a command sending to the wrong
> >device.
> >So, both kernel driver and userspace app can be simpler.
> 
> 
> Not really. User application trying to parse the output of a histogram which
> really will about 4K in size as described by Laurent. Imagine application does lot of parsing to decode the values thrown by the sysfs. Again on different platform, they can be different formats. With ioctl, each of these platforms provides api to access them and it is much simpler to use. Same for configuring IPIPE on DM355/DM365 where there are hundreds of parameters and write a lot of code in sysfs to parse each of these variables. I can see it as a nightmare for user space library or application developer.

I believe Mauro was talking about normal device nodes, not sysfs.

What is a bit more complex in Mauro's scheme is that to get hold of the right
device node needed to access a sub-device you will need to first get the
subdev's entity information from the media controller, then go to libudev to
translate major/minor numbers to an actual device path, and then open that.

On the other hand, we will have a library available to do this.

On balance I think that the kernel implementation will be more complex by
creating device nodes, although not by much, and that userspace will be
slightly simpler in the case of using the same mc filehandle in a multi-
threaded application.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
