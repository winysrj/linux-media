Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:44827 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdHQHW3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 03:22:29 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        <linux-arm-kernel@lists.infradead.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 0/3] media: atmel-isc: Supplement the configuration of formats
Date: Thu, 17 Aug 2017 15:16:11 +0800
Message-ID: <20170817071614.12767-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intention of the patch set is to add more configuration of
formats: GREY, ARGB444, ARGB555 and ARGB32, and add the checking
the format from the extern sensor which doesn't support RGB
formats from the external sensor.


Wenyou Yang (3):
  media: atmel-isc: Not support RBG format from sensor.
  media: atmel-isc: Remove the redundant assignment
  media: atmel-isc: Add more format configurations

 drivers/media/platform/atmel/atmel-isc.c | 89 ++++++++++++++++++++------------
 1 file changed, 56 insertions(+), 33 deletions(-)

-- 
2.13.0
