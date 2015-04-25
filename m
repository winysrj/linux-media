Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52957 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbbDYPnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:23 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 35EBD2A0081
	for <linux-media@vger.kernel.org>; Sat, 25 Apr 2015 17:42:53 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/12] dt3155v4l: clean up and move out of staging
Date: Sat, 25 Apr 2015 17:42:39 +0200
Message-Id: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This has been on my TODO list for a long time and I finally got time to
work on this driver.

These patches clean up this driver, make it pass the v4l2-compliance tests
and even adds support for the breakout cable (at least the additional 3
inputs). Tested with my dt3155 card + breakout cable that I bought a few
years ago.

The code is now in good shape and so this driver is moved out of staging into
drivers/media/pci and renamed to dt3155 (the v4l suffix was silly).

It's unlikely that anyone will ever care about this driver, but, as they say,
"Have hardware, must have proper driver" :-)

Or just call me nuts, that's OK too...

Regards,

	Hans

Hans Verkuil (12):
  dt3155v4l: code cleanup
  dt3155v4l: remove unused statistics
  dt3155v4l: add v4l2_device support
  dt3155v4l: remove pointless dt3155_alloc/free_coherent
  dt3155v4l: remove bogus single-frame capture in init_board
  dt3155v4l: move vb2_queue to top-level
  dt3155v4l: drop CONFIG_DT3155_STREAMING
  dt3155v4l: correctly start and stop streaming
  dt3155v4l: drop CONFIG_DT3155_CCIR, use s_std instead
  dt3155v4l: fix format handling
  dt3155v4l: support inputs VID0-3
  dt3155: move out of staging into drivers/media/pci

 MAINTAINERS                                        |   8 +
 drivers/media/pci/Kconfig                          |   1 +
 drivers/media/pci/Makefile                         |   1 +
 drivers/media/pci/dt3155/Kconfig                   |  13 +
 drivers/media/pci/dt3155/Makefile                  |   1 +
 drivers/media/pci/dt3155/dt3155.c                  | 626 +++++++++++++
 .../dt3155v4l.h => media/pci/dt3155/dt3155.h}      |  64 +-
 drivers/staging/media/Kconfig                      |   2 -
 drivers/staging/media/Makefile                     |   1 -
 drivers/staging/media/dt3155v4l/Kconfig            |  29 -
 drivers/staging/media/dt3155v4l/Makefile           |   1 -
 drivers/staging/media/dt3155v4l/dt3155v4l.c        | 981 ---------------------
 12 files changed, 674 insertions(+), 1054 deletions(-)
 create mode 100644 drivers/media/pci/dt3155/Kconfig
 create mode 100644 drivers/media/pci/dt3155/Makefile
 create mode 100644 drivers/media/pci/dt3155/dt3155.c
 rename drivers/{staging/media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h} (82%)
 delete mode 100644 drivers/staging/media/dt3155v4l/Kconfig
 delete mode 100644 drivers/staging/media/dt3155v4l/Makefile
 delete mode 100644 drivers/staging/media/dt3155v4l/dt3155v4l.c

-- 
2.1.4

