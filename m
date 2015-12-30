Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38016 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbL3Qqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 11:46:42 -0500
Received: by mail-wm0-f53.google.com with SMTP id b14so55516968wmb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 08:46:41 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 00/16] media: rc: nuvoton-cir: series with improvements and
 fixes
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <568408B0.5030507@gmail.com>
Date: Wed, 30 Dec 2015 17:39:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Heiner Kallweit (16):
  media: rc: nuvoton-cir: use request_muxed_region for accessing EFM registers
  media: rc: nuvoton-cir: simplify nvt_select_logical_ dev
  media: rc: nuvoton-cir: simplify nvt_cir_tx_inactive
  media: rc: nuvoton-cir: factor out logical device disabling
  media: rc: nuvoton-cir: factor out logical device enabling
  media: rc: nuvoton-cir: fix clearing wake fifo
  media: rc: nuvoton-cir: fix setting ioport base address
  media: rc: nuvoton-cir: remove unneeded EFM operation in nvt_cir_isr
  media: rc: nuvoton-cir: use IR_DEFAULT_TIMEOUT and consider SAMPLE_PERIOD
  media: rc: nuvoton-cir: improve nvt_hw_detect
  media: rc: nuvoton-cir: improve logical device handling
  media: rc: nuvoton-cir: remove unneeded call to nvt_set_cir_iren
  media: rc: nuvoton-cir: add locking to calls of nvt_enable_wake
  media: rc: nuvoton-cir: fix wakeup interrupt bits
  media: rc: nuvoton-cir: fix interrupt handling
  media: rc: nuvoton-cir: improve locking in both interrupt handlers

 drivers/media/rc/nuvoton-cir.c | 204 +++++++++++++++++++++++------------------
 drivers/media/rc/nuvoton-cir.h |  12 +--
 2 files changed, 122 insertions(+), 94 deletions(-)

-- 
2.6.4

