Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3880 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3HVK1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:27:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 5/5] MAINTAINERS: add entries for adv7511 and adv7842.
Date: Thu, 22 Aug 2013 12:27:30 +0200
Message-Id: <99e0f6dd87b4c1e1ef0503ac13db2aec0fdf24e4.1377167031.git.hans.verkuil@cisco.com>
In-Reply-To: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
References: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <649dbb2a170c401618608d53b9c485396defb683.1377167031.git.hans.verkuil@cisco.com>
References: <649dbb2a170c401618608d53b9c485396defb683.1377167031.git.hans.verkuil@cisco.com>
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

