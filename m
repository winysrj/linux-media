Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4709 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaIVKff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 06:35:35 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8MAZW5B072604
	for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 12:35:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 69B452A0761
	for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 12:35:25 +0200 (CEST)
Message-ID: <541FFB6D.7040602@xs4all.nl>
Date: Mon, 22 Sep 2014 12:35:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] v4l2-ioctl.c fix + saa7134 improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f5281fc81e9a0a3e80b78720c5ae2ed06da3bfae:

  [media] vpif: Fix compilation with allmodconfig (2014-09-09 18:08:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.18d

for you to fetch changes up to 6b167cb4cc6a3b69928dfcc9dbef847a0d937500:

  saa7134: add saa7134-go7007 (2014-09-22 12:10:17 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      v4l2-ioctl.c: fix inverted condition
      saa7134: also capture the WSS signal for 50 Hz VBI capture
      saa7134: add saa7134-go7007

 drivers/media/pci/saa7134/Makefile         |   3 +-
 drivers/media/pci/saa7134/saa7134-cards.c  |  29 +++++
 drivers/media/pci/saa7134/saa7134-core.c   |  10 +-
 drivers/media/pci/saa7134/saa7134-go7007.c | 532 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-vbi.c    |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c  |   2 +-
 drivers/media/pci/saa7134/saa7134.h        |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c       |   2 +-
 8 files changed, 579 insertions(+), 6 deletions(-)
 create mode 100644 drivers/media/pci/saa7134/saa7134-go7007.c
