Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab3AQS7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0HIxAne027346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 13:59:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv11 03/16] [media] dvb: the core logic to handle the DVBv5 QoS properties
Date: Thu, 17 Jan 2013 16:58:17 -0200
Message-Id: <1358449110-11203-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
References: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the logic to poll, reset counters and report the QoS stats
to the end user.
The idea is that the core will periodically poll the frontend for
the stats. The frontend may return -EBUSY, if the previous collect
didn't finish, or it may fill the cached data.
The value returned to the end user is always the cached data.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 27 +++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |  8 ++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index dd35fa9..66be7f7 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1053,6 +1053,14 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
 	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
+
+	/* Statistics API */
+	_DTV_CMD(DTV_STAT_SIGNAL_STRENGTH, 0, 0),
+	_DTV_CMD(DTV_STAT_CNR, 0, 0),
+	_DTV_CMD(DTV_STAT_BIT_ERROR_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_TOTAL_BITS_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_ERROR_BLOCK_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_TOTAL_BLOCKS_COUNT, 0, 0),
 };
 
 static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
@@ -1443,6 +1451,25 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		tvp->u.data = c->lna;
 		break;
 
+	/* Fill quality measures */
+	case DTV_STAT_SIGNAL_STRENGTH:
+		tvp->u.st = c->strength;
+		break;
+	case DTV_STAT_CNR:
+		tvp->u.st = c->cnr;
+		break;
+	case DTV_STAT_BIT_ERROR_COUNT:
+		tvp->u.st = c->bit_error;
+		break;
+	case DTV_STAT_TOTAL_BITS_COUNT:
+		tvp->u.st = c->bit_count;
+		break;
+	case DTV_STAT_ERROR_BLOCK_COUNT:
+		tvp->u.st = c->block_error;
+		break;
+	case DTV_STAT_TOTAL_BLOCKS_COUNT:
+		tvp->u.st = c->block_count;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 97112cd..47952c5 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -393,6 +393,14 @@ struct dtv_frontend_properties {
 	u8			atscmh_sccc_code_mode_d;
 
 	u32			lna;
+
+	/* statistics data */
+	struct dtv_fe_stats	strength;
+	struct dtv_fe_stats	cnr;
+	struct dtv_fe_stats	bit_error;
+	struct dtv_fe_stats	bit_count;
+	struct dtv_fe_stats	block_error;
+	struct dtv_fe_stats	block_count;
 };
 
 struct dvb_frontend {
-- 
1.7.11.7

