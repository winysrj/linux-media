Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36126 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbbIDUEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2015 16:04:36 -0400
Received: by lbcao8 with SMTP id ao8so16988528lbc.3
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2015 13:04:35 -0700 (PDT)
From: Maciek Borzecki <maciek.borzecki@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: maciek.borzecki@gmail.com
Subject: [PATCH 2/3] [media] staging: lirc: fix indentation
Date: Fri,  4 Sep 2015 22:04:04 +0200
Message-Id: <cf23848e5fed33dfaa967fc3399de30318535aa6.1441396162.git.maciek.borzecki@gmail.com>
In-Reply-To: <cover.1441396162.git.maciek.borzecki@gmail.com>
References: <cover.1441396162.git.maciek.borzecki@gmail.com>
In-Reply-To: <cover.1441396162.git.maciek.borzecki@gmail.com>
References: <cover.1441396162.git.maciek.borzecki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix non-tab indentation.

This resolves the following checkpatch problem:
ERROR: code indent should use tabs where possible

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
---
 drivers/staging/media/lirc/lirc_sasem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 9e5674341abe7368e5ec228f737e4c2d766f7d80..904a4667bbb8bebe3cb43bf5201be9d533ada07a 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -181,10 +181,10 @@ static void deregister_from_lirc(struct sasem_context *context)
 	if (retval)
 		dev_err(&context->dev->dev,
 			"%s: unable to deregister from lirc (%d)\n",
-		       __func__, retval);
+			__func__, retval);
 	else
 		dev_info(&context->dev->dev,
-		         "Deregistered Sasem driver (minor:%d)\n", minor);
+			 "Deregistered Sasem driver (minor:%d)\n", minor);
 
 }
 
-- 
2.5.1

