Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3AVLQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:16:09 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MBG94L026194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 06:16:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/7] [media] mb86a20s: make AGC work better
Date: Tue, 22 Jan 2013 09:15:29 -0200
Message-Id: <1358853333-21554-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
References: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is recommented to change register 0x0440 value to 0, in order
to fix some AGC bug.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 3c8587e..40c6183 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -126,7 +126,8 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x50, 0xd7 }, { 0x51, 0x3f },
 	{ 0x28, 0x74 }, { 0x29, 0x00 }, { 0x28, 0x74 }, { 0x29, 0x40 },
 	{ 0x28, 0x46 }, { 0x29, 0x2c }, { 0x28, 0x46 }, { 0x29, 0x0c },
-	{ 0x04, 0x40 }, { 0x05, 0x01 },
+
+	{ 0x04, 0x40 }, { 0x05, 0x00 },
 	{ 0x28, 0x00 }, { 0x29, 0x10 },
 	{ 0x28, 0x05 }, { 0x29, 0x02 },
 	{ 0x1c, 0x01 },
-- 
1.7.11.7

