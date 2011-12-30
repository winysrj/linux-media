Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9SnF024178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 37/94] [media] mb86a16: Add delivery system type at fe struct
Date: Fri, 30 Dec 2011 13:07:34 -0200
Message-Id: <1325257711-12274-38-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/mb86a16.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/mb86a16.c b/drivers/media/dvb/frontends/mb86a16.c
index c283112..292ba7b 100644
--- a/drivers/media/dvb/frontends/mb86a16.c
+++ b/drivers/media/dvb/frontends/mb86a16.c
@@ -1814,6 +1814,7 @@ static enum dvbfe_algo mb86a16_frontend_algo(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops mb86a16_ops = {
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Fujitsu MB86A16 DVB-S",
 		.type			= FE_QPSK,
-- 
1.7.8.352.g876a6

