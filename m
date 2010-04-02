Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54811 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab0DBRnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 13:43:25 -0400
Received: by fxm27 with SMTP id 27so573894fxm.28
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 10:43:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB4E4CC.3020100@redhat.com>
References: <201004011937.39331.hverkuil@xs4all.nl>
	 <4BB4E4CC.3020100@redhat.com>
Date: Fri, 2 Apr 2010 21:43:22 +0400
Message-ID: <y2v1a297b361004021043wa43821d2hfb5b573b110dd5e0@mail.gmail.com>
Subject: Re: [RFC] Serialization flag example
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 1, 2010 at 10:24 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> You'll have issues also with -alsa and -dvb parts that are present on the drivers.
>
> Also, drivers like cx88 have another PCI device for mpeg-encoded streams. It behaves
> like two separate drivers (each with its own bind code at V4L core), but, as there's
> just one PCI bridge, and just one analog video decoder/analog audio decoder, the lock
> should cross between the different drivers.
>
> So, binding videobuf to v4l2_device won't solve the issue with most videobuf-aware drivers,
> nor the lock will work as expected, at least with most of the devices.
>
> Also, although this is not a real problem, your lock is too pedantic: it is
> blocking access to several ioctl's that don't need to be locked. For example, there are
> several ioctl's that just returns static: information: capabilities, supported video standards,
> etc. There are even some cases where dynamic ioctl's are welcome, like accepting QBUF/DQBUF
> without locking (or with a minimum lock), to allow different threads to handle the buffers.
>
> The big issue I see with this approach is that developers will become lazy on checking
> the locks inside the drivers: they'll just apply the flag and trust that all of their
> locking troubles were magically solved by the core.
>
> Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
> used internally on the driver. This approach will still be pedantic, as all ioctls will
> keep being serialized, but at least the driver will need to explicitly handle the lock,
> and the same lock can be used on other parts of the driver.


IMO, A framework shouldn't lock. Why ?

Different devices require different locking schemes, each and every
device require it in different ways. Some drivers might not even
require it, since they may be able to handle different systems
asynchronously.

Locking and such device management, will be known to the driver alone
and not to any framework. While, this may benefit some few devices the
other set of devices will eventually be broken.


Manu
