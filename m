Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZCKLsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 07:48:08 -0400
Date: Wed, 11 Mar 2009 08:47:43 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alain Kalker <miki@dds.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: Improve DKMS build of v4l-dvb?
In-Reply-To: <1236771396.5991.24.camel@miki-desktop>
Message-ID: <alpine.LRH.2.00.0903110842570.1207@pedra.chehab.org>
References: <1236612894.5982.72.camel@miki-desktop>  <20090309204308.10c9afc6@pedra.chehab.org> <1236771396.5991.24.camel@miki-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009, Alain Kalker wrote:

> Op maandag 09-03-2009 om 20:43 uur [tijdzone -0300], schreef Mauro
> Carvalho Chehab:
>> It is not that hard. You'll have a few vars that will always have the same values, like:
> [snip]
>
> Thanks for the information, I'll use this as a starting point.
>
>> Of course, you'll need to write some script to identify what devices are
>> available at the host (by USB or PCI ID), and associate it with the V4L/DVB
>> drivers.
>
> Scanning for available hardware is already available in Jockey, and
> parsing the output from 'lsusb'/'lspci' will do it for users without
> it.
>
> Associating IDs with the principal module is easy after doing a test
> build of all modules (which needs to be done anyway, to find out which
> drivers can actually be built with the current tree and to decide
> whether the tree is suitable for packaging for DKMS build).
>
> After the test build, all you have to do is run "modinfo -F alias" on
> all the modules, add the principal module name, and you will end up with
> a modaliases list which is directly usable with Jockey. For users
> without it, another simple script will select the correct principal
> module to build.

IMO, a perl script searching for PCI and USB tables at the driver would do 
a faster job than doing a module build. You don't need to do a test build 
to know what modules compile, since v4l/versions.txt already contains the 
minimum supported version for each module. If the module is not there, 
then it will build since kernel 2.6.16.

>
> All that remains then is to sort out the module dependencies...
>
>> Probably, the hardest part is to maintain, so, ideally, the scripts should scan
>> the source codes to check what drivers you have, and what are the driver
>> options associated with that device.
>
> Very true. I'm quite dissatisfied with the sad state that Kbuild support
> for building external modules is in, especially for projects that have
> numerous drivers and module dependencies, and I believe v4l-dvb has
> currently the most advanced out-of-tree support available.

Thanks!

> If you enjoy watching a horror movie, have a look at the drivers from
> the ALSA project, they have a hideous 131615 bytes big beast hidden in
> their aclocal.m4, whose sole purpose it is to sort out config variable
> dependencies... Yuck!

Yeah, I've seen this already.

Cheers,
Mauro
