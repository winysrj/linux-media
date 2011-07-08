Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36241 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1GHUwI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] One more Marvell cam patch series
Date: Fri,  8 Jul 2011 14:50:44 -0600
Message-Id: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Here is yet another set of marvell-cam patches.  These ones clean up some
old cruft, fix one bug, and make it so that you don't have to drag in all
three videobuf2 modes if you don't want them.  It looks like a lot of
churn, but the bulk of it is simply moving functions around into a more
logical organization.

The one thing that's not there, unfortunately, is the removal of the ov7670
dependency.  If Linus does another round or two of rc's before 3.0, I may
just get that done for the merge window; otherwise that will have to be for
3.1.  It's the top item on my list.

The patches can be pulled from:

    	git://git.lwn.net/linux-2.6.git for-mauro

Patches in this series:

Jonathan Corbet (6):
      marvell-cam: delete struct mcam_sio_buffer
      marvell-cam: core code reorganization
      marvell-cam: remove {min,max}_buffers parameters
      marvell-cam: power down mmp camera on registration failure
      marvell-cam: Allow selection of supported buffer modes
      marvell-cam: clean up a couple of unused cam structure fields

 Kconfig      |    3 
 mcam-core.c  | 1048 ++++++++++++++++++++++++++++++-----------------------------
 mcam-core.h  |   69 ++-
 mmp-driver.c |    2 
 4 files changed, 601 insertions(+), 521 deletions(-)

Thanks,

jon


