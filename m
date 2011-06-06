Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43014 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1FFWkq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 18:40:46 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>
Subject: [RFC] Refactor the cafe_ccic driver and add Armada 610 support
Date: Mon,  6 Jun 2011 16:39:56 -0600
Message-Id: <1307400003-94758-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, all,

As I promised last week, here's the state of my work refactoring the Cafe
driver and adding Armada 610 support.  I intend to have them ready for 3.1,
but they are not ready for merging yet.  There's a couple of things I'd
like to clean up, and I'd like to let the OLPC people test things a bit
more.  But I figured it would be good to get it out there for comments.

Essentially, Marvell has taken the camera controller from the old Cafe chip
and dropped it into some ARM SoC setups, one of which is the Armada 610.  I
pondered just making a new driver, but, given that the controller has
changed very little, it made a lot more sense to reuse the existing code.

The patches here split cafe_ccic.c into "platform" and "core" pieces while
leaving functionality unchanged.  The new "mmp-camera" driver is then added
as a second platform.

This work is not done; at a minimum, I plan to convert it over to videobuf2
and make use of the Armada's s/g DMA capabilities.  Doubtless there is
plenty more to be done; I would also sure like to see Kassey Lee's Marvell
driver integrated with this one if at all possible.

Comments?

Thanks,

jon


