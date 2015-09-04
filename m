Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:36361 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbIDUEe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2015 16:04:34 -0400
Received: by lanb10 with SMTP id b10so20061626lan.3
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2015 13:04:33 -0700 (PDT)
From: Maciek Borzecki <maciek.borzecki@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: maciek.borzecki@gmail.com
Subject: [PATCH 1/3] [media] staging: lirc: remove unnecessary braces
Date: Fri,  4 Sep 2015 22:04:03 +0200
Message-Id: <5250a374e7053ef0f888ba9c62fa6140d806da24.1441396162.git.maciek.borzecki@gmail.com>
In-Reply-To: <cover.1441396162.git.maciek.borzecki@gmail.com>
References: <cover.1441396162.git.maciek.borzecki@gmail.com>
In-Reply-To: <cover.1441396162.git.maciek.borzecki@gmail.com>
References: <cover.1441396162.git.maciek.borzecki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary braces where appropriate.

This removes the following checkpatch warnings:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 62ec9f70dae4cd87dcf6fb60b1dd81df3d568b19..05d47dc8ffb8a987dc65287d36096a78cd5f96cd 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -785,13 +785,13 @@ static int imon_probe(struct usb_interface *interface,
 	}
 
 	driver = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!driver) {
+	if (!driver)
 		goto free_context;
-	}
+
 	rbuf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!rbuf) {
+	if (!rbuf)
 		goto free_driver;
-	}
+
 	if (lirc_buffer_init(rbuf, BUF_CHUNK_SIZE, BUF_SIZE)) {
 		dev_err(dev, "%s: lirc_buffer_init failed\n", __func__);
 		goto free_rbuf;
-- 
2.5.1

