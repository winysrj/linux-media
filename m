Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1947 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbZJGEqU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 00:46:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Neil Brown <neilb@suse.de>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Adrian Hunter <adrian.hunter@nokia.com>,
	Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
	linux-raid@vger.kernel.org, linux-media@vger.kernel.org,
	cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
	xfs@oss.sgi.com
Subject: [PATCH 0/8] Add vsprintf extension %pU to print UUID/GUIDs and use it
Date: Tue,  6 Oct 2009 21:45:33 -0700
Message-Id: <1254890742-28245-1-git-send-email-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using %pU makes an x86 defconfig image a bit smaller

before:	$ size vmlinux
   text    data     bss     dec     hex filename
6976022  679572 1359668 9015262  898fde vmlinux

after:	$ size vmlinux
   text	   data	    bss	    dec	    hex	filename
6975863	 679652	1359668	9015183	 898f8f	vmlinux

Joe Perches (8):
  lib/vsprintf.c: Add %pU to print UUID/GUIDs
  random.c: Use %pU to print UUIDs
  drivers/firmware/dmi_scan.c: Use %pUB to print UUIDs
  drivers/md/md.c: Use %pU to print UUIDs
  drivers/media/video/uvc: Use %pUl to print UUIDs
  fs/gfs2/sys.c: Use %pUB to print UUIDs
  fs/ubifs: Use %pUB to print UUIDs
  fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs

 drivers/char/random.c                |   10 +---
 drivers/firmware/dmi_scan.c          |    5 +--
 drivers/md/md.c                      |   16 ++------
 drivers/media/video/uvc/uvc_ctrl.c   |   69 ++++++++++++++++------------------
 drivers/media/video/uvc/uvc_driver.c |    7 +--
 drivers/media/video/uvc/uvcvideo.h   |   10 -----
 fs/gfs2/sys.c                        |   16 +------
 fs/ubifs/debug.c                     |    9 +---
 fs/ubifs/super.c                     |    7 +---
 fs/xfs/xfs_log_recover.c             |   14 ++-----
 lib/vsprintf.c                       |   62 ++++++++++++++++++++++++++++++-
 11 files changed, 114 insertions(+), 111 deletions(-)

