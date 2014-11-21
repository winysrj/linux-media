Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49205 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075AbaKUKvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 05:51:45 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B04242A002F
	for <linux-media@vger.kernel.org>; Fri, 21 Nov 2014 11:51:26 +0100 (CET)
Message-ID: <546F192E.5080003@xs4all.nl>
Date: Fri, 21 Nov 2014 11:51:26 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.18] Various fixes for 3.18
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are three fixes and one MAINTAINERS update that should go to 3.18.

Regards,

	Hans

The following changes since commit c02ef64aab828d80040b5dce934729312e698c33:

  [media] cx23885: add DVBSky T982(Dual DVB-T2/T/C) support (2014-11-14 18:28:41 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.18g

for you to fetch changes up to ddc5bee72f9707a8729d214156d7e4e09eecbd3a:

  cx23885: use sg = sg_next(sg) instead of sg++ (2014-11-21 11:43:19 +0100)

----------------------------------------------------------------
Andrey Utkin (1):
      Update MAINTAINERS for solo6x10

Hans Verkuil (1):
      cx23885: use sg = sg_next(sg) instead of sg++

Krzysztof Hałasa (1):
      solo6x10: fix a race in IRQ handler.

sensoray-dev (1):
      s2255drv: fix payload size for JPG, MJPEG

 MAINTAINERS                                |  4 +++-
 drivers/media/pci/cx23885/cx23885-core.c   |  6 +++---
 drivers/media/pci/solo6x10/solo6x10-core.c | 10 ++--------
 drivers/media/usb/s2255/s2255drv.c         |  2 +-
 4 files changed, 9 insertions(+), 13 deletions(-)
