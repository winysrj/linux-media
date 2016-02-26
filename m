Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53193 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbcBZHpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 02:45:53 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7A280180981
	for <linux-media@vger.kernel.org>; Fri, 26 Feb 2016 08:45:48 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Fixes, enhancement and move 3 soc-camera drivers
 to staging
Message-ID: <56D002AC.7020005@xs4all.nl>
Date: Fri, 26 Feb 2016 08:45:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3915d367932609f9c0bdc79c525b5dd5a806ab18:

  [media] ttpci: cleanup a bogus smatch warning (2016-02-23 07:26:22 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6f

for you to fetch changes up to 16295c7590a2272050fb1ae935ce65860f930351:

  soc_camera/mx3_camera.c: move to staging in preparation, for removal (2016-02-26 08:21:05 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      tc358743: use - instead of non-ascii wide-dash character
      vivid: support new multiplanar YUV formats
      soc_camera/omap1: move to staging in preparation for removal
      soc_camera/mx2_camera.c: move to staging in preparation, for removal
      soc_camera/mx3_camera.c: move to staging in preparation, for removal

Philipp Zabel (2):
      coda: add support for native order firmware files with Freescale header
      coda: add support for firmware files named as distributed by NXP

Ulrich Hecht (1):
      adv7604: fix SPA register location for ADV7612

 drivers/media/i2c/adv7604.c                                          |  3 +-
 drivers/media/i2c/tc358743.c                                         | 30 +++++-----
 drivers/media/platform/coda/coda-common.c                            | 96 ++++++++++++++++++++++++++------
 drivers/media/platform/coda/coda.h                                   |  3 +-
 drivers/media/platform/soc_camera/Kconfig                            | 28 ----------
 drivers/media/platform/soc_camera/Makefile                           |  3 -
 drivers/media/platform/vivid/vivid-tpg.c                             | 32 +++++++++++
 drivers/media/platform/vivid/vivid-vid-common.c                      | 39 ++++++++++++-
 drivers/staging/media/Kconfig                                        |  6 ++
 drivers/staging/media/Makefile                                       |  3 +
 drivers/staging/media/mx2/Kconfig                                    | 12 ++++
 drivers/staging/media/mx2/Makefile                                   |  3 +
 .../{media/platform/soc_camera => staging/media/mx2}/mx2_camera.c    |  0
 drivers/staging/media/mx3/Kconfig                                    | 15 +++++
 drivers/staging/media/mx3/Makefile                                   |  3 +
 .../{media/platform/soc_camera => staging/media/mx3}/mx3_camera.c    |  0
 drivers/staging/media/omap1/Kconfig                                  | 13 +++++
 drivers/staging/media/omap1/Makefile                                 |  3 +
 .../platform/soc_camera => staging/media/omap1}/omap1_camera.c       |  0
 19 files changed, 224 insertions(+), 68 deletions(-)
 create mode 100644 drivers/staging/media/mx2/Kconfig
 create mode 100644 drivers/staging/media/mx2/Makefile
 rename drivers/{media/platform/soc_camera => staging/media/mx2}/mx2_camera.c (100%)
 create mode 100644 drivers/staging/media/mx3/Kconfig
 create mode 100644 drivers/staging/media/mx3/Makefile
 rename drivers/{media/platform/soc_camera => staging/media/mx3}/mx3_camera.c (100%)
 create mode 100644 drivers/staging/media/omap1/Kconfig
 create mode 100644 drivers/staging/media/omap1/Makefile
 rename drivers/{media/platform/soc_camera => staging/media/omap1}/omap1_camera.c (100%)
