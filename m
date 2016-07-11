Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41801 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbcGKTP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 15:15:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 47589180185
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 21:15:23 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Add staging driver for the Pulse Eight USB CEC
 adapter
Message-ID: <3f6e731b-6485-bc7c-a8b8-55bf29fe8a5a@xs4all.nl>
Date: Mon, 11 Jul 2016 21:15:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: the first two patches are also in my "Various fixes" pull request
(https://patchwork.linuxtv.org/patch/35332/). They are required for this driver,
otherwise it won't work correctly.

Dmitry is OK with pulling the input patch through our tree.

It would be really cool to have this driver in: it's one of the more common
CEC devices around.

Regards,

	Hans

The following changes since commit ca6e6126db5494f18c6c6615060d4d803b528bff:

  [media] media: dvb_ringbuffer: Add memory barriers (2016-07-09 07:57:47 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git pulse8

for you to fetch changes up to 56e3bab73e5c477b5f8cdc0f1b71731a8ead2632:

  pulse8-cec: add TODO file (2016-07-11 21:11:16 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      cec: add check if adapter is unregistered.
      cec: CEC_RECEIVE is allowed in monitor mode
      input: serio - add new protocol for the Pulse-Eight USB-CEC Adapter
      pulse8-cec: new driver for the Pulse-Eight USB-CEC Adapter
      MAINTAINERS: add entry for the pulse8-cec driver
      pulse8-cec: add TODO file

 MAINTAINERS                                   |   7 +
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/cec/cec-adap.c          |   5 +-
 drivers/staging/media/cec/cec-api.c           |   2 +-
 drivers/staging/media/pulse8-cec/Kconfig      |  10 ++
 drivers/staging/media/pulse8-cec/Makefile     |   1 +
 drivers/staging/media/pulse8-cec/TODO         |  52 ++++++
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 505 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/serio.h                    |   1 +
 10 files changed, 584 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/media/pulse8-cec/Kconfig
 create mode 100644 drivers/staging/media/pulse8-cec/Makefile
 create mode 100644 drivers/staging/media/pulse8-cec/TODO
 create mode 100644 drivers/staging/media/pulse8-cec/pulse8-cec.c
