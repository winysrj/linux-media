Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44001 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0DBRx7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 13:53:59 -0400
Received: by gyg13 with SMTP id 13so1089063gyg.19
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 10:53:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <y2v1a297b361004021043wa43821d2hfb5b573b110dd5e0@mail.gmail.com>
References: <201004011937.39331.hverkuil@xs4all.nl>
	 <4BB4E4CC.3020100@redhat.com>
	 <y2v1a297b361004021043wa43821d2hfb5b573b110dd5e0@mail.gmail.com>
Date: Fri, 2 Apr 2010 13:53:58 -0400
Message-ID: <x2v829197381004021053nf77e2d42q4f1614eced7f999d@mail.gmail.com>
Subject: Re: [RFC] Serialization flag example
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 2, 2010 at 1:43 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Thu, Apr 1, 2010 at 10:24 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>
>> You'll have issues also with -alsa and -dvb parts that are present on the drivers.
>>
>> Also, drivers like cx88 have another PCI device for mpeg-encoded streams. It behaves
>> like two separate drivers (each with its own bind code at V4L core), but, as there's
>> just one PCI bridge, and just one analog video decoder/analog audio decoder, the lock
>> should cross between the different drivers.
>>
>> So, binding videobuf to v4l2_device won't solve the issue with most videobuf-aware drivers,
>> nor the lock will work as expected, at least with most of the devices.
>>
>> Also, although this is not a real problem, your lock is too pedantic: it is
>> blocking access to several ioctl's that don't need to be locked. For example, there are
>> several ioctl's that just returns static: information: capabilities, supported video standards,
>> etc. There are even some cases where dynamic ioctl's are welcome, like accepting QBUF/DQBUF
>> without locking (or with a minimum lock), to allow different threads to handle the buffers.
>>
>> The big issue I see with this approach is that developers will become lazy on checking
>> the locks inside the drivers: they'll just apply the flag and trust that all of their
>> locking troubles were magically solved by the core.
>>
>> Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
>> used internally on the driver. This approach will still be pedantic, as all ioctls will
>> keep being serialized, but at least the driver will need to explicitly handle the lock,
>> and the same lock can be used on other parts of the driver.
>
>
> IMO, A framework shouldn't lock. Why ?
>
> Different devices require different locking schemes, each and every
> device require it in different ways. Some drivers might not even
> require it, since they may be able to handle different systems
> asynchronously.
>
> Locking and such device management, will be known to the driver alone
> and not to any framework. While, this may benefit some few devices the
> other set of devices will eventually be broken.

Hello Manu,

The argument I am trying to make is that there are numerous cases
where you should not be able to use both a particular DVB and V4L
device at the same time.  The implementation of such locking should be
handled by the v4l-dvb core, but the definition of the relationships
dictating which devices cannot be used in parallel is still the
responsibility of the driver.

This way, a bridge driver can say "this DVB device cannot be used at
the same time as this V4L device" but the actual enforcement of the
locking is done in the core.  For cases where the devices can be used
in parallel, the bridge driver doesn't have to do anything.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
