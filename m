Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2380 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaAQNod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 08:44:33 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s0HDiUHr000304
	for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 14:44:32 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 323B42A00A0
	for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 14:44:24 +0100 (CET)
Message-ID: <52D933B8.7070201@xs4all.nl>
Date: Fri, 17 Jan 2014 14:44:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Repost: various v4l2 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some reason this didn't appear in patchwork, so I repost this pull request.

Regards,

	Hans

The following changes since commit d20e4ed6d30c6ecee315eea0efb3449c3591d09e:

  [media] em28xx: use a better value for I2C timeouts (2014-01-10 06:10:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.14c

for you to fetch changes up to 190a7f631e1f972912d1777aadbaa6854be00085:

  vb2: Check if there are buffers before streamon (2014-01-10 16:09:53 +0100)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      go7007-loader: fix usb_dev leak

Hans Verkuil (1):
      Revert "[media] videobuf_vm_{open,close} race fixes"

Levente Kurusa (1):
      media: bt8xx: add missing put_device call

Ricardo Ribalda (1):
      vb2: Check if there are buffers before streamon

 drivers/media/pci/bt8xx/bttv-gpio.c           |  2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c | 12 +++++-------
 drivers/media/v4l2-core/videobuf-dma-sg.c     | 10 ++++------
 drivers/media/v4l2-core/videobuf-vmalloc.c    | 10 ++++------
 drivers/media/v4l2-core/videobuf2-core.c      |  5 +++++
 drivers/staging/media/go7007/go7007-loader.c  |  4 +++-
 6 files changed, 22 insertions(+), 21 deletions(-)
