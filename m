Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0ITCrN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 22:47:13 -0400
Message-ID: <4C96CB28.2000705@redhat.com>
Date: Sun, 19 Sep 2010 23:47:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <201009191229.35800.hverkuil@xs4all.nl> <201009192106.47601.hverkuil@xs4all.nl> <4C967082.3040405@redhat.com> <201009192310.04435.hverkuil@xs4all.nl>
In-Reply-To: <201009192310.04435.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 18:10, Hans Verkuil escreveu:
> On Sunday, September 19, 2010 22:20:18 Mauro Carvalho Chehab wrote:
>> Em 19-09-2010 16:06, Hans Verkuil escreveu:
>>> On Sunday, September 19, 2010 20:29:58 Mauro Carvalho Chehab wrote:
>>>> Em 19-09-2010 11:58, Hans Verkuil escreveu:
>>>>> On Sunday, September 19, 2010 13:43:43 Mauro Carvalho Chehab wrote:
>>>>
>>> Multiple stream per device node: if you are talking about allowing e.g. both VBI streaming
>>> and video streaming from one device node, then that is indeed allowed by the current spec.
>>> Few drivers support this though, and it is a really bad idea. During the Helsinki meeting we
>>> agreed to remove this from the spec (point 10a in the mini summit report).
>>
>> I'm talking about read(), overlay and mmap(). The spec says, at "Multiple Opens" [1]:
>> 	"When a device supports multiple functions like capturing and overlay simultaneously,
>> 	 multiple opens allow concurrent use of the device by forked processes or specialized applications."
>>
>> [1] http://linuxtv.org/downloads/v4l-dvb-apis/ch01.html#id2717880
>>
>> So, it is allowed by the spec. What is forbidden is to have some copy logic in kernel to duplicate data.
> 
> There is no streaming involved with overlays, is there? It is all handled in the driver and
> userspace just tells the driver where the window is. I may be wrong, I'm much more familiar
> with output overlays (OSD). Are overlays actually still working anywhere these days?

It depends on what you call streaming. On overlay mode, there's a PCI2PCI transfer stream, from video 
capture memory into the video adapter memory. It is still a stream, even though it is not "visible"
after started.

>> Besides that, not all device drivers will work with all applications or provide the complete set of
>> functionalities. For example, there are only three drivers (ivtv, cx18 and pvrusb2), as far as I remember, 
>> that only implements read() method. By using your logic that "only a few drivers allow feature X", maybe
>> we should deprecate read() as well ;)
> 
> There's nothing wrong with read. But reading while streaming at the same time from the same source,
> that's another matter. 

You may not like its implementation, but it is currently in use, and there's nothing at spec
forbidding it.

> And I'm hoping that vb2 will make it possible to implement streaming in
> ivtv and cx18.

Ok. That's another reason why we should lock poll/read.

> <snip>
> 
>>>> The problem with the current implementation of v4l2_fh() is that there's no way for the core
>>>> to get per-fh info.
>>>
>>> You mean how to get from a struct file to a v4l2_fh? That should be done through
>>> filp->private_data, but since many driver still put other things there, that is not
>>> really usable at the moment without changing all those drivers first.
>>
>> It should be drivers decision to put whatever they want on a "priv_data". If you want to have
>> core data, then you need to use embeed for the core, but keeping priv_data for private driver's
>> internal usage. That's the standard way used on Linux. You're doing just the reverse ;)
> 
> I don't follow your reasoning here.

What kernel does, in general, is to use a "class inheritance" by embeding one struct into another.
This is used mainly on the core structs. For drivers, it provides void *priv data for internal driver-only
usage.

The way you're wanting to do with v4l2_fh is just the reverse: use priv_data for core usage, and embed 
struct for the drivers.

>>> This actually will work correctly. When a device node is registered in cx88, it is already
>>> hooked into the v4l2_device of the core struct. This was needed to handle the i2c subdevs
>>> in the right place: the cx88 core struct. So refcounting will also be done in the core struct.
>>
>> No. Look at the actual code. For example, this is what cx88-mpeg does:
>>
>> struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
>>
>> cx88 core is at dev->core.
>>
>> The same happens with cx88-video, using struct cx8800:
>>
>> struct cx8800_dev *dev = pci_get_drvdata(pci_dev);
>>
>> cx88 core is also at dev->core.
>>
>> This device is implemented using multiple PCI devices, one for each function. Function 0 (video) and Function 2
>> (used for TS devices, like mpeg encoders) can be used independently, but there are some data that are concurrent.
>> So, drivers will likely need to use two locks, one for the core and one for the function.
> 
> I was talking about refcounting in cx88 using my patch, not locking. Locking in
> cx88 will almost certainly need two locks.

Depending on the way the cx88 core lock will be implemented, you may need to unlock it before release.

I just arguing that it needs to take more care/review at cx88, in order to avoid having a dead lock there.

Cheers,
Mauro
