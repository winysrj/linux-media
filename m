Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56252 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752432AbeGBQHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 12:07:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes/improvements
Message-ID: <d8e71e81-8258-3103-9eca-928a69204a48@xs4all.nl>
Date: Mon, 2 Jul 2018 18:07:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a long-standing bug in v4l2-ctrls.c, mark all interface links as
IMMUTABLE and add helpers to configure an MC for mem-to-mem devices
and use that in vim2m.

Note regarding the v4l2-ctrls.c fix: I've decided not to backport this.
It's a dark corner of the spec that few people use and that AFAICT never
worked properly. Hugues Fruchet was the first to complain about this in
many years, so this is clearly not a high prio thing.

If I change my mind, then this should be backported all the way to 3.11.
But before that it was also wrong, except this patch no longer applies.

Regards,

	Hans

The following changes since commit 3c4a737267e89aafa6308c6c456d2ebea3fcd085:

  media: ov5640: fix frame interval enumeration (2018-06-28 09:24:38 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19g

for you to fetch changes up to dd8320d3a8af219ce084e7342df3e9a0cecc289b:

  vim2m: add media device (2018-07-02 18:00:04 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      media: add helpers for memory-to-memory media controller

Hans Verkuil (3):
      v4l2-ctrls.c: fix broken auto cluster handling
      media: mark entity-intf links as IMMUTABLE
      vim2m: add media device

 drivers/media/dvb-core/dvbdev.c        |  18 ++++--
 drivers/media/platform/vim2m.c         |  41 ++++++++++++--
 drivers/media/v4l2-core/v4l2-ctrls.c   |  15 ++++-
 drivers/media/v4l2-core/v4l2-dev.c     |  16 ++++--
 drivers/media/v4l2-core/v4l2-device.c  |   3 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |  19 +++++++
 7 files changed, 284 insertions(+), 18 deletions(-)
