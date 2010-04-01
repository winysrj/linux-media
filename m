Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758426Ab0DAQoi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 12:44:38 -0400
Message-ID: <4BB4B569.3080608@redhat.com>
Date: Thu, 01 Apr 2010 12:02:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl> <201004011411.02344.laurent.pinchart@ideasonboard.com> <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>
In-Reply-To: <201004011642.19889.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:

> What to do if we have multiple device nodes? E.g. video0 and vbi0? Should we
> allow access to video0 when vbi0 is not yet registered? Or should we block
> access until all video nodes are registered?

It will depend on the driver implementation, but, as new udev implementations
try to open v4l devices asap, the better is to lock the register operation
to avoid an open while not finished.

I remember I had to do it on em28xx:

This is the init code for it:
	...
        mutex_init(&dev->lock);
        mutex_lock(&dev->lock);
        em28xx_init_dev(&dev, udev, interface, nr);
	...
        request_modules(dev);

        /* Should be the last thing to do, to avoid newer udev's to
           open the device before fully initializing it
         */
        mutex_unlock(&dev->lock);
	...

And this is the open code:

static int em28xx_v4l2_open(struct file *filp)
{
	...
        mutex_lock(&dev->lock);
	...
	mutex_unlock(&dev->lock);


The same lock is also used at the ioctl handlers that need to be protected, like:

static int radio_g_tuner(struct file *file, void *priv,
                         struct v4l2_tuner *t)
{
	...
        mutex_lock(&dev->lock);
        v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
        mutex_unlock(&dev->lock);
	...
}

There are some obvious cases where no lock is needed, like for example
vidioc_querycap.


> 
>> One (far from perfect) solution, would be to add a mutex protecting the entire
>> ioctl loop inside the drivers, and the open/close methods. This can later be
>> optimized by a mutex that will just protect the operations that can actually
>> cause problems if happening in parallel.
> 
> I have thought about this in the past.
> 
> What I think would be needed to make locking much more reliable is the following:
> 
> 1) Currently when a device is unregistered all read()s, write()s, poll()s, etc.
> are blocked. Except for ioctl().
> 
> The comment in v4l2-dev.c says this:
> 
>         /* Allow ioctl to continue even if the device was unregistered.
>            Things like dequeueing buffers might still be useful. */
> 
> I disagree with this. Once the device is gone (USB disconnect and similar
> hotplug scenarios), then the only thing an application can do is to close.
> 
> Allowing ioctl to still work makes it hard for drivers since every ioctl
> op that might do something with the device has to call video_is_registered()
> to check whether the device is still alive.
> 
> I know, this is not directly related to the BKL, but it is an additional
> complication.

Depending on how the video buffers are implemented, you may need to run dequeue,
in order to allow freeing the mmaped memories. That's said, maybe we could use
a kref implementation for those kind or resources.

> 2) Add a new video_device flag that turns on serialization. Basically all
> calls are serialized with a mutex in v4l2_device. To handle blocking calls
> like read() or VIDIOC_DQBUF we can either not take the serialization mutex
> in the core, or instead the driver needs to unlock the mutex before it
> waits for an event and lock it afterwards.
> 
> In the first case the core has to know all the exceptions.
> 
> Perhaps we should just add a second flag: whether the core should do full
> serialization (and the driver will have to unlock/lock around blocking waits)
> or smart serialization where know blocking operations are allowed unserialized.
> 
> I think it is fairly simple to add this serialization mechanism. And for many
> drivers this will actually be more than enough.

I remember I proposed a solution to implement the mutex at V4L core level,
when we had this discussion with Alan Cox BKL patches. 

The conclusion I had from the discussion is that, while this is a simple way, 
it may end that a poorly implemented lock would stay there forever.

Also, core has no way to foresee what the driver is doing on their side, and may
miss some cases where the lock needs to be used.

I don't think that adding flags would help to improve it.

-- 

Cheers,
Mauro
