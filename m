Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4959 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaHJLSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:18:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: wbrack@mmm.com.hk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] MAINTAINERS: add tw68 entry
Date: Sun, 10 Aug 2014 13:17:13 +0200
Message-Id: <1407669433-13571-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407669433-13571-1-git-send-email-hverkuil@xs4all.nl>
References: <1407669433-13571-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cdf24c..2b06a8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9199,6 +9199,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
+TW68 VIDEO4LINUX DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/pci/tw68/
+
 TPM DEVICE DRIVER
 M:	Peter Huewe <peterhuewe@gmx.de>
 M:	Ashley Lai <ashley@ashleylai.com>
-- 
2.0.1

