Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36323 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbLRNFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 08:05:38 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 1/5] staging: media: lirc: replace NULL comparisons with !var
Date: Fri, 18 Dec 2015 18:35:25 +0530
Message-Id: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A NULL comparison can be written as if (var) or if (!var).
Reported by checkpatch.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/media/lirc/lirc_parallel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index c140834..9df8d14 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -652,7 +652,7 @@ static int __init lirc_parallel_init(void)
 		goto exit_device_put;
 
 	pport = parport_find_base(io);
-	if (pport == NULL) {
+	if (!pport) {
 		pr_notice("no port at %x found\n", io);
 		result = -ENXIO;
 		goto exit_device_put;
@@ -661,7 +661,7 @@ static int __init lirc_parallel_init(void)
 					   pf, kf, lirc_lirc_irq_handler, 0,
 					   NULL);
 	parport_put_port(pport);
-	if (ppdevice == NULL) {
+	if (!ppdevice) {
 		pr_notice("parport_register_device() failed\n");
 		result = -ENXIO;
 		goto exit_device_put;
-- 
1.9.1

