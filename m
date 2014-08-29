Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1482 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaH2GXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 02:23:10 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7T6N77r092588
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 08:23:09 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E565E2A0757
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 08:23:03 +0200 (CEST)
Message-ID: <54001C47.8020608@xs4all.nl>
Date: Fri, 29 Aug 2014 08:23:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Add driver for tw68xx PCI grabber boards
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the tw68 PCI driver.

These two patches are identical to the v3 patch series I posted earlier:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/81407

Regards,

	Hans

The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:

  [media] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tw68

for you to fetch changes up to f9c0c8edba28682cd6ab7254f2da911272053989:

  MAINTAINERS: add tw68 entry (2014-08-26 08:26:39 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      tw68: add support for Techwell tw68xx PCI grabber boards
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
