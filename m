Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33035 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbbDCIUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 04:20:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B8ADC2A009F
	for <linux-media@vger.kernel.org>; Fri,  3 Apr 2015 10:19:40 +0200 (CEST)
Message-ID: <551E4D1C.7050709@xs4all.nl>
Date: Fri, 03 Apr 2015 10:19:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v4.1] Three important fixes for 4.1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two driver fixes and one compilation fix.

Regards,

	Hans

The following changes since commit a5562f65b1371a0988b707c10c44fcc2bba56990:

  [media] v4l: xilinx: Add Test Pattern Generator driver (2015-04-03 01:04:18 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1p

for you to fetch changes up to b7ecb5bc1ddc64754a7421fb631d005742a40a64:

  ov2640: add missing consumer.h include (2015-04-03 10:17:48 +0200)

----------------------------------------------------------------
David Howells (1):
      cx23885: Always initialise dev->slock spinlock

Florian Echtler (1):
      sur40: fix occasional hard freeze due to buffer queue underrun

Hans Verkuil (1):
      ov2640: add missing consumer.h include

 drivers/input/touchscreen/sur40.c         | 5 +++++
 drivers/media/i2c/soc_camera/ov2640.c     | 1 +
 drivers/media/pci/cx23885/cx23885-core.c  | 1 +
 drivers/media/pci/cx23885/cx23885-video.c | 1 -
 4 files changed, 7 insertions(+), 1 deletion(-)
