Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0ISUU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 16:20:29 -0400
Message-ID: <4C967082.3040405@redhat.com>
Date: Sun, 19 Sep 2010 17:20:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <201009191229.35800.hverkuil@xs4all.nl> <201009191658.11346.hverkuil@xs4all.nl> <4C9656A6.80303@redhat.com> <201009192106.47601.hverkuil@xs4all.nl>
In-Reply-To: <201009192106.47601.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 16:06, Hans Verkuil escreveu:
> On Sunday, September 19, 2010 20:29:58 Mauro Carvalho Chehab wrote:
>> Em 19-09-2010 11:58, Hans Verkuil escreveu:
>>> On Sunday, September 19, 2010 13:43:43 Mauro Carvalho Chehab wrote:
>>
>>>> A per-dev lock may not be good on devices where you have lots of interfaces, and that allows
>>>> more than one stream per interface.
>>>
>>> My proposal is actually a lock per device node, not per device (although that's
>>> what many simple drivers probably will use).
>>
>> Yes, that's what I meant. However, V4L2 API allows multiple opens and multiple streams per
>> device node (and this is actually in use by several drivers).
> 
> Just to be clear: multiple opens is a V4L2 requirement. Some older drivers had exclusive
> access, but those are gradually fixed.
> 
> Multiple stream per device node: if you are talking about allowing e.g. both VBI streaming
> and video streaming from one device node, then that is indeed allowed by the current spec.
> Few drivers support this though, and it is a really bad idea. During the Helsinki meeting we
> agreed to remove this from the spec (point 10a in the mini summit report).

I'm talking about read(), overlay and mmap(). The spec says, at "Multiple Opens" [1]:
	"When a device supports multiple functions like capturing and overlay simultaneously,
	 multiple opens allow concurrent use of the device by forked processes or specialized applications."

[1] http://linuxtv.org/downloads/v4l-dvb-apis/ch01.html#id2717880

So, it is allowed by the spec. What is forbidden is to have some copy logic in kernel to duplicate data.

> 
>>>> So, I did a different implementation, implementing the mutex pointer per file handler.
>>>> On devices that a simple lock is possible, all you need to do is to use the same locking
>>>> for all file handles, but if drivers want a finer control, they can use a per-file handler
>>>> lock.
>>>
>>> I am rather unhappy about this. First of all, per-filehandle locks are pretty pointless. If
>>> you need to serialize for a single filehandle (which would only be needed for multithreaded
>>> applications where the threads use the same filehandle), then you definitely need to serialize
>>> between multiple file handles that are open on the same device node.
>>
>> On multithread apps, they'll share the same file handle, so, there's no issue. Some applications
>> like xawtv and xdtv allows recording a video by starting another proccess that will use the read() 
>> interface for one stream, while the other stream is using mmap() (or overlay) will have two different
>> file handlers, one for each app. That's said, a driver using per-fh locks will likely need to
>> have an additional lock for global resources. I didn't start porting cx88 driver, but I suspect
>> that it will need to use it.
> 
> That read/mmap construct was discussed as well in Helsinki (also point 10a). I quote from the report:
> 
> "Mixed read() and mmap() streaming. Allow or disallow? bttv allows it, which is against the spec since
> it only has one buffer queue so a read() will steal a frame. No conclusion was reached. Everyone thought
> it was very ugly but some apps apparently use this. Even though few drivers actually support this functionality."
> 
> Applications must be able to work without this 'feature' since so few drivers allow this. And it
> is against the spec as well. Perhaps we should try to remove this 'feature' and see if the apps
> still work. If they do, then kill it. It's truly horrible. And it is definitely not a reason to
> choose a overly complex locking scheme just so that some old apps can do a read and dqbuf at the
> same time.

xawtv will stop working in record mode. It is one of the applications we added on our list that
we should use as reference.

I'm not against patching it to implement a different logic for record. Patches are welcome.

Considering that, currently, very few applications allow recording (I think only xawtv/xdtv, both using
ffmpeg or mencoder for record) and mythtv are the only ones, I don't think we should remove it, without
having it implemented on more places.

Besides that, not all device drivers will work with all applications or provide the complete set of
functionalities. For example, there are only three drivers (ivtv, cx18 and pvrusb2), as far as I remember, 
that only implements read() method. By using your logic that "only a few drivers allow feature X", maybe
we should deprecate read() as well ;)

> 
>>> The device node is the right place for this IMHO.
>>>
>>> Regarding creating v4l2_fh structs in the core: many simple drivers do not need a v4l2_fh
>>> at all, and the more complex drivers often need to embed it in a larger struct.
>>>
>>> The lookup get_v4l2_fh function also is unnecessary if we do not create these structs and
>>> so is the *really* ugly reinit_v4l2_fh.
>>
>> The reinit_v4l2_fh() is a temporary workaround, to avoid the need of rewriting the v4l2_fh
>> implementation at ivtv, while keeping it work properly.
>>
>> There are other ways to allow drivers to embed a per-fh data for the more complex devices, like
>> adding a void *priv pointer, and letting the drivers to do whatever they want.
> 
> I've become a big fan of embedded data structures. It's the standard way the kernel structs
> operate and it is the correct one as well. I don't like those void pointers. You loose all
> type checking that way, and it makes managing the memory harder as well. It's the last
> resort for me.

void *priv is also the standard way to support embeed data. So, it is also a valid approach.

>> The problem with the current implementation of v4l2_fh() is that there's no way for the core
>> to get per-fh info.
> 
> You mean how to get from a struct file to a v4l2_fh? That should be done through
> filp->private_data, but since many driver still put other things there, that is not
> really usable at the moment without changing all those drivers first.

It should be drivers decision to put whatever they want on a "priv_data". If you want to have
core data, then you need to use embeed for the core, but keeping priv_data for private driver's
internal usage. That's the standard way used on Linux. You're doing just the reverse ;)

>>>> We could need to do some changes there to cover the case where videobuf sleeps, maybe using
>>>> mutex_lock_interruptible at core, in order to allow abort userspace, if the driver fails
>>>> to fill the buffers (tests are needed).
>>>
>>> Regarding the (very courageous!) videobuf patches: I'm impressed. But videobuf must really
>>> release the lock in waiton. 
>>
>> Well, mutex is allowed to be locked while scheduling. That's why it uses a mutex, instead of a
>> spinlock. So, it seems to be safe. Yet, I agree that it should be releasing it at waiton, 
>> in order to avoid troubles with some kernel threads that may be needing to lock to access
>> the same data. So, the code will likely need to be changed in order to work with some drivers.
> 
> It's safe, sure, but a major blocker in the literal sense. If for some reason no new frames
> arrive, then the whole system grinds to a halt because everyone is waiting for that mutex to
> be release.

This need to be fixed, that's for sure, but only the userspace app and the driver will be blocked,
while the buffer timeout doesn't happen. AFAIK, all drivers have a timeout to return error if
the stream stops.

>>> Right now no other access can be done while it is waiting. That
>>> is not acceptable. The same issue appears in the VIDIOC_DQEVENT core handler, although it
>>> is easy to solve there.
>>>
>>> For videobuf it might be better to pass a pointer to the serializing mutex as an argument.
>>> Then videobuf can use that to unlock/relock when it has to wait. Not elegant, but hopefully
>>> we can do better in vb2.
>>
>> Having two mutexes passing as parameter for vb would be a confusing interface. Maybe the better is
>> to postpone such change to happen after having all drivers ported to the new locking schema.
> 
> I'm OK with that as a temporary measure during developing the patch series, but what enters
> the mainline should be working correctly in this respect. I.e. no mutex should be held when
> the driver has to wait for a new frame (or a new event for that matter). Other apps must be
> able to open/read/ioctl/whatever during that time.

If we'll be fast enough to write the entire series, that would be the better. I'm afraid that
there are too many drivers using it nowadays. Perhaps we could create a new videobuf init call
for the new mutex.

>>> My suggestion would be to use your videobuf patches, but use my idea for the mutex pointer
>>> in struct video_device. Best of both worlds :-)
>>
>> Maybe.
> 
> Hmmm. I need to do more work to convince you :-)

:)

>>>>> One other thing that I do not like is this:
>>>>>
>>>>>         /* Allow ioctl to continue even if the device was unregistered.
>>>>>            Things like dequeueing buffers might still be useful. */
>>>>>         return vdev->fops->unlocked_ioctl(filp, cmd, arg);
>>>>>
>>>>> I do not believe drivers can do anything useful once the device is unregistered
>>>>> except just close the file handle. There are two exceptions to this: poll()
>>>>> and VIDIOC_DQEVENT.
>>>>>
>>>>> Right now drivers have no way of detecting that a disconnect happened. It would
>>>>> be easy to add a disconnect event and let the core issue it automatically. The
>>>>> only thing needed is that VIDIOC_DQEVENT ioctls are passed on and that poll
>>>>> raises an exception. Since all the information regarding events is available in
>>>>> the core framework it is easy to do this transparently.
>>>>>
>>>>> So effectively, once a driver unregistered a device node it will never get
>>>>> called again on that device node except for the release call. That is very
>>>>> useful for a driver.
>>>>>
>>>>> And since we can do this in the core, it will also be consistent for all
>>>>> drivers.
>>>>
>>>> I think we should implement a way to detect disconnections. This will allow simplifying the
>>>> code at the drivers. Yet, I don't think that the solution is (only) to create an
>>>> event. Instead, we need to see how this information could be retrieved from the bus.
>>>> As the normal case for disconnections is for USB devices, we basically need to implement
>>>> a callback when a diconnection happens. The USB core knows about that, but I don't know
>>>> if it provides a callback for it.
>>>
>>> Well, USB drivers have a disconnect callback. All V4L2 USB drivers hook into that.
>>> What they are supposed to do is to unregister all video nodes. That sets the 'unregistered'
>>> in the core preventing any further access.
>>
>> I don't think all drivers implement it. I need to double check.
> 
> If a USB driver doesn't, then that's a driver bug. It will almost certainly crash if
> you disconnect unexpectedly. Not that the presence of that callback gives you any
> guarantees: usbvision has the callback but crashes spectacularly when you disconnect
> while capturing :-(
>  
>>>> If it provides, drivers may just implement the callback,
>>>> calling buffer_release, and saying to V4L2 core that the device is disconnected. V4L2 core
>>>> can then properly handle any new fops to that device, passing to the device just the
>>>> close() events, returning -ENODEV and POLLERR for userspace.
>>>
>>> That basically is what happens right now. Except for passing on the ioctls which is a bad
>>> idea IMHO.
>>
>> Yeah. If core already knows that the device got disconnected, it can just use a default handler
>> for disconnected devices, instead of passing ioctls to the drivers.
>>
>>> BTW: one other thing I've worked on today is a global release callback in v4l2_device.
>>> Right now we have proper refcounting for struct video_device, but if a driver has multiple
>>> device nodes, then it can be hard to tell when all of them are properly released and it
>>> is safe to release the full device instance.
>>>
>>> I made a fairly straightforward implementation available here:
>>>
>>> http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/v4l2core
>>>
>>> Without a global release it is almost impossible to cleanup a driver like usbvision
>>> correctly.
>>
>> It seems interesting. Not sure how we can use it on drivers like cx88, but it is probably ok
>> for most of the drivers. In the case of cx88, the refcount should be done at cx88 core struct,
>> that it is used by 4 different drivers (3 of them opening V4L devices: cx88, cx88-mpeg, cx88-blackbird,
>> plust cx88-alsa).
> 
> This actually will work correctly. When a device node is registered in cx88, it is already
> hooked into the v4l2_device of the core struct. This was needed to handle the i2c subdevs
> in the right place: the cx88 core struct. So refcounting will also be done in the core struct.

No. Look at the actual code. For example, this is what cx88-mpeg does:

struct cx8802_dev *dev = pci_get_drvdata(pci_dev);

cx88 core is at dev->core.

The same happens with cx88-video, using struct cx8800:

struct cx8800_dev *dev = pci_get_drvdata(pci_dev);

cx88 core is also at dev->core.

This device is implemented using multiple PCI devices, one for each function. Function 0 (video) and Function 2
(used for TS devices, like mpeg encoders) can be used independently, but there are some data that are concurrent.
So, drivers will likely need to use two locks, one for the core and one for the function.

Cheers,
Mauro.
