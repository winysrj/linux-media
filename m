Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4585 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab3HLNO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 09:14:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: scott.jiang.linux@gmail.com,
	uclinux-dist-devel@blackfin.uclinux.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] MAINTAINERS: add entries for adv7511 and adv7842.
Date: Mon, 12 Aug 2013 15:13:59 +0200
Message-Id: <1376313239-19921-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376313239-19921-1-git-send-email-hverkuil@xs4all.nl>
References: <1376313239-19921-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..e50819b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -580,12 +580,24 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/ad9389b*
 
+ANALOG DEVICES INC ADV7511 DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/adv7511*
+
 ANALOG DEVICES INC ADV7604 DRIVER
 M:	Hans Verkuil <hans.verkuil@cisco.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/adv7604*
 
+ANALOG DEVICES INC ADV7842 DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/adv7842*
+
 ANALOG DEVICES INC ASOC CODEC DRIVERS
 M:	Lars-Peter Clausen <lars@metafoo.de>
 L:	device-drivers-devel@blackfin.uclinux.org
-- 
1.8.3.2

