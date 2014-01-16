Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.hs-offenburg.de ([141.79.128.11]:57212 "EHLO
	mx.hs-offenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaAPRpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 12:45:55 -0500
Received: from [141.79.65.136] (asa2.rz.hs-offenburg.de [141.79.10.2])
	by mx.hs-offenburg.de (8.13.6/8.13.6/SuSE Linux 0.8) with ESMTP id s0GHjuiN015667
	for <linux-media@vger.kernel.org>; Thu, 16 Jan 2014 18:45:57 +0100
Message-ID: <52D81AD4.3050504@hs-offenburg.de>
Date: Thu, 16 Jan 2014 18:45:56 +0100
From: Andreas Weber <andreas.weber@hs-offenburg.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: 2 bugs (errno = EINTR) in v4l2grab.c and v4l2gl.c?
Content-Type: multipart/mixed;
 boundary="------------020003020800040909050200"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020003020800040909050200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear maintainers,

I guess these are 2 bugs:
contrib/test/v4l2grab.c:132: } while ((r == -1 && (errno = EINTR)));
contrib/test/v4l2gl.c:227:   } while ((r == -1 && (errno = EINTR)));

please consider my attached patch if it's really a bug.
Regards, Andy

--------------020003020800040909050200
Content-Type: text/x-diff;
 name="errno_assignment.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="errno_assignment.patch"

>From 63d4fd18cb91852b64c81bf63d0d4100fc53d38d Mon Sep 17 00:00:00 2001
From: Andreas Weber <andreas.weber@hs-offenburg.de>
Date: Thu, 16 Jan 2014 18:43:31 +0100
Subject: [PATCH] bugfix for errno assignment in while loop

---
 contrib/test/v4l2gl.c   |    2 +-
 contrib/test/v4l2grab.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/contrib/test/v4l2gl.c b/contrib/test/v4l2gl.c
index e921212..4b549c1 100644
--- a/contrib/test/v4l2gl.c
+++ b/contrib/test/v4l2gl.c
@@ -224,7 +224,7 @@ static int capture(char *dev_name, int x_res, int y_res, int n_frames,
 			tv.tv_usec = 0;
 
 			r = select(fd + 1, &fds, NULL, NULL, &tv);
-		} while ((r == -1 && (errno = EINTR)));
+		} while ((r == -1 && (errno == EINTR)));
 		if (r == -1) {
 			perror("select");
 			return errno;
diff --git a/contrib/test/v4l2grab.c b/contrib/test/v4l2grab.c
index a93ad43..14d2a8f 100644
--- a/contrib/test/v4l2grab.c
+++ b/contrib/test/v4l2grab.c
@@ -129,7 +129,7 @@ static int capture(char *dev_name, int x_res, int y_res, int n_frames,
 			tv.tv_usec = 0;
 
 			r = select(fd + 1, &fds, NULL, NULL, &tv);
-		} while ((r == -1 && (errno = EINTR)));
+		} while ((r == -1 && (errno == EINTR)));
 		if (r == -1) {
 			perror("select");
 			return errno;
-- 
1.7.10.4


--------------020003020800040909050200--
