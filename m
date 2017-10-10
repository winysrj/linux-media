Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34801 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbdJJHSy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 25/26] media: MAINTAINERS: add entry for zilog_ir
Date: Tue, 10 Oct 2017 08:18:52 +0100
Message-Id: <37d37727a8c23194594dbd045906536d6e4c901f.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add MAINTAINER's entry for this new driver ported from staging.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb5f548a568e..15d32348e902 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14876,6 +14876,12 @@ Q:	https://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/zd1301_demod*
 
+ZILOG/HAUPPAUGE IR TRANSMITTER
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/zilog_ir.c
+
 ZPOOL COMPRESSED PAGE STORAGE API
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
-- 
2.13.6
