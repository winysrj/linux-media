Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38516 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 09:02:58 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p8SD2sXp013152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 28 Sep 2011 08:02:57 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [GIT PULL] davinci vpbe: enable DM365 v4l2 display driver
Date: Wed, 28 Sep 2011 18:32:48 +0530
Message-ID: <1317214968-8679-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, 
  Please pull : 
git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git  for_mauro

The patchset adds incremental changes necessary to enable dm365
v4l2 display driver, which includes vpbe display driver changes,
osd specific changes and venc changes. The changes are incremental
in nature,addind a few HD modes, and taking care of register level
changes.

The patches are tested for both SD and HD modes.

Manjunath Hadli (3):
  davinci vpbe: add dm365 VPBE display driver changes
  davinci vpbe: add dm365 and dm355 specific OSD changes
  davinci vpbe: add VENC block changes to enable dm365 and dm355

 drivers/media/video/davinci/vpbe.c      |   48 +++-
 drivers/media/video/davinci/vpbe_osd.c  |  472 ++++++++++++++++++++++++++++---
 drivers/media/video/davinci/vpbe_venc.c |  205 ++++++++++++--
 include/media/davinci/vpbe.h            |   16 +
 include/media/davinci/vpbe_venc.h       |    4 +
 5 files changed, 677 insertions(+), 68 deletions(-)

