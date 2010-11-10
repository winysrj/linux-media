Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab0KJXgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 18:36:39 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1269064wyb.19
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 15:36:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101111002952.f5873ed4.ospite@studenti.unina.it>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	<AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
	<20101110222418.6098a92a.ospite@studenti.unina.it>
	<AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
	<AANLkTim4hzoTg4t-jHFUCrpQwQ9Pj2sbJAH=iuawrK7E@mail.gmail.com>
	<20101111002952.f5873ed4.ospite@studenti.unina.it>
Date: Thu, 11 Nov 2010 00:36:37 +0100
Message-ID: <AANLkTi=v9Ev0BDXBTWZs=LcMVGXoxcA7we5bKaR_m+2Z@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
From: Markus Rechberger <mrechberger@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 12:29 AM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> On Thu, 11 Nov 2010 00:13:09 +0100
> Markus Rechberger <mrechberger@gmail.com> wrote:
>
>> On Wed, Nov 10, 2010 at 11:48 PM, Mohamed Ikbel Boulabiar
>> <boulabiar@gmail.com> wrote:
>> > On Wed, Nov 10, 2010 at 10:24 PM, Antonio Ospite
>> > <ospite@studenti.unina.it> wrote:
>> >> If there are arguments against a kernel driver I can't see them yet.
> [...]
>> > If I want to use this device, I will add many userspace code to create
>> > the skeleton model and that need much computation. Kernel Module adds
>> > performance to my other code.
>>
>> just some experience from our side, we do have fully working
>> video4linux1/2 drivers
>> in userspace, the only exception we have is a very thin layered
>> kernelmodule in order
>> to improve the datatransfer.
>
> Markus, can you point to some example so I can get a clearer picture?
>

unfortunately we're closed source (and much more advanced) but you can
have a look at other projects:

* libv4l2
* freebsd has webcamd or something like that to emulate analog
tv/webcams and dvb (they are even reusing linux kernel drivers with a
userspace wrapper - so everything works in userspace for them).

aside of that you can just debug userspace drivers with gdb, valgrind
etc. if issues come up it will only affect your work not the entire
system, kernel is seriously something critical.

Markus
> Thanks,
>   Antonio
>
> --
> Antonio Ospite
> http://ao2.it
>
> PGP public key ID: 0x4553B001
>
> A: Because it messes up the order in which people normally read text.
>   See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?
>
