Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab1KXVZi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 16:25:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: gregkh@suse.de, rdunlap@xenotime.net,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] MAINTAINERS: Update media entries
Date: Thu, 24 Nov 2011 19:25:23 -0200
Message-Id: <1322169923-4130-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we've created a /drivers/staging/media, put it together with
/drivers/media. Also, added there a missing entry for the Media API spec.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e839b95..273b049 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4234,7 +4234,9 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	Documentation/video4linux/
+F:	Documentation/DocBook/media/
 F:	drivers/media/
+F:	drivers/staging/media/
 F:	include/media/
 F:	include/linux/dvb/
 F:	include/linux/videodev*.h
-- 
1.7.7.1

