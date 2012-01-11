Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab2AKAhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:37:39 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0bduE000354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:37:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2] [media] tda18271-fe: Fix support for ISDB-T
Date: Tue, 10 Jan 2012 22:37:32 -0200
Message-Id: <1326242252-23852-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
References: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

V2: ISDB-T can use 6, 7 or 8MHz for bandwidth. So, the code should
handle it just like DVB-T.

 drivers/media/common/tuners/tda18271-fe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index d3d91ea..2e67f44 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -946,6 +946,7 @@ static int tda18271_set_params(struct dvb_frontend *fe)
 		map = &std_map->atsc_6;
 		bw = 6000000;
 		break;
+	case SYS_ISDBT:
 	case SYS_DVBT:
 	case SYS_DVBT2:
 		if (bw <= 6000000) {
-- 
1.7.7.5

