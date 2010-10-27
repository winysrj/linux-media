Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab0J0C2R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Oct 2010 22:28:17 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9R2SHSE000517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 26 Oct 2010 22:28:17 -0400
Received: from [10.3.227.53] (vpn-227-53.phx2.redhat.com [10.3.227.53])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o9R2SFCJ002580
	for <linux-media@vger.kernel.org>; Tue, 26 Oct 2010 22:28:16 -0400
Message-ID: <4CC78E3E.5010104@redhat.com>
Date: Wed, 27 Oct 2010 00:28:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] new experimental building system
References: <4CBB2470.50405@redhat.com>
In-Reply-To: <4CBB2470.50405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-10-2010 14:29, Mauro Carvalho Chehab escreveu:
> I received some comments from some developers that wanted to test their drivers
> with the latest -stable kernel. After thinking for a while, I decided to do
> a small test, packaging the current build system into a separate tree, without
> any drivers, and providing a way to allow using it with the latest driver.
> 
> I added it at:
> 	http://git.linuxtv.org/mchehab/new_build.git
> 
> The current version is very raw, but people are free to send patches to improve it.
> 
> Usage:
> 
> git clone git://linuxtv.org/mchehab/new_build.git
> cd new_build/linux
> make tar DIR=<some dir with media -git tree>
> make untar
> cd ..
> 
> After that, it will work like the old -hg build system.
> 
> Notes:
> 
> 1) There's not much compat stuff here. So, it will likely not work with
>    legacy kernels. It will probably be fine to use it with the latest stable
>    kernel, although I tested it only with 2.6.36-rc7.
> 
> 2) For now, this is just an experience. I don't intend to maintain any
>    out-of-tree building system, due to my lack of time for it. If this interests
>    someone, feel free to candidate to maintain it.
> 
> 3) It shouldn't be hard to support legacy kernels. All that it is needed is
>    to have patches adding backports that don't fit at compat.h, and let the
>    building system to apply them, depending on the kernel version.
> 
> If someone manifests interests on maintaining it, we probably may have some
> script at linuxtv.org, generating daily tarballs with the latest drivers, to
> be used by this build system.

I added several patches today to the new experimental building system, and added
a script at linuxtv.org to auto-generate a tarball with the latest drivers.

Basically, with the patches I made, it is compiling fine with the following kernel
releases (vanilla upstream kernels):
	linux-2.6.32.24
	linux-2.6.33.7
	linux-2.6.34.7
	linux-2.6.35.7
	linux-2.6.36

(e. g. the latest stable releases from 2.6.32 to 2.6.36).

The 2.6.32 backport also compiled fine with the experimental RHEL6 kernel I have on
my machine.

WARNING: I just test compilation. There are some random warnings generated with some
of those kernels that may or may not indicate a problem.

If you want to test the new building system, all you need to do is:

	$ git clone git://linuxtv.org/mchehab/new_build.git
	$ cd new_build
	$ ./build.sh

This will download the newest tarball from linuxtv.org, apply the backport patches
and build it.

After that, you may install the new drivers with:
	$ make install

The building system is the same as we had on the mercurial tree, but I didn't test the
other targets (well, except for make release DIR=<dir> - it is also working fine).
Yet, I think that the other make targets should be working properly.

Patches (and a maintainer) are welcome.

Have fun!
Mauro.
