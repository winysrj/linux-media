Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36925 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750926AbdFSMZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 08:25:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Various fixes/enhancements
Message-ID: <e1aee479-2701-466f-b2e8-1ea62cc511fb@xs4all.nl>
Date: Mon, 19 Jun 2017 14:25:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit acec3630155763c170c7ae6508cf973355464508:

   [media] s3c-camif: fix arguments position in a function call (2017-06-13 14:21:24 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.13f

for you to fetch changes up to abb81a8cd3e779209887c5d757b104d0737be57b:

   s5p-cec: update MAINTAINERS entry (2017-06-19 14:21:04 +0200)

----------------------------------------------------------------
Kieran Bingham (1):
       media: fdp1: Support ES2 platforms

Marek Szyprowski (1):
       s5p-cec: update MAINTAINERS entry

Niklas Söderlund (3):
       v4l: async: check for v4l2_dev in v4l2_async_notifier_register()
       media: entity: Add get_fwnode_pad entity operation
       media: entity: Add media_entity_get_fwnode_pad() function

Tomasz Figa (1):
       v4l2-core: Use kvmalloc() for potentially big allocations

  MAINTAINERS                                |  7 ++++---
  drivers/media/media-entity.c               | 36 ++++++++++++++++++++++++++++++++++++
  drivers/media/platform/rcar_fdp1.c         | 10 +++++++---
  drivers/media/v4l2-core/v4l2-async.c       |  8 +++++---
  drivers/media/v4l2-core/v4l2-ctrls.c       | 26 ++++++++++++++------------
  drivers/media/v4l2-core/v4l2-event.c       |  8 +++++---
  drivers/media/v4l2-core/v4l2-ioctl.c       |  7 ++++---
  drivers/media/v4l2-core/v4l2-subdev.c      |  8 +++++---
  drivers/media/v4l2-core/videobuf2-dma-sg.c |  8 ++++----
  include/media/media-entity.h               | 28 ++++++++++++++++++++++++++++
  10 files changed, 112 insertions(+), 34 deletions(-)
