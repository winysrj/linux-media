Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43173 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754503AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 15/15] [media] gen-errors.rst fix error table column limits
Date: Fri, 19 Aug 2016 10:05:05 -0300
Message-Id: <3ebec8bb3483ad91141fefbabec7682262891a55.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the generic errors table to avoid column overflows on
LaTeX output.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/gen-errors.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index d37284d50e56..6e983b9880fc 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -9,7 +9,7 @@ Generic Error Codes
 
 .. _gen-errors:
 
-.. tabularcolumns:: |p{1.0cm}|p{16.5cm}|
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table:: Generic error codes
     :header-rows:  0
-- 
2.7.4


