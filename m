Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:34996 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdIRBaz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 21:30:55 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v3 0/3] media: ov7670: Add entity init and power operation
Date: Mon, 18 Sep 2017 09:29:24 +0800
Message-ID: <20170918012928.13278-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is to add the media entity pads initialization,
the s_power operation and get_fmt callback support.

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

 drivers/media/i2c/ov7670.c | 103 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 96 insertions(+), 7 deletions(-)

-- 
2.13.0
