Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2965 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHZGdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 02:33:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/2] MAINTAINERS: add tw68 entry
Date: Tue, 26 Aug 2014 08:33:13 +0200
Message-Id: <1409034793-9465-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1409034793-9465-1-git-send-email-hverkuil@xs4all.nl>
References: <1409034793-9465-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa948..78b38e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9227,6 +9227,14 @@ T:	git git://linuxtv.org/media_tree.git
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
2.1.0

