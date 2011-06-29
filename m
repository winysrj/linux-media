Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1F2T1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 15:27:34 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5TJRYZd013927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 15:27:34 -0400
Message-ID: <4E0B7CA3.3010104@redhat.com>
Date: Wed, 29 Jun 2011 16:27:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:xawtv3/master] xawtv: reenable its usage with webcam's
References: <E1Qbdw6-0007wL-E8@www.linuxtv.org> <4E0B05F5.1000704@redhat.com> <4E0B1407.8000907@redhat.com> <4E0B199B.4010008@redhat.com>
In-Reply-To: <4E0B199B.4010008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-06-2011 09:24, Hans de Goede escreveu:
> Hi,
> 
> On 06/29/2011 02:01 PM, Mauro Carvalho Chehab wrote:
>> Em 29-06-2011 08:01, Hans de Goede escreveu:
>>> Hmm, this changes the behavior from what I intended, the idea was to select the
>>> first *tv-card*, without checking for a tuner, there is little value in the auto
>>> device feature. Granted it will still skip v4l2 output only devices but those are
>>> very rare.
>>
>> Your patch broke support for vivi and for video grabber devices. Those devices don't
>> have a tuner.
>>
> 
> I did no such thing as "break support". The new xawtv will still work fine with
> them with an explicit "-c /dev/video#" argument.

Ok. I got confused by your patch, and the error message didn't help.

Anyway, it is fixed. I also made scantv to force for a TV device at auto mode, as it
doesn't sense to scan for TV channels on devices without tuner.
> Granted, maybe the error should be changed to:
> vid-open: could not find a suitable tv-card
> 
> To make things even more clear.

Yes, I've changed it to a message similar to that.

>> There's currently just one detail to be
>> fixed: the window title will be changed to "???" on those devices. This is an
>> old bug, as changing from Television to S-Video or Composite, on a device that
>> has both tuner and grabber capabilities, it will still keep the channel name
>> there. It probably makes sense to print there the input name instead, if the
>> input is not Television.
> 
> Agreed.

Fixed.

>>> The above patch definitely is not what I had in mind. My system has a
>>> bt878 tv card, and a varying number of webcams connected, thus constantly
>>> changing the /dev/video# for the tv-card. The intent of my "auto" device
>>> patches was to make xawtv automatically pick the tvcard.
>>
>> Well, a varying device for /dev/video is something that we need to fix at udev.
>> There are some ways to create persistent rules for that.
>>
>> In a matter of fact, IMO, we should change the V4L2 device nodes reported via
>> udev, to be more intuitive, e. g. instead of creating /dev/video for everything,
>> create /dev/webcam? /dev/grabber? /dev/analog_tv? device nodes, while creating
>> a symlink to /dev/video, in order to not break existing applications that have
>> it hardcoded.
> 
> That sounds like a good idea, but first needs to be written and then make its
> way into distributions, I wanted something which would improve the user experience
> right now, rather then in 2 years.

I see. Yet, I think we should or ping someone from udev team or add it on our TODO
lists. The needed information is probably already there (and there's an udev name
retrieving the information from querycap). I suspect that all it needs to be 
persistent is to add some udev rules.

>>> I intented to mail you about my get_media_devices fixes as well as my
>>> auto device patches, and suggest that we do a new release soon.
>>
>> Yes, I think we should make a release for it soon. There are enough features
>> added on xawtv that justifies doing a new release.
>>
> 
> Agreed,

>From my side, I don't intend to touch on xawtv any time soon. So, maybe we can wait
for a couple days and release version 1.101.

Cheers,
Mauro
