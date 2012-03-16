Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56068 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162033Ab2CPXgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:20 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] A series of Marvell camera fixes
Date: Fri, 16 Mar 2012 17:14:49 -0600
Message-Id: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Mauro,

Here is a set of relatively straightforward fixes for some Marvell camera
bugs, some of which were rather less straightforward to find.  If you
prefer, they can be pulled from:

	git://git.lwn.net/linux-2.6.git marvell-fixes

Therein you'll find:

Jonathan Corbet (7):
      marvell-cam: ensure that the camera stops when requested
      marvell-cam: Remove broken "owner" logic
      marvell-cam: Increase the DMA shutdown timeout
      marvell-cam: fix the green screen of death
      marvell-cam: Don't signal multiple frame completions in scatter/gather mode
      mmp-camera: Don't power up the sensor on resume
      marvell-cam: Demote the "release" print to debug level

 mcam-core.c  |   35 +++++++++++++++++++++++------------
 mcam-core.h  |    1 -
 mmp-driver.c |   13 +++++++++----
 3 files changed, 32 insertions(+), 17 deletions(-)

If it's not to late to get these in to 3.4 (during the merge window or a
later fix cycle) I'd appreciate it.

Thanks,

jon


