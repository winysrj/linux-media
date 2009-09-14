Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZINAJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 20:09:06 -0400
Received: from 200-158-183-52.dsl.telesp.net.br ([200.158.183.52] helo=caramujo.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Mmz81-00037J-M1
	for linux-media@vger.kernel.org; Mon, 14 Sep 2009 00:09:10 +0000
Date: Sun, 13 Sep 2009 21:08:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Subject: [ANOUNCE] Staging trees at V4L/DVB trees
Message-ID: <20090913210841.6a4db925@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Probably some of you already noticed that we're creating some staging trees at
V4L/DVB trees.

There are currently 2 staging trees:

1) /linux/drivers/staging - With drivers that aren't ready yet for merge, needing
help for being finished.

There are currently two drivers there: 
	go7007 driver - Used on some designs with a Micronas encoder.
	cx25821 driver - Driver for Conexant cx25821 chips.

The go7007 driver were written a long time ago and requires not only
CodingStyle fixes but also porting to some new API's and to V4L2 framework.
This driver is already at kernel upstream, under /drivers/staging.

The cx25821 driver is a new driver written this year for some very powerful
PCIe chips, capable of up to 10 simultaneous video input/outputs. The driver
needs several CodingStyle fixes, and has duplicated code for each input/output.

I intend to add tm6000 driver there later this week, if time permits to port it
to the new i2c interface.

The policy to accept new drivers code at staging tree is less rigid than
at /drivers/media: the kernel driver for an unsupported hardware shouldn't
depend on any userspace library other than libv4l and dvb-apps and the code
should compile fine with the latest kernel, and the developer(s) should be
working on fixing it for upstream inclusion. Drivers with bugs, CodingStyle
errors, deprecated API usage, etc can be accepted. Also, drivers there not
maintained for some time can be removed.

2) /staging-specs - This contains the latest V4L and DVB API specs, in DocBook
XML 4.1.2. This is the same DocBook version used in kernel. 

It basically contains an effort to finally merge the API's at kernel DocBook
directory.

Currently, this is _not_ the official API, and the document still needs review
and cleanups.

My intention is to add the first tree upstream, under drivers/staging for
kernel 2.6.32. As those drivers are new, if we can get them on a good shape
during 2.6.32 rc cycle, it could be possible to move them to drivers/media for
2.6.32. All depends on how they'll evolute.

If time is enough and we have the DocBook tree in good shape on the next two
weeks, I intend to add it also to 2.6.32.

Feel free to contribute to both trees.

Have Fun!

Cheers,
Mauro
