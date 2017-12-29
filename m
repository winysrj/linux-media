Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59342 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750814AbdL2NiC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:38:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] media: dmx.h documentation: fix a warning
Date: Fri, 29 Dec 2017 08:37:56 -0500
Message-Id: <3f3c11c3c4654ee7554bb13974e81e13a1ce4757.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

/devel/v4l/patchwork/Documentation/output/dmx.h.rst:6: WARNING: undefined label: dmx_dqbuf (if the link has no caption the label must precede a section header)

This is defined together with DMX_QBUF.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dmx.h.rst.exceptions | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index 629db384104a..63f55a9ae2b1 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -54,3 +54,5 @@ ignore symbol DMX_OUT_DECODER
 ignore symbol DMX_OUT_TAP
 ignore symbol DMX_OUT_TS_TAP
 ignore symbol DMX_OUT_TSDEMUX_TAP
+
+replace ioctl DMX_DQBUF dmx_qbuf
-- 
2.14.3
