Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab3DQAmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:54 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gs0S024278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 16/31] [media] r820t: better report signal strength
Date: Tue, 16 Apr 2013 21:42:27 -0300
Message-Id: <1366159362-3773-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If signal is zero, shows it as a zero, not as 0xff.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 5be4635..d5686e8 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1506,6 +1506,8 @@ static int r820t_signal(struct dvb_frontend *fe, u16 *strength)
 
 		/* A higher gain at LNA means a lower signal strength */
 		*strength = (45 - rc) << 4 | 0xff;
+		if (*strength == 0xff)
+			*strength = 0;
 	} else {
 		*strength = 0;
 	}
-- 
1.8.1.4

