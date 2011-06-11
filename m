Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:54688 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1FKRrG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/8] marvell-cam: Remove the "untested" comment
Date: Sat, 11 Jun 2011 11:46:45 -0600
Message-Id: <1307814409-46282-5-git-send-email-corbet@lwn.net>
In-Reply-To: <1307814409-46282-1-git-send-email-corbet@lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This code is, indeed, tested :)

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/cafe-driver.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index 08edf95..91ba74b 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -14,9 +14,6 @@
  * v4l2_device/v4l2_subdev conversion by:
  * Copyright (C) 2009 Hans Verkuil <hverkuil@xs4all.nl>
  *
- * Note: this conversion is untested! Please contact the linux-media
- * mailinglist if you can test this, together with the test results.
- *
  * This file may be distributed under the terms of the GNU General
  * Public License, version 2.
  */
-- 
1.7.5.4

