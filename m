Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2969 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2KWL0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/15] MAINTAINERS: add adv7604/ad9389b entries.
Date: Fri, 23 Nov 2012 12:25:42 +0100
Message-Id: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
In-Reply-To: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
References: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Cisco maintains these drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b623679..6f0a8b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -557,6 +557,18 @@ L:	linux-rdma@vger.kernel.org
 S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
+ANALOG DEVICES INC AD9389B DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/ad9389b*
+
+ANALOG DEVICES INC ADV7604 DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/adv7604*
+
 ANALOG DEVICES INC ASOC CODEC DRIVERS
 M:	Lars-Peter Clausen <lars@metafoo.de>
 L:	device-drivers-devel@blackfin.uclinux.org
-- 
1.7.10.4

