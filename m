Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54380 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbH1Lt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com
Subject: [PATCHv2 0/8] saa7164: v4l2-compliance fixes
Date: Fri, 28 Aug 2015 13:48:25 +0200
Message-Id: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes many v4l2-compliance issues in the saa7164 driver.

As part of that it converts this driver to the control framework which
simplifies Ricardo's "Support getting default values from any control"
patch series.

Everything has been tested with my HVR-2200 board.

v4l2-compliance now no longer returns any failures for the video and vbi
devices.

Regards,

	Hans

Hans Verkuil (8):
  saa7164: convert to the control framework
  saa7164: add v4l2_fh support
  saa7164: fix poll bugs
  saa7164: add support for control events
  saa7164: fix format ioctls
  saa7164: remove unused videobuf references
  saa7164: fix input and tuner compliance problems
  saa7164: video and vbi ports share the same input/tuner/std

 drivers/media/pci/saa7164/Kconfig           |   1 -
 drivers/media/pci/saa7164/saa7164-encoder.c | 653 ++++++++--------------------
 drivers/media/pci/saa7164/saa7164-vbi.c     | 629 +--------------------------
 drivers/media/pci/saa7164/saa7164.h         |  26 +-
 4 files changed, 217 insertions(+), 1092 deletions(-)

-- 
2.1.4

