Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41832 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754079AbdJJCtW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 22:49:22 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v4 0/5] media: atmel-isc: Rework the format list and clock provider
Date: Tue, 10 Oct 2017 10:46:35 +0800
Message-ID: <20171010024640.5733-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To improve the readability of code, rework the format list table,
split the format array into two. Meanwhile, fix the issue of the
clock provider operation and the pm runtime support.

Changes in v4:
 - Call pm_runtime_get_sync() and pm_runtime_put_sync() in ->prepare
   and ->unprepare callback.
 - Move pm_runtime_enable() call from the complete callback to the
   end of probe.
 - Call pm_runtime_get_sync() and pm_runtime_put_sync() in
   ->is_enabled() callbacks.
 - Call clk_disable_unprepare() in ->remove callback.

Changes in v3:
 - Fix the wrong used spinlock.
 - s/_/- on the subject.
 - Add a new flag for Raw Bayer format to remove MAX_RAW_FMT_INDEX define.
 - Add the comments for define of the format flag.
 - Rebase media_tree/master.

Changes in v2:
 - Add the new patch to remove the unnecessary member from
   isc_subdev_entity struct.
 - Rebase on the patch set,
        [PATCH 0/6] [media] Atmel: Adjustments for seven function implementations
        https://www.mail-archive.com/linux-media@vger.kernel.org/msg118342.html

Wenyou Yang (5):
  media: atmel-isc: Add spin lock for clock enable ops
  media: atmel-isc: Add prepare and unprepare ops
  media: atmel-isc: Enable the clocks during probe
  media: atmel-isc: Remove unnecessary member
  media: atmel-isc: Rework the format list

 drivers/media/platform/atmel/atmel-isc-regs.h |   1 +
 drivers/media/platform/atmel/atmel-isc.c      | 629 ++++++++++++++++++++------
 2 files changed, 498 insertions(+), 132 deletions(-)

-- 
2.13.0
