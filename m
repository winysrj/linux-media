Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35645 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdFKRqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Jun 2017 13:46:21 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] MAINTAINERS: add entry for OV5640 sensor driver
Date: Sun, 11 Jun 2017 10:46:11 -0700
Message-Id: <1497203171-9757-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add maintainer entry for the OV5640 V4L2 sensor driver.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bd..9c7f663 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9419,6 +9419,13 @@ M:	Harald Welte <laforge@gnumonks.org>
 S:	Maintained
 F:	drivers/char/pcmcia/cm4040_cs.*
 
+OMNIVISION OV5640 SENSOR DRIVER
+M:	Steve Longerbeam <slongerbeam@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ov5640.c
+
 OMNIVISION OV5647 SENSOR DRIVER
 M:	Ramiro Oliveira <roliveir@synopsys.com>
 L:	linux-media@vger.kernel.org
-- 
2.7.4
