Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49754 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751754AbcHVJPY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:15:24 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 714FD180BB8
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 11:15:18 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] rcar-vin: clean up and prepare for Gen3
Message-ID: <47a78b54-1ab9-8a2b-de9a-2b9472a69c3c@xs4all.nl>
Date: Mon, 22 Aug 2016 11:15:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See cover letter of this patch series for more details:

http://www.spinics.net/lists/linux-renesas-soc/msg06449.html

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rcarvin

for you to fetch changes up to 77434b5e30b57eaed9932cc95d03004702993950:

  rcar-vin: move media bus information to struct rvin_graph_entity (2016-08-19 16:08:48 +0200)

----------------------------------------------------------------
Niklas Söderlund (10):
      rcar-vin: fix indentation errors in rcar-v4l2.c
      rcar-vin: reduce indentation in rvin_s_dv_timings()
      rcar-vin: arrange enum chip_id in chronological order
      rcar-vin: rename entity to digital
      rcar-vin: return correct error from platform_get_irq()
      rcar-vin: do not use v4l2_device_call_until_err()
      rcar-vin: add dependency on MEDIA_CONTROLLER
      rcar-vin: move chip check for pixelformat support
      rcar-vin: rework how subdeivce is found and bound
      rcar-vin: move media bus information to struct rvin_graph_entity

 drivers/media/platform/rcar-vin/Kconfig     |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 258 ++++++++++++++++++++++++++------------------------------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  18 ++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  91 ++++++++++----------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  25 +++---
 5 files changed, 186 insertions(+), 208 deletions(-)
