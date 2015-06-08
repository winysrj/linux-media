Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34179 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbbFHO45 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 10:56:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EB99D2A0095
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2015 16:56:50 +0200 (CEST)
Message-ID: <5575AD32.7080100@xs4all.nl>
Date: Mon, 08 Jun 2015 16:56:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] bdisp driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the bdisp driver (again), this time with MAINTAINERS update.

Regards,

	Hans

The following changes since commit 839aa56d077972170a074bcbe31bf0d7eba37b24:

  [media] v4l2-ioctl: log buffer type 0 correctly (2015-06-06 07:43:49 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2o

for you to fetch changes up to d7d3934afef945c771d476df19614d6631805462:

  bdisp: update MAINTAINERS (2015-06-08 16:55:59 +0200)

----------------------------------------------------------------
Fabien Dessenne (3):
      bdisp: add DT bindings documentation
      bdisp: 2D blitter driver using v4l2 mem2mem framework
      bdisp: add debug file system

Hans Verkuil (1):
      bdisp: update MAINTAINERS

 Documentation/devicetree/bindings/media/st,stih4xx.txt |   32 ++
 MAINTAINERS                                            |    8 +
 drivers/media/platform/Kconfig                         |   10 +
 drivers/media/platform/Makefile                        |    2 +
 drivers/media/platform/sti/bdisp/Kconfig               |    9 +
 drivers/media/platform/sti/bdisp/Makefile              |    3 +
 drivers/media/platform/sti/bdisp/bdisp-debug.c         |  668 ++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-filter.h        |  346 +++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-hw.c            |  823 +++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-reg.h           |  235 ++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c          | 1420 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp.h               |  216 +++++++++++
 12 files changed, 3772 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stih4xx.txt
 create mode 100644 drivers/media/platform/sti/bdisp/Kconfig
 create mode 100644 drivers/media/platform/sti/bdisp/Makefile
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-debug.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h
