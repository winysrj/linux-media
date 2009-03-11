Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:41013 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbZCKLgu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 07:36:50 -0400
Subject: Re: Improve DKMS build of v4l-dvb?
From: Alain Kalker <miki@dds.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090309204308.10c9afc6@pedra.chehab.org>
References: <1236612894.5982.72.camel@miki-desktop>
	 <20090309204308.10c9afc6@pedra.chehab.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 12:36:36 +0100
Message-Id: <1236771396.5991.24.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op maandag 09-03-2009 om 20:43 uur [tijdzone -0300], schreef Mauro
Carvalho Chehab: 
> It is not that hard. You'll have a few vars that will always have the same values, like:
[snip]

Thanks for the information, I'll use this as a starting point.

> Of course, you'll need to write some script to identify what devices are
> available at the host (by USB or PCI ID), and associate it with the V4L/DVB
> drivers.

Scanning for available hardware is already available in Jockey, and
parsing the output from 'lsusb'/'lspci' will do it for users without
it. 

Associating IDs with the principal module is easy after doing a test
build of all modules (which needs to be done anyway, to find out which
drivers can actually be built with the current tree and to decide
whether the tree is suitable for packaging for DKMS build).

After the test build, all you have to do is run "modinfo -F alias" on
all the modules, add the principal module name, and you will end up with
a modaliases list which is directly usable with Jockey. For users
without it, another simple script will select the correct principal
module to build.

All that remains then is to sort out the module dependencies...

> Probably, the hardest part is to maintain, so, ideally, the scripts should scan
> the source codes to check what drivers you have, and what are the driver
> options associated with that device.

Very true. I'm quite dissatisfied with the sad state that Kbuild support
for building external modules is in, especially for projects that have
numerous drivers and module dependencies, and I believe v4l-dvb has
currently the most advanced out-of-tree support available.
If you enjoy watching a horror movie, have a look at the drivers from
the ALSA project, they have a hideous 131615 bytes big beast hidden in
their aclocal.m4, whose sole purpose it is to sort out config variable
dependencies... Yuck!

> If you can write such script, then we can add it at v4l/scripts and add a
> "make myconfig" option that would run the script and compile the minimal set of
> drivers.

That would be great!

Kind regards,

Alain

