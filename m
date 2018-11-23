Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbeKXFYO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 00:24:14 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Subject: [PATCH 6/6] media: pixfmt-meta-d4xx.rst: Add a license to it
Date: Fri, 23 Nov 2018 16:38:39 -0200
Message-Id: <af41c235dcd5b41cec9938ed8e438ed1614d2992.1542997584.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1542997584.git.mchehab+samsung@kernel.org>
References: <cover.1542997584.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is a recent addition to media docs, and it is now the
only one without any license.

While the best is to dual-license with GFDL and GPL, it is,
at least, compatible with GFDL, as this is a requirement to be
part of the media uAPI docs.

So, add such license to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
index 63bf1a2c9116..862e1f327150 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
@@ -1,4 +1,11 @@
-.. -*- coding: utf-8; mode: rst -*-
+.. Permission is granted to copy, distribute and/or modify this
+.. document under the terms of the GNU Free Documentation License,
+.. Version 1.1 or any later version published by the Free Software
+.. Foundation, with no Invariant Sections, no Front-Cover Texts
+.. and no Back-Cover Texts. A copy of the license is included at
+.. Documentation/media/uapi/fdl-appendix.rst.
+..
+.. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
 
 .. _v4l2-meta-fmt-d4xx:
 
-- 
2.19.1
