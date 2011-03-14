Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:48351 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1CNFfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 01:35:48 -0400
Date: Mon, 14 Mar 2011 00:35:48 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] pvrusb2 driver fixes / improvements
Message-ID: <alpine.DEB.1.10.1103140031070.31934@ivanova.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Mauro:

Please pull the following patches.  Note also that the "Implement 
support for Terratec Grabster AV400" is not as big of a change as it 
might sound.  The work to implement that really amounted to just some 
extra table entries, plus those changes have been out in the wild via 
the standalone pvrusb2 driver for quite some time.  Getting that into 
the kernel is long overdue.

  -Mike


The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:
  Hans Verkuil (1):
        [media] V4L DocBook: update V4L2 version

are available in the git repository at:

  git://git.linuxtv.org/mcisely/pvrusb2-dev.git pvrusb2-merge-2

Mike Isely (2):
      pvrusb2: Implement support for Terratec Grabster AV400
      pvrusb2: Remove dead code

Xiaochen Wang (1):
      pvrusb2: check kmalloc return value

 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c |   18 +++++++++++++++
 drivers/media/video/pvrusb2/pvrusb2-devattr.c     |   24 +++++++++++++++++++++
 drivers/media/video/pvrusb2/pvrusb2-hdw.c         |   24 ++++++++++++++-------
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c        |    2 -
 4 files changed, 58 insertions(+), 10 deletions(-)

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
