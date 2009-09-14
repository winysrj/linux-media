Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZINLtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 07:49:18 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	wk <handygewinnspiel@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 14 Sep 2009 06:49:13 -0500
Subject: RE: Media controller: sysfs vs ioctl
Message-ID: <A69FA2915331DC488A831521EAE36FE40154EE191C@dlee06.ent.ti.com>
References: <200909120021.48353.hverkuil@xs4all.nl>
	<4AAD15A3.5080001@gmx.de>,<20090913203136.41bb7ae0@caramujo.chehab.org>
In-Reply-To: <20090913203136.41bb7ae0@caramujo.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In our experience, sysfs was useful for simple control mechanism such as enable/disable or displaying statistics or status. But we had received
customer complaints that with this approach, these functionality will become unavailable when kernel is built without sysfs as part of size
optimization. So if this is really true, I don't think sysfs is the right candidate for MC.  Since sysfs is more string oriented, won't it increase the 
code size when it is used for parsing a lot of variable/value pair to setup device hw configuration ? Besides, most of the application that
is written for TI video drivers are based on ioctl and it would make technical support a nightmare with a different API used for device configuration.

Murali
________________________________________
From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab [mchehab@infradead.org]
Sent: Sunday, September 13, 2009 7:31 PM
To: wk
Cc: Hans Verkuil; linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl

Em Sun, 13 Sep 2009 17:54:11 +0200
wk <handygewinnspiel@gmx.de> escreveu:

> Hans Verkuil schrieb:
> > Hi all,
> >
> > I've started this as a new thread to prevent polluting the discussions of the
> > media controller as a concept.
> >
> > First of all, I have no doubt that everything that you can do with an ioctl,
> > you can also do with sysfs and vice versa. That's not the problem here.
> >
> > The problem is deciding which approach is the best.
> >
> >
>
> Is it really a good idea to create a dependency to some virtual file
> system which may go away in future?
>  From time to time some of those seem to go away, for example devfs.

> Is it really unavoidable to have something in sysfs, something which is
> really not possible with ioctls?
> And do you really want to depend on sysfs developers?

First of all, both ioctl's and sysfs are part of vfs support.

Second: where did you got the wrong information that sysfs would be deprecated?

There's no plan to deprecate sysfs, and, since there are lots of
kernel-userspace API's depending on sysfs, you can't just remove it.

It is completely different from what we had with devfs, where just device names
were created there, on a limited way (for example, no directories were allowed
at devfs). Yet, before devfs removal, sysfs was added to implement the same
features, providing even more functionality.

Removing sysfs is as hard as removing ioctl or procfs support on kernel.
You may change their internal implementation, but not the userspace API.

Btw, if we'll seek for the last internal changes, among those three API's, the more
recent internal changes were at fs API where ioctl support is. There, the
Kernel big logs were removed. This required a review on all driver locks and changes
on almost all v4l/dvb drivers.

Also, wanting or not, sysfs is called on every kernel driver, so this
dependency already exists.

Cheers,
Mauro
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

