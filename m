Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab0DARgx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:36:53 -0400
Message-ID: <4BB4D9AB.6070907@redhat.com>
Date: Thu, 01 Apr 2010 14:36:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>	 <201004011411.02344.laurent.pinchart@ideasonboard.com>	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>	 <4BB4B569.3080608@redhat.com> <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>
In-Reply-To: <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Apr 1, 2010 at 11:02 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> I remember I had to do it on em28xx:
>>
>> This is the init code for it:
>>        ...
>>        mutex_init(&dev->lock);
>>        mutex_lock(&dev->lock);
>>        em28xx_init_dev(&dev, udev, interface, nr);
>>        ...
>>        request_modules(dev);
>>
>>        /* Should be the last thing to do, to avoid newer udev's to
>>           open the device before fully initializing it
>>         */
>>        mutex_unlock(&dev->lock);
>>        ...
>>
>> And this is the open code:
>>
>> static int em28xx_v4l2_open(struct file *filp)
>> {
>>        ...
>>        mutex_lock(&dev->lock);
>>        ...
>>        mutex_unlock(&dev->lock);
>>
> 
> It's probably worth noting that this change is actually pretty badly
> broken.  Because the modules are loading asynchronously, there is a
> high probability that the em28xx-dvb driver will still be loading when
> hald connects in to the v4l device.  That's the big reason people
> often see things like tvp5150 i2c errors when the driver is first
> loaded up.
> 
> It's a good idea in theory, but pretty fatally flawed due to the async
> loading (as to make it work properly you would have to do something
> like locking the mutex in em28xx and clearing it in em28xx-dvb at the
> end of its initialization).

If you take a look at em28xx-dvb, it is not lock-protected. If the bug is due
to the async load, we'll need to add the same locking at *alsa and *dvb
parts of em28xx.

Yet, in this specific case, as the errors are due to the reception of
wrong data from tvp5150, maybe the problem is due to the lack of a 
proper lock at the i2c access. 


> 
> Devin
> 


-- 

Cheers,
Mauro
