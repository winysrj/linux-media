Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:55281 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZGCQGH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2009 12:06:07 -0400
Received: from [127.0.0.1] (killala.koala.ie [195.7.61.12])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n63G68qC023375
	for <linux-media@vger.kernel.org>; Fri, 3 Jul 2009 17:06:09 +0100
Message-ID: <4A4E2C6E.3010707@koala.ie>
Date: Fri, 03 Jul 2009 17:06:06 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Call for testers: Terratec Cinergy T XS USB support
References: <829197380906290700n16a0f4faxd29caa12587222f7@mail.gmail.com> <d9def9db0907030313t4ea3685m8f63981696d63c96@mail.gmail.com>
In-Reply-To: <d9def9db0907030313t4ea3685m8f63981696d63c96@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Rechberger wrote:
> Hi all,
>
> On Mon, Jun 29, 2009 at 4:00 PM, Devin
> Heitmueller<dheitmueller@kernellabs.com> wrote:
>   
>> Hello all,
>>
>> A few weeks ago, I did some work on support for the Terratec Cinergy T
>> XS USB product.  I successfully got the zl10353 version working and
>> issued a PULL request last week
>> (http://www.kernellabs.com/hg/~dheitmueller/em28xx-terratec-zl10353)
>>
>>     
>
> There will be an alternative driver entirely in userspace available
> which works across all major kernelversions and distributions. It will
> support the old em28xx devices and handle audio routing for the most
> popular TV applications directly.
>
> This system makes compiling the drivers unnecessary across all
> available linux systems between 2.6.15 and ongoing. This package also
> allows commercial drivers from vendors, the API itself is almost the
> same as the video4linux/linuxdvb API. Installing a driver takes less
> than five seconds without having to take care about the kernel API or
> having to set up a development system. Aside of that it's operating
> system independent (working on Linux, MacOSX and FreeBSD).
> I think this is the way to go for the future since it adds more
> possibilities to the drivers, and it eases up and speeds up driver
> development dramatically.
>
> Best Regards,
> Markus
>   
ROTFLOL (well actually it was more like a rather bemused smile)
--
simon
