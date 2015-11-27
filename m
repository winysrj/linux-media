Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44803 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbbK0Na7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 08:30:59 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 84B0BE0BBB
	for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 14:30:54 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] New ti-cal driver
Message-ID: <56585B0E.8090907@xs4all.nl>
Date: Fri, 27 Nov 2015 14:30:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 10897dacea26943dd80bd6629117f4620fc320ef:

  Merge tag 'v4.4-rc2' into patchwork (2015-11-23 14:16:58 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cal

for you to fetch changes up to 5df9a7909b737e9725c1005b3b39383e9c2490ca:

  media: v4l: ti-vpe: Document DRA72 CAL h/w module (2015-11-27 14:25:07 +0100)

----------------------------------------------------------------
Benoit Parrot (2):
      media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
      media: v4l: ti-vpe: Document DRA72 CAL h/w module

 Documentation/devicetree/bindings/media/ti-cal.txt |   72 ++
 drivers/media/platform/Kconfig                     |   12 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/ti-vpe/Makefile             |    4 +
 drivers/media/platform/ti-vpe/cal.c                | 2143 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h           |  779 +++++++++++++++++++++
 6 files changed, 3012 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
