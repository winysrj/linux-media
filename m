Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38525 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0F2Mop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:45 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl RFC][PATCH 3/5] v4l: Add v4l2-mediabus.h to headers_install
Date: Tue, 29 Jun 2010 07:43:08 -0500
Message-Id: <1277815390-24681-4-git-send-email-saaguirre@ti.com>
In-Reply-To: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
References: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This complements commit ID:

  commit f1ee99adf3c73c6a2423c11813e17ca0227d98b7
  Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
  Date:   Mon Mar 15 23:33:31 2010 +0100

      v4l: Move the media/v4l2-mediabus.h header to include/linux

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index c5e8c6a..257812e 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -167,6 +167,7 @@ header-y += udf_fs_i.h
 header-y += ultrasound.h
 header-y += un.h
 header-y += utime.h
+header-y += v4l2-mediabus.h
 header-y += v4l2-subdev.h
 header-y += veth.h
 header-y += videotext.h
-- 
1.6.3.3

