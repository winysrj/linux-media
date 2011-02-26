Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43864 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab1BZGHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 01:07:54 -0500
Subject: [RESEND][GIT PATCHES for 2.6.39] ivtv fixes
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Paul Cassella <pwc@bigw.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 01:07:43 -0500
Message-ID: <1298700463.2709.40.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the following ivtv patches for 2.6.39.

Thanks go to David Alan Gilbert for reporting a problem I failed to
clean up properly the first time, and Paul Cassella for providing fixes
for long-standing problems in error handling.

Regards,
Andy


The following changes since commit ffd14aab03dbb8bb1bac5284603835f94d833bd6:

  [media] au0828: fix VBI handling when in V4L2 streaming mode (2011-02-02 12:06:14 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git ivtv_39

Andy Walls (1):
      ivtv: Fix sparse warning regarding a user pointer in ivtv_write_vbi_from_user()

Paul Cassella (3):
      Documentation: README.ivtv: Remove note that ivtvfb is not yet in the kernel
      ivtv: udma: handle get_user_pages() returning fewer pages than we asked for
      ivtv: yuv: handle get_user_pages() -errno returns

 Documentation/video4linux/README.ivtv |    3 +-
 drivers/media/video/ivtv/ivtv-udma.c  |    7 ++++-
 drivers/media/video/ivtv/ivtv-vbi.c   |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c   |   52 +++++++++++++++++++++++++-------
 4 files changed, 48 insertions(+), 16 deletions(-)



