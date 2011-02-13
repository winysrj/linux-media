Return-path: <mchehab@pedra>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:58516 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1BMKkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 05:40:15 -0500
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH] Fix sysfs rc protocol lookup for rc-5-sz
Date: Sun, 13 Feb 2011 12:29:15 +0200
Message-Id: <1297592955-19860-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the current matching rules the lookup for rc protocol named rc-5-sz matches with "rc-5" before finding "rc-5-sz". Thus one is able to never enable/disable the rc-5-sz protocol via sysfs.

Fix the lookup to require an exact match which allows the manipulation of sz protocol.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/rc-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 512a2f4..5b4422e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -850,7 +850,7 @@ static ssize_t store_protocols(struct device *device,
 			count++;
 		} else {
 			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-				if (!strncasecmp(tmp, proto_names[i].name, strlen(proto_names[i].name))) {
+				if (!strcasecmp(tmp, proto_names[i].name)) {
 					tmp += strlen(proto_names[i].name);
 					mask = proto_names[i].type;
 					break;
-- 
1.7.3.4

