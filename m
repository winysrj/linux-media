Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4423 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaICGme (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 02:42:34 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s836gU3D083850
	for <linux-media@vger.kernel.org>; Wed, 3 Sep 2014 08:42:32 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 66DE12A075A
	for <linux-media@vger.kernel.org>; Wed,  3 Sep 2014 08:42:26 +0200 (CEST)
Message-ID: <5406B852.2020000@xs4all.nl>
Date: Wed, 03 Sep 2014 08:42:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Add driver for tw68xx PCI grabber boards
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

As requested, this is the same tw68 driver, but it first adds the original tw68
sources from the gitorious repository.

I still disagree with this, I would think that it would be sufficient if the
commit log would state that you checked the original sources and that they were
all GPL. In my view this pollutes the kernel git repository. But it's your call
whether to take my original tw68 pull request or to take this one.

Regards,

	Hans

The following changes since commit 6c1c423a54b5b3a6c9c9561c7ef32aee0fda7253:

  [media] vivid: comment the unused g_edid/s_edid functions (2014-09-02 18:01:05 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tw68b

for you to fetch changes up to 0d96a1b6e48d0eec6a8880c825c1d6e16396c280:

  MAINTAINERS: add tw68 entry (2014-09-03 08:37:23 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      tw68: add original tw68 code
      tw68: refactor and cleanup the tw68 driver
      MAINTAINERS: add tw68 entry

 MAINTAINERS                         |    8 +
 drivers/media/pci/Kconfig           |    1 +
 drivers/media/pci/Makefile          |    1 +
 drivers/media/pci/tw68/Kconfig      |   10 +
 drivers/media/pci/tw68/Makefile     |    3 +
 drivers/media/pci/tw68/tw68-core.c  |  434 ++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw68/tw68-reg.h   |  195 ++++++++++++++++
 drivers/media/pci/tw68/tw68-risc.c  |  230 +++++++++++++++++++
 drivers/media/pci/tw68/tw68-video.c | 1060 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw68/tw68.h       |  231 +++++++++++++++++++
 10 files changed, 2173 insertions(+)
 create mode 100644 drivers/media/pci/tw68/Kconfig
 create mode 100644 drivers/media/pci/tw68/Makefile
 create mode 100644 drivers/media/pci/tw68/tw68-core.c
 create mode 100644 drivers/media/pci/tw68/tw68-reg.h
 create mode 100644 drivers/media/pci/tw68/tw68-risc.c
 create mode 100644 drivers/media/pci/tw68/tw68-video.c
 create mode 100644 drivers/media/pci/tw68/tw68.h
