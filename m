Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40012 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbaLIUp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Dec 2014 15:45:28 -0500
Message-ID: <54875F61.7010500@xs4all.nl>
Date: Tue, 09 Dec 2014 21:45:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [GIT PULL FOR v3.20] Add am437x driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the new am437x TI driver.

Regards,

	Hans

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git am437x

for you to fetch changes up to 035e534ddf8e9f2bc14520c3c09e627e42b3186c:

  media: platform: add VPFE capture driver support for AM437X (2014-12-09 21:43:04 +0100)

----------------------------------------------------------------
Benoit Parrot (1):
      media: platform: add VPFE capture driver support for AM437X

 Documentation/devicetree/bindings/media/ti-am437x-vpfe.txt |   61 ++
 MAINTAINERS                                                |    9 +
 drivers/media/platform/Kconfig                             |    1 +
 drivers/media/platform/Makefile                            |    2 +
 drivers/media/platform/am437x/Kconfig                      |   11 +
 drivers/media/platform/am437x/Makefile                     |    3 +
 drivers/media/platform/am437x/am437x-vpfe.c                | 2778 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/am437x/am437x-vpfe.h                |  283 +++++++
 drivers/media/platform/am437x/am437x-vpfe_regs.h           |  140 ++++
 include/uapi/linux/Kbuild                                  |    1 +
 include/uapi/linux/am437x-vpfe.h                           |  122 +++
 11 files changed, 3411 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-am437x-vpfe.txt
 create mode 100644 drivers/media/platform/am437x/Kconfig
 create mode 100644 drivers/media/platform/am437x/Makefile
 create mode 100644 drivers/media/platform/am437x/am437x-vpfe.c
 create mode 100644 drivers/media/platform/am437x/am437x-vpfe.h
 create mode 100644 drivers/media/platform/am437x/am437x-vpfe_regs.h
 create mode 100644 include/uapi/linux/am437x-vpfe.h
