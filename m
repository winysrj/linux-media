Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60895 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab0F2Mop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:45 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl RFC][PATCH 1/5] media: Add media.h to headers_install
Date: Tue, 29 Jun 2010 07:43:06 -0500
Message-Id: <1277815390-24681-2-git-send-email-saaguirre@ti.com>
In-Reply-To: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
References: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the header available to the user-space apps when
doing headers_install.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 2fc8e14..efc9718 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -112,6 +112,7 @@ header-y += magic.h
 header-y += major.h
 header-y += map_to_7segment.h
 header-y += matroxfb.h
+header-y += media.h
 header-y += meye.h
 header-y += minix_fs.h
 header-y += mmtimer.h
-- 
1.6.3.3

