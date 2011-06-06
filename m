Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43033 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab1FFWks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 18:40:48 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/7] marvell-cam: Remove the "untested" comment
Date: Mon,  6 Jun 2011 16:40:00 -0600
Message-Id: <1307400003-94758-5-git-send-email-corbet@lwn.net>
In-Reply-To: <1307400003-94758-1-git-send-email-corbet@lwn.net>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This code is, indeed, tested :)

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/cafe-driver.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index e9cbb45..78b4077 100644
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
1.7.5.2

