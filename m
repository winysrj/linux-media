Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:59352 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab2EEDW6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 23:22:58 -0400
Date: Fri, 4 May 2012 22:17:56 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: linux-media@vger.kernel.org
cc: Mike Isely <isely@isely.net>
Subject: [GIT PULL FOR 3.5] pvrusb2 driver updates
Message-ID: <alpine.DEB.2.00.1205042212081.5355@ivanova.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro:

Please pull - this includes a long-awaited change courtesy of Hans 
Verkuil which finally transitions the driver to video_ioctl2.

  -Mike Isely


The following changes since commit a1ac5dc28d2b4ca78e183229f7c595ffd725241c:

  [media] gspca - sn9c20x: Change the exposure setting of Omnivision sensors (2012-05-03 15:29:56 -0300)

are available in the git repository at:
  git://git.linuxtv.org/mcisely/pvrusb2-20120504.git pvrusb2-merge-20120504

Hans Verkuil (1):
      pvrusb2: convert to video_ioctl2

Mike Isely (9):
      pvrusb2: Stop statically initializing reserved struct fields to zero
      pvrusb2: Clean up pvr2_hdw_get_detected_std()
      pvrusb2: Implement querystd for videodev_ioctl2
      pvrusb2: Transform video standard detection result into read-only control ID
      pvrusb2: Fix truncated video standard names (trivial)
      pvrusb2: Base available video standards on what hardware supports
      pvrusb2: Trivial tweak to get rid of some redundant dereferences
      pvrusb2: Get rid of obsolete code for video standard enumeration
      pvrusb2: For querystd, start with list of hardware-supported standards

 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  193 +---
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         | 1343 ++++++++++----------
 4 files changed, 735 insertions(+), 816 deletions(-)

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
