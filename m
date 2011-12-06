Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab1LFNnp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 08:43:45 -0500
Message-ID: <4EDE1C0C.2060701@redhat.com>
Date: Tue, 06 Dec 2011 11:43:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE HVR-930C
 again
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com> <1321800978-27912-2-git-send-email-mchehab@redhat.com> <1321800978-27912-3-git-send-email-mchehab@redhat.com> <1321800978-27912-4-git-send-email-mchehab@redhat.com> <1321800978-27912-5-git-send-email-mchehab@redhat.com> <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com> <4EDD0F01.7040808@redhat.com> <CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com> <CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com> <CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com> <CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com> <4EDE0FD7.4020603@teksavvy.com>
In-Reply-To: <4EDE0FD7.4020603@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-12-2011 10:51, Mark Lord wrote:
> On 11-12-05 06:47 PM, Devin Heitmueller wrote:
>> On Mon, Dec 5, 2011 at 6:32 PM, Eddi De Pieri<eddi@depieri.net>  wrote:
>>> Sorry,  I think I applied follow patch on my tree while I developed
>>> the driver trying to fix tuner initialization.
>>>
>>> http://patchwork.linuxtv.org/patch/6617/
>>>
>>> I forgot to remove from my tree after I see that don't solve anything.
>>
>> Ok, great.  At least that explains why it's there (since I couldn't
>> figure out how on Earth the patch made sense otherwise).
>>
>> Eddi, could you please submit a patch removing the offending code?
>
>
> That's good.
>
> But there definitely still is a race between modules in there somewhere.
> The HVR-950Q tuners use several:  xc5000, au8522, au0828, ..
> and unless au0828 is loaded *last*, with a delay before/after,
> the dongles don't always work.  Preloading all of the modules
> before allowing hardware detection seems to help.
>
> Even just changing from a mechanical hard drive to a very fast SSD
> is enough to change the behaviour from not-working to working
> (and sometimes the other way around).
>
> I tried to track this down a couple of years ago,
> and found cross-module calls failing because the
> target functions hadn't been loaded yet.
> But my lack of notes from 2-3 years ago isn't helpful here.
>
> Here's a similar report from 2 years ago, as valid today as it was then:
>
>    http://www.mythtv.org/pipermail/mythtv-users/2010-January/279912.html

The driver who binds everything is the bridge driver. In your case, it is
the au0828 driver.

What you're experiencing seems to be some race issue inside it, and not at xc5000.

On a quick look on it, I'm noticing that there's no lock at au0828_usb_probe().

Also, it uses a separate lock for analog and for digital:

	mutex_init(&dev->mutex);
	mutex_init(&dev->dvb.lock);

Probably, the right thing to do would be to use just one lock for both rising
it at usb_probe, lowering it just before return 0. This will avoid any open
operations while the device is not fully initialized. Btw, newer udev's open
the analog part of the driver just after V4L register, in order to get the
device capabilities. This is known to cause race conditions, if the locking
schema is not working properly.

Regards,
Mauro.
