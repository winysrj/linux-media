Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:52988 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AYKgV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 05:36:21 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 0/2] Add support THS7353 video amplifier support
Date: Fri, 25 Jan 2013 16:06:05 +0530
Message-Id: <1359110167-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch series adds driver for THS7353 video amplifier.
The first patch of the series adds the chip-id for THS7353 and
the second patch adds the driver.

Manjunath Hadli (2):
  media: add chip id for THS7353
  media: add support for THS7353 video amplifier

 drivers/media/i2c/Kconfig       |   10 ++
 drivers/media/i2c/Makefile      |    1 +
 drivers/media/i2c/ths7353.c     |  223 +++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h |    3 +
 4 files changed, 237 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/ths7353.c

-- 
1.7.4.1

