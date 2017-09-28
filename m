Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37153 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752102AbdI1IU2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 04:20:28 -0400
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
Subject: [PATCH v3 0/5] media: atmel-isc: Rework the format list and clock provider
Date: Thu, 28 Sep 2017 16:18:23 +0800
Message-ID: <20170928081828.20335-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To improve the readability of code, rework the format list table,
split the format array into two. Meanwhile, fix the issue of the
clock provider operation.

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
 drivers/media/platform/atmel/atmel-isc.c      | 616 ++++++++++++++++++++------
 2 files changed, 483 insertions(+), 134 deletions(-)

-- 
2.13.0
