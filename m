Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54978 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbcAYPBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 10:01:06 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id BF70A180D36
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2016 16:00:50 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] New TI CAL driver
Message-ID: <56A638A2.3090602@xs4all.nl>
Date: Mon, 25 Jan 2016 16:00:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding Benoit's new TI CAL driver.

Regards,

	Hans


The following changes since commit 99e44da7928d4abb3028258ac3cd23a48495cd61:

  [media] media: change email address (2016-01-25 12:01:08 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cal

for you to fetch changes up to 795dc7e38f25d7f76a596dc39e031cac490b873a:

  media: ti-vpe: Add CAL v4l2 camera capture driver (2016-01-25 15:54:20 +0100)

----------------------------------------------------------------
Benoit Parrot (3):
      media: ti-vpe: Document CAL driver
      MAINTAINERS: Add ti-vpe maintainer entry
      media: ti-vpe: Add CAL v4l2 camera capture driver

 Documentation/devicetree/bindings/media/ti-cal.txt |   72 +++
 MAINTAINERS                                        |    8 +
 drivers/media/platform/Kconfig                     |   12 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/ti-vpe/Makefile             |    4 +
 drivers/media/platform/ti-vpe/cal.c                | 1970 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h           |  479 ++++++++++++++
 7 files changed, 2547 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
