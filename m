Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2552 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJVJlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 05:41:32 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s9M9fR5F066978
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 11:41:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.200.78] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id 1FAFD2A0432
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 11:41:16 +0200 (CEST)
Message-ID: <54477BC6.6050901@xs4all.nl>
Date: Wed, 22 Oct 2014 11:41:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] cx88: convert to vb2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request contains this patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg79597.html

It's unchanged except for rebasing to v3.18-rc1.

Regards,

	Hans

The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

   Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cx88

for you to fetch changes up to ad3314ca0ea90fd7b82d0a8a72727a7cc7bd99f1:

   cx88: fix VBI support (2014-10-22 11:30:36 +0200)

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
  drivers/media/pci/cx88/cx88-alsa.c      | 112 +++++++--
  drivers/media/pci/cx88/cx88-blackbird.c | 565 ++++++++++++++++++++-------------------------
  drivers/media/pci/cx88/cx88-cards.c     |  71 +++---
  drivers/media/pci/cx88/cx88-core.c      | 113 +++------
  drivers/media/pci/cx88/cx88-dvb.c       | 158 +++++++++----
  drivers/media/pci/cx88/cx88-mpeg.c      | 159 ++++---------
  drivers/media/pci/cx88/cx88-vbi.c       | 216 +++++++++--------
  drivers/media/pci/cx88/cx88-video.c     | 871 +++++++++++++++++++++------------------------------------------------
  drivers/media/pci/cx88/cx88.h           | 104 ++++-----
  11 files changed, 985 insertions(+), 1390 deletions(-)
