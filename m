Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55839 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbaKCIvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 03:51:50 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id ED7C72A0376
	for <linux-media@vger.kernel.org>; Mon,  3 Nov 2014 09:51:40 +0100 (CET)
Message-ID: <5457421C.4050100@xs4all.nl>
Date: Mon, 03 Nov 2014 09:51:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] cx88: convert to vb2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains this patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg79597.html

It's unchanged except for rebasing to the latest master and for fixing the
somewhat garbled commit message of patch 02/16.

I have also re-tested the DMA engine: stress testing with continuously
switching between TV frequencies (one with and one without a channel) and
between inputs (one with (TV) and one without a signal (Composite)) while
streaming without ever detecting any DMA problems.

I am convinced the whole DMA restart mess is due to misunderstandings of
how format changes are handled. The author apparently thought that format
changes can be done while streaming, which is not the case since you cannot
change the size of the buffers without stopping first.

So I am sticking by this patch series :-)

Regards,

	Hans

The following changes since commit 082417d10fafe7be835d143ade7114b5ce26cb50:

  [media] cx231xx: remove direct register PWR_CTL_EN modification that switches port3 (2014-11-01 08:59:06 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx88

for you to fetch changes up to 1a48165e38da225fa187a756c6dd9941bdd85a9e:

  cx88: fix VBI support (2014-11-03 09:39:12 +0100)

----------------------------------------------------------------
Hans Verkuil (16):
      cx88: remove fmt from the buffer struct
      cx88: drop the bogus 'queue' list in dmaqueue.
      cx88: drop videobuf abuse in cx88-alsa
      cx88: convert to vb2
      cx88: fix sparse warning
      cx88: return proper errors during fw load
      cx88: drop cx88_free_buffer
      cx88: remove dependency on btcx-risc
      cx88: increase API command timeout
      cx88: don't pollute the kernel log
      cx88: move width, height and field to core struct
      cx88: drop mpeg_active field.
      cx88: don't allow changes while vb2_is_busy
      cx88: consistently use UNSET for absent tuner
      cx88: pci_disable_device comes after free_irq.
      cx88: fix VBI support

 drivers/media/pci/cx88/Kconfig          |   5 +-
 drivers/media/pci/cx88/Makefile         |   1 -
 drivers/media/pci/cx88/cx88-alsa.c      | 112 +++++++++--
 drivers/media/pci/cx88/cx88-blackbird.c | 565 +++++++++++++++++++++++++-----------------------------
 drivers/media/pci/cx88/cx88-cards.c     |  71 +++----
 drivers/media/pci/cx88/cx88-core.c      | 113 ++++-------
 drivers/media/pci/cx88/cx88-dvb.c       | 158 +++++++++++-----
 drivers/media/pci/cx88/cx88-mpeg.c      | 159 ++++------------
 drivers/media/pci/cx88/cx88-vbi.c       | 216 +++++++++++----------
 drivers/media/pci/cx88/cx88-video.c     | 871 ++++++++++++++++++++++++++----------------------------------------------------------
 drivers/media/pci/cx88/cx88.h           | 104 +++++-----
 11 files changed, 985 insertions(+), 1390 deletions(-)
