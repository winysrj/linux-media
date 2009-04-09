Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64517 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935810AbZDIQca (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 12:32:30 -0400
Received: by fxm2 with SMTP id 2so674703fxm.37
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2009 09:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DE2226.7030406@linuxtv.org>
References: <49DE0891.9010506@yahoo.gr>
	 <412bdbff0904090839v43772f6dk7f2ac47ef417f45f@mail.gmail.com>
	 <20090409124810.6c9f73bb@pedra.chehab.org>
	 <d9def9db0904090852v63b71413r616369babeff1d95@mail.gmail.com>
	 <49DE2226.7030406@linuxtv.org>
Date: Thu, 9 Apr 2009 18:32:27 +0200
Message-ID: <d9def9db0904090932o4438902bt83d303f0853e5e11@mail.gmail.com>
Subject: Re: Multiple em28xx devices
From: Markus Rechberger <mrechberger@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	rvf16 <rvf16@yahoo.gr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 9, 2009 at 6:28 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Markus Rechberger wrote:
>>
>> On Thu, Apr 9, 2009 at 5:48 PM, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>>
>>> On Thu, 9 Apr 2009 11:39:47 -0400
>>> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>>>
>>>> 2009/4/9 rvf16 <rvf16@yahoo.gr>:
>>>>>
>>>>> So does the upstream driver support all the rest ?
>>>>> Analog TV
>>>>
>>>> Yes
>>>>
>>>>> FM radio
>>>>
>>>> No
>>>
>>> Yes, it does support FM radio, provided that you proper add radio
>>> specific
>>> configuration at em28xx-cards.c.
>>>
>>
>> I plan to add support for it to the existing kerneldriver anyway, but
>> by using userspace drivers.
>> Those drivers are just ontop of everything and no changes are required
>> for the existing drivers.
>>
>> I'll just intercept all the calls as I do right now already with the
>> latest device. I ported the entire configuration framework to userland
>> and it also works on Apple OSX without any change. I'm just using
>> usbfs for it, PCI config support is possible by using libpci or
>> opening the corresponding node in the proc filesystem too. This time
>> there's nothing you can do against it since it requires no change as
>> it is.
>
> Userspace drivers won't be accepted but it's not worth re-opening that old
> wound - especially since I haven't followed this specific thread.
>

no problem, as I wrote it sits ontop of everything not needing any kernel hooks.

> I _am_ interested in the fact that you've ported GPL code (frameworks and/or
> drivers) to Apple, creating derived works.
>

hehe, I did not touch any GPL code.

> Obviously you'll need to make those changes to the community. Where can I
> download these?

The framework will be opened when it's time to be opened, right now
it's only available to interested developers.

Markus
