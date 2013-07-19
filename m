Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m02.mx.aol.com ([64.12.143.76]:35344 "EHLO
	omr-m02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759609Ab3GSDpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 23:45:53 -0400
Message-ID: <51E8B4B9.7080702@netscape.net>
Date: Fri, 19 Jul 2013 00:38:33 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org> <51E6A20B.8020507@netscape.net> <20130718042314.2773b7c0.mchehab@infradead.org>
In-Reply-To: <20130718042314.2773b7c0.mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

El 17/07/13 16:23, Mauro Carvalho Chehab escribió:
>
> No. You'll need to clone the entire kernel tree (either Linus one or
> mine).
>
> The build system at the Kernel will rebuild an entire Kernel image.
> You'll then need to boot that new image.
>
> That takes some machine time, but, after the first compilation, the
> subsequent compilations are faster.
>
> I recommend you to use a minimal .config file for the compilation,
> as this speeds up a lot the time to compile the Kernel.
> Here, I use this small script to produce such mini-kernel:
> 	http://ftp.suse.com/pub/people/tiwai/misc/diet-kconfig
>
> After running it (and using the default for whatever question it
> asks me), I do a make menuconfig, to be sure that the media
> drivers and options I want are there.
>
> In summary, what I suggest is:
>
> 	$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 	$ git checkout v3.2
> 	$ git bisect good
> 	$ diet-kconfig
> 	$ make menuconfig
>
> 	select what is missed at media stuff
>
> 	$ make && make modules install && make install & reboot
>
> 	after reboot check if everything is ok
>
> 	$ git bisect bad v3.4
>
> repeat:
> 	$ make && make modules install && make install & reboot
> 	
> 	it will likely ask you about some new drivers =  it is generally safe
> 	to just let the default - just be more careful with the media
> 	menuconfig items
>
> 	test the kernel:
> 	if OK:
> 		$ git bisect good
> 	if BAD:
> 		$ git bisect bad
> 	if git bisect answers that there are xxx bisects left, then goto repeat
>
> After running the above, git bisect will put its fingers on the broken patch.
>
>
>

Thank you very much Mauro.

A very clear explanation. Without it I do not think I could do well.

When finished, I report back what I found

Again, thank you very much,

Alfredo
