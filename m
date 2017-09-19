Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:28982 "EHLO
        DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750893AbdISAql (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 20:46:41 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v5 0/3] media: ov7670: Add entity init and power operation
Date: Tue, 19 Sep 2017 08:45:06 +0800
Message-ID: <20170919004509.12722-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is to add the media entity pads initialization,
the s_power operation and get_fmt callback support.

Changes in v5:
 - Fix the build warning on the declaration *mbus_fmt(ISO C90 forbids mixed).

Changes in v4:
 - Fix the build error when not enabling Media Controller API option.
 - Fix the build error when not enabling V4L2 sub-device userspace API option.

Changes in v3:
 - Keep tried format info in the try_fmt member of
   v4l2_subdev__pad_config struct.
 - Add the internal_ops callback to set default format.

Changes in v2:
 - Add the patch to support the get_fmt ops.
 - Remove the redundant invoking ov7670_init_gpio().

Wenyou Yang (3):
  media: ov7670: Add entity pads initialization
  media: ov7670: Add the get_fmt callback
  media: ov7670: Add the s_power operation

 drivers/media/i2c/ov7670.c | 130 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 7 deletions(-)

-- 
2.13.0
