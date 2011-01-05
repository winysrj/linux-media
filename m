Return-path: <mchehab@gaivota>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1248 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1AESNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 13:13:37 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p05IDR1a075118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 5 Jan 2011 19:13:36 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Remove duplicate radio-gemtek-pci driver
Date: Wed, 5 Jan 2011 19:13:21 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101051913.21915.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The radio-gemtek-pci driver and the radio-maxiradio driver are identical.
This patch removes the gemtek-pci driver. The maxiradio driver is slightly
better as it supports mono/stereo detection.

Tested with my GemTek PCI card.

Regards,

	Hans

The following changes since commit aeb13b434d0953050306435cd3134d65547dbcf4:
  Mauro Carvalho Chehab (1):
        cx25821: Fix compilation breakage due to BKL dependency

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git gemtek

Hans Verkuil (2):
      radio-maxiradio.c: use sensible frequency range
      radio-gemtek-pci: remove duplicate driver

 drivers/media/radio/Kconfig            |   14 -
 drivers/media/radio/Makefile           |    1 -
 drivers/media/radio/radio-gemtek-pci.c |  478 --------------------------------
 drivers/media/radio/radio-maxiradio.c  |    4 +-
 4 files changed, 2 insertions(+), 495 deletions(-)
 delete mode 100644 drivers/media/radio/radio-gemtek-pci.c	
-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
