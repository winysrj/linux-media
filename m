Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:44611 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab1BUCdm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 21:33:42 -0500
Date: Sun, 20 Feb 2011 20:28:40 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.39] pvrusb2 driver
Message-ID: <alpine.DEB.1.10.1102202025010.15115@ivanova.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Mauro,

[Note: This is my first real attempt at using git to get changes pulled, 
so please let me know if I missed a step.  These changes are all 
relatively minor and have been sitting around for while.  There will be 
more to follow once I'm sure I am doing this process correctly...  
-Mike Isely]


The following changes since commit 5ed4bbdae09d207d141759e013a0f3c24ae76ecc:
  Mauro Carvalho Chehab (1):
        [media] tuner-core: Don't touch at standby during tuner_lookup

are available in the git repository at:

  git://git.linuxtv.org/mcisely/pvrusb2-dev.git pvrusb2-merge-1

Mike Isely (5):
      pvrusb2: Handle change of mode before handling change of video standard
      pvrusb2: Minor cosmetic code tweak
      pvrusb2: Fix a few missing default control values, for cropping
      pvrusb2: Minor VBI tweak to help potential CC support
      pvrusb2: Use sysfs_attr_init() where appropriate

Servaas Vandenberghe (1):
      pvrusb2: width and height maximum values.

 drivers/media/video/pvrusb2/pvrusb2-hdw.c   |   60 +++++++++++++++------------
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    9 ++++
 2 files changed, 43 insertions(+), 26 deletions(-)

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
