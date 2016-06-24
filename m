Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35427 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbcFXFkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:17 -0400
Received: by mail-wm0-f66.google.com with SMTP id a66so2180778wme.2
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:17 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/9] media: rc: nuvoton: several clean-ups / removal of dead
 code
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <bf2e8de2-b00b-4724-0cd2-0ea0a7803562@gmail.com>
Date: Fri, 24 Jun 2016 07:38:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set for the nuvoton-cir driver includes several
clean-ups and removes dead code.

Heiner Kallweit (9):
  media: rc: nuvoton: remove interrupt handling for wakeup
  media: rc: nuvoton: clean up initialization of wakeup registers
  media: rc: nuvoton: remove wake states
  media: rc: nuvoton: simplify a few functions
  media: rc: nuvoton: remove unneeded code in nvt_process_rx_ir_data
  media: rc: nuvoton: remove study states
  media: rc: nuvoton: simplify interrupt handling code
  media: rc: nuvoton: remove unneeded check in nvt_get_rx_ir_data
  media: rc: nuvoton: remove two unused elements in struct nvt_dev

 drivers/media/rc/nuvoton-cir.c | 123 ++++-------------------------------------
 drivers/media/rc/nuvoton-cir.h |  25 ---------
 2 files changed, 10 insertions(+), 138 deletions(-)

-- 
2.9.0

