Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57005 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2EMMSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 08:18:18 -0400
Received: by wibhj8 with SMTP id hj8so837366wib.1
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 05:18:17 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 5/8] added m4 directory to gitignore
Date: Sun, 13 May 2012 14:17:27 +0200
Message-Id: <1336911450-23661-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
References: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index f33eb98..d6bb3a3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,6 +18,7 @@ config.status
 Makefile
 Makefile.in
 configure
+m4
 aclocal.m4
 autom4te.cache
 build-aux
-- 
1.7.2.5

