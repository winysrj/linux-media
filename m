Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:42446 "EHLO
	relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755020AbZGCQJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2009 12:09:07 -0400
Message-ID: <4A4E2D24.8070504@powercraft.nl>
Date: Fri, 03 Jul 2009 18:09:08 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Call for testers: Terratec Cinergy T XS USB support
References: <829197380906290700n16a0f4faxd29caa12587222f7@mail.gmail.com> <d9def9db0907030313t4ea3685m8f63981696d63c96@mail.gmail.com>
In-Reply-To: <d9def9db0907030313t4ea3685m8f63981696d63c96@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Rechberger wrote:
> Hi all,
> 
> On Mon, Jun 29, 2009 at 4:00 PM, Devin
> Heitmueller<dheitmueller@kernellabs.com> wrote:
>> Hello all,
>>
>> A few weeks ago, I did some work on support for the Terratec Cinergy T
>> XS USB product. �I successfully got the zl10353 version working and
>> issued a PULL request last week
>> (http://www.kernellabs.com/hg/~dheitmueller/em28xx-terratec-zl10353)
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

Still keep feeling an itch to response to this. I am not interested in
any proprietary driver binaries and I tried to work with you and
contributed documentation, testing and lot of time to your em28xx
project. I feel mislead and wasted my time trying to help you. Please
don't response to this mail in this thread make a separate public thread
if you want to discus it. I don't like thread highjacking. You are more
then welcome to contribute code back in small patches for one change at
a time that meets the Linux kernel licensing and coding guidelines. I
sometimes got the feeling you are doing more good then harm working for
Empiatech.

Best regards,

Jelle de Jong
