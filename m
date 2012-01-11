Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab2AKAWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:22:15 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0MESc030276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:22:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/6] [media] tda18271-fe: Fix support for ISDB-T
Date: Tue, 10 Jan 2012 22:20:21 -0200
Message-Id: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda18271-fe.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index d3d91ea..7e30304 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -946,6 +946,10 @@ static int tda18271_set_params(struct dvb_frontend *fe)
 		map = &std_map->atsc_6;
 		bw = 6000000;
 		break;
+	case SYS_ISDBT:
+		map = &std_map->dvbt_6;
+		bw = 6000000;
+		break;
 	case SYS_DVBT:
 	case SYS_DVBT2:
 		if (bw <= 6000000) {
-- 
1.7.7.5

