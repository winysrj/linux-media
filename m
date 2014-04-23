Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2846 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaDWNu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 09:50:57 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3NDos5d084991
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 15:50:56 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E39F82A0002
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 15:50:42 +0200 (CEST)
Message-ID: <5357C532.4030206@xs4all.nl>
Date: Wed, 23 Apr 2014 15:50:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] saa7134 fixes and vb2 conversion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I have attempted to split up the saa7134 vb2 conversion a bit more, but I don't
see how I can reduce it further, except by disabling parts of the driver, then
converting each part and enabling it again (i.e., disable dvb & empress, convert
just video/vbi to vb2, then empress, then dvb).

But I think that's rather ugly since a bisect might end up with a partially
crippled driver.

It's the same as what I posted a week ago, except rebased to the latest master
branch:

http://www.spinics.net/lists/linux-media/msg75893.html

If you still want more changes, then please see if you can at least merge the
first 9 patches.

Regards,

	Hans

The following changes since commit ce9c22443e77594531be84ba8d523f4148ba09fe:

  [media] vb2: fix compiler warning (2014-04-23 10:13:57 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16c

for you to fetch changes up to e37d96689c22fd547ed4153ae8a67c26c54ae679:

  saa7134: add saa7134_userptr module option to enable USERPTR (2014-04-23 15:42:45 +0200)

----------------------------------------------------------------
Hans Verkuil (11):
      saa7134: fix regression with tvtime
      saa7134: coding style cleanups.
      saa7134: drop abuse of low-level videobuf functions
      saa7134: swap ts_init_encoder and ts_reset_encoder
      saa7134: store VBI hlen/vlen globally
      saa7134: remove fmt from saa7134_buf
      saa7134: rename empress_tsq to empress_vbq
      saa7134: rename vbi/cap to vbi_vbq/cap_vbq
      saa7134: move saa7134_pgtable to saa7134_dmaqueue
      saa7134: convert to vb2
      saa7134: add saa7134_userptr module option to enable USERPTR

 drivers/media/pci/saa7134/Kconfig           |   4 +-
 drivers/media/pci/saa7134/saa7134-alsa.c    | 106 +++++++++++--
 drivers/media/pci/saa7134/saa7134-core.c    | 130 ++++++++--------
 drivers/media/pci/saa7134/saa7134-dvb.c     |  50 ++++---
 drivers/media/pci/saa7134/saa7134-empress.c | 186 +++++++++--------------
 drivers/media/pci/saa7134/saa7134-i2c.c     |   7 -
 drivers/media/pci/saa7134/saa7134-reg.h     |   7 -
 drivers/media/pci/saa7134/saa7134-ts.c      | 191 +++++++++++++-----------
 drivers/media/pci/saa7134/saa7134-tvaudio.c |   7 -
 drivers/media/pci/saa7134/saa7134-vbi.c     | 175 ++++++++++------------
 drivers/media/pci/saa7134/saa7134-video.c   | 652 +++++++++++++++++++++++++++++---------------------------------------------------
 drivers/media/pci/saa7134/saa7134.h         | 107 +++++++------
 12 files changed, 732 insertions(+), 890 deletions(-)
