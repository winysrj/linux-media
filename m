Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab2CGQgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 11:36:04 -0500
Message-ID: <4F578E65.4070409@redhat.com>
Date: Wed, 07 Mar 2012 13:35:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: gregkh <gregkh@linuxfoundation.org>
CC: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: A second easycap driver implementation
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com> <4F572611.50607@redhat.com> <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com> <20120307154311.GB14836@kroah.com>
In-Reply-To: <20120307154311.GB14836@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-03-2012 12:43, gregkh escreveu:
> On Wed, Mar 07, 2012 at 11:32:23AM -0300, Ezequiel García wrote:
>> Hi,
>>
>>>
>>> Have you considered instead slowly moving the existing easycap driver
>>> over to all the new infrastructure we have now. For starters replace
>>> its buffer management with videobuf2, then in another patch replace
>>> some other bits, etc. ?  See what I've done to the pwc driver :)
>>
>> Yes. And that was what I was doing until now.
>> Yet, after some work it seemed much easier
>> to simply start over from scratch.

Yes, the driver is weird, as it encapsulates the demod code
inside it , instead of using the saa7115 driver, that covers most
of saa711x devices, including saa7113.

Btw, is this driver really needed? The em28xx driver has support
for the Easy Cap Capture DC-60 model (I had access to one of those
in the past, and I know that the driver works properly).

What's the chipset using on your Easycap device?

If it is not an Empiatech em28xx USB bridge, then it makes sense
to have a separate driver for it. Otherwise, it is just easier
and better to add support for your device there.

>>
>> Besides, it's being a great learning experience :)
>>
>> So, since the driver is not yet working I guess there
>> is no point in submitting anything.
>>
>> Instead, anyone the wants to help I can send what I have now
>> or we can start working through github.
>> If someone owns this device, it would be a *huge* help
>> with testing.
>>
>> However, as soon as this is capturing video I would like
>> to put it on staging, so everyone can help.
>> Is this possible?
> 
> Yes it is, just send the patches to the correct people (note I don't
> control the drivers/staging/media subdirectory.)
> 
> good luck,
> 
> greg k-h

