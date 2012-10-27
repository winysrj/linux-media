Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933405Ab2J0UnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:43:05 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKh4u3006455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:43:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 42/68] [media] dvb_frontend: Don't declare values twice at a table
Date: Sat, 27 Oct 2012 18:41:00 -0200
Message-Id: <1351370486-29040-43-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-core/dvb_frontend.c:1032:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1032:2: warning: (near initialization for 'dtv_cmds[36]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1033:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1033:2: warning: (near initialization for 'dtv_cmds[37]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1034:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1034:2: warning: (near initialization for 'dtv_cmds[38]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1035:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1035:2: warning: (near initialization for 'dtv_cmds[39]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1036:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1036:2: warning: (near initialization for 'dtv_cmds[40]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1037:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1037:2: warning: (near initialization for 'dtv_cmds[60]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1045:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1045:2: warning: (near initialization for 'dtv_cmds[46]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1051:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1051:2: warning: (near initialization for 'dtv_cmds[52]') [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1060:2: warning: initialized field overwritten [-Woverride-init]
drivers/media/dvb-core/dvb_frontend.c:1060:2: warning: (near initialization for 'dtv_cmds[61]') [-Woverride-init]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 7e92793..49d9504 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1029,12 +1029,6 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	/* Get */
 	_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
 	_DTV_CMD(DTV_API_VERSION, 0, 0),
-	_DTV_CMD(DTV_CODE_RATE_HP, 0, 0),
-	_DTV_CMD(DTV_CODE_RATE_LP, 0, 0),
-	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
-	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
-	_DTV_CMD(DTV_HIERARCHY, 0, 0),
-	_DTV_CMD(DTV_INTERLEAVING, 0, 0),
 
 	_DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
 
@@ -1042,13 +1036,11 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 1, 0),
 
 	_DTV_CMD(DTV_ATSCMH_FIC_VER, 0, 0),
-	_DTV_CMD(DTV_ATSCMH_PARADE_ID, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_NOG, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_TNOG, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SGN, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_PRC, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_RS_FRAME_MODE, 0, 0),
-	_DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_RS_CODE_MODE_PRI, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_RS_CODE_MODE_SEC, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_BLOCK_MODE, 0, 0),
@@ -1056,8 +1048,6 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
-
-	_DTV_CMD(DTV_LNA, 0, 0),
 };
 
 static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
-- 
1.7.11.7

