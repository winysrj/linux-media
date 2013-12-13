Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2692 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3LMM1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 07:27:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 4/4] MAINTAINERS: add entry for new radio-raremono radio driver.
Date: Fri, 13 Dec 2013 13:26:49 +0100
Message-Id: <1386937609-11581-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
References: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4..cedf0df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8480,6 +8480,14 @@ L:	linux-xtensa@linux-xtensa.org
 S:	Maintained
 F:	arch/xtensa/
 
+THANKO'S RAREMONO AM/FM/SW RADIO RECEIVER USB DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/radio/radio-raremono.c
+
 THERMAL
 M:      Zhang Rui <rui.zhang@intel.com>
 M:      Eduardo Valentin <eduardo.valentin@ti.com>
-- 
1.8.4.3

