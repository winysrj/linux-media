Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3GQTXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 15:23:19 -0400
Date: Thu, 18 Jul 2013 04:23:14 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130718042314.2773b7c0.mchehab@infradead.org>
In-Reply-To: <51E6A20B.8020507@netscape.net>
References: <51054759.7050202@netscape.net>
	<20130127141633.5f751e5d@redhat.com>
	<5105A0C9.6070007@netscape.net>
	<20130128082354.607fae64@redhat.com>
	<5106E3EA.70307@netscape.net>
	<511264CF.3010002@netscape.net>
	<51336331.10205@netscape.net>
	<20130303134051.6dc038aa@redhat.com>
	<20130304164234.18df36a7@redhat.com>
	<51353591.4040709@netscape.net>
	<20130304233028.7bc3c86c@redhat.com>
	<513A6968.4070803@netscape.net>
	<515A0D03.7040802@netscape.net>
	<51E44DCA.8060702@netscape.net>
	<20130716053030.3fda034e.mchehab@infradead.org>
	<51E6A20B.8020507@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jul 2013 10:54:19 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi all
> 
> El 15/07/13 17:30, Mauro Carvalho Chehab escribió:
> > Em Mon, 15 Jul 2013 16:30:18 -0300
> > Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
> >
> >> Hi all
> >>
> >> After some time trying to see what the problem is, I have found it is
> >> not come the RF signal.
> >>
> >> I've gone back using a 3.2 kernel, after doing a couple of tests, the
> >> board works :-)
> >> When I try to apply these changes to a 3.4 or later kernel does not tune
> >> plate.
> >>
> >> Between 3.2 and 3.4 kernel there are several changes to the drivers:
> >> CX23885, xc5000 and mb86a20s. I tried to cancel several of them on a 3.4
> >> kernel, but I can not make the card tune.
> > If you know already that the breakage happened between 3.2 and 3.4, the better
> > is to use git bisect to discover what patch broke it.
> 
> Mauro Thanks for the suggestion.
> This weekend I have some time and I'll study how to implement it.
> 
> I guess it's do something similar to:
> 
> ~ $ git clone git://linuxtv.org/media_build.git
> ~ $ cd media_build
> ~/media_build $./build --main-git
> ~/media_build $ cd media
> ~/media $ gedit drivers/media/video/foo.c
> ~/media $ make -C ../v4l
> ~/media $ make -C ../ install
> ~/media $ make -C .. rmmod
> ~/media $ modprobe foo

No. You'll need to clone the entire kernel tree (either Linus one or
mine).

The build system at the Kernel will rebuild an entire Kernel image.
You'll then need to boot that new image.

That takes some machine time, but, after the first compilation, the
subsequent compilations are faster.

I recommend you to use a minimal .config file for the compilation,
as this speeds up a lot the time to compile the Kernel.
Here, I use this small script to produce such mini-kernel:
	http://ftp.suse.com/pub/people/tiwai/misc/diet-kconfig

After running it (and using the default for whatever question it
asks me), I do a make menuconfig, to be sure that the media
drivers and options I want are there.

In summary, what I suggest is:

	$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
	$ git checkout v3.2
	$ git bisect good
	$ diet-kconfig
	$ make menuconfig

	select what is missed at media stuff

	$ make && make modules install && make install & reboot

	after reboot check if everything is ok

	$ git bisect bad v3.4

repeat:
	$ make && make modules install && make install & reboot
	
	it will likely ask you about some new drivers =  it is generally safe
	to just let the default - just be more careful with the media
	menuconfig items

	test the kernel:
	if OK:
		$ git bisect good
	if BAD:
		$ git bisect bad
	if git bisect answers that there are xxx bisects left, then goto repeat

After running the above, git bisect will put its fingers on the broken patch.


> >
> > You can do (using Linus git tree):
> >
> > 	git checkout v3.4
> > 	git bisect bad
> > 	git checkout good v3.2
> 
> Where is the git tree of Linus in <git://git.kernel.org/> or 
> <git://linuxtv.org/>?
> 
> Thanks again,
> 
> Alfredo
> 
> 
> >
> > git bisect will then do a binary search between those two kernels. All you
> > have to do is to recompile the Kernel and test it. Then you'll tag the
> > changeset as "bad" or "good", until the end of the search. In general, you'll
> > discover the changeset responsible for the breakage after a few (8-10)
> > interactions.
> >
> > For more reference, you can take a look, for example, at:
> > 	http://git-scm.com/book/en/Git-Tools-Debugging-with-Git
> >
> > Regards,
> > Mauro
> >
> > PS.: Someone should fix our wiki, as it is still pointing to hg bisect,
> > instead of pointing to git bisect.
> >
> >> The changes I have applied to kernel 3.2 are:
> >
> 




Cheers,
Mauro
