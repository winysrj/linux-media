Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4536 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaGYHaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 03:30:07 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6P7U1UJ024148
	for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 09:30:05 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 16CF82A037E
	for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 09:30:01 +0200 (CEST)
Message-ID: <53D20778.5040001@xs4all.nl>
Date: Fri, 25 Jul 2014 09:30:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17/18] miro/si4713 RDS enhancements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I leave it to you whether to merge this for 3.17 or 3.18.

Note that this pull request includes (and requires) the patches from my earlier
pull request: https://patchwork.linuxtv.org/patch/25026/

The patches from that pull request are definitely for 3.17, but the miro and
si4713 enhancements are fine for 3.18 as well.

All tested and verified with my miropcm20 board and my si4713 board.
I've been sitting on this for quite some time waiting for the compound control
support to go in since the alternate frequency support required that.

Regards,

	Hans

The following changes since commit 488046c237f3b78f91046d45662b318cd2415f64:

  [media] rc: Fix compilation of st_rc and sunxi-cir (2014-07-23 23:04:17 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17g

for you to fetch changes up to cccea2f830ae3a739071883e5dea4c32161fcfcc:

  radio-miropcm20: add RDS support. (2014-07-25 09:20:45 +0200)

----------------------------------------------------------------
Hans Verkuil (10):
      Docbook/media: improve data_offset/bytesused documentation
      v4l2-ctrls: add support for setting string controls
      vb2: fix videobuf2-core.h comments
      vb2: fix vb2_poll for output streams
      v4l2-ctrls: add new RDS TX controls
      DocBook/media: document the new RDS TX controls
      si4713: add the missing RDS functionality.
      v4l2-ctrls: add RX RDS controls.
      DocBook/media: document the new RDS RX controls
      radio-miropcm20: add RDS support.

 Documentation/DocBook/media/v4l/controls.xml | 113 ++++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/io.xml       |   7 +-
 drivers/media/radio/radio-miropcm20.c        | 303 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/media/radio/si4713/si4713.c          |  76 +++++++++++++++++++-
 drivers/media/radio/si4713/si4713.h          |   9 +++
 drivers/media/v4l2-core/v4l2-ctrls.c         | 101 +++++++++++++++++++--------
 drivers/media/v4l2-core/videobuf2-core.c     |   7 ++
 include/media/v4l2-ctrls.h                   |  26 +++++++
 include/media/videobuf2-core.h               |  16 +++--
 include/uapi/linux/v4l2-controls.h           |  15 ++++
 include/uapi/linux/videodev2.h               |   2 +
 11 files changed, 621 insertions(+), 54 deletions(-)
