Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:33200 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbbEJK6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2015 06:58:00 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id CD5FB25AF52B
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:57:59 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3ll2Rq4rz0z5vN8
	for <linux-media@vger.kernel.org>; Sun, 10 May 2015 12:57:59 +0200 (CEST)
Date: Sun, 10 May 2015 12:57:48 +0200
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] <sys/fcntl.h> is a less portable synonym to <fcntl.h>
Message-ID: <20150510105748.GC27779@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 utils/qv4l2/raw2sliced.cpp          | 2 +-
 utils/v4l2-compliance/v4l-helpers.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/raw2sliced.cpp b/utils/qv4l2/raw2sliced.cpp
index 4db158a..9fee6e1 100644
--- a/utils/qv4l2/raw2sliced.cpp
+++ b/utils/qv4l2/raw2sliced.cpp
@@ -5,7 +5,7 @@
 #include <string.h>
 #include <assert.h>
 #include <unistd.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 
 #include "raw2sliced.h"
 
diff --git a/utils/v4l2-compliance/v4l-helpers.h b/utils/v4l2-compliance/v4l-helpers.h
index a36ca14..c7433e5 100644
--- a/utils/v4l2-compliance/v4l-helpers.h
+++ b/utils/v4l2-compliance/v4l-helpers.h
@@ -9,7 +9,7 @@
 #include <time.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include <sys/mman.h>
 #include <errno.h>
 
-- 
2.3.6

