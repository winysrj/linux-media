Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12093 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2BMQQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 11:16:22 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZC00F2GAJ8Q2@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Feb 2012 16:16:21 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LZC008HRAJ8XK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Feb 2012 16:16:20 +0000 (GMT)
Date: Mon, 13 Feb 2012 17:16:17 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [GIT PULL FOR 3.4] Updates to S5P-TV for v3.4
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4F393751.1010100@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull-request contains fixes and updates to S5P-TV drivers set.
New driver for MHL is introduced and it is integrated with S5P-HDMI.
I kindly ask for merging info 3.4.

Regards,
Tomasz Stanislawski

The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:

   Merge branch 'v4l_for_linus' into staging/for_v3.4 (2012-01-23 
18:11:30 -0200)

are available in the git repository at:

   git://git.infradead.org/users/kmpark/linux-2.6-samsung 
3.4-s5p-mhl-tv-fixes

Julia Lawall (1):
       v4l: s5p-tv: use devm_ functions

Masanari Iida (1):
       media: Fix typo in mixer_drv.c and hdmi_drv.c

Tomasz Stanislawski (3):
       v4l: s5p-tv: add sii9234 driver
       v4l: s5p-tv: hdmi: add support for platform data
       v4l: s5p-tv: hdmi: integrate with MHL

  drivers/media/video/s5p-tv/Kconfig       |   10 +
  drivers/media/video/s5p-tv/Makefile      |    2 +
  drivers/media/video/s5p-tv/hdmi_drv.c    |  120 +++++----
  drivers/media/video/s5p-tv/mixer_drv.c   |    2 +-
  drivers/media/video/s5p-tv/sdo_drv.c     |   26 +--
  drivers/media/video/s5p-tv/sii9234_drv.c |  432 
++++++++++++++++++++++++++++++
  include/media/s5p_hdmi.h                 |   35 +++
  include/media/sii9234.h                  |   24 ++
  8 files changed, 585 insertions(+), 66 deletions(-)
  create mode 100644 drivers/media/video/s5p-tv/sii9234_drv.c
  create mode 100644 include/media/s5p_hdmi.h
  create mode 100644 include/media/sii9234.h
