Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45252 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbbASRSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 12:18:36 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id BB5162A0080
	for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 18:18:14 +0100 (CET)
Message-ID: <54BD3C56.4070600@xs4all.nl>
Date: Mon, 19 Jan 2015 18:18:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.19] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request fixes two cases of missing device_caps (3.19 warns about that
now, so fix this before it's released), one cx23885 warning related to the
incorrect freeing of an interrupt, and one important fix for vb2 thread race
conditions. The last bug is responsible for various kernel warnings and oopses
when using DVB and vb2. The last one is CC-ed to stable and should be applied
to all kernels >= 3.16.

Regards,

	Hans

The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:

  [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19b

for you to fetch changes up to b65558a8f31bcd585989a8259272f975d3236612:

  omap3isp: Correctly set QUERYCAP capabilities (2015-01-19 12:12:44 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
      vb2: fix vb2_thread_stop race conditions
      pvrusb2: fix missing device_caps in querycap
      cx23885: fix free interrupt bug

Sakari Ailus (1):
      omap3isp: Correctly set QUERYCAP capabilities

 drivers/media/pci/cx23885/cx23885-core.c   |  4 ++--
 drivers/media/platform/omap3isp/ispvideo.c |  7 +++++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c   | 24 +++++++++++++-----------
 drivers/media/v4l2-core/videobuf2-core.c   | 19 +++++++++----------
 4 files changed, 29 insertions(+), 25 deletions(-)
