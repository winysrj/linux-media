Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40581 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3L2EF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:05:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v6 09/12] DocBook: fix wait.c location
Date: Sun, 29 Dec 2013 06:04:01 +0200
Message-Id: <1388289844-2766-10-git-send-email-crope@iki.fi>
In-Reply-To: <1388289844-2766-1-git-send-email-crope@iki.fi>
References: <1388289844-2766-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation did not compile as wait.c location was wrong.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/device-drivers.tmpl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 6c9d9d3..f517008 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -58,7 +58,7 @@
      </sect1>
      <sect1><title>Wait queues and Wake events</title>
 !Iinclude/linux/wait.h
-!Ekernel/wait.c
+!Ekernel/sched/wait.c
      </sect1>
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
-- 
1.8.4.2

