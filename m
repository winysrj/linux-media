Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:57490 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZDIQ2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 12:28:31 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHU002XJDRAB1J0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 09 Apr 2009 12:28:24 -0400 (EDT)
Date: Thu, 09 Apr 2009 12:28:22 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Multiple em28xx devices
In-reply-to: <d9def9db0904090852v63b71413r616369babeff1d95@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	rvf16 <rvf16@yahoo.gr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <49DE2226.7030406@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49DE0891.9010506@yahoo.gr>
 <412bdbff0904090839v43772f6dk7f2ac47ef417f45f@mail.gmail.com>
 <20090409124810.6c9f73bb@pedra.chehab.org>
 <d9def9db0904090852v63b71413r616369babeff1d95@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Rechberger wrote:
> On Thu, Apr 9, 2009 at 5:48 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> On Thu, 9 Apr 2009 11:39:47 -0400
>> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>>
>>> 2009/4/9 rvf16 <rvf16@yahoo.gr>:
>>>> So does the upstream driver support all the rest ?
>>>> Analog TV
>>> Yes
>>>
>>>> FM radio
>>> No
>> Yes, it does support FM radio, provided that you proper add radio specific
>> configuration at em28xx-cards.c.
>>
> 
> I plan to add support for it to the existing kerneldriver anyway, but
> by using userspace drivers.
> Those drivers are just ontop of everything and no changes are required
> for the existing drivers.
> 
> I'll just intercept all the calls as I do right now already with the
> latest device. I ported the entire configuration framework to userland
> and it also works on Apple OSX without any change. I'm just using
> usbfs for it, PCI config support is possible by using libpci or
> opening the corresponding node in the proc filesystem too. This time
> there's nothing you can do against it since it requires no change as
> it is.

Userspace drivers won't be accepted but it's not worth re-opening that old wound 
- especially since I haven't followed this specific thread.

I _am_ interested in the fact that you've ported GPL code (frameworks and/or 
drivers) to Apple, creating derived works.

Obviously you'll need to make those changes to the community. Where can I 
download these?

Thanks,

- Steve


