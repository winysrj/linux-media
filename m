Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37779 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752644AbdK3NVC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 08:21:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>
Subject: [PATCH 2/2] media: rc-core.rst: add the lirc_dev.h header
Date: Thu, 30 Nov 2017 08:20:56 -0500
Message-Id: <f6d3f536250fd85bfab10695548f313250b14618.1512048047.git.mchehab@s-opensource.com>
In-Reply-To: <44530601e2f49433690aeec1c76e425907ae6842.1512048047.git.mchehab@s-opensource.com>
References: <44530601e2f49433690aeec1c76e425907ae6842.1512048047.git.mchehab@s-opensource.com>
In-Reply-To: <44530601e2f49433690aeec1c76e425907ae6842.1512048047.git.mchehab@s-opensource.com>
References: <44530601e2f49433690aeec1c76e425907ae6842.1512048047.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a kAPI declaration there. Add it to the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/rc-core.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/media/kapi/rc-core.rst
index 41c2256dbf6a..dd2482c58cdb 100644
--- a/Documentation/media/kapi/rc-core.rst
+++ b/Documentation/media/kapi/rc-core.rst
@@ -7,3 +7,5 @@ Remote Controller core
 .. kernel-doc:: include/media/rc-core.h
 
 .. kernel-doc:: include/media/rc-map.h
+
+.. kernel-doc:: include/media/lirc_dev.h
-- 
2.14.3
