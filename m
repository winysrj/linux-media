Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33074 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbcBAUvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 15:51:04 -0500
Received: by mail-wm0-f68.google.com with SMTP id r129so10835486wmr.0
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2016 12:51:03 -0800 (PST)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/3] media: rc: nuvoton: fix locking regression
Message-ID: <56AFC48C.90203@gmail.com>
Date: Mon, 1 Feb 2016 21:48:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 3def9ad6d306 "use request_muxed_region for accessing EFM registers"
caused a regression by using request_muxed_region (that may sleep) from
contexts holding a spinlock.

Heiner Kallweit (3):
  media: rc: nuvoton: fix locking issue with nvt_enable_cir
  media: rc: nuvoton: fix locking issue when calling nvt_enable_wake
  media: rc: nuvoton: fix locking issue when calling nvt_disable_cir

 drivers/media/rc/nuvoton-cir.c | 59 +++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

-- 
2.7.0


