Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42990 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935163AbZDIPwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 11:52:55 -0400
Received: by bwz17 with SMTP id 17so655883bwz.37
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2009 08:52:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090409124810.6c9f73bb@pedra.chehab.org>
References: <49DE0891.9010506@yahoo.gr>
	 <412bdbff0904090839v43772f6dk7f2ac47ef417f45f@mail.gmail.com>
	 <20090409124810.6c9f73bb@pedra.chehab.org>
Date: Thu, 9 Apr 2009 17:52:52 +0200
Message-ID: <d9def9db0904090852v63b71413r616369babeff1d95@mail.gmail.com>
Subject: Re: Multiple em28xx devices
From: Markus Rechberger <mrechberger@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	rvf16 <rvf16@yahoo.gr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 9, 2009 at 5:48 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Thu, 9 Apr 2009 11:39:47 -0400
> Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
>
>> 2009/4/9 rvf16 <rvf16@yahoo.gr>:
>> > So does the upstream driver support all the rest ?
>> > Analog TV
>> Yes
>>
>> > FM radio
>> No
>
> Yes, it does support FM radio, provided that you proper add radio specific
> configuration at em28xx-cards.c.
>

I plan to add support for it to the existing kerneldriver anyway, but
by using userspace drivers.
Those drivers are just ontop of everything and no changes are required
for the existing drivers.

I'll just intercept all the calls as I do right now already with the
latest device. I ported the entire configuration framework to userland
and it also works on Apple OSX without any change. I'm just using
usbfs for it, PCI config support is possible by using libpci or
opening the corresponding node in the proc filesystem too. This time
there's nothing you can do against it since it requires no change as
it is.

Markus
