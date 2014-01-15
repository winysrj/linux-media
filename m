Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41620 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaAOSrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:47 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so684349eaj.12
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 10:47:46 -0800 (PST)
Message-ID: <52D6D81A.10309@googlemail.com>
Date: Wed, 15 Jan 2014 19:48:58 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/7] em28xx: Only deallocate struct em28xx after finishing
 all extensions
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-4-git-send-email-m.chehab@samsung.com> <52D4383B.6030304@googlemail.com> <20140113172334.191862a7@samsung.com> <52D460D8.1000807@googlemail.com> <20140114111054.58ede4a3@samsung.com> <52D57E2C.2070407@googlemail.com> <20140114165512.2d14af95@samsung.com> <52D5A290.8040605@googlemail.com> <20140114192013.578b6b2f@samsung.com>
In-Reply-To: <20140114192013.578b6b2f@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.01.2014 22:20, schrieb Mauro Carvalho Chehab:
> Em Tue, 14 Jan 2014 21:48:16 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 14.01.2014 19:55, schrieb Mauro Carvalho Chehab:
>>> Em Tue, 14 Jan 2014 19:13:00 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
> ...
>>>> At first glance it seems there are at least 2 issues:
>>>> 1.) use after freeing in v4l-extension (happens when the device is 
>>>> closed after the usb disconnect)
>>> That's basically what this patch fixes. Both V4L2 and ALSA handles it
>>> well, if you warn the subsystem that a device will be removed.
>>>
>>> If are there still any issues, we may add a kref_get() at device open,
>>> an a kref_put() at device close on the affected sub-driver.
>> Ok, I've tested it and I was right here.
>> This is what happens when closing a disconnected device:
>>
>> [  144.045691] usb 1-8: USB disconnect, device number 7
>> [  144.047387] em2765 #0: disconnecting em2765 #0 video
>> [  144.047403] em2765 #0: V4L2 device video1 deregistered
>> [  144.050197] em2765 #0: Deregistering snapshot button
>> [  144.058336] em2765 #0: Freeing device
>> [  147.525267] : em28xx_v4l2_close() called
>> [  147.525287] : em28xx_videodevice_release() called
>>
>>
>> I will make some tests tomorrow, but here is a first suggestion how to
>> fix this:
>>
>> Remove the kref_put() call from em28xx_v4l2_fini().
>> Instead, add the following lines to em28xx_videodevice_release():
>>
>> if (dev->users == 0) {
>>         dev->users--; /* avoid multiple kref_put() calls when the
>> devices are unregistered and no device is open */
>>         kref_put(&dev->ref, em28xx_free_device);
>> }
>>
>> That should fix it.
> What I actually did on version 2 (already submitted) is that it is calling 
> kref_get() at open, and kref_put() at close.
Yes, that's even better.

>
>> Interestingly no oops happens. I will have to take a closer look at this
>> tomorrow, but I suspect that the dev we obtain from struct file filp is
>> an outdated copy of the original device struct.
> Likely.
>
>> If that would be true and no bad things can happen in the close()
>> function we actually wouldn't need kref for the v4l extension at all.
> Still, it will be writing on a deallocated buffer, and this can be
> making some memory used by some other part of the Kernel dirty.
>
>> Of course, the ideal solution would be, if we could just clear the
>> device struct at the end of the usb disconnect handler, because we can
>> be sure that the fini() functions have already made sure that dev isn't
>> used anymore.
>>
>> Btw, what happens in em28xx-audio ?
>> Does the ALSA core also allow to call the close() function when the
>> device is already gone ?
> I suspect so. This is what happens when I remove HVR-950 while both
> audio and video are still streaming:
>
> [ 4313.540907] usb 3-4: USB disconnect, device number 7
> [ 4313.541280] em2882/3 #0: Disconnecting em2882/3 #0
> [ 4313.541313] em2882/3 #0: Closing video extension
> [ 4313.541352] em2882/3 #0: V4L2 device vbi0 deregistered
> [ 4313.541635] em2882/3 #0: V4L2 device video0 deregistered
> [ 4313.542188] em2882/3 #0: Closing audio extension
>
> (I waited for ~5 secs before removing the driver)
>
> [ 4317.470747] em2882/3 #0: couldn't setup AC97 register 2
> [ 4317.470772] em2882/3 #0: couldn't setup AC97 register 4
> [ 4317.470785] em2882/3 #0: couldn't setup AC97 register 6
> [ 4317.470797] em2882/3 #0: couldn't setup AC97 register 54
> [ 4317.470810] em2882/3 #0: couldn't setup AC97 register 56
> [ 4317.470950] em2882/3 #0: Closing DVB extension
> [ 4317.471890] xc2028 19-0061: destroying instance
> [ 4317.471913] em2882/3 #0: Closing input extension
> [ 4317.489374] em2882/3 #0: Freeing device
>
> As the code now have a kref for open/close on both audio and video
> extensions, that means that em28xx close was called after device
> removal, as otherwise, we won't see the "Freeing device" print.
Ok, thanks.
I will make further tests now.

Regards,
Frank
