Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:22224 "EHLO
        DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750770AbdINFM1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 01:12:27 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v2 0/3] media: ov7670: Add entity init and power operation
Date: Thu, 14 Sep 2017 13:11:08 +0800
Message-ID: <20170914051111.18197-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is to add the media entity pads initialization,
the s_power operation and get_fmt callback support.

Changes in v2:
 - Add the patch to support the get_fmt ops.
 - Remove the redundant invoking ov7670_init_gpio().

Wenyou Yang (3):
  media: ov7670: Add entity pads initialization
  media: ov7670: Add the get_fmt callback
  media: ov7670: Add the s_power operation

 drivers/media/i2c/ov7670.c | 71 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 6 deletions(-)

-- 
2.13.0
