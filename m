Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1LFPoV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 10:44:21 -0500
Message-ID: <4EDE384F.6030301@redhat.com>
Date: Tue, 06 Dec 2011 13:44:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE HVR-930C
 again
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com> <1321800978-27912-2-git-send-email-mchehab@redhat.com> <1321800978-27912-3-git-send-email-mchehab@redhat.com> <1321800978-27912-4-git-send-email-mchehab@redhat.com> <1321800978-27912-5-git-send-email-mchehab@redhat.com> <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com> <4EDD0F01.7040808@redhat.com> <CAGoCfizRuBEgBhfnzyrE=aJD-WMXCz9OmkoEqQCDpqmYXU2=zA@mail.gmail.com> <CAGoCfiywqY+U0+t9tget1X09=apDm46GpGCa-_QiGp+JhyLXxQ@mail.gmail.com> <CAKdnbx7Ayg6AGS-u=z9Pg6pHV6UN_ZiB-kQ1rv78zG9nm+U9TA@mail.gmail.com> <CAGoCfiwwt898OwmNNwrboT7q5v-sNQuTP6TxCdtY-fFauAyHrA@mail.gmail.com> <4EDE0FD7.4020603@teksavvy.com> <4EDE1C0C.2060701@redhat.com> <CAGoCfizuMQMz3_ihh1AB2uRUn5-1DkCVju1VFMzOnUkqA+tJJQ@mail.gmail.com> <4EDE34B7.9030609@teksavvy.com>
In-Reply-To: <4EDE34B7.9030609@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-12-2011 13:28, Mark Lord wrote:
> On 11-12-06 08:56 AM, Devin Heitmueller wrote:
>> On Tue, Dec 6, 2011 at 8:43 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com>  wrote:
>>> The driver who binds everything is the bridge driver. In your case, it is
>>> the au0828 driver.
>>>
>>> What you're experiencing seems to be some race issue inside it, and not at
>>> xc5000.
>>>
>>> On a quick look on it, I'm noticing that there's no lock at
>>> au0828_usb_probe().
>>>
>>> Also, it uses a separate lock for analog and for digital:
>>>
>>>         mutex_init(&dev->mutex);
>>>         mutex_init(&dev->dvb.lock);
>>>
>>> Probably, the right thing to do would be to use just one lock for both
>>> rising
>>> it at usb_probe, lowering it just before return 0. This will avoid any open
>>> operations while the device is not fully initialized. Btw, newer udev's open
>>> the analog part of the driver just after V4L register, in order to get the
>>> device capabilities. This is known to cause race conditions, if the locking
>>> schema is not working properly.
>>
>> Just to be clear, we're now talking about a completely different race
>> condition that has nothing to do with the subject at hand, and this
>> discussion should probably be moved to a new thread.
>
> If this discussion does change threads, could you folks please copy me
> on it?  I'm already subscribed to several other kernel mailing lists
> in my roles as developer and maintainer of various bits, but I would
> like to avoid having yet another daily deluge added to my inbox.  :)
>
> That said, I can test possible fixes for this stuff,
> and am rather interested to see it resolved.
> ..
>> The notion that this is something that has been there for over a year
>> is something I only learned of in the last couple of days.  All the
>> complaints I had seen thus far were from existing users who were
>> perfectly happy until they upgraded their kernel a couple of months
>> ago and then started seeing the problem.
> ..
>
> It's always exhibited races for me here.  I have long since worked around
> the issue(s), so my own systems currently behave.   But with the newer
> HVR-950Q revision (B4F0), the issue is far more prevalent than before.
>
> I may try Mauro's locking suggestion -- more detail or a patch would be useful.

You may take a look at the lock changes applied on em28xx driver for some examples.
You basically need to block access to DVB while the device is handling a V4L syscall
and vice-versa.

Changing the locking schema is not trivial, as it may generate dead locks. So,
careful testing is required. It also helps to compile a kernel with the dead lock
detection logic enabled, as it may help you to discover if you did something wrong.

Regards,
Mauro

>
> Mauro?

