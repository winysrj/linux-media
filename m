Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43483 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaIRTAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 15:00:21 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so801835wib.17
        for <linux-media@vger.kernel.org>; Thu, 18 Sep 2014 12:00:20 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: use hyperlinks in doxygen PDF
Date: Thu, 18 Sep 2014 21:00:13 +0200
Message-Id: <1411066813-15732-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 doxygen_libdvbv5.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen_libdvbv5.cfg b/doxygen_libdvbv5.cfg
index bbdaf9a..51ec180 100644
--- a/doxygen_libdvbv5.cfg
+++ b/doxygen_libdvbv5.cfg
@@ -1656,7 +1656,7 @@ LATEX_EXTRA_FILES      =
 # The default value is: YES.
 # This tag requires that the tag GENERATE_LATEX is set to YES.
 
-PDF_HYPERLINKS         = NO
+PDF_HYPERLINKS         = YES
 
 # If the LATEX_PDFLATEX tag is set to YES, doxygen will use pdflatex to generate
 # the PDF file directly from the LaTeX files. Set this option to YES to get a
-- 
1.9.1

